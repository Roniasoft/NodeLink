#ifndef OBJECTCREATOR_H
#define OBJECTCREATOR_H

#include <QObject>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickItem>
#include <QVector>
#include <QVariantMap>
#include <QtQml/qqmlregistration.h>

class ObjectCreator : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit ObjectCreator(QObject *parent = nullptr);
    ~ObjectCreator();

    Q_INVOKABLE QQuickItem* createNode(
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &properties
        );
    
    Q_INVOKABLE QVariantList createNodes(QVariantList createdItems,
                                         QQuickItem *parentItem,
                                         const QString &componentUrl,
                                         const QVariantMap &baseProperties
                                         );

    Q_INVOKABLE void destroyObject(const QVariant &var);
    Q_INVOKABLE void destroyObjects(const QVariantList &objects);

private:
    QQmlEngine *m_engine;
    QHash<QString, QQmlComponent*> m_components;
    QVector<QObject*> m_createdObjects;

    QQmlComponent* getOrCreateComponent(const QString &componentUrl);
};

#endif
