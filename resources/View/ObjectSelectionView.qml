import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * ObjectSelectionView is an Item that manages tools of selected object and
 * draw a rectangle around them.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property I_Scene        scene
    property SceneSession   sceneSession
    property SelectionModel selectionModel: scene?.selectionModel ?? null

    property bool           hasSelectedObject: Object.values(selectionModel?.selectedModel ?? ({})).length > 0

    /*  Object Properties
    * ****************************************************************************************/
    visible: hasSelectedObject && sceneSession.isSceneEditable
    z: 1000

    Keys.forwardTo: parent

    /*  Children
    * ****************************************************************************************/
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
        color: Object.values(scene?.selectionModel?.selectedModel ?? ({})).length> 1 ? "#8F30FA" :
                                                                             "transparent"
        opacity: 0.2

        visible: Object.values(scene?.selectionModel?.selectedModel ?? ({})).length > 1
   }

    //! selected object tool rect
    SelectionToolsRect {
        anchors.bottom: parent.top
        anchors.bottomMargin: selectedContainerOnly ? Object.values(scene.selectionModel.selectedModel)[0].guiConfig.containerTextHeight + 5 : 5
        anchors.horizontalCenter: parent.horizontalCenter
        //! This prevents header item from moving over NodeView
        transformOrigin: Item.Bottom
        //! This is for keeping size fixed and ignoring scale
        scale: 1 / sceneSession.zoomManager.zoomFactor
        scene: root.scene
        sceneSession: root.sceneSession

        visible: hasSelectedObject
    }

    //! MouseArea to move contain nodes.
    MouseArea {
        id: rubberBandMouseArea
        anchors.fill: parent

        property int    prevX:      0
        property int    prevY:      0

        //! update isMouseInRubberBand with containsMouse
        onContainsMouseChanged: sceneSession.isMouseInRubberBand = containsMouse

        //! Enable when select more than one Item and shift not pressed.
        enabled: sceneSession && !sceneSession.isShiftModifierPressed &&
                 Object.keys(selectionModel?.selectedModel ?? ({})).length > 1

        hoverEnabled: rubberBandMouseArea.containsMouse
        preventStealing: true
        propagateComposedEvents: true

        // To hide cursor when is disable
        visible: enabled

        cursorShape: (containsMouse && sceneSession.isRubberBandMoving) ?
                         Qt.ClosedHandCursor : Qt.OpenHandCursor

        onDoubleClicked: (mouse) => {
            sceneSession.isRubberBandMoving = false;

            // Set mouse Accepted = false
            // to pass double click into nodeView
            mouse.accepted = false
        }

        onPressed: (mouse) => {
            sceneSession.isRubberBandMoving = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: (mouse) => {
            _timer.start();
        }

        onPositionChanged: (mouse) => {
            if (sceneSession.isRubberBandMoving) {
                // Prepare key variables of node movement
                var deltaX = (mouse.x - prevX);
                prevX = mouse.x - deltaX;
                var deltaY = (mouse.y - prevY);
                prevY = mouse.y - deltaY;

                var s = scene.selectionModel.selectedModel;
                var keys = Object.keys(s);

                var minX = Number.POSITIVE_INFINITY;
                var minY = Number.POSITIVE_INFINITY;
                var maxX = Number.NEGATIVE_INFINITY;
                var maxY = Number.NEGATIVE_INFINITY;

                for (var i = 0; i < keys.length; ++i) {
                   var item = s[keys[i]];
                   if (!item || (item.objectType !== NLSpec.ObjectType.Node &&
                                 item.objectType !== NLSpec.ObjectType.Container))
                   continue;

                   item.guiConfig.position.x += deltaX;
                   item.guiConfig.position.y += deltaY;

                   if (NLStyle.snapEnabled)
                   item.guiConfig.position = scene.snappedPosition(item.guiConfig.position);

                   if ((item.guiConfig.position.x < 0 && deltaX < 0) ||
                       (item.guiConfig.position.y < 0 && deltaY < 0))
                   sceneSession.isRubberBandMoving = false;

                   // if (Math.abs(deltaX) > 10 || Math.abs(deltaY) > 10)
                   item.guiConfig.positionChanged();

                   minX = Math.min(minX, item.guiConfig.position.x);
                   minY = Math.min(minY, item.guiConfig.position.y);
                   maxX = Math.max(maxX, item.guiConfig.position.x + item.guiConfig.width);
                   maxY = Math.max(maxY, item.guiConfig.position.y + item.guiConfig.height);
                }

                if (keys.length > 1) {
                   root.x = minX
                   root.y = minY
                   root.width = maxX - minX
                   root.height = maxY - minY
                }
            }
        }
    }

    //! Timer to set false the rubberBand moving
    Timer {
        id: _timer
        repeat: false
        running: false
        interval: 10

        onTriggered: sceneSession.isRubberBandMoving = false;
    }

    //! Connection to calculate rubber band Dimensions when necessary.
    Connections {
        target: scene?.selectionModel ?? null

        function onSelectedModelChanged() {
            calculateDimensions();
        }

        // function onSelectedObjectChanged() {
           // calculateDimensions();
        // }
    }

    //! Connection to calculate rubber band Dimensions when zoomFactorChanged.
    Connections {
        target: sceneSession?.zoomManager ?? null

        function onZoomFactorChanged() {
            _timerUpdateDimention.start();
        }
    }

    //! Wait to update all factors that depeand on zoom factor then do calculations
    Timer {
        id: _timerUpdateDimention

        running: false
        repeat: false
        interval: 0

         onTriggered: calculateDimensions();
    }

    /*  Functions
    * ****************************************************************************************/

    //! calculate X, Y, width and height of rubber band
    function calculateDimensions() { //FIXME: really expensive function
            var firstObj = Object.values(scene.selectionModel.selectedModel)[0];
            if (firstObj === undefined)
                return;

            var isNodeFirstObj = firstObj.objectType === NLSpec.ObjectType.Node || firstObj.objectType === NLSpec.ObjectType.Container;
            var portPosVecOut = isNodeFirstObj ? Qt.vector2d(0, 0) : firstObj?.outputPort?._position

            var position = isNodeFirstObj ? firstObj.guiConfig?.position : firstObj?.inputPort?._position;
            var leftX = (isNodeFirstObj ? position.x : (position.x < portPosVecOut.x) ? position.x : portPosVecOut.x);
            var topY = (isNodeFirstObj ? position.y : (position.y < portPosVecOut.y) ? position.y : portPosVecOut.y);

            var rightX = (isNodeFirstObj ? position.x + firstObj.guiConfig.width:
                                          (position.x > portPosVecOut.x) ? position.x : portPosVecOut.x);
            var bottomY = (isNodeFirstObj ? position.y + firstObj.guiConfig.height:
                                           (position.y > portPosVecOut.y) ? position.y : portPosVecOut.y);

            Object.values(scene.selectionModel.selectedModel).forEach(obj => {
                if (!obj)
                    return;
                if (obj.objectType === NLSpec.ObjectType.Node || obj.objectType === NLSpec.ObjectType.Container) {
                    // Find left, right, top and bottom positions.
                    // they are depend on inputPort and outputPort position (temporary).
                    var pos = obj.guiConfig.position; //obj.guiConfig.position.plus(obj.guiConfig.position.minus(sceneSession.zoomManager.zoomPoint).times(sceneSession.zoomManager.zoomFactor - 1))
                    var tempLeftX = pos.x;
                    var tempTopY = pos.y;
                    var tempRightX = pos.x + obj.guiConfig.width;
                    var tempBottomY =pos.y + obj.guiConfig.height;
                    if (tempLeftX < leftX) {
                        leftX = tempLeftX;
                    }
                    if (tempTopY < topY) {
                        topY = tempTopY;
                    }
                    if (rightX < tempRightX) {
                        rightX = tempRightX;
                    }
                    if (bottomY < tempBottomY) {
                        bottomY = tempBottomY;
                     }
                } else if (obj.objectType === NLSpec.ObjectType.Link) {
                    var portPosVecIn = obj?.inputPort?._position
                    portPosVecOut = obj?.outputPort?._position
                    // Find left, right, top and bottom positions.
                    // they are depend on inputPort and outputPort position (temporary).
                    tempLeftX = (portPosVecIn.x < portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                    tempTopY = (portPosVecIn.y < portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;
                    tempRightX = (portPosVecIn.x > portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                    tempBottomY = (portPosVecIn.y > portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;
                    // Set temp value into it's real variable.
                    if (tempLeftX < leftX)
                       leftX = tempLeftX;
                    if (tempTopY < topY)
                       topY = tempTopY;
                    if (tempRightX > rightX)
                       rightX = tempRightX;
                    if (tempBottomY > bottomY)
                       bottomY = tempBottomY;
                }
            });
            var margin = 5;

            // Update dimentions
            root.width = (rightX - leftX + 2 * margin)
            root.height = (bottomY - topY + 2 * margin)
            root.x = leftX - margin;
            root.y = topY - margin;
        }
    }
