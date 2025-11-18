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
            LSpecs.NodeType.Input   = borderColor,
            LSpecs.NodeType.AND     = borderColor,
            LSpecs.NodeType.OR      = borderColor,
            LSpecs.NodeType.NOT     = borderColor,
            LSpecs.NodeType.Output  = borderColor
        ]
    }

    //! Selection Model
    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    //! Undo Core
    property UndoCore _undoCore: UndoCore {
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
    //! Update all logic in the circuit
    function updateLogic() {
        console.log("=== UPDATE LOGIC STARTED ===");

        // Reset all operation nodes
        Object.values(nodes).forEach(node => {
            if (node.type === LSpecs.NodeType.AND ||
                node.type === LSpecs.NodeType.OR ||
                node.type === LSpecs.NodeType.NOT) {
                console.log("Resetting node:", node.type, "ID:", node._qsUuid);
                node.nodeData.inputA = null;
                node.nodeData.inputB = null;
                node.nodeData.output = null;
            }
            // Also reset output nodes
            if (node.type === LSpecs.NodeType.Output) {
                node.nodeData.inputA = null;
                node.nodeData.displayValue = "UNDEFINED";
            }
        });

        // Track which upstream nodes are connected to which downstream inputs
        var connectionMap = {};

        // Propagate values through the circuit
        var maxIterations = 10;
        var changed = true;

        for (var i = 0; i < maxIterations && changed; i++) {
            console.log("Iteration:", i);
            changed = false;

            Object.values(links).forEach(link => {
                var upstreamNode = findNode(link.inputPort._qsUuid);
                var downstreamNode = findNode(link.outputPort._qsUuid);

                if (upstreamNode && downstreamNode && upstreamNode.nodeData.output !== null) {
                    console.log("Link found - From:", upstreamNode.type, "To:", downstreamNode.type, "Value:", upstreamNode.nodeData.output);

                    // FIX: Prevent the same upstream node from connecting to multiple inputs of the same gate
                    var connectionKey = downstreamNode._qsUuid + "_" + upstreamNode._qsUuid;

                    if (downstreamNode.type === LSpecs.NodeType.AND ||
                        downstreamNode.type === LSpecs.NodeType.OR) {

                        // For 2-input gates, ensure DIFFERENT upstream nodes for inputA and inputB
                        if (downstreamNode.nodeData.inputA === null && !connectionMap[connectionKey + "_A"]) {
                            console.log("Setting inputA of", downstreamNode.type, "to", upstreamNode.nodeData.output);
                            downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                            connectionMap[connectionKey + "_A"] = true;
                            changed = true;
                        } else if (downstreamNode.nodeData.inputB === null && !connectionMap[connectionKey + "_B"]) {
                            // Only set inputB if it's from a different upstream node than inputA
                            var inputAUpstream = null;
                            Object.keys(connectionMap).forEach(key => {
                                if (key.startsWith(downstreamNode._qsUuid) && key.endsWith("_A")) {
                                    var upstreamId = key.split("_")[1];
                                    inputAUpstream = upstreamId;
                                }
                            });

                            if (inputAUpstream !== upstreamNode._qsUuid) {
                                console.log("Setting inputB of", downstreamNode.type, "to", upstreamNode.nodeData.output);
                                downstreamNode.nodeData.inputB = upstreamNode.nodeData.output;
                                connectionMap[connectionKey + "_B"] = true;
                                changed = true;
                            } else {
                                console.log("Skipping inputB - same upstream node as inputA");
                            }
                        }

                    } else if (downstreamNode.type === LSpecs.NodeType.NOT ||
                              downstreamNode.type === LSpecs.NodeType.Output) {

                        // For single-input gates, only set inputA
                        if (downstreamNode.nodeData.inputA === null) {
                            console.log("Setting inputA of", downstreamNode.type, "to", upstreamNode.nodeData.output);
                            downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                            changed = true;
                        }
                    }

                    // Update downstream node - BUT ONLY IF IT HAS ALL REQUIRED INPUTS
                    if (downstreamNode.updateData) {
                        var canUpdate = false;

                        switch(downstreamNode.type) {
                            case LSpecs.NodeType.AND:
                            case LSpecs.NodeType.OR:
                                canUpdate = (downstreamNode.nodeData.inputA !== null &&
                                           downstreamNode.nodeData.inputB !== null);
                                console.log("AND/OR Gate - Can update:", canUpdate, "InputA:", downstreamNode.nodeData.inputA, "InputB:", downstreamNode.nodeData.inputB);
                                break;
                            case LSpecs.NodeType.NOT:
                                canUpdate = (downstreamNode.nodeData.inputA !== null);
                                console.log("NOT Gate - Can update:", canUpdate, "InputA:", downstreamNode.nodeData.inputA);
                                break;
                            case LSpecs.NodeType.Output:
                                canUpdate = (downstreamNode.nodeData.inputA !== null);
                                console.log("Output Gate - Can update:", canUpdate, "InputA:", downstreamNode.nodeData.inputA);
                                break;
                            default:
                                canUpdate = true;
                        }

                        if (canUpdate) {
                            console.log("Calling updateData on:", downstreamNode.type);
                            downstreamNode.updateData();
                            console.log("Result - Output:", downstreamNode.nodeData.output);
                        }
                    }
                }
            });
        }
        console.log("=== UPDATE LOGIC COMPLETED ===");
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
        // Basic validation
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
