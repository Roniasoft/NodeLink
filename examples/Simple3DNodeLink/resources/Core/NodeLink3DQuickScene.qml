import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Simple3DNodeLinkScene - A 3D scene that can contain 2D nodes positioned in 3D space
 * This uses NodeLink's Node class (not Qt3D's Node) to avoid confusion
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
    property UndoCore _undoCore: UndoCore {
        scene: root
    }
    
    //! 3D positioning properties
    property real node3DSpacing: 200.0
    property real layerSpacing: 100.0
    
    /* Functions
     * ****************************************************************************************/

    //! Override this function to create nodes with 3D positioning
    function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
        var qsType = root.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(root.nodes).filter(node => node.type === nodeType).length + 1);
        
        // Use 2D position for both 2D and 3D (3D is just for reference)
        return createSpecificNode3D(nodeRegistry.imports, nodeType, qsType,
                                  nodeRegistry.nodeColors[nodeType],
                                  title, xPos, yPos,  // 2D position (fixed on screen)
                                  xPos, yPos, 0.0);  // 3D position (for reference)
    }
    
    //! Create a node with explicit 3D positioning
    function createCustomizeNode3D(nodeType: int, x2D: real, y2D: real, x3D: real, y3D: real, z3D: real): string {
        var qsType = root.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(root.nodes).filter(node => node.type === nodeType).length + 1);
        
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

        node._qsRepo = root._qsRepo;
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

    //! Arrange nodes in 3D grid
    function arrangeNodes3D() {
        var nodeList = Object.values(nodes);
        var gridSize = Math.ceil(Math.sqrt(nodeList.length));
        
        for (var i = 0; i < nodeList.length; i++) {
            var row = Math.floor(i / gridSize);
            var col = i % gridSize;
            
            var x = col * node3DSpacing;
            var y = row * node3DSpacing;
            var z = (i % 3) * layerSpacing - layerSpacing; // Distribute in 3 layers
            
            updateNode3DPosition(nodeList[i]._qsUuid, x, y, z);
        }
    }

    //! Override linkNodes to work with 3D positioning
    //! Note: createLink already handles children/parents relationships, so we don't duplicate it here
    function linkNodes(portA: string, portB: string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[3DQuickScene] Cannot link Nodes ");
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
    //! Similar to CalculatorScene.updateData() but simplified for SourceNode -> ResultNode
    function updateData() {
        // Process all links to transfer data from SourceNode to ResultNode
        Object.values(links).forEach(link => {
            // In I_Scene.createLink, inputPort is portA (output port from SourceNode)
            // and outputPort is portB (input port to ResultNode)
            var outputPortUuid = link.inputPort._qsUuid;  // Output port (from SourceNode)
            var inputPortUuid = link.outputPort._qsUuid;  // Input port (to ResultNode)

            var upstreamNode = findNode(outputPortUuid);   // SourceNode (has output port)
            var downStreamNode = findNode(inputPortUuid);  // ResultNode (has input port)

            if (!upstreamNode || !downStreamNode) {
                return;
            }

            // Only process if upstream node has data (SourceNode type is 0)
            if (upstreamNode.type === 0 && upstreamNode.nodeData && upstreamNode.nodeData.data !== null && upstreamNode.nodeData.data !== undefined) {
                // For ResultNode (type 1), directly copy data from SourceNode
                if (downStreamNode.type === 1) {
                    downStreamNode.nodeData.data = upstreamNode.nodeData.data;
                }
            }
        });
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

        // Check for existing link (most expensive operation - do last)
        var sameLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
            HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));

        if (sameLinks.length > 0)
            return false;

        // An input port can accept only a single link
        var inputPortLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.inputPort._qsUuid, portB));

        if (inputPortLinks.length > 0)
            return false;

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
            root.updateData();
        });
    }
}

