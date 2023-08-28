import QtQuick
import NodeLink
import QtQuick.Controls

/*! ***********************************************************************************************
 * Blocker Node
 * ************************************************************************************************/
Rectangle {

    /* Property Declarations
    * ****************************************************************************************/
    property NotionNode node

    property SceneSession   sceneSession

    property real zoomFactor: sceneSession.zoomManager.zoomFactor

    //! Correct position based on zoomPoint and zoomFactor
    property vector2d     positionMapped: node.guiConfig?.position?.times(zoomFactor)

    /*  Object Properties
    * ****************************************************************************************/
    color: "black"//Qt.darker(node.guiConfig.color, 15)
    opacity: 0.7
    width: node.guiConfig.width
    height: node.guiConfig.height
    x: positionMapped.x
    y: positionMapped.y
    radius: NLStyle.radiusAmount.blockerNode
    smooth: true
    antialiasing: true
    layer.enabled: false

    //! Scales relative to top left
    transform: Scale {
        xScale: zoomFactor
        yScale: zoomFactor
    }

    //! Mouse are to blcok all mouse interactions
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    //! Why a node is not accessible
    Text {
        id: textBlock
        property bool textVisible: false
        anchors.fill: parent
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        font.family: textVisible ?  NLStyle.fontType.roboto : NLStyle.fontType.font6Pro
        font.weight: textVisible ? Font.Medium : 400
        text: textVisible ? (formatConditionsText()) : "\uf06a"
        font.pixelSize:  textVisible ? 11 : Math.min(parent.width, parent.height) / 4
        color: "grey"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                textBlock.textVisible = true;
            }
            onExited: {
                textBlock.textVisible = false;
            }
        }
    }

    //! function to join the unMet conditions in the form of a string
    function formatConditionsText() {
        if (node._unMetConditions.length === 0)
            return "Not accessible";
        else
            return "Entry condition is not met" + "\n"  + node._unMetConditions.join("\n");
    }

}
