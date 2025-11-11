#include "objectcreator.h"
#include <QDebug>
#include <QElapsedTimer>

ObjectCreator::ObjectCreator(QObject *parent)
    : QObject(parent)
    , m_engine(nullptr)
{
}

ObjectCreator::~ObjectCreator()
{
    qDeleteAll(m_components);
}

QQmlComponent* ObjectCreator::getOrCreateComponent(const QString &componentUrl)
{
    if (m_components.contains(componentUrl)) {
        return m_components[componentUrl];
    }

    if (!m_engine) {
        qWarning() << "QML engine not initialized!";
        return nullptr;
    }
    qDebug() << "Will use the component:" << componentUrl;
    QQmlComponent *component = new QQmlComponent(
        m_engine,
        componentUrl,
        QQmlComponent::Asynchronous,
        this
        );

    if (component->isError()) {
        qWarning() << "Component errors:" << component->errors();
        delete component;
        return nullptr;
    }

    m_components[componentUrl] = component;
    return component;
}

QVariantMap ObjectCreator::createItem(
    QQuickItem *parentItem,
    const QString &componentUrl,
    const QVariantMap &properties)
{
    QVariantMap result;
    result["item"] = QVariant::fromValue<QQuickItem*>(nullptr);
    result["needsPropertySet"] = false;

    if (!parentItem) {
        qWarning() << "Parent item is null!";
        return result;
    }

    if (!m_engine) {
        m_engine = qmlEngine(parentItem);
    }

    if (!m_engine) {
        qWarning() << "Could not get QML engine!";
        return result;
    }

    QQmlComponent *component = getOrCreateComponent(componentUrl);
    if (!component) {
        return result;
    }

    QObject *obj = nullptr;

#if QT_VERSION > QT_VERSION_CHECK(6, 2, 4)
    obj = component->createWithInitialProperties(properties, m_engine->rootContext());
    result["needsPropertySet"] = false;
#else
    obj = component->create(m_engine->rootContext());
    result["needsPropertySet"] = true;
#endif

    if (obj) {
        QQuickItem *item = qobject_cast<QQuickItem*>(obj);
        if (item) {
            QQmlEngine::setObjectOwnership(obj, QQmlEngine::JavaScriptOwnership);
            item->setParentItem(parentItem);
            result["item"] = QVariant::fromValue(item);
            return result;
        }
        delete obj;
    }

    return result;
}

QVariantMap ObjectCreator::createItems(
    const QString &name,
    QVariantList itemArray,
    QQuickItem *parentItem,
    const QString &componentUrl,
    const QVariantMap &baseProperties)
{
    QVariantMap result;
    QVariantList createdItems;
    result["items"] = createdItems;
    result["needsPropertySet"] = false;

    QElapsedTimer timer;
    timer.start();
    int count = itemArray.count();

    if (!parentItem || count <= 0) {
        return result;
    }

    if (!m_engine) {
        m_engine = qmlEngine(parentItem);
    }

    if (!m_engine) {
        qWarning() << "Could not get QML engine!";
        return result;
    }

    QQmlComponent *component = getOrCreateComponent(componentUrl);
    if (!component || !component->isReady()) {
        qWarning() << "Component not ready:" << componentUrl;
        if (component) {
            qWarning() << component->errors();
        }
        return result;
    }

#if QT_VERSION > QT_VERSION_CHECK(6, 2, 4)
    result["needsPropertySet"] = false;
    for (int i = 0; i < count; ++i) {
        QVariantMap properties = baseProperties;
        properties[name] = itemArray[i];
        QObject *obj = component->createWithInitialProperties(properties, m_engine->rootContext());

        if (obj) {
            QQuickItem *item = qobject_cast<QQuickItem*>(obj);
            if (item) {
                QQmlEngine::setObjectOwnership(obj, QQmlEngine::JavaScriptOwnership);
                item->setParentItem(parentItem);
                createdItems.append(QVariant::fromValue(item));
            } else {
                delete obj;
            }
        }
    }
#else
    result["needsPropertySet"] = true;
    for (int i = 0; i < count; ++i) {
        QObject *obj = component->create(m_engine->rootContext());

        if (obj) {
            QQuickItem *item = qobject_cast<QQuickItem*>(obj);
            if (item) {
                QQmlEngine::setObjectOwnership(obj, QQmlEngine::JavaScriptOwnership);
                item->setParentItem(parentItem);
                createdItems.append(QVariant::fromValue(item));
            } else {
                delete obj;
            }
        }
    }
#endif

    result["items"] = createdItems;
    qDebug() << "Creating" << count << name << "took" << timer.elapsed() << "ms";
    return result;
}
