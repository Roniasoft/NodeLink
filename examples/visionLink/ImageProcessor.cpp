#include "ImageProcessor.h"
#include <QBuffer>
#include <QByteArray>
#include <QPainter>
#include <QDebug>
#include <QtMath>


/* ************************************************************************************************
 * Public Constructors & Destructor
 * ************************************************************************************************/

/*! Default constructor
 * ************************************************************************************************/
ImageProcessor::ImageProcessor(QObject *parent)
    : QObject(parent)
{
}

/* ************************************************************************************************
 * Public Image Processing Functions
 * ************************************************************************************************/

/*!
 * Load image from file path and return as QVariant.
 * Handles file:// URL prefix cleanup and ensures detached image copy.
 * 
 * \param path is the file path or URL to the image file
 * \return QVariant containing loaded QImage, or invalid QVariant on failure
 */
QVariant ImageProcessor::loadImage(const QString &path)
{
    QString cleanPath = path;
    
    // Remove file:/// prefix if present
    if (cleanPath.startsWith("file:///")) {
        cleanPath = cleanPath.mid(8);
    } else if (cleanPath.startsWith("file://")) {
        cleanPath = cleanPath.mid(7);
    }
        
    QImage image(cleanPath);
    
    if (image.isNull()) {
        qWarning() << "ImageProcessor: Failed to load image from:" << cleanPath;
        return QVariant();
    }

    // Ensure the image is detached and has its own data
    // This prevents issues with shallow copies across C++/QML boundary
    QImage detachedImage = image.copy();
    
    return imageToVariant(detachedImage);
}

/*!
 * Apply box blur filter to image.
 * 
 * \param imageData is the QVariant containing input QImage
 * \param radius is the blur radius (0 or higher)
 * \return QVariant containing blurred QImage, or invalid QVariant on failure
 */
QVariant ImageProcessor::applyBlur(const QVariant &imageData, qreal radius)
{
    QImage image = variantToImage(imageData);
    
    if (image.isNull()) {
        qWarning() << "ImageProcessor: Invalid image data for blur";
        return QVariant();
    }
        
    if (radius < 0.1) {
        return imageData; // No blur needed
    }
    
    QImage result = boxBlur(image, qRound(radius));
    
    return imageToVariant(result);
}

/*!
 * Adjust image brightness.
 * 
 * \param imageData is the QVariant containing input QImage
 * \param level is the brightness adjustment level (-1.0 to 1.0)
 * \return QVariant containing adjusted QImage, or invalid QVariant on failure
 */
QVariant ImageProcessor::applyBrightness(const QVariant &imageData, qreal level)
{
    QImage image = variantToImage(imageData);
    
    if (image.isNull()) {
        qWarning() << "ImageProcessor: Invalid image data for brightness";
        return QVariant();
    }
        
    if (qAbs(level) < 0.01) {
        return imageData; // No change needed
    }
    
    QImage result = adjustBrightness(image, level);
    
    return imageToVariant(result);
}

/*!
 * Adjust image contrast.
 * 
 * \param imageData is the QVariant containing input QImage
 * \param level is the contrast adjustment level (-1.0 to 1.0)
 * \return QVariant containing adjusted QImage, or invalid QVariant on failure
 */
QVariant ImageProcessor::applyContrast(const QVariant &imageData, qreal level)
{
    QImage image = variantToImage(imageData);
    
    if (image.isNull()) {
        qWarning() << "ImageProcessor: Invalid image data for contrast";
        return QVariant();
    }
        
    if (qAbs(level) < 0.01) {
        return imageData; // No change needed
    }
    
    QImage result = adjustContrast(image, level);
    
    return imageToVariant(result);
}

/*!
 * Convert image to base64 data URL for QML Image component.
 * 
 * \param imageData is the QVariant containing QImage
 * \return QString with data URL (data:image/png;base64,...), or empty string on failure
 */
QString ImageProcessor::saveToDataUrl(const QVariant &imageData)
{
    QImage image = variantToImage(imageData);
    
    if (image.isNull()) {
        return QString();
    }
    
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "PNG");
    
    QString dataUrl = QString("data:image/png;base64,%1")
                          .arg(QString(ba.toBase64()));
    
    return dataUrl;
}

/*!
 * Check if QVariant contains valid image data.
 * 
 * \param imageData is the QVariant to check
 * \return true if QVariant contains valid QImage, false otherwise
 */
bool ImageProcessor::isValidImage(const QVariant &imageData) const
{
    QImage image = variantToImage(imageData);
    return !image.isNull();
}

/* ************************************************************************************************
 * Private Helper Functions
 * ************************************************************************************************/

