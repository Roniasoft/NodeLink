import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * SelectionHelperView draw a rectangle and select some nodes inside it's rubberband..
 * ************************************************************************************************/

Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Scene is the main model containing information about all nodes/links
    required property Scene          scene

    //! Scene session contains information about scene states (UI related)
    required property SceneSession   sceneSession

    //! Handle rubber band drawing.
    property          bool           isLeftClickPressedAndHold: false

    /* Children
    * ****************************************************************************************/

    //! Rubber band item
    Item {
        id: selectionRubberBandItem

        visible: sceneSession.rubberBandSelectionMode
        //! Rubber band border with different opacity
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            opacity: 0.5

            visible: root.visible
            border.width: 3
            border.color: "#8F30FA"
        }

        //! Rubber band to handle selection rect
        Rectangle {
            anchors.fill: parent

            color: "#8F30FA"
            opacity: 0.2
        }
    }

    //! MouseArea to handle RubberBand geometry.
    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        enabled: sceneSession.isCtrlPressed
        hoverEnabled: true
        preventStealing: true

        onEnabledChanged: {
            if (!enabled) {
                // Reset the rubberband width and height
                selectionRubberBandItem.width  = 0;
                selectionRubberBandItem.height = 0;
                sceneSession.rubberBandSelectionMode = false;
            }
        }


        // lastPressPoint to handle temp rubber band dimentions
        property var lastPressPoint: Qt.point(0,0)

        //! PressAndHold to control temp rubber band.
        pressAndHoldInterval: 5
        onPressAndHold: (mouse) => {
            if(mouse.button === Qt.LeftButton)
                sceneSession.rubberBandSelectionMode = true;
            if (sceneSession.rubberBandSelectionMode) {
                // create a new rectangle at the wanted position
                lastPressPoint.x = mouse.x;
                lastPressPoint.y = mouse.y;

                // Reset the rubberband width and height
                selectionRubberBandItem.width  = 0;
                selectionRubberBandItem.height = 0;
            }
        }
        onPositionChanged: (mouse) => {
                               if(sceneSession.rubberBandSelectionMode) {
                                   // Update position and dimentions of temp rubber band
                                   selectionRubberBandItem.x = Math.min(lastPressPoint.x , mouse.x)
                                   selectionRubberBandItem.y = Math.min(lastPressPoint.y , mouse.y)
                                   selectionRubberBandItem.width = Math.abs(lastPressPoint.x - mouse.x);
                                   selectionRubberBandItem.height =  Math.abs(lastPressPoint.y - mouse.y);

                                   selectionTimer.start();
                               }
                           }

        onReleased: (mouse) => {
                        if(mouse.button === Qt.LeftButton)
                            sceneSession.rubberBandSelectionMode = false;
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
                var selectedObj = scene.findNodesInContainerItem(selectionRubberBandItem,
                                                                 sceneSession.zoomManager.zoomFactor);
                selectedObj.forEach(node => scene.selectionModel.selectNode(node));
            }
        }
    }
}
