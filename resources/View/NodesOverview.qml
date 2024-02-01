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

    property var nodes: Object.values(scene?.nodes ?? ({}))

    //! Top Left position of node rect (pos of the node in the top left corner)
    property real         nodeRectTopLeftX: Math.min(...nodes.map(node => node.guiConfig.position.x), NLStyle.scene.defaultContentX)
    property real         nodeRectTopLeftY: Math.min(...nodes.map(node => node.guiConfig.position.y), NLStyle.scene.defaultContentY)
    property vector2d     nodeRectTopLeft: Qt.vector2d(nodeRectTopLeftX, nodeRectTopLeftY)

    //! Bottom Right position of node rect (pos of the node in the bottom right corner)
    property real         nodeRectBottomRightX: Math.max(...nodes.map(node => node.guiConfig.position.x + node.guiConfig.width), NLStyle.scene.defaultContentX + 1000)
    property real         nodeRectBottomRightY: Math.max(...nodes.map(node => node.guiConfig.position.y + node.guiConfig.height), NLStyle.scene.defaultContentY + 1000)

    //! Overview scale in x direction
    property real         overviewXScaleFactor: width / (nodeRectBottomRightX - nodeRectTopLeftX)

    //! Overview scale in y direction
    property real         overviewYScaleFactor: height / (nodeRectBottomRightY - nodeRectTopLeftY)

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         overviewScaleFactor:  Math.min( overviewXScaleFactor > 1 ? 1 : overviewXScaleFactor,
                                                       overviewYScaleFactor > 1 ? 1 : overviewYScaleFactor)

    //! Whether background border should be visible or not
    property  bool        backgroundBorderVisibility: true


    /* Object Properties
    * ****************************************************************************************/

    width: overviewWidth
    height: overviewHeight
    visible: sceneSession && sceneSession.enabledOverview  && sceneSession.visibleOverview

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

        //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
        property real         customScaleFactor: root.overviewScaleFactor / (sceneSession?.zoomManager?.zoomFactor ?? 1.0)

        visible: interactive
        color: "transparent"
        border.color: NLStyle.primaryColor
        x: ((scene?.sceneGuiConfig?.contentX / (sceneSession?.zoomManager.zoomFactor) - nodeRectTopLeftX) ?? 0) * root.overviewScaleFactor
        y: ((scene?.sceneGuiConfig?.contentY / (sceneSession?.zoomManager.zoomFactor) - nodeRectTopLeftY) ?? 0) * root.overviewScaleFactor
        width: (scene?.sceneGuiConfig?.sceneViewWidth ?? 0) * customScaleFactor
        height: (scene?.sceneGuiConfig?.sceneViewHeight ?? 0) * customScaleFactor
    }

    //! Overview borders, implemented here (and not in the background rect) because borders need to be higher
    //! on the visual stack than userViewRect
    Rectangle {
        id: borderRect
        anchors.fill: parent
        color: "transparent"
        border.color: NLStyle.primaryBorderColor
        border.width: (backgroundBorderVisibility) ? 2 : 0
    }

    //! MouseArea to handle position change of user view
    MouseArea {

        property real    prevX
        property real    prevY
        property bool    isDraging:  false

        //! Handle unexpected behaviors by capturing both left and right buttons.
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        anchors.fill: parent
        z: 3

        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton)
                return;

            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: (mouse) => {
                        if (mouse.button === Qt.LeftButton && !isDraging) {
                            //! When mouse is clicked, the diff between clicked area and the red rectangle position is calculated
                            // and then mapped to the scene
                            var diffX = (mouse.x - userViewRect.x) / userViewRect.customScaleFactor
                            var diffY = (mouse.y - userViewRect.y) / userViewRect.customScaleFactor
                            var halfWidthBefore = scene.sceneGuiConfig.sceneViewWidth / 2
                            var halfHeightBefore = scene.sceneGuiConfig.sceneViewHeight / 2

                            scene.contentMoveRequested(Qt.vector2d(diffX - halfWidthBefore, diffY - halfHeightBefore));
                        }

                        isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (mouse.button === Qt.RightButton)
                return;


            isDraging = true;
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
}
