#include "BackgroundGridsCPP.h"
#include <QSGGeometryNode>
#include <QSGFlatColorMaterial>
#include <QSGGeometry>
#include <cmath>
/* ************************************************************************************************
 * Public Constructors & Destructor
 * ************************************************************************************************/
/*! Default constructor
 * ************************************************************************************************/
BackgroundGridsCPP::BackgroundGridsCPP(QQuickItem *parent) :
    QQuickItem(parent),
    mSpacing(0)
{
    setFlag(ItemHasContents, true);
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
    update();
}

QSGNode *BackgroundGridsCPP::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    QSGGeometryNode *node = static_cast<QSGGeometryNode *>(oldNode);
    if (!node) {
        node = new QSGGeometryNode();
        QSGGeometry *g = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(),
                                         0, 0, QSGGeometry::UnsignedIntType);
        g->setDrawingMode(QSGGeometry::DrawTriangles);
        node->setGeometry(g);
        node->setFlag(QSGNode::OwnsGeometry);

        QSGFlatColorMaterial *mat = new QSGFlatColorMaterial();
        mat->setColor(QColor(51, 51, 51));
        node->setMaterial(mat);
        node->setFlag(QSGNode::OwnsMaterial);
    }

    if (mSpacing <= 0.0 || width() <= 0 || height() <= 0) {
        node->geometry()->allocate(0);
        node->markDirty(QSGNode::DirtyGeometry);
        return node;
    }

    const float spacing = float(mSpacing);
    const float squareSize = 2.0f;
    const float W = float(width());
    const float H = float(height());

    const int cols = int(std::ceil(W / spacing)) + 1;
    const int rows = int(std::ceil(H / spacing)) + 1;

    if (cols <= 0 || rows <= 0) {
        node->geometry()->allocate(0);
        node->markDirty(QSGNode::DirtyGeometry);
        return node;
    }

    const int verticesCount = cols * rows * 6;
    QSGGeometry *geometry = node->geometry();
    geometry->allocate(verticesCount);
    QSGGeometry::Point2D *v = geometry->vertexDataAsPoint2D();

    int idx = 0;
    for (int row = 0; row < rows; ++row) {
        const float y = row * spacing;
        for (int col = 0; col < cols; ++col) {
            const float x = col * spacing;

            v[idx++].set(x,              y);
            v[idx++].set(x + squareSize, y);
            v[idx++].set(x,              y + squareSize);

            v[idx++].set(x + squareSize, y);
            v[idx++].set(x + squareSize, y + squareSize);
            v[idx++].set(x,              y + squareSize);
        }
    }

    float minX = FLT_MAX, maxX = -FLT_MAX, minY = FLT_MAX, maxY = -FLT_MAX;
    for (int i = 0; i < idx; ++i) {
        minX = qMin(minX, v[i].x);
        maxX = qMax(maxX, v[i].x);
        minY = qMin(minY, v[i].y);
        maxY = qMax(maxY, v[i].y);
    }

    node->markDirty(QSGNode::DirtyGeometry);
    return node;
}
