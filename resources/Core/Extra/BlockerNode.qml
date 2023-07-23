import QtQuick
import NodeLink
import QtQuick.Controls

/*! ***********************************************************************************************
 * Blocker Node
 * ************************************************************************************************/
Rectangle {

    property Node node

    /*  Object Properties
    * ****************************************************************************************/
    color: "black"//Qt.darker(node.guiConfig.color, 15)
    opacity: 0.7
    width: node.guiConfig.width
    height: node.guiConfig.height
    x: node.guiConfig.position.x
    y: node.guiConfig.position.y
    radius: NLStyle.radiusAmount.blockerNode
    smooth: true
    antialiasing: true
    layer.enabled: false


    //! Mouse are to blcok all mouse interactions
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }
}
