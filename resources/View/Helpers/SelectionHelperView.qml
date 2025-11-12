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

    //! busySelecting to skip operations if busy with selection
    property          bool           busySelecting: false

    /* Children
    * ****************************************************************************************/

    //! Update marquee selection with SceneSession signals.
    Connections {
        target: sceneSession

        function onMarqueeSelectionModeChanged() {
            if (!sceneSession.marqueeSelectionMode && !selectionTimer.running && !busySelecting) {
                resetMarqueeDimensions();
            }
        }

        function onMarqueeSelectionStart(mouse) {
            // create a new rectangle at the wanted position
            lastPressPoint.x = mouse.x;
            lastPressPoint.y = mouse.y;

            resetMarqueeDimensions();
        }

        function onUpdateMarqueeSelection(mouse) {
            // Update position and dimentions of temp rubber band
            selectionRubberBandItem.x = Math.min(lastPressPoint.x , mouse.x)
            selectionRubberBandItem.y = Math.min(lastPressPoint.y , mouse.y)
            selectionRubberBandItem.width = Math.abs(lastPressPoint.x - mouse.x);
            selectionRubberBandItem.height = Math.abs(lastPressPoint.y - mouse.y);

            if (!selectionTimer.running && !busySelecting)
                Qt.callLater(selectionTimer.start)
        }
    }

    //! Rubber band item
    Item {
        id: selectionRubberBandItem

        visible: sceneSession?.marqueeSelectionMode ?? false

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
            busySelecting = true
            // Disable sending signals temporarily for performance improvement
            scene.selectionModel.notifySelectedObject = false;

            // clear selection model
            scene.selectionModel.clear();

            // Find objects inside foregroundItem
            var selectionRubberBandRect = Qt.rect(selectionRubberBandItem.x,
                                                  selectionRubberBandItem.y,
                                                  selectionRubberBandItem.width,
                                                  selectionRubberBandItem.height);
            var selectedObj = scene.findNodesInContainerItem(selectionRubberBandRect);
            selectedObj.forEach(node =>  {
                if (node.objectType === NLSpec.ObjectType.Node) {
                    scene.selectionModel.selectNode(node);

                } else if (node.objectType === NLSpec.ObjectType.Container) {
                    scene.selectionModel.selectContainer(node);
                }
            }); // todo: why don't we select the LINKS?

            scene.selectionModel.notifySelectedObject = true;
            // todo: should we check actual change?
            scene.selectionModel.selectedModelChanged();

            busySelecting = false
        }
    }

    // Reset the rubberband width and height
    function resetMarqueeDimensions() {
        selectionRubberBandItem.width = 0;
        selectionRubberBandItem.height = 0;
    }
}
