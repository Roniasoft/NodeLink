import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Ui for Overview Node Rect
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene        scene

    property SceneSession sceneSession

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
    property real         customScaleFactor: Math.min(overviewWidth / (nodeRectBottomRight.x- nodeRectTopLeft.x) > 1 ?
                                                      1 : overviewWidth / (nodeRectBottomRight.x- nodeRectTopLeft.x),
                                                      overviewHeight / (nodeRectBottomRight.y- nodeRectTopLeft.y) > 1 ?
                                                      1 : overviewHeight / (nodeRectBottomRight.y- nodeRectTopLeft.y))
    /*  Object Properties
    * ****************************************************************************************/
    width: (nodeRectBottomRight.x- nodeRectTopLeft.x) * customScaleFactor
    height: (nodeRectBottomRight.y - nodeRectTopLeft.y) * customScaleFactor

    /*  Children
    * ****************************************************************************************/
    //! Nodes
    NLRepeater {
        id: nodeRepeater

        delegate: NodeViewOverview {
            id: nodeView
            node: modelData
            scene: root.scene
            nodeRectTopLeft: root.nodeRectTopLeft
            customScaleFactor: root.customScaleFactor
        }
    }

    //! Links
    NLRepeater {
        id: linkRepeater

        delegate: LinkViewOverview {
            scene: root.scene
            sceneSession: root.sceneSession
            link: modelData
            nodeRectTopLeft: root.nodeRectTopLeft.times(sceneSession.zoomManager.zoomFactor)
            customScaleFactor: root.customScaleFactor
            zoomFactor: sceneSession.zoomManager.zoomFactor
        }
    }

    //! Connection to manage node model changes.
    Connections {
        target: scene

        //! nodeRepeater updated when a node added
        function onNodeAdded(node: Node) {
            nodeRepeater.addElement(node);
        }

        //! nodeRepeater updated when a node Removed
        function onNodeRemoved(node: Node) {
            nodeRepeater.removeElement(node)
        }

        //! linkRepeater updated when a link added
        function onLinkAdded(link: Link) {
            linkRepeater.addElement(link);
        }

        //! linkRepeater updated when a link Removed
        function onLinkRemoved(link: Link) {
            linkRepeater.removeElement(link)
        }
    }
}
