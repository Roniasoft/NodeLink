#ifndef ELAPSEDTIMER_H
#define ELAPSEDTIMER_H

#include <QObject>
#include <QQmlEngine>
#include <QElapsedTimer>

/*!
 * \brief The ElapsedTimer class can be used to calculate the amount of time passed between two event
 */
class ElapsedTimer : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ElapsedTimer(QObject *parent = nullptr);

    //!
    //! Public Invokable methods

    /*!
     * \brief start Start \ref mElapsedTimer
     */
    Q_INVOKABLE void    start();

    /*!
     * \brief stop Stops timer
     */
    Q_INVOKABLE void    stop();

    /*!
     * \brief restart Restarts counting
     */
    Q_INVOKABLE void    restart();

    /*!
     * \brief msecsElapsed Returns the number of milliseconds since last start
     * \return
     */
    Q_INVOKABLE qint64  msecsElapsed();

    /*!
     * \brief nsecsElapsed Returns the number of nanoseconds since last start
     * \return
     */
    Q_INVOKABLE qint64  nsecsElapsed();

private:
    QElapsedTimer   mElapsedTimer;
};

#endif // ELAPSEDTIMER_H
