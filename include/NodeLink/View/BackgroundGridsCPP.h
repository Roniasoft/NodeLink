#ifndef BACKGROUNDGRIDSCPP_H
#define BACKGROUNDGRIDSCPP_H

#include <QQuickItem>
#include <QSGNode>

/*! ***********************************************************************************************
 * BackgroundGridsCPP renders grid lines/points which includes a series
 *  of horizontal triangles coupled together to form a rectangle in a grid view.
 *
 * This class uses QQuickItem::updatePaintNode() to render all objects by using GPU power to be
 * completely efficient.
 * ************************************************************************************************/
class BackgroundGridsCPP : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(int spacing READ spacing WRITE setSpacing NOTIFY spacingChanged)
    QML_ELEMENT

public:
    /* Public Constructors & Destructor
     * ****************************************************************************************/
    BackgroundGridsCPP(QQuickItem* parent = nullptr);

    int spacing() const;
    void setSpacing(int newSpacing);

signals:
    void spacingChanged();

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *updatePaintNodeData) override;

private:
    /* Attributes
     * ****************************************************************************************/
    int             mSpacing;
};

#endif // BACKGROUNDGRIDSCPP_H
