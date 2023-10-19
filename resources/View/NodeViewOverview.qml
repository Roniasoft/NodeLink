import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Layouts

/*! ***********************************************************************************************
 * This class show node ui for overview.
 * ************************************************************************************************/
I_NodeView {
    id: overviewNodeView

    /* Property Declarations
     * ****************************************************************************************/
    //! Node is selected or not
    property bool         isSelected:          scene?.selectionModel?.isSelected(node?._qsUuid ?? "") ?? false

    //! Node Rect Top Left Position
    property vector2d     nodeRectTopLeft:     viewProperties.nodeRectTopLeft

    //! Scale Factor used for scene -> overview mapping
    property real         overviewScaleFactor: viewProperties.overviewScaleFactor

    /* Object Properties
     * ****************************************************************************************/
    width: node.guiConfig.width * overviewScaleFactor
    height: node.guiConfig.height * overviewScaleFactor
    x: (node.guiConfig?.position?.x - nodeRectTopLeft.x) * overviewScaleFactor
    y: (node.guiConfig?.position?.y - nodeRectTopLeft.y) * overviewScaleFactor
    border.color: node.guiConfig.locked ? "gray" : Qt.lighter(node.guiConfig.color, isSelected ? 1.2 : 1)
    border.width: (isSelected ? 2 : 1)
    opacity: isSelected ? 1 : 0.6
    radius: NLStyle.radiusAmount.nodeView * overviewScaleFactor

    /* Children
    * ****************************************************************************************/
    //! Minimal nodeview
    contentItem: Rectangle {
        anchors.fill: parent
        anchors.margins: 10 * overviewScaleFactor
        color: "#282828"
        radius: NLStyle.radiusAmount.nodeView * overviewScaleFactor

        //! Text Icon
        Text {
            font.family: NLStyle.fontType.font6Pro
            font.pixelSize: NLStyle.node.overviewFontSize * overviewScaleFactor
            anchors.centerIn: parent
            text: scene.nodeRegistry.nodeIcons[node.type]
            color: node.guiConfig.locked ? "gray" : node.guiConfig.color
            font.weight: 400
        }
    }

}
