import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 *
 * ************************************************************************************************/
I_Scene {
    id: root

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

    // automaticNodeReorder moved to I_Scene.qml

    //! Override this function in your scene
    //! Create a node with node type and its position
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string {
        var qsType = root.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(root.nodes).filter(node => node.type === nodeType).length + 1);
        if (NLStyle.snapEnabled) {
            var position = snappedPosition(Qt.vector2d(xPos, yPos));
            xPos = position.x;
            yPos = position.y;
        }
        return createSpecificNode(nodeRegistry.imports, nodeType, qsType,
                                  nodeRegistry.nodeColors[nodeType],
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
            // Find the nodes to which portA and portB belong
            let nodeX = findNode(portA);
            let nodeY = findNode(portB);

            //! Updates children and parents when a link created successfully
            nodeX.children[nodeY._qsUuid] = nodeY;
            nodeX.childrenChanged()

            nodeY.parents[nodeX._qsUuid] = nodeX;
            nodeY.parentsChanged()

            // Create link
            createLink(portA, portB)
        }
    }

    //! Override this function in your scene
    //! The ability to create a link is detected in the canLinkNodes function.
    //! Rols:
    //!     - A link must be established between two specific links
    //!     - Link can not be duplicate
    //!     - A node cannot establish a link with itself
    function canLinkNodes(portA: string, portB: string): bool {
        // Sanity check
        if (portA.length === 0 || portB.length === 0)
            return false;

        // Find nodes first (cheaper than iterating all links)
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);

        // Early exit: empty node IDs or same node
        if (nodeA.length === 0 || nodeB.length === 0 ||
            HashCompareString.compareStringModels(nodeA, nodeB)) {
            return false;
        }

        // Check port types (cheaper than iterating links)
        var portAObj = findPort(portA);
        var portBObj = findPort(portB);

        if (!portAObj || !portBObj)
            return false;

        // Input port cannot be source, output port cannot be destination
        if (portAObj.portType === NLSpec.PortType.Input ||
            portBObj.portType === NLSpec.PortType.Output)
            return false;

        // Check for existing link (most expensive operation - do last)
        var linkKeys = Object.keys(links);
        for (var i = 0; i < linkKeys.length; i++) {
            var link = links[linkKeys[i]];
            if (link &&
                HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
                HashCompareString.compareStringModels(link.outputPort._qsUuid, portB)) {
                return false;
            }
        }

        return true;
    }
}
