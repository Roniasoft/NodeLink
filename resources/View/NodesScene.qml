import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import Qt5Compat.GraphicalEffects
import QtQuickStream

import "Logics/Calculation.js" as Calculation


/*! ***********************************************************************************************
 * NodesScene show the Nodes, Links, ports and etc.
 * ************************************************************************************************/
I_NodesScene {
    id: flickable

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent

    /* Children
    * ****************************************************************************************/
    background: SceneViewBackground {}

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if(scene.selectionModel.selectedModel.length > 0) {
            deletePopup.open();
        }
    }

    //! Use Key to manage shift pressed to handle multiObject selection
    Keys.onPressed: (event)=> {
        if (event.key === Qt.Key_Shift)
            sceneSession.isShiftModifierPressed = true;
    }

    Keys.onReleased: (event)=> {
        if (event.key === Qt.Key_Shift)
           sceneSession.isShiftModifierPressed = false;
    }

    /* Children
    * ****************************************************************************************/
    //! Delete selected objects
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: {
            scene.deleteSelectedObjects();
        }
    }

    //! Delete popup to confirm deletion process
    ConfirmPopUp {
        id: deletePopup
        onAccepted: delTimer.start();
    }

    //! MouseArea for selection of links
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !sceneSession.connectingMode

        //! We should toggle line selection with mouse press event
        onClicked: mouse => {
            if (!sceneSession.isShiftModifierPressed)
                 scene.selectionModel.clear();

            if (mouse.button === Qt.LeftButton) {
                var gMouse = mapToItem(contentLoader.item, Qt.point(mouse.x, mouse.y));
                var link = findLink(gMouse);
                if(link === null)
                     return;

                // Select current node
                if(scene.selectionModel.isSelected(link?._qsUuid) &&
                   sceneSession.isShiftModifierPressed)
                     scene.selectionModel.remove(link._qsUuid);
                else
                     scene.selectionModel.toggleLinkSelection(link);

            } else if (mouse.button === Qt.RightButton) {
                contextMenu.popup(mouse.x, mouse.y)
            }
        }
        onDoubleClicked: (mouse) => {
            scene.selectionModel.clear();
            if (mouse.button === Qt.LeftButton) {
                scene.createCustomizeNode(NLSpec.NodeType.General, mouse.x, mouse.y);
            }
        }

        //! Context Menu for adding a new node (for now)
        ContextMenu {
            id: contextMenu
            scene: flickable.scene
        }

        //! find the link under or close to the mouse cursor
        function findLink(gMouse): Link {
            let foundLink = null;
            Object.values(scene.links).forEach(obj => {
                var inputPos  = scene?.portsPositions[obj.inputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                var outputPos = scene?.portsPositions[obj.outputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                if (Calculation.isPointOnLink(gMouse.x, gMouse.y, 15, obj.controlPoints, obj.guiConfig.type)) {
                    foundLink = obj;
                }
            });
            return foundLink;
        }
    }

    //! Nodes/Connections
    contentItem: NodesRect {
        scene: flickable.scene
        sceneSession: flickable.sceneSession
        contentWidth: flickable.contentWidth
        contentHeight: flickable.contentHeight
    }

    //! Foreground
    foreground: null

    //! Background Loader
    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
    }

    //! Content Loader
    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: contentItem
    }

    //! Foreground Loader
    Loader {
        id: foregroundLoader
        anchors.fill: parent
        sourceComponent: foreground
    }
}
