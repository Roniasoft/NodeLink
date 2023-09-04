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
    property I_Scene        scene

    //! Scene session contains information about scene states (UI related)
    property SceneSession   sceneSession

    //! Overview width, used for calculatin scale for mapping scene -> overview
    property int          overviewWidth

    //! Overview height, used for calculatin scale for mapping scene -> overview
    property int          overviewHeight


    //! Top Left position of node rect (pos of the node in the top left corner)
    property vector2d     nodeRectTopLeft: Qt.vector2d(Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x )),
                                                       Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y)))

    //! Bottom Right position of node rect (pos of the node in the bottom right corner)
    property vector2d     nodeRectBottomRight: Qt.vector2d(Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.x + node.guiConfig.width)),
                                                           Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.y + node.guiConfig.height)))

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         customScaleFactor: Math.min(overviewWidth / (nodeRectBottomRight.x - nodeRectTopLeft.x) > 1 ?
                                                      1 : overviewWidth / (nodeRectBottomRight.x - nodeRectTopLeft.x),
                                                      overviewHeight / (nodeRectBottomRight.y - nodeRectTopLeft.y) > 1 ?
                                                      1 : overviewHeight / (nodeRectBottomRight.y - nodeRectTopLeft.y))


    /* Object Properties
    * ****************************************************************************************/

    width: overviewWidth
    height: overviewHeight

    /* Children
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

        nodeRectTopLeft:  root.nodeRectTopLeft
        nodeRectBottomRight: root.nodeRectBottomRight
        customScaleFactor: root.customScaleFactor

        MouseArea {
            anchors.fill: parent
            onClicked: (mouse) =>  {
                //! When mouse is clicked, the diff between clicked area and the red rectangle position is calculated
                // and then mapped to the scene
                var diffX = (mouse.x - visibleAreaRedRect.x) / visibleAreaRedRect.customScaleFactor
                var diffY = (mouse.y - visibleAreaRedRect.y) / visibleAreaRedRect.customScaleFactor
                var halfWidthBefore = sceneSession.width / 2
                var halfHeightBefore = sceneSession.height / 2
                sceneSession.contentX += diffX - halfWidthBefore
                sceneSession.contentY += diffY - halfHeightBefore
            }
        }

    }

    //! A rectangle to change
    Rectangle {
        id: visibleAreaRedRect

        //! Top Left position of node rect (pos of the node in the top left corner)
        property vector2d     nodeRectTopLeft: root.nodeRectTopLeft.times(sceneSession.zoomManager.zoomFactor)

        //! Bottom Right position of node rect (pos of the node in the bottom right corner)
        property vector2d     nodeRectBottomRight: root.nodeRectBottomRight.times(sceneSession.zoomManager.zoomFactor)

        //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
        property real         customScaleFactor: root.customScaleFactor / (root.customScaleFactor > 1 ? 1 : sceneSession.zoomManager.zoomFactor)

        color: "transparent"
        border.color: "red"
        x: (sceneSession.contentX - nodeRectTopLeft.x) * customScaleFactor
        y: (sceneSession.contentY - nodeRectTopLeft.y) * customScaleFactor
        width: (sceneSession.contentX + sceneSession.sceneViewWidth - nodeRectTopLeft.x) * customScaleFactor - x
        height: (sceneSession.contentY + sceneSession.sceneViewHeigh - nodeRectTopLeft.y) * customScaleFactor - y
        z: 3

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
                    sceneSession.contentX += endingPointInSceneX - startingPointInSceneX
                    sceneSession.contentY += endingPointInSceneY - startingPointInSceneY
                }
            }
        }
    }

}
