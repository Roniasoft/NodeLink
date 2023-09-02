import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Nodes Overview UI
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Scene is the main model containing information about all nodes/links
    property Scene          scene:          null

    //! Scene session contains information about scene states (UI related)
    property SceneSession   sceneSession:   null


    /* Object Properties
    * ****************************************************************************************/

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: "#20262d"
    }

    NodesRectOverview {
        anchors.fill: parent
        scene: root.scene
        sceneSession: root.sceneSession
        overviewHeight: root.height
        overviewWidth: root.width

        MouseArea {
            anchors.fill: parent
            onClicked: (mouse) =>  {
                //! When mouse is clicked, the diff between clicked area and the red rectangle position is calculated
                // and then mapped to the scene
                var diffX = (mouse.x - visibleAreaRedRect.x) / visibleAreaRedRect.customScaleFactor
                var diffY = (mouse.y - visibleAreaRedRect.y) / visibleAreaRedRect.customScaleFactor
                var halfWidthBefore = nodesScene.width / 2
                var halfHeightBefore = nodesScene.height / 2
                nodesScene.contentX += diffX - halfWidthBefore
                nodesScene.contentY += diffY - halfHeightBefore
            }
        }

        Rectangle {
            id: visibleAreaRedRect

            //! Top Left position of node rect (pos of the node in the top left corner)
            property vector2d     nodeRectTopLeft: Qt.vector2d(Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x * sceneSession.zoomManager.zoomFactor)),
                                                               Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y * sceneSession.zoomManager.zoomFactor)))

            //! Bottom Right position of node rect (pos of the node in the bottom right corner)
            property vector2d     nodeRectBottomRight: Qt.vector2d(Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.x + node.guiConfig.width) * sceneSession.zoomManager.zoomFactor)),
                                                                   Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.y + node.guiConfig.height)  * sceneSession.zoomManager.zoomFactor)))

            //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
            property real         customScaleFactor: Math.min(parent.width / (nodeRectBottomRight.x- nodeRectTopLeft.x) > 1 ?
                                                              1 : parent.width / (nodeRectBottomRight.x- nodeRectTopLeft.x),
                                                              parent.height / (nodeRectBottomRight.y- nodeRectTopLeft.y) > 1 ?
                                                              1 : parent.height / (nodeRectBottomRight.y- nodeRectTopLeft.y))

            color: "transparent"
            border.color: "red"
            x: (nodesScene.contentX - nodeRectTopLeft.x) * customScaleFactor
            y: (nodesScene.contentY - nodeRectTopLeft.y) * customScaleFactor
            width: (nodesScene.contentX + nodesScene.width - nodeRectTopLeft.x) * customScaleFactor - x
            height: (nodesScene.contentY + nodesScene.height - nodeRectTopLeft.y) * customScaleFactor - y

            MouseArea {

                property real    prevX
                property real    prevY
                property bool    isDraging:  false

                anchors.fill: parent
                hoverEnabled: true

                onPressed: (mouse) => {
                    isDraging = true;
                    prevX = mouse.x;
                    prevY = mouse.y;
                }

                onReleased: (mouse) => {
                    isDraging = false;
                }

                onPositionChanged: (mouse) => {
                    if (isDraging) {
                        //! When mouse is dragged, the diff between pressed mouse and current position is calculated
                        // and then mapped to the scene
                        var diffX = (prevX - mouse.x)
                        var diffY = (prevY - mouse.y)
                        var startingPointInSceneX = (prevX / visibleAreaRedRect.customScaleFactor)  + visibleAreaRedRect.nodeRectTopLeft.x
                        var startingPointInSceneY = (prevY / visibleAreaRedRect.customScaleFactor)  + visibleAreaRedRect.nodeRectTopLeft.y
                        var endingPointInSceneX = (mouse.x / visibleAreaRedRect.customScaleFactor)  + visibleAreaRedRect.nodeRectTopLeft.x
                        var endingPointInSceneY = (mouse.y / visibleAreaRedRect.customScaleFactor)  + visibleAreaRedRect.nodeRectTopLeft.y
                        nodesScene.contentX += endingPointInSceneX - startingPointInSceneX
                        nodesScene.contentY += endingPointInSceneY - startingPointInSceneY
                    }
                }
            }
        }
    }

}
