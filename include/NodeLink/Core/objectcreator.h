#ifndef OBJECTCREATOR_H
#define OBJECTCREATOR_H

#include <QObject>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickItem>
#include <QVector>
#include <QVariantMap>
#include <QtQml/qqmlregistration.h>

/*! ***********************************************************************************************
 * ObjectCreator is responsible for dynamically creating QML components from component URLs.
 * It handles component caching, asynchronous loading, and property setting with proper
 * binding evaluation to avoid Qt 6.2.4 compatibility issues.
 * ************************************************************************************************/
class ObjectCreator : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    /* Public Constructors & Destructor
     * ****************************************************************************************/
    explicit ObjectCreator(QObject *parent = nullptr);
    ~ObjectCreator();

public:
    /* Public Functions
     * ****************************************************************************************/
    //! Create a single QML item from a component URL with given properties.
    Q_INVOKABLE QQuickItem* createItem(
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &properties
        );
    
    //! Create multiple QML items from a component URL with properties from an array.
    Q_INVOKABLE QVariantList createItems(
        const QString &name,
        QVariantList itemArray,
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &baseProperties
        );

private:
    /* Private Functions
     * ****************************************************************************************/
    //! Get or create a QQmlComponent from the given URL, using cache if available.
    QQmlComponent* getOrCreateComponent(const QString &componentUrl);

    //! Ensure that an asynchronous component is ready before use (Qt 6.2.4 compatibility).
    bool ensureComponentReady(QQmlComponent *component);

private:
    /* Private Attributes
     * ****************************************************************************************/
    QQmlEngine *m_engine;
    QHash<QString, QQmlComponent*> m_components;
};

#endif // OBJECTCREATOR_H
