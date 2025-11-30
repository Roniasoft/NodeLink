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
    property vector2d     nodeRectTopLeft:     viewProperties?.nodeRectTopLeft ?? Qt.vector2d(0, 0)

    //! Scale Factor used for scene -> overview mapping
    property real         overviewScaleFactor: viewProperties?.overviewScaleFactor ?? 1.0

    /* Object Properties
    * ****************************************************************************************/
    width: (node?.guiConfig?.width ?? 100) * overviewScaleFactor
    height: (node?.guiConfig?.height ?? 70) * overviewScaleFactor
    x: ((node?.guiConfig?.position?.x ?? 0) - nodeRectTopLeft.x) * overviewScaleFactor
    y: ((node?.guiConfig?.position?.y ?? 0) - nodeRectTopLeft.y) * overviewScaleFactor
    border.color: (node?.guiConfig?.locked ?? false) ? "gray" : Qt.lighter(node?.guiConfig?.color ?? "#ffffff", isSelected ? 1.2 : 1)
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
            text: (scene?.nodeRegistry?.nodeIcons ?? {})[node?.type ?? ""] ?? ""
            color: (node?.guiConfig?.locked ?? false) ? "gray" : (node?.guiConfig?.color ?? "#ffffff")
            font.weight: 400
        }
    }

}
