#include "NLUtilsCPP.h"

#include <QKeySequence>

/*! Default constructor
 * ************************************************************************************************/
NLUtilsCPP::NLUtilsCPP(QObject *parent)
    : QObject{parent}
{

}

QString NLUtilsCPP::imageURLToImageString(QString url)
{
    QFile file(url);
    if(!file.open(QIODevice::ReadOnly)) {
        qDebug()<<Q_FUNC_INFO<<__LINE__<< "error"<<file.errorString();

        return QString();
    }

    return (file.readAll().toBase64());
}

QString NLUtilsCPP::keySequenceToString(int keySequence) {

    // Convert StandardKey to string
    QString keyString = QKeySequence((QKeySequence::StandardKey)keySequence).toString(QKeySequence::NativeText);

    // Change the splitter
    QString keyStringModified = keyString.split("+").join(" + ");

    return keyStringModified;
}
