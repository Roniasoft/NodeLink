import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * Confirmation  Popup
 * ************************************************************************************************/

Popup {
    id: popUp

    /* Property Declarations
     * ****************************************************************************************/
    //! Confirm Text
    property string confirmText: "Are you sure you want to delete this item?"

    /* Object Properties
     * ****************************************************************************************/
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 300
    height: 150
    padding: 30
    modal: true
    focus: true


    /* Signals
     * ****************************************************************************************/
    signal accepted();
    signal rejected();

    /* Children
     * ****************************************************************************************/
    background: Rectangle {
        color: "black"
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        Text {
            text: popUp.confirmText
            font.pointSize: 10
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.top: parent.top
        }

        //if clicked yes, card is deleted
        Button {
            width: 60
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            background: Rectangle {
                color: "gray"
                radius:10
            }
            text: qsTr("Yes")
            onClicked: {
                popUp.accepted();
                popUp.close();
            }
        }

        //if clicked no, popup is closed
        Button {
            width: 60
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            background: Rectangle {
                color: "gray"
                radius:10
            }
            text: qsTr("No")
            onClicked: {
                popUp.rejected();
                popUp.close()
            }
        }
    }
}
