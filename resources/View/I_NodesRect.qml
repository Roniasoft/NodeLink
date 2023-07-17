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

    /*  Object Properties
    * ****************************************************************************************/
    //width: (Math.max(...Object.values(scene?.nodes ?? ({})).map(node => (node.guiConfig.position.x + node.guiConfig.width)), 1024) + 200) * sceneSession.zoomManager.zoomFactor
    //height: (Math.max(...Object.values(scene?.nodes ?? ({})).map(node => (node.guiConfig.position.y + node.guiConfig.height)), 768) + 200) * sceneSession.zoomManager.zoomFactor
    anchors.fill: parent
    color: "transparent"

    Keys.forwardTo: parent

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
        }
    }

    //! Links
    NLRepeater {
        id: linkRepeater

        delegate: LinkView {
            scene: root.scene
            sceneSession: root.sceneSession
            isSelected: scene?.selectionModel?.isSelected(modelData?._qsUuid) ?? false

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
