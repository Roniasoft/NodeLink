#ifndef HASHCOMPARESTRINGCPP_H
#define HASHCOMPARESTRINGCPP_H

#include <QObject>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlContext>

/*! ***********************************************************************************************
 * HashCompareStringCPP compare two important strings.
 * ************************************************************************************************/
class HashCompareStringCPP : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HashCompareString)
    QML_SINGLETON

public:

    /* Public Constructors & Destructor
     * ****************************************************************************************/
    explicit HashCompareStringCPP(QObject *parent = nullptr);

    //! Compare two string models.
    Q_INVOKABLE bool compareStringModels(QString strModelFirst, QString strModelSecound);
};

#endif // HASHCOMPARESTRINGCPP_H
