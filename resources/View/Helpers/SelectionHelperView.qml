import QtQuick
import QtQuick.Controls

import NodeLink

Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Scene is the main model containing information about all nodes/links
    required property I_Scene        scene

    //! Scene session contains information about scene states (UI related)
    required property SceneSession   sceneSession

    property string activeSelectionMode: sceneSession.selectionType

    /* ****************************************************************************************
     * Rectangle Selection
     *****************************************************************************************/
    Item {
        id: rectangleSelection
        visible: root.activeSelectionMode === "rectangle"

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
                if (!sceneSession.marqueeSelectionMode && !selectionTimer.running && !rectangleSelection.busySelecting
                        && root.activeSelectionMode === "rectangle") {
                    rectangleSelection.resetMarqueeDimensions();
                }
            }

            function onMarqueeSelectionStart(mouse) {
                if (root.activeSelectionMode === "rectangle") {
                    // create a new rectangle at the wanted position
                    rectangleSelection.lastPressPoint.x = mouse.x;
                    rectangleSelection.lastPressPoint.y = mouse.y;

                    rectangleSelection.resetMarqueeDimensions();
                }
            }

            function onUpdateMarqueeSelection(mouse) {
                if (root.activeSelectionMode === "rectangle") {
                    // Update position and dimentions of temp rubber band
                    selectionRubberBandItem.x = Math.min(rectangleSelection.lastPressPoint.x , mouse.x)
                    selectionRubberBandItem.y = Math.min(rectangleSelection.lastPressPoint.y , mouse.y)
                    selectionRubberBandItem.width = Math.abs(rectangleSelection.lastPressPoint.x - mouse.x);
                    selectionRubberBandItem.height = Math.abs(rectangleSelection.lastPressPoint.y - mouse.y);

                    if (!selectionTimer.running && !rectangleSelection.busySelecting)
                        Qt.callLater(selectionTimer.start)
                }
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

                visible: rectangleSelection.visible
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
                rectangleSelection.busySelecting = true
                // Disable sending signals temporarily for performance improvement
                scene.selectionModel.notifySelectedObject = false;

                // clear selection model
                scene.selectionModel.clear();

                // Find objects inside foregroundItem
                var selectionRect = Qt.rect(selectionRubberBandItem.x,
                                            selectionRubberBandItem.y,
                                            selectionRubberBandItem.width,
                                            selectionRubberBandItem.height);
                var selectedObj = scene.findNodesInContainerItem(selectionRect);
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

                rectangleSelection.busySelecting = false
            }
        }

        // Reset the rubberband width and height
        function resetMarqueeDimensions() {
            selectionRubberBandItem.width = 0;
            selectionRubberBandItem.height = 0;
        }
    }

    /* ****************************************************************************************
     * Lasso Selection (Freehand)
     *****************************************************************************************/
    Item {
        id: lassoSelection
        width: root.width
        height: root.height
        visible: root.activeSelectionMode === "lasso"

        property bool isLeftClickPressedAndHold: false
        property var lastPressPoint: Qt.point(0,0)
        property bool busySelecting: false
        property var pathPoints: []
        property bool isShapeClosed: false
        property string currentStrokeColor: "#8F30FA"

        Canvas {
            id: freehandCanvas
            anchors.fill: parent
            visible: root.activeSelectionMode === "lasso"

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                if (lassoSelection.isShapeClosed && lassoSelection.pathPoints.length > 2) {
                    ctx.beginPath();
                    ctx.moveTo(lassoSelection.pathPoints[0].x, lassoSelection.pathPoints[0].y);
                    for (var i = 1; i < lassoSelection.pathPoints.length; i++)
                        ctx.lineTo(lassoSelection.pathPoints[i].x, lassoSelection.pathPoints[i].y);
                    ctx.closePath();

                    ctx.fillStyle = "rgba(143, 48, 250, 0.2)";
                    ctx.fill();
                }

                ctx.lineWidth = 3;
                ctx.strokeStyle = lassoSelection.currentStrokeColor;
                ctx.globalAlpha = 0.8;

                ctx.beginPath();
                if (lassoSelection.pathPoints.length > 1) {
                    ctx.moveTo(lassoSelection.pathPoints[0].x, lassoSelection.pathPoints[0].y);
                    for (var j = 1; j < lassoSelection.pathPoints.length; j++)
                        ctx.lineTo(lassoSelection.pathPoints[j].x, lassoSelection.pathPoints[j].y);
                }
                ctx.stroke();
            }
        }

        Connections {
            target: sceneSession

            function onMarqueeSelectionModeChanged() {
                if (!sceneSession.marqueeSelectionMode && !selectionTimerLasso.running && !lassoSelection.busySelecting
                        && root.activeSelectionMode === "lasso")
                    lassoSelection.resetFreehand();
            }

            function onMarqueeSelectionStart(mouse) {
                if (root.activeSelectionMode === "lasso") {
                    freehandCanvas.visible = true
                    lassoSelection.resetFreehand();
                    lassoSelection.lastPressPoint = Qt.point(mouse.x, mouse.y);
                    lassoSelection.pathPoints.push(Qt.point(mouse.x, mouse.y));
                    freehandCanvas.requestPaint();
                }
            }

            function onUpdateMarqueeSelection(mouse) {
                if (root.activeSelectionMode === "lasso") {
                    var current = Qt.point(mouse.x, mouse.y);
                    if (lassoSelection.pathPoints.length === 0)
                        return;
                    var last = lassoSelection.pathPoints[lassoSelection.pathPoints.length - 1];
                    if (Math.abs(last.x - current.x) > 2 || Math.abs(last.y - current.y) > 2)
                        lassoSelection.pathPoints.push(current);

                    freehandCanvas.requestPaint();

                    if (!selectionTimerLasso.running && !lassoSelection.busySelecting)
                        Qt.callLater(selectionTimerLasso.start);
                }
            }

            function onMarqueeSelectionEnd(mouse) {
                if (lassoSelection.pathPoints.length < 3) {
                    lassoSelection.resetFreehand()
                    return
                }

                var first = lassoSelection.pathPoints[0]
                var last = lassoSelection.pathPoints[lassoSelection.pathPoints.length - 1]

                var dx = first.x - last.x
                var dy = first.y - last.y
                var dist = Math.sqrt(dx*dx + dy*dy)
                var threshold = 25

                if (dist >= threshold) {
                    lassoSelection.resetFreehand()
                } else {
                    lassoSelection.isShapeClosed = true
                }
            }
        }

        Timer {
            id: selectionTimerLasso
            interval: 120
            repeat: false
            running: false

            onTriggered: {
                lassoSelection.busySelecting = true;

                lassoSelection.closeShapeIfNeeded()

                scene.selectionModel.notifySelectedObject = false;
                scene.selectionModel.clear();

                // simple bounding rect for selection
                var minX = 999999, minY = 999999;
                var maxX = -999999, maxY = -999999;

                for (var i = 0; i < lassoSelection.pathPoints.length; i++) {
                    minX = Math.min(minX, lassoSelection.pathPoints[i].x);
                    minY = Math.min(minY, lassoSelection.pathPoints[i].y);
                    maxX = Math.max(maxX, lassoSelection.pathPoints[i].x);
                    maxY = Math.max(maxY, lassoSelection.pathPoints[i].y);
                }

                var selectionRect = Qt.rect(minX, minY, maxX - minX, maxY - minY);
                var selectedObj = scene.findNodesInContainerItem(selectionRect);

                selectedObj.forEach(node => {
                    if (node.objectType === NLSpec.ObjectType.Node)
                        scene.selectionModel.selectNode(node);
                    else if (node.objectType === NLSpec.ObjectType.Container)
                        scene.selectionModel.selectContainer(node);
                });

                scene.selectionModel.notifySelectedObject = true;
                scene.selectionModel.selectedModelChanged();
                lassoSelection.busySelecting = false;
            }
        }

        function closeShapeIfNeeded() {
            lassoSelection.isShapeClosed = false;

            if (lassoSelection.pathPoints.length < 3)
                return;

            var first = lassoSelection.pathPoints[0];
            var last = lassoSelection.pathPoints[lassoSelection.pathPoints.length - 1];

            var dx = first.x - last.x;
            var dy = first.y - last.y;
            var dist = Math.sqrt(dx*dx + dy*dy);

            var threshold = 25;

            if (dist < threshold) {
                lassoSelection.pathPoints[lassoSelection.pathPoints.length - 1] = Qt.point(first.x, first.y);
                lassoSelection.isShapeClosed = true;
            }

            freehandCanvas.requestPaint();
        }

        function resetFreehand() {
            lassoSelection.pathPoints = [];
            lassoSelection.isShapeClosed = false;
            freehandCanvas.requestPaint();
        }
    }
}
