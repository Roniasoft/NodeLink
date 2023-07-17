import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import QtQuick.Dialogs
import NodeLink

/*! ***********************************************************************************************
 * Confirmation  Popup
 * ************************************************************************************************/

Popup {
    id: popUp

    /* Property Declarations
     * ****************************************************************************************/
    property SceneSession   sceneSession: null

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

    onOpened:{
        // Checked the yesBtn when PopUp opened.
        yesBtn.checked = true;
        noBtn.checked = false;

        // Get key events
        mainRect.forceActiveFocus();
    }

    onClosed: sceneSession?.sceneForceFocus();

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
        radius: 10
    }

    Rectangle {
        id: mainRect
        anchors.fill: parent
        color: "transparent"

        //! Use Key to manage shift pressed to handle multiObject selection
        //! and Use Left and Right key to handle Yes or No buttons.
        Keys.onPressed: (event)=> {
                            switch (event.key){
                                case Qt.Key_Shift: {
                                sceneSession.isShiftModifierPressed = true;
                                break;
                                }
                                case Qt.Key_Control: {
                                    sceneSession.isCtrlPressed = true;
                                    break;
                                }
                                case Qt.Key_Left:
                                case Qt.Key_Right: {
                                    if(yesBtn.checked) {
                                        noBtn.checked = true;
                                        yesBtn.checked = false;
                                    } else if (noBtn.checked) {
                                        yesBtn.checked = true;
                                        noBtn.checked = false;
                                    }
                                    break;
                                }
                                // Enter on the keypad
                                case Qt.Key_Enter :
                                // Enter on the wordkey
                                case Qt.Key_Return: {
                                    if (yesBtn.checked)
                                        yesBtn.clicked()
                                    else if (noBtn.checked)
                                        noBtn.clicked()
                                    break;
                                }
                                default:
                                    break;
                            }
        }

        Keys.onReleased: (event)=> {
                             if (event.key === Qt.Key_Shift)
                                sceneSession.isShiftModifierPressed = false;
                             if(event.key === Qt.Key_Control)
                                sceneSession.isCtrlPressed = false;
                         }

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
                checkable: true
                background: Rectangle {
                    color: yesBtn.enabled && (yesBtn.hovered || yesBtn.checked)? Qt.lighter("gray", 1.5) : "gray"
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
                checkable: true

                background: Rectangle {
                    color: noBtn.enabled && (noBtn.hovered || noBtn.checked) ? Qt.lighter("gray", 1.5) : "gray"
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
