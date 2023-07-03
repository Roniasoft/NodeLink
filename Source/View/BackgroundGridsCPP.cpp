#include "BackgroundGridsCPP.h"

/* ************************************************************************************************
 * Public Constructors & Destructor
 * ************************************************************************************************/
/*! Default constructor
 * ************************************************************************************************/
BackgroundGridsCPP::BackgroundGridsCPP(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    mSpacing(0)
{
    connect(this, &BackgroundGridsCPP::spacingChanged,          this, &BackgroundGridsCPP::refresh);
    connect(this, &QQuickItem::widthChanged,                    this, &BackgroundGridsCPP::refresh);
    connect(this, &QQuickItem::heightChanged,                   this, &BackgroundGridsCPP::refresh);
    connect(&mRefreshTimer, &QTimer::timeout,                   this, &BackgroundGridsCPP::updateGraph);

    mRefreshTimer.setSingleShot(true);
    mRefreshTimer.setInterval(5);
}

/*! This function, which is usually called by the QML Scene Graph,
 *   paints the contents of an item in local coordinates.
 *   the underlying texture will have a size defined by textureSize
 *   when set, or the item's size, multiplied by the window's device pixel ratio
 *
 *   The function is called everytime the QQuickPaintedItem::update
 *    method is triggered in updateGraph
 * ************************************************************************************************/
void BackgroundGridsCPP::paint(QPainter *painter)
{
    if(!mGraphImage.isNull()) {
        for (int i = 0; i < width(); i += 20*mSpacing) {
            for (int j = 0; j < height(); j += 20*mSpacing) {
                painter->drawImage(QRectF(i, j, 20*mSpacing, 20*mSpacing), mGraphImage, mGraphImage.rect());
            }
        }
//        painter->drawImage(QRectF(0, 0, width(), height()), mGraphImage, mGraphImage.rect());
    }
}

/*! This is triggered whenever the input properties are updated.
 *  The timer also triggers the updateGraph method to update the texture.
 * ************************************************************************************************/
void BackgroundGridsCPP::refresh()
{
    if(!mRefreshTimer.isActive()) {
        mRefreshTimer.start();
    }
}

/*! Updates the image that is needed for the texture.
 *
 * ************************************************************************************************/
void BackgroundGridsCPP::updateGraph()
{
    if (mSpacing != 0 && width() > 0 && height() > 0) {

        if (mRenderWorker.isRunning()) {
            mHasPendingRender = true;
        } else {
            int w = width();
            int h = height();

            // Using a future watcher to monitor the future (renderWorker)
            // we need this mechanism here since we are going to use QPainter for drawing
            // which uses raster api to reduce CPU bloackage.
            auto renderWorkerWatcher = new QFutureWatcher<QImage>();

            // When the future finished we update the graphImage and then call the QQuickPaintedItem::update()
            connect(renderWorkerWatcher, &QFutureWatcher<QImage>::finished, this, [this, renderWorkerWatcher](){
                mGraphImage = renderWorkerWatcher->result();
                if(!mGraphImage.isNull()){
                    update();   // triggers paint method to update texture
                }
                renderWorkerWatcher->deleteLater();

                if(mHasPendingRender) {
                    mHasPendingRender = false;
                    QTimer::singleShot(0, this, &BackgroundGridsCPP::updateGraph);
                }
            });

            // Creates a concurrent callback that returns an image as result
            mRenderWorker = QtConcurrent::run([w, h, this]() -> QImage {
                double w2 = 20 * mSpacing;
                double h2 = 20 * mSpacing;
                auto image = QImage(w2, h2, QImage::Format_ARGB32_Premultiplied);
                image.fill(Qt::transparent);

                QPainter painter;
                painter.begin(&image);

                // Iterate over all events, draw rectangle with the provided color
                for (int i = 0; i < w2; i += mSpacing) {
                    for (int j = 0; j < h2; j += mSpacing) {
                        painter.fillRect(QRectF(i, j, 2, 2), QBrush(QColor(51, 51, 51)));
                    }
                }

                painter.end();
                return image;
            });

            // Starts watching the given future (mRenderWorker)
            renderWorkerWatcher->setFuture(mRenderWorker);
        }
    }
}

int BackgroundGridsCPP::spacing() const
{
    return mSpacing;
}

void BackgroundGridsCPP::setSpacing(int newSpacing)
{
    if (mSpacing == newSpacing)
        return;
    mSpacing = newSpacing;
    emit spacingChanged();
}