/*!
 * Convert QVariant to QImage with detached copy.
 * This ensures proper memory management across C++/QML boundary.
 *
 * \param imageData is the QVariant containing QImage data
 * \return QImage with detached data, or null QImage if conversion fails
 */
QImage ImageProcessor::variantToImage(const QVariant &imageData) const
{
    if (imageData.canConvert<QImage>()) {
        QImage image = imageData.value<QImage>();
        // Ensure we have a detached copy
        if (!image.isNull()) {
            return image.copy();
        }
    }
    return QImage();
}

/*!
 * Convert QImage to QVariant for safe C++/QML transfer.
 *
 * \param image is the QImage to convert
 * \return QVariant containing the image data
 */
QVariant ImageProcessor::imageToVariant(const QImage &image) const
{
    return QVariant::fromValue(image);
}

/*!
 * Apply box blur algorithm with given radius.
 * Performs horizontal and vertical blur passes for improved performance.
 * 
 * \param source is the input QImage
 * \param radius is the blur radius in pixels
 * \return QImage with blur applied
 */
QImage ImageProcessor::boxBlur(const QImage &source, int radius)
{
    if (radius < 1) {
        return source;
    }
    
    QImage result = source.convertToFormat(QImage::Format_ARGB32);
    
    int width = result.width();
    int height = result.height();
    
    // Horizontal pass
    QImage temp(width, height, QImage::Format_ARGB32);
    
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            int r = 0, g = 0, b = 0, a = 0;
            int count = 0;
            
            for (int dx = -radius; dx <= radius; ++dx) {
                int xx = qBound(0, x + dx, width - 1);
                QRgb pixel = result.pixel(xx, y);
                
                r += qRed(pixel);
                g += qGreen(pixel);
                b += qBlue(pixel);
                a += qAlpha(pixel);
                count++;
            }
            
            temp.setPixel(x, y, qRgba(r / count, g / count, b / count, a / count));
        }
    }
    
    // Vertical pass
    for (int x = 0; x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            int r = 0, g = 0, b = 0, a = 0;
            int count = 0;
            
            for (int dy = -radius; dy <= radius; ++dy) {
                int yy = qBound(0, y + dy, height - 1);
                QRgb pixel = temp.pixel(x, yy);
                
                r += qRed(pixel);
                g += qGreen(pixel);
                b += qBlue(pixel);
                a += qAlpha(pixel);
                count++;
            }
            
            result.setPixel(x, y, qRgba(r / count, g / count, b / count, a / count));
        }
    }
    
    return result;
}

/*!
 * Adjust brightness level of image.
 * 
 * \param source is the input QImage
 * \param level is the brightness adjustment (-1.0 to 1.0)
 * \return QImage with adjusted brightness
 */
QImage ImageProcessor::adjustBrightness(const QImage &source, qreal level)
{
    QImage result = source.convertToFormat(QImage::Format_ARGB32);
    
    int width = result.width();
    int height = result.height();
    
    // level range: -1.0 to 1.0
    // Convert to adjustment value: -255 to 255
    int adjustment = qRound(level * 255.0);
    
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            QRgb pixel = result.pixel(x, y);
            
            int r = qBound(0, qRed(pixel) + adjustment, 255);
            int g = qBound(0, qGreen(pixel) + adjustment, 255);
            int b = qBound(0, qBlue(pixel) + adjustment, 255);
            
            result.setPixel(x, y, qRgba(r, g, b, qAlpha(pixel)));
        }
    }
    
    return result;
}

/*!
 * Adjust contrast level of image.
 * 
 * \param source is the input QImage
 * \param level is the contrast adjustment (-1.0 to 1.0)
 * \return QImage with adjusted contrast
 */
QImage ImageProcessor::adjustContrast(const QImage &source, qreal level)
{
    QImage result = source.convertToFormat(QImage::Format_ARGB32);
    
    int width = result.width();
    int height = result.height();
    
    // level range: -1.0 to 1.0
    // Convert to contrast factor: 0.0 to 2.0
    qreal factor = (level + 1.0);
    
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            QRgb pixel = result.pixel(x, y);
            
            // Apply contrast formula: newValue = factor * (oldValue - 128) + 128
            int r = qBound(0, qRound(factor * (qRed(pixel) - 128) + 128), 255);
            int g = qBound(0, qRound(factor * (qGreen(pixel) - 128) + 128), 255);
            int b = qBound(0, qRound(factor * (qBlue(pixel) - 128) + 128), 255);
            
            result.setPixel(x, y, qRgba(r, g, b, qAlpha(pixel)));
        }
    }
    
    return result;
}


