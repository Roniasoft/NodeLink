#include "ElapsedTimer.h"

ElapsedTimer::ElapsedTimer(QObject *parent)
    : QObject{parent}
{}

void ElapsedTimer::start()
{
    if (!mElapsedTimer.isValid()) {
        mElapsedTimer.start();
    } //! Else timer is already started
}

void ElapsedTimer::stop()
{
    if (mElapsedTimer.isValid()) {
        mElapsedTimer.invalidate();
    }
}

void ElapsedTimer::restart()
{
    if (mElapsedTimer.isValid()) {
        mElapsedTimer.restart();
    }
}

qint64 ElapsedTimer::msecsElapsed()
{
    return mElapsedTimer.elapsed();
}

qint64 ElapsedTimer::nsecsElapsed()
{
    return mElapsedTimer.nsecsElapsed();
}
