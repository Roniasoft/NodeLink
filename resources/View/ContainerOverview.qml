import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * This class show container ui for overview.
 * ************************************************************************************************/
ContainerView {
    id: containerOverview

    /* Property Declarations
     * ****************************************************************************************/
    //! container is selected or not
    property bool         isSelected:          scene?.selectionModel?.isSelected(node?._qsUuid ?? "") ?? false

    //! container Rect Top Left Position
    property vector2d     nodeRectTopLeft:     viewProperties?.nodeRectTopLeft ?? Qt.vector2d(0, 0)

    //! Scale Factor used for scene -> overview mapping
    property real         overviewScaleFactor: viewProperties?.overviewScaleFactor ?? 1.0

    /* Object Properties
     * ****************************************************************************************/
    x: ((node?.guiConfig?.position?.x ?? 0) - nodeRectTopLeft.x) * overviewScaleFactor
    y: ((node?.guiConfig?.position?.y ?? 0) - nodeRectTopLeft.y) * overviewScaleFactor
    width: (node?.guiConfig?.width ?? 100) * overviewScaleFactor
    height: (node?.guiConfig?.height ?? 70) * overviewScaleFactor
    border.color: (node?.guiConfig?.locked ?? false) ? "gray" : Qt.lighter(node?.guiConfig?.color ?? "#ffffff", isSelected ? 1.2 : 1)
    border.width: (isSelected ? 2 : 1)
    opacity: isSelected ? 1 : 0.6
    radius: NLStyle.radiusAmount.nodeView * overviewScaleFactor
    isNodeMinimal: true
}
