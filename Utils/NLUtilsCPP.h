#pragma once

#include <QObject>
#include <QtQmlIntegration>

class NLUtilsCPP : public QObject
{
    Q_OBJECT
    QML_ELEMENT
//    QML_SINGLETON

public:
    /* Public Constructors & Destructor
     * ****************************************************************************************/

    explicit NLUtilsCPP(QObject *parent = nullptr);

public:
    //! Read image file and convert to QString (UTF8)
    Q_INVOKABLE QString imageURLToImageString(QString url);

    //! Convert QKeySequence::StandardKey to QString
    Q_INVOKABLE QString keySequenceToString(int keySequence);
};
