#ifndef BACKGROUNDGRIDSCPP_H
#define BACKGROUNDGRIDSCPP_H

#include <QPainter>
#include <QCoreApplication>
#include <QtQml>
#include <QQuickPaintedItem>
#include <QObject>
#include <QImage>
#include <QtConcurrent>
#include <QList>

/*! ***********************************************************************************************
 * BackgroundGridsCPP renders grid lines/points which includes a series
 *  of horizontal rectangles in a grid view.
 *
 * This class uses QQuickPaintedItem::paint() to renders all objects into
 *  a texture. This way the memory is saved.
 * ************************************************************************************************/
class BackgroundGridsCPP : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int spacing READ spacing WRITE setSpacing NOTIFY spacingChanged)
    QML_ELEMENT

public:
    /* Public Constructors & Destructor
     * ****************************************************************************************/
    BackgroundGridsCPP(QQuickItem* parent = nullptr);

    virtual void paint(QPainter *painter);

    int spacing() const;
    void setSpacing(int newSpacing);

signals:
    void spacingChanged();

private slots:
    /* Private Slots
     * ****************************************************************************************/
    void refresh();
    void updateGraph();

private:
    /* Attributes
     * ****************************************************************************************/
    bool            mHasPendingRender = false;
    QTimer          mRefreshTimer;
    QFuture<QImage> mRenderWorker;
    QImage          mGraphImage;
    int             mSpacing;
};

#endif // BACKGROUNDGRIDSCPP_H
