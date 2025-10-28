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
    QML_ELEMENT

public:

    /* Public Constructors & Destructor
     * ****************************************************************************************/
    explicit HashCompareStringCPP(QObject *parent = nullptr);

protected slots:
    /* Protected Slots
     * ****************************************************************************************/

    //! Compare two string models.
    bool compareStringModels(QString strModelFirst, QString strModelSecound);
};

#endif // HASHCOMPARESTRINGCPP_H
