import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Context Menu to manage Node selection actions
 * ************************************************************************************************/
Menu {
    id: contextMenu

    /* Property Declarations
     * ****************************************************************************************/
    required property I_Scene scene
    required property var     node

    property SceneSession   sceneSession: null

    /* Signals
     * ****************************************************************************************/
    signal viewImage();

    /* Object Properties
     * ****************************************************************************************/
    width: 180
    padding: 5
    //background is overrided
    background: Rectangle{
        anchors.fill: parent
        radius: NLStyle.radiusAmount.itemButton
        color: "#262626"
        border.width: 1
        border.color: "#1c1c1c"
    }

    /* Signal
     * ****************************************************************************************/
    signal editNode()

    /* Children
     * ****************************************************************************************/
    //! Edit button
    ContextMenuItem {
        name: "Edit"
        iconStr: "\uf044"
        enabled: !node?.guiConfig?.locked ?? false
        onClicked: {
            editNode();
        }
    }

    //! Duplicate button
    ContextMenuItem {
        name: "Duplicate Node"
        iconStr: "\uf24d"
        onClicked: {
            scene.cloneNode(node._qsUuid);
        }
    }

    //! Lock button
    ContextMenuItem {
        id: lockItem

        name: "Lock Node"
        iconStr: "\uf30d"
        checkable: true
        checked: node?.guiConfig?.locked ?? false
        onClicked: {
            node.guiConfig.locked = checked;
        }
    }

    //! Spacer
    Rectangle {
        id: spacerRect

        anchors.top: lockItem.bottom
        anchors.topMargin: 4
        width: parent.width
        height: 1

        color:  Qt.lighter("#444", 1.2)
    }

    //! Delete button
    ContextMenuItem {
        anchors.top: spacerRect.bottom
        anchors.topMargin: 4

        name: "Delete Node"
        iconStr: "\uf2ed"
        onClicked: deletePopup.open();

        //! Delete popup to confirm deletion process
        ConfirmPopUp {
            id: deletePopup
            sceneSession: contextMenu.sceneSession
            onAccepted: delTimer.start();
        }

        //! Delete objects
        Timer {
            id: delTimer
            repeat: false
            running: false
            interval: 100
            onTriggered: scene.deleteNode(node._qsUuid);
        }
    }
}
