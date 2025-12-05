import QtQuick
import QtQuick.Controls

import NodeLink
import Simple3DNodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Simple3DNodeLinkScene - A 3D scene that can contain 2D nodes positioned in 3D space
 * This uses NodeLink's Node class (not Qt3D's Node) to avoid confusion
 * ************************************************************************************************/

I_Scene {
    id: scene

    /* Property Properties
     * ****************************************************************************************/
    
    //! Scene Selection Model
    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    //! Undo Core
    property UndoCore _undoCore: UndoCore {
        scene: scene
    }
    
    /* Functions
     * ****************************************************************************************/

    //! Override this function to create nodes with 3D positioning
    function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
        var qsType = scene.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        
        // Use 2D position for both 2D and 3D (3D is just for reference)
        return createSpecificNode3D(nodeRegistry.imports, nodeType, qsType,
                                  nodeRegistry.nodeColors[nodeType],
                                  title, xPos, yPos,  // 2D position (fixed on screen)
                                  xPos, yPos, 0.0);  // 3D position (for reference)
    }
    
    //! Create a node with explicit 3D positioning
    function createCustomizeNode3D(nodeType: int, x2D: real, y2D: real, x3D: real, y3D: real, z3D: real): string {
        var qsType = scene.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        
        // Use provided 2D and 3D positions
        return createSpecificNode3D(nodeRegistry.imports, nodeType, qsType,
                                  nodeRegistry.nodeColors[nodeType],
                                  title, x2D, y2D,  // 2D position
                                  x3D, y3D, z3D);  // 3D position
    }

    //! Create a specific node with 3D positioning
    //! x2D, y2D: 2D screen position (fixed on screen, doesn't move with camera)
    //! x3D, y3D, z3D: 3D world position (for reference, e.g., for linking calculations)
    function createSpecificNode3D(imports: var, type: int, qsType: string,
                                color: string, title: string,
                                x2D: real, y2D: real,  // 2D screen position (fixed)
                                x3D: real, y3D: real, z3D: real): string {  // 3D world position (for reference)
        var node = QSSerializer.createQSObject(qsType, imports, NLCore.defaultRepo);

        node._qsRepo = scene._qsRepo;
        node.title = title;
        node.type = type;
        node.guiConfig.color = color;
        // 2D position (fixed on screen, doesn't move with camera)
        node.guiConfig.position.x = x2D;
        node.guiConfig.position.y = y2D;
        // 3D position (for reference, e.g., for linking calculations)
        node.guiConfig.position3D = Qt.vector3d(x3D, y3D, z3D);

        addNode(node, false);
        return node._qsUuid;
    }

    //! Override the standard createSpecificNode to include 3D positioning
    function createSpecificNode(imports: var, type: int, qsType: string,
                                color: string, title: string,
                                xPos: real, yPos: real): string {
        // Use 2D position for both 2D and 3D (3D is just for reference)
        return createSpecificNode3D(imports, type, qsType, color, title, xPos, yPos, xPos, yPos, 0.0);
    }

    //! Update node 3D position
    function updateNode3DPosition(nodeId: string, x: real, y: real, z: real) {
        var node = nodes[nodeId];
        if (node) {
            node.guiConfig.position.x = x;
            node.guiConfig.position.y = y;
            node.guiConfig.position3D = Qt.vector3d(x, y, z);
        }
    }

    //! Override linkNodes to work with 3D positioning
    //! Note: createLink already handles children/parents relationships, so we don't duplicate it here
    function linkNodes(portA: string, portB: string) {
        if (!canLinkNodes(portA, portB)) {
            return;
        }

        let link = Object.values(links).find(conObj =>
                                             conObj.inputPort._qsUuid === portA &&
                                             conObj.outputPort._qsUuid === portB);

        if (link === undefined) {
            // Create link with 3D support
            // createLink in I_Scene will handle children/parents relationships and trigger signals
            createLink(portA, portB)
            // Update data after link is created
            updateData();
        }
    }
    
    //! Update node data with connected links
    //! Handles data propagation for all node types
    //! This function processes all links and updates downstream nodes recursively
    function updateData() {
        // Track processed nodes to avoid infinite loops
        var processedNodes = {};
        var maxIterations = 100;
        var iteration = 0;
        
        // Keep processing until no more updates are needed
        while (iteration < maxIterations) {
            iteration++;
            var hasUpdates = false;
            
            // Process all links to transfer data between nodes
            Object.values(links).forEach(link => {
                // In I_Scene.createLink, inputPort is portA (output port from upstream node)
                // and outputPort is portB (input port to downstream node)
                var outputPortUuid = link.inputPort._qsUuid;  // Output port (from upstream node)
                var inputPortUuid = link.outputPort._qsUuid;  // Input port (to downstream node)

                var upstreamNode = findNode(outputPortUuid);   // Upstream node (has output port)
                var downStreamNode = findNode(inputPortUuid);  // Downstream node (has input port)

                if (!upstreamNode || !downStreamNode) {
                    return;
                }

                // Get data from upstream node
                if (!upstreamNode.nodeData || upstreamNode.nodeData.data === null || upstreamNode.nodeData.data === undefined) {
                    return;
                }

                var data = upstreamNode.nodeData.data;
                var outputPortTitle = link.inputPort.title;
                var inputPortTitle = link.outputPort.title;

            // Try to update downstream node with the data
            // Use inputPortTitle to identify which port the data should go to
            if (downStreamNode.updateInput) {
                // Node has updateInput function - call it with port title and data
                var oldData = downStreamNode.nodeData ? downStreamNode.nodeData.data : null;
                downStreamNode.updateInput(inputPortTitle, data);
                
                // Check if data changed (for recursive updates)
                var newData = downStreamNode.nodeData ? downStreamNode.nodeData.data : null;
                if (oldData !== newData) {
                    hasUpdates = true;
                }
            }
            });
            
            // If no updates happened, we're done
            if (!hasUpdates) {
                break;
            }
        }
        
        // Trigger update for all nodes to ensure they process their inputs
        Object.values(nodes).forEach(node => {
            if (node && node.updateNodeData) {
                node.updateNodeData();
            }
        });
    }
    
    //! Update data from a specific node (recursive)
    //! This is called when a node's data changes to propagate changes downstream
    function updateDataFromNode(startingNode) {
        if (!startingNode) return;
        
        // Find all links where this node is upstream (output)
        var downstreamLinks = Object.values(links).filter(function(link) {
            var upstreamNodeId = findNodeId(link.inputPort._qsUuid);
            return upstreamNodeId === startingNode._qsUuid;
        });
        
        // Process each downstream link
        downstreamLinks.forEach(function(link) {
            var inputPortUuid = link.outputPort._qsUuid;  // Input port (to downstream node)
            var downStreamNode = findNode(inputPortUuid);
            
            if (!downStreamNode || !startingNode.nodeData) {
                return;
            }
            
            var data = startingNode.nodeData.data;
            if (data === null || data === undefined) {
                return;
            }
            
            var inputPortTitle = link.outputPort.title;
            
            // Update downstream node
            if (downStreamNode.updateInput) {
                downStreamNode.updateInput(inputPortTitle, data);
                // Recursively update from this node
                updateDataFromNode(downStreamNode);
            } else if (downStreamNode.type === 1) {
                downStreamNode.nodeData.data = data;
            }
        });
    }

    //! Get data type from output port
    function getOutputDataType(portUuid: string): string {
        var port = findPort(portUuid);
        if (!port || port.portType !== NLSpec.PortType.Output) {
            return "Unknown";
        }
        
        var node = findNode(portUuid);
        if (!node) {
            return "Unknown";
        }
        
        var portTitle = port.title;
        
        if (portTitle === "Position") {
            return "Position";
        } else if (portTitle === "Rotation") {
            return "Rotation";
        } else if (portTitle === "Scale") {
            return "Scale";
        } else if (portTitle === "Dimensions") {
            return "Dimensions";
        } else if (portTitle === "Material") {
            return "Material";
        } else if (portTitle === "Number") {
            return "Number";
        }
        
        if (node.type === Specs.NodeType.Number) {
            return "Number";
        } else if (node.type === Specs.NodeType.Position) {
            return "Position";
        } else if (node.type === Specs.NodeType.Rotation) {
            return "Rotation";
        } else if (node.type === Specs.NodeType.Scale) {
            return "Scale";
        } else if (node.type === Specs.NodeType.Dimensions) {
            return "Dimensions";
        } else if (node.type >= Specs.NodeType.Metal && node.type <= Specs.NodeType.Wood) {
            return "Material";
        }
        
        return "Unknown";
    }
    
    //! Get expected data type for input port
    function getInputDataType(portUuid: string): string {
        var port = findPort(portUuid);
        if (!port) {
            return "Unknown";
        }
        
        var portTitle = port.title;
        
        if (portTitle === "X" || portTitle === "Y" || portTitle === "Z" ||
            portTitle === "W" || portTitle === "H" || portTitle === "D" ||
            portTitle === "Metallic" || portTitle === "Roughness" || portTitle === "Emissive Power") {
            return "Number";
        } else if (portTitle === "Position") {
            return "Position";
        } else if (portTitle === "Rotation") {
            return "Rotation";
        } else if (portTitle === "Scale") {
            return "Scale";
        } else if (portTitle === "Dimensions") {
            return "Dimensions";
        } else if (portTitle === "Material") {
            return "Material";
        } else if (portTitle === "Input" || portTitle === "Number") {
            return "Number";
        }
        
        return "Unknown";
    }

    //! Check if two ports can be linked
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

        // Type checking: check if output type matches input type
        var outputType = getOutputDataType(portA);
        var inputType = getInputDataType(portB);
        
        if (outputType !== "Unknown" && inputType !== "Unknown" && outputType !== inputType) {
            return false;
        }

        // Check for existing link (most expensive operation - do last)
        // Check if the exact same link already exists
        var sameLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
            HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));

        if (sameLinks.length > 0)
            return false;

        // An input port can accept only a single link
        // Check if portB (input port) is already connected to any output port
        // In I_Scene.createLink: link.inputPort = portA (output), link.outputPort = portB (input)
        var inputPortLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));

        if (inputPortLinks.length > 0) {
            // Input port already has a connection, reject new connection
            return false;
        }

        return true;
    }

    /* Component Setup
     * ****************************************************************************************/
    Component.onCompleted: {
        // Scene initialized
    }
    
    //! When a link is added, update data
    onLinkAdded: (link) => {
        // Update data when a new link is created
        Qt.callLater(function() {
            scene.updateData();
        });
    }
}

