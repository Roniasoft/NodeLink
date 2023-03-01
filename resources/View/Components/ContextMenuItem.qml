import QtQuick
import QtQuick.Controls

/*! ***********************************************************************************************
 * Context Menu Item
 * ************************************************************************************************/
MenuItem {
    id: menuItem

    /* Property Declarations
     * ****************************************************************************************/
    property real hoverTracker: 0;

    /* Object Properties
     * ****************************************************************************************/
    height: 25

    background: Rectangle{
        anchors.fill: parent
        radius: 5
        anchors.rightMargin: 7
        anchors.leftMargin: 7
        color: (menuItem.hoverTracker) ? "#363636" : "transparent"
        Text {
            id: contextMenuIcon
            width: 20
            height: 20
            anchors { left: parent.left; leftMargin : 7; top: parent.top;
                    topMargin: 4}
            color: "#ababab"
            text: "\ue494"
            font.family: "fa-regular"
            font.pixelSize: 14
        }
        Text {
            id: contextMenuText
            anchors { left: contextMenuIcon.right; leftMargin : 7; top: parent.top;
                    topMargin: 2}
            text: "Add new card"
            color: "#ababab"
            font.pixelSize: 14
        }
    }
    onHoveredChanged: {
        menuItem.hoverTracker = !menuItem.hoverTracker
    }

}
