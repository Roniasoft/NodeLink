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
    required property I_Scene        scene

    //! Scene session contains information about scene states (UI related)
    required property SceneSession   sceneSession

    //! Handle rubber band drawing.
    property          bool           isLeftClickPressedAndHold: false

    //! lastPressPoint to handle temp rubber band dimentions
    property          var            lastPressPoint: Qt.point(0,0)

    /* Children
    * ****************************************************************************************/

    //! Update marque selection with SceneSession signals.
    Connections {
        target: sceneSession

        function onRubberBandSelectionModeChanged() {
            if (!sceneSession.rubberBandSelectionMode) {
                selectionRubberBandItem.width  = 0;
                selectionRubberBandItem.height = 0;
            }
        }

        function onMarqueSelectionStart(mouse) {
            // create a new rectangle at the wanted position
            lastPressPoint.x = mouse.x;
            lastPressPoint.y = mouse.y;

            // Reset the rubberband width and height
            selectionRubberBandItem.width  = 0;
            selectionRubberBandItem.height = 0;

        }

        function onUpdateMarqueSelection(mouse) {
            // Update position and dimentions of temp rubber band
            selectionRubberBandItem.x = Math.min(lastPressPoint.x , mouse.x)
            selectionRubberBandItem.y = Math.min(lastPressPoint.y , mouse.y)
            selectionRubberBandItem.width = Math.abs(lastPressPoint.x - mouse.x);
            selectionRubberBandItem.height =  Math.abs(lastPressPoint.y - mouse.y);

            selectionTimer.start();
        }
    }

    //! Rubber band item
    Item {
        id: selectionRubberBandItem

        visible: sceneSession?.rubberBandSelectionMode ?? false
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
            var zoomFactor = sceneSession.zoomManager.zoomFactor
            var selectionRubberBandRect = Qt.rect(selectionRubberBandItem.x / zoomFactor,
                                                  selectionRubberBandItem.y / zoomFactor,
                                                  selectionRubberBandItem.width / zoomFactor,
                                                  selectionRubberBandItem.height / zoomFactor);
            var selectedObj = scene.findNodesInContainerItem(selectionRubberBandRect);
            selectedObj.forEach(node => scene.selectionModel.selectNode(node));
        }
    }
}
