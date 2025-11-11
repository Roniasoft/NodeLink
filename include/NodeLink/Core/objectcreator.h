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
    QML_NAMED_ELEMENT(ObjectCreator)
    QML_SINGLETON

public:
    explicit ObjectCreator(QObject *parent = nullptr);
    ~ObjectCreator();

    Q_INVOKABLE QVariantMap createItem(
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &properties
        );

    Q_INVOKABLE QVariantMap createItems(
        const QString &name,
        QVariantList itemArray,
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &baseProperties
        );

private:
    QQmlEngine *m_engine;
    QHash<QString, QQmlComponent*> m_components;

    QQmlComponent* getOrCreateComponent(const QString &componentUrl);
};

#endif
