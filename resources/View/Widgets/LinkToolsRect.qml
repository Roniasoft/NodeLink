import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import NodeLink
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * The toolbar appearing on top of each link.
 * From left, first button is to change color.
 * Second is to make a description enable to edit.
 * Third is for deleting the card completely.
 * ************************************************************************************************/
Rectangle {
    id: toolsItem

    /* Property Declarations
     * ****************************************************************************************/
    required property Scene scene

    required property Link  link

    property alias colorPicker: colorPicker

    property bool isEditableDescription: false

    /* Object Properties
     * ****************************************************************************************/
    radius: 5
    height: 34
    width: layout.implicitWidth + 4
    border.color: "#363636"
    color: "#1e1e1e"

    /* Children
     * ****************************************************************************************/
    //A row of different buttons
    RowLayout {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3

        //color change
        NLToolButton {
            id: colorButton1
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            text: "\uf53f"

            //color changer appears on one click
            onClicked: {
                colorPicker.visible = !colorPicker.visible
            }
        }


        //Edit discription
        NLToolButton {
            id: editLabelButton
            text: "\uf044"
            checkable: true
            checked: isEditableDescription
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2

            //Enabling read only
            onClicked:{
                isEditableDescription = editLabelButton.checked
            }

        }

        //Direction button
        NLToolButton {
            id: directionButton
            text: NLStyle.linkDirectionIcon[link.direction]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            //popup appears on click
            onClicked: menu.open()

            // Select link direction
            Menu {
                id: menu
                y: directionButton.height

                // Nondirectional MenuItem
                NLMenuItem {
                    text: NLStyle.linkDirectionIcon[NLSpec.LinkDirection.Nondirectional]
                    description: "Nondirectional"
                    checked: link.direction === NLSpec.LinkDirection.Nondirectional
                    onTriggered: link.direction = NLSpec.LinkDirection.Nondirectional
                }

                // Unidirectional MenuItem
                NLMenuItem {
                    text: NLStyle.linkDirectionIcon[NLSpec.LinkDirection.Unidirectional]
                    description: "Unidirectional"
                    checked: link.direction === NLSpec.LinkDirection.Unidirectional
                    onTriggered: link.direction = NLSpec.LinkDirection.Unidirectional
                }

                // Bidirectional MenuItem
                NLMenuItem {
                    text: NLStyle.linkDirectionIcon[NLSpec.LinkDirection.Bidirectional]
                    description: "Bidirectional"
                    checked: link.direction === NLSpec.LinkDirection.Bidirectional
                    onTriggered: link.direction = NLSpec.LinkDirection.Bidirectional
                }

                background: Item {
                    implicitWidth: 150
                    implicitHeight: 100

                    Rectangle {
                        id: toolButtonController

                        anchors.fill: parent
                        radius: 5
                        color: "#1e1e1e"
                        opacity: enabled ? 1 : 0.3
                    }
                }
            }
        }

        //Delete button
        NLToolButton {
            id: deleteButton
            text: "\uf2ed"
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            //popup appears on click
            onClicked: objectDeletorItem.unlinkNodes(link)
        }
    }

    // delete link
    ObjectDeletorItem {
        id: objectDeletorItem
        scene: toolsItem.scene
    }


    //defining a color picker element to be used in the first button
    ColorPicker {
        id: colorPicker
        anchors.bottom: toolsItem.top
        anchors.topMargin: 5
        anchors.horizontalCenter: toolsItem.horizontalCenter
        visible: false
        onColorChanged: (colorName)=> {
            link.guiConfig.color = colorName
        }
   }
}
