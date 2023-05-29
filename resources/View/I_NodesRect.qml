import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * I_NodesRect is an interface classs that shows nodes.
 * ************************************************************************************************/
Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    property int                contentWidth

    property int                contentHeight

    /*  Object Properties
    * ****************************************************************************************/
    width: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.x + node.guiConfig.width)), 1024) + 200
    height: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.y + node.guiConfig.height)), 768) + 200
    color: "transparent"

    /*  Children
    * ****************************************************************************************/
    //! Nodes
    NLRepeater {
        id: nodeRepeater

        delegate: NodeView {
            id: nodeView
            node: modelData
            scene: root.scene
            sceneSession: root.sceneSession
            isSelected: modelData === scene.selectionModel.selectedNode
            onClicked: scene.selectionModel.select(modelData)
            contentWidth: root.contentWidth
            contentHeight: root.contentHeight
        }
    }

    //! Links
    NLRepeater {
        id: linkRepeater

        delegate: LinkView {
            scene: root.scene
            isSelected: modelData === scene.selectionModel.selectedLink
            inputPort: modelData.inputPort
            outputPort: modelData.outputPort
            link: modelData
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
