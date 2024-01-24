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
    property vector2d     nodeRectTopLeft:     viewProperties.nodeRectTopLeft

    //! Scale Factor used for scene -> overview mapping
    property real         overviewScaleFactor: viewProperties.overviewScaleFactor

    /* Object Properties
     * ****************************************************************************************/
    x: (node.guiConfig?.position?.x - nodeRectTopLeft.x) * overviewScaleFactor
    y: (node.guiConfig?.position?.y - nodeRectTopLeft.y) * overviewScaleFactor
    width: node.guiConfig.width * overviewScaleFactor
    height: node.guiConfig.height * overviewScaleFactor
    border.color: node.guiConfig.locked ? "gray" : Qt.lighter(node.guiConfig.color, isSelected ? 1.2 : 1)
    border.width: (isSelected ? 2 : 1)
    opacity: isSelected ? 1 : 0.6
    radius: NLStyle.radiusAmount.nodeView * overviewScaleFactor
    isNodeMinimal: true
}
