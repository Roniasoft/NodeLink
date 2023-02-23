import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import NodeLink
import QtQuick.Dialogs

Popup {
    required property Scene scene;
    id: popup1
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 300
    height: 150
    padding: 30
    modal: true
    focus: true
    background: Rectangle {
        color: "black";
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Text {
            text: qsTr("Are you sure you want to delete this item?")
            font.pointSize: 10
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.top: parent.top
        }

        //if clicked yes, card is deleted
        Button {
            id: yesbutton
            width: 60
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            background: Rectangle {
                color: "gray";
                radius:10
            }
            text: qsTr("Yes")
            onClicked: {
                popup1.close();
                scene.deleteNode(node.id);
            }
        }

        //if clicked no, popup is closed
        Button {
            id: nobutton
            width: 60
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            background: Rectangle {
                color: "gray";
                radius:10
            }
            text: qsTr("No")
            onClicked: {
                popup1.close()
            }
        }
    }
    //if clicked outside popup or the esc key pressed, popup closes
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
}
