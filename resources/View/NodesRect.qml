import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * NoedsRect is an Item that contain a Mousearea to manage I_NodesRect and its events.
 * ************************************************************************************************/
I_NodesRect {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    /*  Children
    * ****************************************************************************************/

    //! Rubber band border with different opacity
    Rectangle {
        anchors.fill: rubberBand
        color: "transparent"
        opacity: 0.5

        visible: rubberBand.visible
        border.width: 3
        border.color: "#8F30FA"
    }

    //! Rubber band to handle selection rect
    Rectangle {
        id: rubberBand

        color: Object.values(scene.selectionModel.selectedModel).length> 1 ? "#8F30FA" :
                                                                             "transparent"
        opacity: 0.2

        visible: Object.values(scene.selectionModel.selectedModel).length > 1

        //! calculate X, Y, width and height of rubber band
        function calculateDimentions() {
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

                                                                              var tempLeftX = (portPosVecIn.x < portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                                                                              var tempTopY = (portPosVecIn.y < portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;
                                                                              var tempRightX = (portPosVecIn.x > portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                                                                              var tempBottomY = (portPosVecIn.y > portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;

                                                                              if(tempLeftX < leftX) {
                                                                                 leftX = tempLeftX;
                                                                              }

                                                                              if(tempTopY < topY) {
                                                                                 topY = tempTopY;
                                                                              }

                                                                              if(tempRightX > rightX) {
                                                                                 rightX = tempRightX;
                                                                              }

                                                                              if(tempBottomY > bottomY) {
                                                                                 bottomY = tempBottomY;
                                                                              }

                                                                          }
                                                                      });
            var margin = 5;
            // Update dimentions
            rubberBand.x = leftX - margin;
            rubberBand.y = topY - margin;
            rubberBand.width  = rightX  - leftX + 2 * margin
            rubberBand.height = bottomY - topY + 2 * margin
        }
    }

    SelectionToolsRect {
        x: rubberBand.x + rubberBand.width / 2 - width / 2
        y: rubberBand.y - 34
        scene: root.scene

        visible: Object.values(scene.selectionModel.selectedModel).length > 0
    }

    //! User Connection Curve
    UserLinkView {
        scene: root.scene
        anchors.fill: parent
    }

    Connections {
        target: scene.selectionModel

        function onSelectedModelChanged() {
            rubberBand.calculateDimentions();
        }

        function onSelectedObjectChanged() {
           rubberBand.calculateDimentions();
        }
    }
}
