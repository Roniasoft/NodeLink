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
        color: (menuItem.hoverTracker) ? "#363636" : "transparent"

        Rectangle {
            id: contextMenuIconRect

            radius: 5
            color: (checkable && checked) ? "#2f2f2f" : "transparent"
            width: 25
            height: 25

            anchors.left: parent.left
            anchors.leftMargin : 2
            anchors.top: parent.top;
            anchors.topMargin: 2

            Text {
                id: contextMenuIcon

                anchors.left: parent.left
                anchors.leftMargin : 7
                anchors.top: parent.top;
                anchors.topMargin: 4

                color: "#ababab"
                text: menuItem.iconStr
                font.family: "Font Awesome 6 Pro"
                font.pixelSize: 14
                font.weight: 400

            }
        }
        Text {
            id: contextMenuText
            anchors.left: contextMenuIconRect.right;
            anchors.leftMargin : 7
            anchors.top: parent.top
            anchors.topMargin: 2

            text: menuItem.name
            color: "#ababab"
            font.pixelSize: 14
        }
    }
    onHoveredChanged: {
        menuItem.hoverTracker = !menuItem.hoverTracker
    }

    indicator: Item {}
}
