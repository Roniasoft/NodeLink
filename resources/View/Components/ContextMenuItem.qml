import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Context Menu Item
 * ************************************************************************************************/
MenuItem {
    id: menuItem

    /* Property Declarations
     * ****************************************************************************************/
    property real hoverTracker: 0

    property string name: "General Node"

    property var iconStr: NLStyle.nodeIcons[NLSpec.NodeType.General]

    /* Object Properties
     * ****************************************************************************************/
    height: 25

    background: Rectangle{
        anchors.fill: parent
        radius: 5
//        anchors.rightMargin: 2
//        anchors.leftMargin: 2
        color: (menuItem.hoverTracker) ? "#363636" : "transparent"
        Text {
            id: contextMenuIcon
            width: 20
            height: 20
            anchors { left: parent.left; leftMargin : 5; top: parent.top;
                    topMargin: 4}
            color: "#ababab"
            text: menuItem.iconStr
            font.family: "Font Awesome 6 Pro"
            font.pixelSize: 14
            font.weight: 400
        }
        Text {
            id: contextMenuText
            anchors { left: contextMenuIcon.right; leftMargin : 7; top: parent.top;
                    topMargin: 2}
            text: menuItem.name
            color: "#ababab"
            font.pixelSize: 14
        }
    }
    onHoveredChanged: {
        menuItem.hoverTracker = !menuItem.hoverTracker
    }

}
