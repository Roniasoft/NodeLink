#include "HashCompareStringCPP.h"

#include <QCryptographicHash>


/* ************************************************************************************************
 * Public Constructors & Destructor
 * ************************************************************************************************/

/*! Default constructor
 * ************************************************************************************************/
HashCompareStringCPP::HashCompareStringCPP(QObject *parent)
    : QObject{parent}
{

}

/* ************************************************************************************************
 * Public Functions
 * ************************************************************************************************/
/*!
 * Compare two string models.
 *
 * \param strModelFirst is the first string model.
 * \param strModelSecound is the secound string model.
 */
bool HashCompareStringCPP::compareStringModels(QString strModelFirst, QString strModelSecound)
{
    QCryptographicHash::Algorithm algorithm = QCryptographicHash::Md5;
    QByteArray modelFirst   = QCryptographicHash::hash(strModelFirst.toStdString(),   algorithm);
    QByteArray modelSecound = QCryptographicHash::hash(strModelSecound.toStdString(), algorithm);

    return (modelFirst.compare(modelSecound) == 0);
}
