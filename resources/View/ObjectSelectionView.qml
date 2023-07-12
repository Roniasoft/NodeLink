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
    property Scene          scene
    property SceneSession   sceneSession
    property SelectionModel selectionModel: scene.selectionModel

    property bool           hasSelectedObject: Object.values(scene.selectionModel.selectedModel).length > 0

    /*  Object Properties
    * ****************************************************************************************/
    visible: hasSelectedObject
    z: 1000

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
        color: Object.values(scene.selectionModel.selectedModel).length> 1 ? "#8F30FA" :
                                                                             "transparent"
        opacity: 0.2

        visible: Object.values(scene.selectionModel.selectedModel).length > 1
   }

    //! selected object tool rect
    SelectionToolsRect {
        anchors.bottom: parent.top
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

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
        enabled: !sceneSession.isShiftModifierPressed &&
                 Object.keys(selectionModel.selectedModel).length > 1

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
                var deltaX = mouse.x - prevX;
                prevX = mouse.x - deltaX;
                var deltaY = mouse.y - prevY;
                prevY = mouse.y - deltaY;

                // Start movement process
                Object.values(scene.selectionModel.selectedModel).forEach(obj => {
                    // Ignore Link objects
                    if(obj?.objectType === NLSpec.ObjectType.Node) {
                        obj.guiConfig.position.x += deltaX;
                        obj.guiConfig.position.y += deltaY;
                    obj.guiConfig.positionChanged();
                    if(((obj.guiConfig.position.x) < 0 && deltaX < 0)   ||
                        ((obj.guiConfig.position.x + obj.guiConfig.width ) > contentWidth) && deltaX > 0||
                        ((obj.guiConfig.position.y) < 0 && deltaY < 0)   ||
                        ((obj.guiConfig.position.y + obj.guiConfig.height) > contentHeight) && deltaY > 0)
                           sceneSession.isRubberBandMoving = false;
                        }
                });
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

    //! Connection to calculate rubber band Dimentions when necessary.
    Connections {
        target: scene.selectionModel

        function onSelectedModelChanged() {
            calculateDimensions();
        }

        function onSelectedObjectChanged() {
           calculateDimensions();
        }
    }

    /*  Functions
    * ****************************************************************************************/

    //! calculate X, Y, width and height of rubber band
    function calculateDimensions() {
        var firstObj = Object.values(scene.selectionModel.selectedModel)[0];
        if(firstObj === undefined)
            return;

        var isNodeFirstObj = firstObj.objectType === NLSpec.ObjectType.Node;
        var portPosVecOut = isNodeFirstObj ? Qt.vector2d(0, 0) : scene.portsPositions[firstObj?.outputPort?._qsUuid]

        var position = isNodeFirstObj ? firstObj.guiConfig.position : scene.portsPositions[firstObj?.inputPort?._qsUuid];
        var leftX = isNodeFirstObj ? position.x : (position.x < portPosVecOut.x) ? position.x : portPosVecOut.x;
        var topY = isNodeFirstObj ? position.y : (position.y < portPosVecOut.y) ? position.y : portPosVecOut.y;

        var rightX = isNodeFirstObj ? position.x + firstObj.guiConfig.width :
                                      (position.x > portPosVecOut.x) ? position.x : portPosVecOut.x;
        var bottomY = isNodeFirstObj ? position.y + firstObj.guiConfig.height :
                                       (position.y > portPosVecOut.y) ? position.y : portPosVecOut.y;

        Object.values(scene.selectionModel.selectedModel).forEach(obj => {
                                                                      if(obj.objectType === NLSpec.ObjectType.Node) {
                                                                          if(obj.guiConfig.position.x < leftX) {
                                                                              leftX = obj.guiConfig.position.x;
                                                                          }

                                                                          if(obj.guiConfig.position.x < leftX) {
                                                                              leftX = obj.guiConfig.position.x;
                                                                          }
                                                                          if(obj.guiConfig.position.y < topY) {
                                                                              topY = obj.guiConfig.position.y;
                                                                          }

                                                                          if(rightX < obj.guiConfig.position.x + obj.guiConfig.width) {
                                                                              rightX = obj.guiConfig.position.x + obj.guiConfig.width;
                                                                          }

                                                                          if(bottomY < obj.guiConfig.position.y + obj.guiConfig.height) {
                                                                              bottomY = obj.guiConfig.position.y + obj.guiConfig.height;
                                                                          }

                                                                      } else if(obj.objectType === NLSpec.ObjectType.Link) {
                                                                          var portPosVecIn = scene.portsPositions[obj?.inputPort?._qsUuid]
                                                                          portPosVecOut = scene.portsPositions[obj?.outputPort?._qsUuid]

                                                                          // Find left, right, top and bottom positions.
                                                                          // they are depend on inputPort and outputPort position (temporary).
                                                                          var tempLeftX = (portPosVecIn.x < portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                                                                          var tempTopY = (portPosVecIn.y < portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;
                                                                          var tempRightX = (portPosVecIn.x > portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                                                                          var tempBottomY = (portPosVecIn.y > portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;

                                                                          // Set temp value into it's real variable.
                                                                          if(tempLeftX < leftX)
                                                                             leftX = tempLeftX;

                                                                          if(tempTopY < topY)
                                                                             topY = tempTopY;

                                                                          if(tempRightX > rightX)
                                                                             rightX = tempRightX;

                                                                          if(tempBottomY > bottomY)
                                                                             bottomY = tempBottomY;
                                                                      }
                                                                  });
        var margin = 5;

        // Update dimentions
        root.x = leftX - margin;
        root.y = topY - margin;
        root.width  = rightX  - leftX + 2 * margin
        root.height = bottomY - topY + 2 * margin
    }
}
