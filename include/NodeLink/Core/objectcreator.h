#ifndef OBJECTCREATOR_H
#define OBJECTCREATOR_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>
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
    QML_NAMED_ELEMENT(ObjectCreator)
    QML_SINGLETON

public:
    explicit ObjectCreator(QObject *parent = nullptr);
    ~ObjectCreator();

    /*! Get the singleton instance of ObjectCreator
     *
     * This function is called by Qt QML engine to get the singleton instance.
     * The engine parameter can be used to initialize the instance if needed.
     *
     * \param engine The QQmlEngine instance (can be used to get engine-specific settings).
     * \param scriptEngine The QJSEngine instance (unused, but required by QML_SINGLETON).
     * \return Pointer to the singleton ObjectCreator instance.
     * ************************************************************************************************/
    static ObjectCreator *instance(QQmlEngine *engine = nullptr, QJSEngine *scriptEngine = nullptr);

public:
    /*! Create a single QML item from a component URL with given properties.
     *
     * This function creates a QML component dynamically, sets properties in three stages
     * (context, before completeCreate, and after completeCreate) to ensure QML bindings
     * are properly evaluated and avoid showing default values before actual values.
     *
     * \param parentItem The parent QQuickItem for the new item.
     * \param componentUrl The URL of the QML component (relative or absolute).
     * \param properties A map of property names to values to set on the created item.
     * \return Pointer to the created QQuickItem, or nullptr if creation failed.
     * ************************************************************************************************/
    Q_INVOKABLE QQuickItem* createItem(
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &properties
        );

    /*! Create multiple QML items from a component URL with properties from an array.
     *
     * This function creates multiple QML items in batch, where each item gets properties
     * from baseProperties plus one item from itemArray assigned to the property named 'name'.
     * This is useful for creating multiple views for an array of model objects.
     * Internally uses createItem() to avoid code duplication.
     *
     * \param name The property name that will receive each item from itemArray.
     * \param itemArray The array of items to create views for.
     * \param parentItem The parent QQuickItem for all created items.
     * \param componentUrl The URL of the QML component (relative or absolute).
     * \param baseProperties Base properties that will be set on all created items.
     * \return A list of created QQuickItems.
     * ************************************************************************************************/
    Q_INVOKABLE QVariantList createItems(
        const QString &name,
        QVariantList itemArray,
        QQuickItem *parentItem,
        const QString &componentUrl,
        const QVariantMap &baseProperties
        );

private:
    /*! Get or create a QQmlComponent from the given URL, using cache if available.
     *
     * \param componentUrl The component URL (can be relative like "NodeView.qml" or
     *                     full path like "qrc:/Calculator/resources/View/CalculatorNodeView.qml").
     * \return Pointer to the QQmlComponent, or nullptr if creation failed.
     * ************************************************************************************************/
    QQmlComponent* getOrCreateComponent(const QString &componentUrl);

    /*! Ensure that an asynchronous component is ready before use (Qt 6.2.4 compatibility).
     *
     * This function waits for an asynchronous component to finish loading by processing
     * events. This is necessary because createWithInitialProperties asserts if the
     * component isn't ready.
     *
     * \param component The QQmlComponent to check and wait for.
     * \return true if component is ready, false if there was an error or timeout.
     * ************************************************************************************************/
    bool ensureComponentReady(QQmlComponent *component);

private:
    QQmlEngine *m_engine;
    QHash<QString, QQmlComponent*> m_components;
};

#endif // OBJECTCREATOR_H
