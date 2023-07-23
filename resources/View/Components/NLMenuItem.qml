import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * MenuItem customize menu item.
 * ************************************************************************************************/

MenuItem {
    id: menuItem

    /* Property Declarations
     * ****************************************************************************************/

    // Menu item description
    property string description: ""

    /* Object Properties
     * ****************************************************************************************/

    // Check icon
    indicator: Text {
        id: checkedIcon
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 5
        text: "\uf00c"
        visible: menuItem.checked
        font.family: NLStyle.fontType.font6Pro
        font.pointSize: 12
        font.weight: 400
        color: "white"
    }

    // Icon and its description
    contentItem: Item {
        Text {
            id: icon
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            text: menuItem.text
            font.family: NLStyle.fontType.font6Pro
            font.pointSize: 12
            font.weight: 400
            color: "white"

        }

        Text {
            id: name
            anchors.left: icon.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 5
            text: description
            font.family: NLStyle.fontType.roboto
            color: "white"
        }
    }

    // Menu bachground
    background: Rectangle {
        id:toolButtonController
        width: menuItem.width
        height: menuItem.height
        radius: NLStyle.radiusAmount.itemButton
        color: menuItem.hovered ? "#2f2f2f" : "transparent"
        opacity: enabled ? 1 : 0.3
        Behavior on color{ColorAnimation{duration: 75}}
    }
}
