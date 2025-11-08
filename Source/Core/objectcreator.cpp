#include "objectcreator.h"
#include <QDebug>

ObjectCreator::ObjectCreator(QObject *parent)
    : QObject(parent)
    , m_engine(nullptr)
{
}

ObjectCreator::~ObjectCreator()
{
    qDeleteAll(m_createdObjects);
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
    qDebug() << "the component:" << componentUrl;
    QQmlComponent *component = new QQmlComponent(
        m_engine,
        "qrc:/NodeLink/resources/View/" + componentUrl,
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

QQuickItem* ObjectCreator::createNode(
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

    QObject *obj = component->createWithInitialProperties(properties);

    if (obj) {
        QQuickItem *item = qobject_cast<QQuickItem*>(obj);
        if (item) {
            item->setParentItem(parentItem);
            m_createdObjects.append(obj);
            return item;
        }
        delete obj;
    }

    return nullptr;
}

QVariantList ObjectCreator::createNodes(
    QVariantList nodeArray,
    QQuickItem *parentItem,
    const QString &componentUrl,
    const QVariantMap &baseProperties)
{
    QVariantList createdItems;
    QElapsedTimer timer;
    timer.start();
    int count = nodeArray.count();

    if (!parentItem || count <= 0) {
        return createdItems;
    }

    if (!m_engine) {
        m_engine = qmlEngine(parentItem);
    }

    if (!m_engine) {
        qWarning() << "Could not get QML engine!";
        return createdItems;
    }

    QQmlComponent *component = getOrCreateComponent(componentUrl);
    if (!component || !component->isReady()) {
        qWarning() << "Component not ready:" << componentUrl;
        if (component) {
            qWarning() << component->errors();
        }
        return createdItems;
    }

    for (int i = 0; i < count; ++i) {
        QVariantMap properties = baseProperties;
        properties["node"] = nodeArray[i];
        QObject *obj = component->createWithInitialProperties(properties);

        if (obj) {
            QQuickItem *item = qobject_cast<QQuickItem*>(obj);
            if (item) {
                item->setParentItem(parentItem);
                m_createdObjects.append(obj);
                createdItems.append(QVariant::fromValue(item));
            } else {
                delete obj;
            }
        }
    }
    qDebug() << "Creating" << count << "Nodes took " << timer.elapsed() << "ms";
    return createdItems;
}

void ObjectCreator::destroyObject(const QVariant &var)
{
    QObject *obj = qvariant_cast<QObject*>(var);
    if (!obj) return;

    m_createdObjects.removeAll(obj);
    obj->deleteLater();
}

void ObjectCreator::destroyObjects(const QVariantList &objects)
{
    for (const QVariant &var : objects) {
        QObject *obj = qvariant_cast<QObject*>(var);
        if (!obj) return;

        m_createdObjects.removeAll(obj);
        obj->deleteLater();
    }
}
