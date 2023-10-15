import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 *
 * ************************************************************************************************/
I_Scene {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    //! bannedNodes includes all node types that can not create in this scene.
    //! node types need to be registered in NLNodeRegistry.
    property var bannedNodes: []

    /* Property Properties
     * ****************************************************************************************/
    //! Scene Selection Model
    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: root
    }

    /* Children
     * ****************************************************************************************/
    //    Component.onCompleted: {
    //        // adding example nodes
    //        for (var i = 0; i < 5; i++) {
    //            var node = NLCore.createNode();
    //            node.guiConfig.position.x = Math.random() * 1000;
    //            node.guiConfig.position.y = Math.random() * 1000;
    //            node.guiConfig.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
    //            addNode(node);
    //        }
    //        _timer.start();
    //    }
    // Adding example links
    property Timer _timer: Timer {
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            // example link
            linkNodes(Object.keys(Object.values(nodes)[1].ports)[1], Object.keys(Object.values(nodes)[2].ports)[3]);
            linkNodes(Object.keys(Object.values(nodes)[1].ports)[1], Object.keys(Object.values(nodes)[3].ports)[3]);
            linkNodes(Object.keys(Object.values(nodes)[2].ports)[0], Object.keys(Object.values(nodes)[0].ports)[2]);
        }
    }

    /* Functions
     * ****************************************************************************************/

    //! Override this function in your scene
    //! Create a node with node type and its position
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string {
        if (bannedNodes.includes(nodeType)) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return;
        }

        var title = NLNodeRegistry.nodeNames[nodeType] + "_" + (Object.values(root.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(NLNodeRegistry.imports, nodeType,
                                  NLNodeRegistry.nodeTypes[nodeType],
                                  NLNodeRegistry.nodeColors[nodeType],
                                  title, xPos, yPos);
    }

    //! Override this function in your scene
    //! Check some condition and
    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function linkNodes(portA : string, portB : string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes ");
            return;
        }
        let link = Object.values(links).find(conObj =>
                                             conObj.inputPort._qsUuid === portA &&
                                             conObj.outputPort._qsUuid === portB);

        if (link === undefined) {
            createLink(portA, portB)
        }
    }

    //! Override this function in your scene
    //! The ability to create a link is detected in the canLinkNodes function.
    //! Rols:
    //!     - A link must be established between two specific links
    //!     - Link can not be duplicate
    //!     - A node cannot establish a link with itself
    function canLinkNodes(portA : string, portB : string): bool {

        //! Sanity check
        if (portA.length === 0 || portB.length === 0)
            return false;

        // Find exist links with portA as input port and portB as output port.
        var sameLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
            HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));

        if (sameLinks.length > 0)
            return false;

        // A node cannot establish a link with itself
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);
        if (HashCompareString.compareStringModels(nodeA, nodeB)
                    || nodeA.length === 0 || nodeB.length === 0) {
            return false;
        }

        return true;
    }

    //! Ban a noed type (Node types that can not create in this scene)
    function bannedNodeType(nodeType : int) {
//        bannedNodes.includes
        bannedNodes.push(nodeType);
    }

}
