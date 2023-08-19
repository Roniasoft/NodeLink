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

    /*  Object Properties
    * ****************************************************************************************/
    anchors.fill: parent

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
