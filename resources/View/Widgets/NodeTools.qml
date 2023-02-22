import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import NodeLink
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * The toolbar appearing on top of each node.
 * From left, first button is to change color.
 * Second is to make a duplicate.
 * Third is to disable text editting. It is activated with click and deactivated with double click.
 * Fourth is for deleting the card completely.
 * ************************************************************************************************/
Rectangle {
    id: toolsItem

    /* Property Declarations
     * ****************************************************************************************/


    /* Object Properties
     * ****************************************************************************************/
    radius: 5
    height: 34
    width: layout.implicitWidth + 4
    border.color: "#363636"
    color: "#1e1e1e"

    //A row of different buttons
    RowLayout {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3

        //color change
        MButton {
            id: colorButton1
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            text: "\uf53f"

            //color changer appears on one click
            onClicked: {
                tangle.visible = !tangle.visible
            }
        }

        //Duplicating the card
        MButton {
            text: "\uf24d"
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            id: duplicateButton
            onClicked: {
                scene.cloneNode(node.id);
            }
        }

        //Locking the card
        MButton {
            id: lockButton
            text: "\uf30d"
            checkable: true
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            //Enabling read only

            onClicked:{
                locked = lockButton.checked
            }
        }

        //Delete button
        MButton {
            id: deleteButton
            text: "\uf2ed"
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            //popup appears on click
            onClicked: {
                popup1.open()
            }

            Popup {
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
        }
    }

    //defining a color picker element to be used in the first button
    ColorPicker {
        id: tangle
        anchors.bottom: toolsItem.top
        anchors.topMargin: 5
        anchors.horizontalCenter: toolsItem.horizontalCenter
        visible: false
        onColorChanged: (colorName)=> {
            node.guiConfig.color = colorName
        }
    }
}
