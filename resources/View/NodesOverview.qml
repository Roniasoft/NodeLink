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
    property vector2d     nodeRectTopLeft: Qt.vector2d(Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x ), NLStyle.scene.defaultContentX),
                                                       Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y), NLStyle.scene.defaultContentY))

    //! Bottom Right position of node rect (pos of the node in the bottom right corner)
    property vector2d     nodeRectBottomRight: Qt.vector2d(Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.x + node.guiConfig.width), NLStyle.scene.defaultContentX + 1000),
                                                           Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.y + node.guiConfig.height), NLStyle.scene.defaultContentY + 1000))

    //! Overview scale in x direction
    property real         overviewXScaleFactor: overviewWidth / (nodeRectBottomRight.x - nodeRectTopLeft.x)

    //! Overview scale in y direction
    property real         overviewYScaleFactor: overviewHeight / (nodeRectBottomRight.y - nodeRectTopLeft.y)

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         overviewScaleFactor:  Math.min( overviewXScaleFactor > 1 ? 1 : overviewXScaleFactor,
                                                       overviewYScaleFactor > 1 ? 1 : overviewYScaleFactor)


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
        scene: root.scene
        sceneSession: root.sceneSession

        nodeRectTopLeft:  root.nodeRectTopLeft
        overviewScaleFactor: root.overviewScaleFactor

        MouseArea {
            anchors.fill: parent

            onClicked: (mouse) =>  {
                //! When mouse is clicked, the diff between clicked area and the red rectangle position is calculated
                // and then mapped to the scene
                var diffX = (mouse.x - userViewRect.x) / userViewRect.customScaleFactor
                var diffY = (mouse.y - userViewRect.y) / userViewRect.customScaleFactor
                var halfWidthBefore = sceneSession.sceneViewWidth / 2
                var halfHeightBefore = sceneSession.sceneViewHeight / 2
                sceneSession.contentX += diffX - halfWidthBefore
                sceneSession.contentY += diffY - halfHeightBefore
            }
        }
    }

    //! A rectangle to change
    Rectangle {
        id: userViewRect

        //! Top Left position of node rect (pos of the node in the top left corner)
        property vector2d     nodeRectTopLeft: root.nodeRectTopLeft.times(sceneSession.zoomManager.zoomFactor)

        //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
        property real         customScaleFactor: root.overviewScaleFactor / (root.overviewScaleFactor > 1 ? 1 : sceneSession.zoomManager.zoomFactor)

        color: "transparent"
        border.color: Material.accent
        x: (sceneSession.contentX - nodeRectTopLeft.x) * customScaleFactor
        y: (sceneSession.contentY - nodeRectTopLeft.y) * customScaleFactor
        width: sceneSession.sceneViewWidth * customScaleFactor
        height: sceneSession.sceneViewHeight * customScaleFactor
        z: 3

        //! MouseArea to handle position change of user view
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
                    var startingPointInSceneX = (prevX / userViewRect.customScaleFactor);
                    var startingPointInSceneY = (prevY / userViewRect.customScaleFactor);
                    var endingPointInSceneX = (mouse.x / userViewRect.customScaleFactor);
                    var endingPointInSceneY = (mouse.y / userViewRect.customScaleFactor);

                    var contentX = sceneSession.contentX + endingPointInSceneX - startingPointInSceneX;
                    // Check the maximum value of contentX
                    if (contentX < (sceneSession.contentWidth - sceneSession.sceneViewWidth))
                        sceneSession.contentX = Math.max(0, contentX);

                    var contentY = sceneSession.contentY + endingPointInSceneY - startingPointInSceneY;

                    // Check the maximum value of contentY
                    if (contentY < (sceneSession.contentHeight - sceneSession.sceneViewHeight))
                        sceneSession.contentY = Math.max(0, contentY);
                }
            }
        }
    }

}
