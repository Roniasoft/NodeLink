#include "objectcreator.h"
#include <QDebug>
#include <QElapsedTimer>
#include <QCoreApplication>
#include <QQmlContext>
#include <QQmlProperty>
#include <QJSEngine>

ObjectCreator::ObjectCreator(QObject *parent)
    : QObject(parent)
    , m_engine(nullptr)
{
}

ObjectCreator::~ObjectCreator()
{
    qDeleteAll(m_components);
}


ObjectCreator *ObjectCreator::instance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine)

    static ObjectCreator *singletonInstance = nullptr;

    if (!singletonInstance) {
        singletonInstance = new ObjectCreator();
        // If engine is provided, we can store it for later use
        // But we'll get it from parentItem when needed
    }

    return singletonInstance;
}

QQuickItem* ObjectCreator::createItem(
    QQuickItem *parentItem,
    const QString &componentUrl,
    const QVariantMap &properties)
{
    if (!parentItem) {
        qWarning() << "Parent item is null!";
        return nullptr;
    }

    if (!m_engine) {
        m_engine = qmlEngine(parentItem);
    }

    if (!m_engine) {
        qWarning() << "Could not get QML engine!";
        return nullptr;
    }

    QQmlComponent *component = getOrCreateComponent(componentUrl);
    if (!component) {
        return nullptr;
    }

    // Ensure component is ready before creating (required for Qt 6.2.4 compatibility)
    if (!ensureComponentReady(component)) {
        qWarning() << "Component not ready:" << componentUrl;
        if (component->isError()) {
            qWarning() << component->errors();
        }
        return nullptr;
    }

    // For Qt 6.2.4: createWithInitialProperties has a bug that causes assertion
    // Workaround: Use beginCreate/completeCreate to set properties before completion
    QQmlContext *parentContext = qmlContext(parentItem);
    if (!parentContext) {
        parentContext = m_engine->rootContext();
    }

    // Create a child context for the object
    QQmlContext *creationContext = new QQmlContext(parentContext, m_engine);

    // Set properties in context BEFORE beginCreate() so they're available during component construction
    // This is critical for properties that affect bindings during initialization
    if (!properties.isEmpty()) {
        for (auto it = properties.begin(); it != properties.end(); ++it) {
            const QString &propertyName = it.key();
            const QVariant &propertyValue = it.value();
            creationContext->setContextProperty(propertyName, propertyValue);
        }
    }

    // Begin creation - this creates the object but doesn't complete it yet
    QObject *obj = component->beginCreate(creationContext);

    if (!obj) {
        qWarning() << "Failed to begin create object from component:" << componentUrl;
        if (component->isError()) {
            qWarning() << component->errors();
        }
        delete creationContext;
        return nullptr;
    }

    // Also set properties directly on the object to ensure they're set
    // This is important for properties that are used in Component.onCompleted handlers
    if (!properties.isEmpty()) {
        QQmlContext *objContext = m_engine->contextForObject(obj);
        if (!objContext) {
            objContext = creationContext;
        }

        for (auto it = properties.begin(); it != properties.end(); ++it) {
            const QString &propertyName = it.key();
            const QVariant &propertyValue = it.value();

            // Use QQmlProperty to set properties (handles QML property bindings correctly)
            QQmlProperty prop(obj, propertyName, objContext);
            if (prop.isValid() && prop.isWritable()) {
                prop.write(propertyValue);
            } else {
                // Fallback to direct property setting using QMetaObject
                const QByteArray propName = propertyName.toUtf8();
                const QMetaObject *metaObj = obj->metaObject();
                int propIndex = metaObj->indexOfProperty(propName.constData());
                if (propIndex >= 0) {
                    QMetaProperty metaProp = metaObj->property(propIndex);
                    if (metaProp.isWritable()) {
                        if (!metaProp.write(obj, propertyValue)) {
                            obj->setProperty(propName.constData(), propertyValue);
                        }
                    }
                }
            }
        }
    }

    // Now complete the component creation
    // This will trigger Component.onCompleted and activate QML bindings
    // Properties are already set before this point, so bindings will see the correct values
    component->completeCreate();

    // Check for errors after completion
    if (component->isError()) {
        qWarning() << "Component errors after completion:" << component->errors();
        delete creationContext;
        delete obj;
        return nullptr;
    }

    // Context must stay alive as long as the object exists
    obj->setParent(creationContext);

    if (obj) {
        QQuickItem *item = qobject_cast<QQuickItem*>(obj);
        if (item) {
            // Set engine ownership to JavaScript so QML can manage it
            // This allows QML to manage the object lifecycle
            QQmlEngine::setObjectOwnership(obj, QQmlEngine::JavaScriptOwnership);
            item->setParentItem(parentItem);
            return item;
        }
        // If not a QQuickItem, clean up
        obj->setParent(nullptr);  // Remove from context
        delete creationContext;
        delete obj;
    } else {
        delete creationContext;
    }

    return nullptr;
}

