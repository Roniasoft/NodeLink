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
    property bool         isSelected:     scene?.selectionModel?.isSelected(modelData?._qsUuid ?? "") ?? false

    //! Node Rect Top Left Position
    property vector2d     nodeRectTopLeft: extraProperties.nodeRectTopLeft

    //! Scale Factor used for scene -> overview mapping
    property real         customScaleFactor: extraProperties.customScaleFactor

    /* Object Properties
     * ****************************************************************************************/
    width: node.guiConfig.width * customScaleFactor
    height: node.guiConfig.height * customScaleFactor
    x: (node.guiConfig?.position?.x - nodeRectTopLeft.x) * customScaleFactor
    y: (node.guiConfig?.position?.y - nodeRectTopLeft.y) * customScaleFactor
    border.color: node.guiConfig.locked ? "gray" : Qt.lighter(node.guiConfig.color, isSelected ? 1.2 : 1)
    border.width: (isSelected ? 2 : 1)
    opacity: isSelected ? 1 : 0.6
    radius: NLStyle.radiusAmount.nodeView * customScaleFactor

    /* Children
    * ****************************************************************************************/
    //! Minimal nodeview
    contentItem: Rectangle {
        id: minimalRectangle
        anchors.fill: parent
        anchors.margins: 10
        color: "#282828"
        radius: NLStyle.radiusAmount.nodeView * customScaleFactor

        //! Text Icon
        Text {
            font.family: NLStyle.fontType.font6Pro
            font.pixelSize: 60 * customScaleFactor
            anchors.centerIn: parent
            text: NLStyle.nodeIcons[node.type]
            color: node.guiConfig.locked ? "gray" : node.guiConfig.color
            font.weight: 400
        }
    }

}
