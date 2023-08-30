import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * I_NodesRect is an interface classs that shows nodes.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    property real topLeftX: Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x ))
    property real topLeftY: Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y))

    property real bottomRightX: Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.x + node.guiConfig.width) )
    property real bottomRightY: Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.y + node.guiConfig.height) )


    property real scaleFactorWidth: 300 / (bottomRightX- topLeftX) > 1 ? 1 : 300 / (bottomRightX- topLeftX)
    property real scaleFactorHeight: 300 / (bottomRightY- topLeftY) > 1 ? 1 : 300 / (bottomRightY- topLeftY)
    /*  Object Properties
    * ****************************************************************************************/
//    anchors.fill: parent
    width: (bottomRightX- topLeftX) * scaleFactorWidth
    height: (bottomRightY - topLeftY) * scaleFactorHeight

    /*  Children
    * ****************************************************************************************/
    //! Nodes
    NLRepeater {
        id: nodeRepeater

        delegate: OverviewNodeView {
            id: nodeView
            node: modelData
            scene: root.scene
            sceneSession: root.sceneSession
            topLeftX: root.topLeftX
            topLeftY: root.topLeftY
            scaleFactorHeight: Math.min(root.scaleFactorHeight, root.scaleFactorWidth)
            scaleFactorWidth: Math.min(root.scaleFactorHeight, root.scaleFactorWidth)

        }
    }

    //! Links
    NLRepeater {
        id: linkRepeater

        delegate: OverviewLinkView {
            scene: root.scene
            sceneSession: root.sceneSession
            link: modelData
            topLeftXroot: root.topLeftX
            topLeftYroot: root.topLeftY
            scaleFactorHeight: Math.min(root.scaleFactorHeight, root.scaleFactorWidth)
            scaleFactorWidth: Math.min(root.scaleFactorHeight, root.scaleFactorWidth)
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
