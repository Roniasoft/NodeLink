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
    //! When use anchors, can not use overviewWidth property
    //! anchors update the width and height directly
    property int          overviewWidth

    //! Overview height, used for calculatin scale for mapping scene -> overview
    //! When use anchors, can not use overviewHeight property
    //! anchors update the width and height directly
    property int          overviewHeight

    //! Show controller (userViewRect)
    property bool         interactive:  true

    //! OverView background color
    property string       backColor:    "#20262d"

    //! Top Left position of node rect (pos of the node in the top left corner)
    property vector2d     nodeRectTopLeft: Qt.vector2d(Math.min(...Object.values(scene?.nodes ?? ({})).map(node => node.guiConfig.position.x ), NLStyle.scene.defaultContentX),
                                                       Math.min(...Object.values(scene?.nodes ?? ({})).map(node => node.guiConfig.position.y), NLStyle.scene.defaultContentY))

    //! Bottom Right position of node rect (pos of the node in the bottom right corner)
    property vector2d     nodeRectBottomRight: Qt.vector2d(Math.max(...Object.values(scene?.nodes ?? ({})).map(node => node.guiConfig.position.x + node.guiConfig.width), NLStyle.scene.defaultContentX + 1000),
                                                           Math.max(...Object.values(scene?.nodes ?? ({})).map(node => node.guiConfig.position.y + node.guiConfig.height), NLStyle.scene.defaultContentY + 1000))

    //! Overview scale in x direction
    property real         overviewXScaleFactor: width / (nodeRectBottomRight.x - nodeRectTopLeft.x)

    //! Overview scale in y direction
    property real         overviewYScaleFactor: height / (nodeRectBottomRight.y - nodeRectTopLeft.y)

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         overviewScaleFactor:  Math.min( overviewXScaleFactor > 1 ? 1 : overviewXScaleFactor,
                                                       overviewYScaleFactor > 1 ? 1 : overviewYScaleFactor)


    /* Object Properties
    * ****************************************************************************************/

    width: overviewWidth
    height: overviewHeight
    visible: sceneSession?.visibleOverview ?? false

    /* Children
    * ****************************************************************************************/

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: backColor
    }

    //! NodesRectOverview (nodes and links)
    NodesRectOverview {
        scene: root.scene
        sceneSession: root.sceneSession

        nodeRectTopLeft:  root.nodeRectTopLeft
        overviewScaleFactor: root.overviewScaleFactor
    }

    //! User view rectangle to handle position change of user view
    Rectangle {
        id: userViewRect

        //! Top Left position of node rect (pos of the node in the top left corner)
        property vector2d     nodeRectTopLeft: root.nodeRectTopLeft

        //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
        property real         customScaleFactor: root.overviewScaleFactor / (sceneSession?.zoomManager?.zoomFactor ?? 1.0)

        visible: interactive
        color: "transparent"
        border.color: NLStyle.primaryColor
        x: ((scene?.sceneGuiConfig?.contentX / (sceneSession?.zoomManager.zoomFactor) - nodeRectTopLeft.x) ?? 0) * root.overviewScaleFactor
        y: ((scene?.sceneGuiConfig?.contentY / (sceneSession?.zoomManager.zoomFactor) - nodeRectTopLeft.y) ?? 0) * root.overviewScaleFactor
        width: (scene?.sceneGuiConfig?.sceneViewWidth ?? 0) * customScaleFactor
        height: (scene?.sceneGuiConfig?.sceneViewHeight ?? 0) * customScaleFactor
    }

    //! MouseArea to handle position change of user view
    MouseArea {

        property real    prevX
        property real    prevY
        property bool    isDraging:  false

        //! Handle unexpected behaviors by capturing both left and right buttons.
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        anchors.fill: parent
        hoverEnabled: true
        z: 3

        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton)
                return;

            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: (mouse) => {
            isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (mouse.button === Qt.RightButton)
                return;

            if (isDraging) {
                //! When mouse is dragged, the diff between pressed mouse and current position is calculated
                // and then mapped to the scene
                var startingPointInSceneX = (prevX / userViewRect.customScaleFactor);
                var startingPointInSceneY = (prevY / userViewRect.customScaleFactor);
                var endingPointInSceneX = (mouse.x / userViewRect.customScaleFactor);
                var endingPointInSceneY = (mouse.y / userViewRect.customScaleFactor);

                prevX = mouse.x;
                prevY = mouse.y;

                scene.contentMoveRequested(Qt.vector2d(endingPointInSceneX - startingPointInSceneX,
                                                       endingPointInSceneY - startingPointInSceneY));

            }
        }

        onClicked: (mouse) =>  {
            if (mouse.button === Qt.RightButton)
                return;

            //! When mouse is clicked, the diff between clicked area and the red rectangle position is calculated
            // and then mapped to the scene
            var diffX = (mouse.x - userViewRect.x) / userViewRect.customScaleFactor
            var diffY = (mouse.y - userViewRect.y) / userViewRect.customScaleFactor
            var halfWidthBefore = scene.sceneGuiConfig.sceneViewWidth / 2
            var halfHeightBefore = scene.sceneGuiConfig.sceneViewHeight / 2

            scene.contentMoveRequested(Qt.vector2d(diffX - halfWidthBefore, diffY - halfHeightBefore));
        }
    }
}