QVariantList ObjectCreator::createItems(
    const QString &name,
    QVariantList itemArray,
    QQuickItem *parentItem,
    const QString &componentUrl,
    const QVariantMap &baseProperties)
{
    QVariantList createdItems;
    QElapsedTimer timer;
    timer.start();
    int count = itemArray.count();

    if (!parentItem || count <= 0) {
        return createdItems;
    }

    // Create each item using createItem() to avoid code duplication
    for (int i = 0; i < count; ++i) {
        // Merge baseProperties with the current item from itemArray
        QVariantMap properties = baseProperties;
        properties[name] = itemArray[i];

        // Use createItem() to handle all the creation logic
        QQuickItem *item = createItem(parentItem, componentUrl, properties);

        if (item) {
            createdItems.append(QVariant::fromValue(item));
        }
    }

    qDebug() << "Creating" << count << name << "took" << timer.elapsed() << "ms";
    return createdItems;
}

QQmlComponent* ObjectCreator::getOrCreateComponent(const QString &componentUrl)
{
    // Check if componentUrl is already a full qrc path or absolute path
    QString fullUrl;
    if (componentUrl.startsWith("qrc:") || componentUrl.startsWith("/") ||
        (componentUrl.length() > 1 && componentUrl[1] == ':')) {
        // Already a full path (qrc: or absolute file path)
        fullUrl = componentUrl;
    } else {
        // Relative path, prepend default NodeLink view path
        fullUrl = "qrc:/NodeLink/resources/View/" + componentUrl;
    }

    // Use fullUrl as cache key to avoid loading the same component twice
    // (e.g., if someone passes both "NodeView.qml" and "qrc:/NodeLink/resources/View/NodeView.qml")
    if (m_components.contains(fullUrl)) {
        return m_components[fullUrl];
    }

    if (!m_engine) {
        qWarning() << "QML engine not initialized!";
        return nullptr;
    }

    qDebug() << "Will use the component:" << fullUrl;

    // For Qt 6.2.4: Load component asynchronously but we'll wait for it to be ready
    // before using create() instead of createWithInitialProperties
    QQmlComponent *component = new QQmlComponent(
        m_engine,
        fullUrl,
        QQmlComponent::Asynchronous,  // Keep asynchronous for performance
        this
        );

    if (component->isError()) {
        qWarning() << "Component errors:" << component->errors();
        delete component;
        return nullptr;
    }

    m_components[fullUrl] = component;
    return component;
}

bool ObjectCreator::ensureComponentReady(QQmlComponent *component)
{
    if (!component) {
        return false;
    }

    // If component is already ready, return true
    if (component->isReady()) {
        return true;
    }

    // Check for errors
    if (component->isError()) {
        qWarning() << "Component has errors:" << component->errors();
        return false;
    }

    // For Qt 6.2.4 compatibility: Wait for asynchronous component to be ready
    // This is necessary because createWithInitialProperties asserts if component isn't ready
    // We need to process events to allow the component to load
    QElapsedTimer timer;
    timer.start();
    const int maxWaitTime = 5000; // 5 seconds timeout

    // Wait for component to be ready, processing events to allow loading to progress
    while (!component->isReady() && !component->isError() && timer.elapsed() < maxWaitTime) {
        // Process events to allow component loading to progress
        // This allows the QML engine to process component loading events
        QCoreApplication::processEvents(QEventLoop::AllEvents, 10);
    }

    if (component->isError()) {
        qWarning() << "Component errors after loading:" << component->errors();
        return false;
    }

    if (timer.elapsed() >= maxWaitTime && !component->isReady()) {
        qWarning() << "Component loading timeout after" << maxWaitTime << "ms";
        return false;
    }

    return component->isReady();
}

