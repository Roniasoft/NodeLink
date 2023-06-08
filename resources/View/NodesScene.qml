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
    interactive: !sceneSession.isCtrlPressed

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
        if(event.key === Qt.Key_Control)
            sceneSession.isCtrlPressed = true;

    }

    Keys.onReleased: (event)=> {
        if (event.key === Qt.Key_Shift)
           sceneSession.isShiftModifierPressed = false;
        if(event.key === Qt.Key_Control)
             sceneSession.isCtrlPressed = false;
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

        hoverEnabled: true//sceneSession.isCtrlPressed

        property var lastPressPoint: Qt.point(0,0)

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

        //! PressAndHold to control temp rubber band.
        pressAndHoldInterval: 100
        onPressAndHold: (mouse) => {
            if(mouse.button === Qt.LeftButton)
                sceneSession.isLeftClickPressedAndHold = true;
            if (sceneSession.isCtrlPressed && sceneSession.isLeftClickPressedAndHold) {
                // create a new rectangle at the wanted position
                lastPressPoint.x = mouse.x;
                lastPressPoint.y = mouse.y;
            }
        }

        onReleased: (mouse) => {
                        if(mouse.button === Qt.LeftButton)
                            sceneSession.isLeftClickPressedAndHold = false;
                    }

        // lastMousePos to handle temp rubber band dimentions
        property var lastMousePos: Qt.point(0, 0)
        onPositionChanged: (mouse) => {
                               if(sceneSession.isCtrlPressed &&
                                  sceneSession.isLeftClickPressedAndHold) {
                                   // Update position and dimentions of temp rubber band
                                   tempRubberBand.x = Math.min(lastPressPoint.x , mouse.x)
                                   tempRubberBand.y = Math.min(lastPressPoint.y , mouse.y)
                                   tempRubberBand.width = Math.abs(lastPressPoint.x - mouse.x);
                                   tempRubberBand.height =  Math.abs(lastPressPoint.y - mouse.y);

                                   // Update content dimentions of flicable with mouse position.
                                   if(flickable.contentX + flickable.width < tempRubberBand.x + tempRubberBand.width) {
                                       contentX += mouse.x - lastMousePos.x
                                   }
                                   if(flickable.contentX > tempRubberBand.x) {
                                       flickable.contentX = tempRubberBand.x
                                   }

                                   if(flickable.contentY + flickable.height < tempRubberBand.y + tempRubberBand.height) {
                                       flickable.contentY += mouse.y - lastMousePos.y
                                   }
                                   if(flickable.contentY > tempRubberBand.y) {
                                       flickable.contentY = tempRubberBand.y
                                   }

                                   lastMousePos = Qt.point(mouse.x, mouse.y);

                                   selectionTimer.start();
                               }
                           }

        //! Timer to handle additional fuction calls.
        Timer {
            id: selectionTimer
            interval: 100
            repeat: false
            running: false

            onTriggered: {
                // clear selection model
                scene.selectionModel.clear();
                // Find objects inside foregroundItem
                var selectedObj = scene.findNodesInContainerItem(tempRubberBand);
                selectedObj.forEach(node => scene.selectionModel.select(node));
            }
        }

        //! Context Menu for adding a new node (for now)
        ContextMenu {
            id: contextMenu
            scene: flickable.scene
        }


        //! Temporary Rubber band, draw a rectangle and selec some nodes.
        Item {
            id: tempRubberBand

            visible: sceneSession.isCtrlPressed &&
                     sceneSession.isLeftClickPressedAndHold

            onVisibleChanged: {
                if(!visible) {
                    width = 0;
                    height = 0;
                }
            }

            //! Rubber band border with different opacity
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                opacity: 0.5

                visible: rubberBand.visible
                border.width: 3
                border.color: "#8F30FA"
            }

            //! Rubber band to handle selection rect
            Rectangle {
                id: rubberBand

                anchors.fill: parent

                color: "#8F30FA"
                opacity: 0.2
            }

            Connections {
                target: sceneSession

                function onIsCtrlPressedChanged() {
                    if(!sceneSession.isCtrlPressed) {
                        tempRubberBand.width = 0;
                        tempRubberBand.height = 0;
                    }

                }
            }

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
