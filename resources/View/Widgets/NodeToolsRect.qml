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
    required property Scene scene

    required property Node  node

    property alias    colorPicker: colorPicker

    property bool isNodeLock: false


    /* Object Properties
     * ****************************************************************************************/
    radius: 5
    height: 34
    width: layout.implicitWidth + 4
    border.color: "#363636"
    color: "#1e1e1e"

    /* Children
     * ****************************************************************************************/
    //! A row of different buttons
    RowLayout {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3

        //! Color change
        NLToolButton {
            id: colorButton1
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            text: "\uf53f"

            // Color changer appears on one click
            onClicked: {
                colorPicker.visible = !colorPicker.visible
            }
        }

        //! Duplicating the card
        NLToolButton {
            text: "\uf24d"
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            id: duplicateButton
            onClicked: {
                scene.cloneNode(node._qsUuid);
            }
        }

        //! Locking the card
        NLToolButton {
            id: lockButton
            text: "\uf30d"
            checkable: true
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            checked: isNodeLock

            //! Enabling read only
            onClicked: {
                isNodeLock = checked;
            }
        }

        //! Delete button
        NLToolButton {
            id: deleteButton
            text: "\uf2ed"
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            onClicked: deletePopup.open()

            //! Delete popup to confirm deletion process
            ConfirmPopUp {
                id: deletePopup
                onAccepted: delTimer.start();
            }
        }
    }

    //! Delete objects
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: scene.deleteNode(node._qsUuid);
    }

    //! Defining a color picker element to be used in the first button
    ColorPicker {
        id: colorPicker
        anchors.bottom: toolsItem.top
        anchors.topMargin: 5
        anchors.horizontalCenter: toolsItem.horizontalCenter
        visible: false
        onColorChanged: (colorName)=> {
            node.guiConfig.color = colorName
        }
    }
}
