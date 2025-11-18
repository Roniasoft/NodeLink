import QtQuick
import QtQuick.Controls

import NodeLink
import LogicCircuit

I_Scene {
    id: scene

    property color borderColor: "#000000"

    //! Node Registry
    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["LogicCircuit"]

        defaultNode: LSpecs.NodeType.Input
        nodeTypes: [
            LSpecs.NodeType.Input   = "InputNode",
            LSpecs.NodeType.AND     = "AndNode",
            LSpecs.NodeType.OR      = "OrNode",
            LSpecs.NodeType.NOT     = "NotNode",
            LSpecs.NodeType.Output  = "OutputNode"
        ]

        nodeNames: [
            LSpecs.NodeType.Input   = "Input",
            LSpecs.NodeType.AND     = "AND Gate",
            LSpecs.NodeType.OR      = "OR Gate",
            LSpecs.NodeType.NOT     = "NOT Gate",
            LSpecs.NodeType.Output  = "Output"
        ]

        nodeIcons: [
            LSpecs.NodeType.Input   = "⚡",
            LSpecs.NodeType.AND     = "∧",
            LSpecs.NodeType.OR      = "∨",
            LSpecs.NodeType.NOT     = "¬",
            LSpecs.NodeType.Output  = "○"
        ]

        nodeColors: [
            // LSpecs.NodeType.Input   = "#2e7d32",
            // LSpecs.NodeType.AND     = "#1976d2",
            // LSpecs.NodeType.OR      = "#7b1fa2",
            // LSpecs.NodeType.NOT     = "#d32f2f",
            // LSpecs.NodeType.Output  = "#f57c00"
            LSpecs.NodeType.Input   = borderColor,
            LSpecs.NodeType.AND     = borderColor,
            LSpecs.NodeType.OR      = borderColor,
            LSpecs.NodeType.NOT     = borderColor,
            LSpecs.NodeType.Output  = borderColor
        ]
    }

    //! Selection Model
    selectionModel:  SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    //! Update logic when connections change
    onLinkRemoved: updateLogic();
    onNodeRemoved: updateLogic();
    onLinkAdded: updateLogic();

    property Timer _upateDataTimer: Timer {
        repeat: false
        running: false
        interval: 1
        onTriggered: scene.updateLogic();
    }

    /* Functions
     * ****************************************************************************************/

    //! Create a node with node type and its position
    function createCustomizeNode(nodeType, xPos, yPos) {
        var title = nodeRegistry.nodeNames[nodeType] + "_" +
                   (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(nodeRegistry.imports, nodeType,
                                 nodeRegistry.nodeTypes[nodeType],
                                 nodeRegistry.nodeColors[nodeType],
                                 title, xPos, yPos);

    }

    //! Update all logic in the circuit
    // function updateLogic() {
    //     // Reset all operation nodes
    //     Object.values(nodes).forEach(node => {
    //         if (node.type === LSpecs.NodeType.AND ||
    //             node.type === LSpecs.NodeType.OR ||
    //             node.type === LSpecs.NodeType.NOT) {
    //             node.nodeData.inputA = null;
    //             node.nodeData.inputB = null;
    //             node.nodeData.output = null;
    //         }
    //     });

    //     // Propagate values through the circuit
    //     var maxIterations = 10; // Prevent infinite loops
    //     var changed = true;

    //     for (var i = 0; i < maxIterations && changed; i++) {
    //         changed = false;
    //         Object.values(links).forEach(link => {
    //             var upstreamNode = findNode(link.inputPort._qsUuid);
    //             var downstreamNode = findNode(link.outputPort._qsUuid);

    //             if (upstreamNode && downstreamNode && upstreamNode.nodeData.output !== null) {
    //                 // Set input for downstream node based on port title
    //                 if (downstreamNode.nodeData.inputA === null) {
    //                     downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
    //                     changed = true;
    //                 } else if (downstreamNode.nodeData.inputB === null &&
    //                           downstreamNode.type !== LSpecs.NodeType.NOT) {
    //                     downstreamNode.nodeData.inputB = upstreamNode.nodeData.output;
    //                     changed = true;
    //                 }

    //                 // Update downstream node
    //                 if (downstreamNode.updateData) {
    //                     downstreamNode.updateData();
    //                 }

    //                 // Update output display
    //                 if (downstreamNode.type === LSpecs.NodeType.Output) {
    //                     downstreamNode.updateDisplay(upstreamNode.nodeData.output);
    //                 }
    //             }
    //         });
    //     }
    // }

    //! Update all logic in the circuit
    function updateLogic() {
        // Reset all operation nodes
        Object.values(nodes).forEach(node => {
            if (node.type === LSpecs.NodeType.AND ||
                node.type === LSpecs.NodeType.OR ||
                node.type === LSpecs.NodeType.NOT) {
                node.nodeData.inputA = null;
                node.nodeData.inputB = null;
                node.nodeData.output = null;
            }
        });

        // Propagate values through the circuit
        var maxIterations = 10; // Prevent infinite loops
        var changed = true;

        for (var i = 0; i < maxIterations && changed; i++) {
            changed = false;
            Object.values(links).forEach(link => {
                var upstreamNode = findNode(link.inputPort._qsUuid);
                var downstreamNode = findNode(link.outputPort._qsUuid);

                if (upstreamNode && downstreamNode && upstreamNode.nodeData.output !== null) {
                    // Set input for downstream node based on port title
                    if (downstreamNode.nodeData.inputA === null) {
                        downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                        changed = true;
                    } else if (downstreamNode.nodeData.inputB === null &&
                              downstreamNode.type !== LSpecs.NodeType.NOT) {
                        downstreamNode.nodeData.inputB = upstreamNode.nodeData.output;
                        changed = true;
                    }

                    // Update downstream node - BUT ONLY IF IT HAS ALL REQUIRED INPUTS
                    if (downstreamNode.updateData) {
                        // Check if the gate has all required inputs before updating
                        var canUpdate = false;

                        switch(downstreamNode.type) {
                            case LSpecs.NodeType.AND:
                            case LSpecs.NodeType.OR:
                                // AND and OR gates require BOTH inputs
                                canUpdate = (downstreamNode.nodeData.inputA !== null &&
                                           downstreamNode.nodeData.inputB !== null);
                                break;
                            case LSpecs.NodeType.NOT:
                                // NOT gate only requires ONE input
                                canUpdate = (downstreamNode.nodeData.inputA !== null);
                                break;
                            case LSpecs.NodeType.Output:
                                // Output node always updates when input changes
                                canUpdate = true;
                                break;
                            default:
                                canUpdate = true;
                        }

                        if (canUpdate) {
                            downstreamNode.updateData();
                        }
                    }

                    // Update output display for output nodes
                    if (downstreamNode.type === LSpecs.NodeType.Output) {
                        downstreamNode.updateDisplay(downstreamNode.nodeData.inputA);
                    }
                }
            });
        }
    }

    //! Link two nodes with validation
    function linkNodes(portA, portB) {
        if (canLinkNodes(portA, portB)) {
            createLink(portA, portB);
            updateLogic();
        }
    }

    //! Check if nodes can be linked
    function canLinkNodes(portA, portB) {
        // Basic validation (similar to Calculator example)
        if (portA.length === 0 || portB.length === 0) return false;

        var portAObj = findPort(portA);
        var portBObj = findPort(portB);

        // Output can only connect to input
        if (portAObj.portType !== NLSpec.PortType.Output) return false;
        if (portBObj.portType !== NLSpec.PortType.Input) return false;

        // Prevent duplicate links
        var sameLinks = Object.values(links).filter(link =>
            link.inputPort._qsUuid === portA && link.outputPort._qsUuid === portB);
        if (sameLinks.length > 0) return false;

        // Input port can only have one connection
        var portBObjLinks = Object.values(links).filter(link =>
            link.outputPort._qsUuid === portB);
        if (portBObjLinks.length > 0) return false;

        // Prevent self-connection
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);
        if (nodeA === nodeB) return false;

        return true;
    }
}
