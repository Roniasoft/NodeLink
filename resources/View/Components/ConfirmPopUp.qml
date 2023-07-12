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
    width: 350
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
        id: background

        opacity: 0.95
        color: "black"
        radius: 5
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        //! description text
        Text {
            text: popUp.confirmText
            font.pointSize: 10
            font.family: "Roboto"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
        }

        //! Button Item
        Item {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            height: 25

            //if clicked yes, card is deleted
            Button {
                id: yesBtn
                width: 60
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    color: yesBtn.enabled && yesBtn.hovered ? Qt.lighter("gray", 1.5) : "gray"
                    radius: 10
                }
                text: qsTr("Yes")

                font.family: "Roboto"
                font.pointSize: yesBtn.enabled && yesBtn.hovered ? 12 : 10

                onClicked: {
                    popUp.accepted();
                    popUp.close();
                }
            }

            //if clicked no, popup is closed
            Button {
                id: noBtn
                width: 60
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                background: Rectangle {
                    color: noBtn.enabled && noBtn.hovered ? Qt.lighter("gray", 1.5) : "gray"
                    radius: 10
                }

                text: qsTr("No")
                font.family: "Roboto"
                font.pointSize: noBtn.enabled && noBtn.hovered ? 12 : 10
                onClicked: {
                    popUp.rejected();
                    popUp.close()
                }
            }
        }
    }
}
