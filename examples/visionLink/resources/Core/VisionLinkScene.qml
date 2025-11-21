import QtQuick
import QtQuick.Controls

import NodeLink
import VisionLink

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 * ************************************************************************************************/
I_Scene {
    id: scene

    /* Object Properties
     * ****************************************************************************************/
    //! nodeRegistry
    nodeRegistry:      NLNodeRegistry {
        _qsRepo:  scene._qsRepo

        imports: ["VisionLink"]

        defaultNode: CSpecs.NodeType.ImageInput
        nodeTypes : [
            CSpecs.NodeType.ImageInput      = "ImageInputNode",
            CSpecs.NodeType.ImageResult     = "ImageResultNode",
            CSpecs.NodeType.Blur            = "BlurOperationNode",
            CSpecs.NodeType.Brightness      = "BrightnessOperationNode",
            CSpecs.NodeType.Contrast        = "ContrastOperationNode"
        ];

        nodeNames: [
            CSpecs.NodeType.ImageInput      = "Image Input",
            CSpecs.NodeType.ImageResult     = "Image Result",
            CSpecs.NodeType.Blur            = "Blur",
            CSpecs.NodeType.Brightness      = "Brightness",
            CSpecs.NodeType.Contrast        = "Contrast"
        ];

        nodeIcons: [
            CSpecs.NodeType.ImageInput      = "\uf093",
            CSpecs.NodeType.ImageResult     = "\uf03e",
            CSpecs.NodeType.Blur            = "\uf1fc",
            CSpecs.NodeType.Brightness      = "\uf185",
            CSpecs.NodeType.Contrast        = "\uf042"
        ];

        nodeColors: [
            CSpecs.NodeType.ImageInput     = "#444",
            CSpecs.NodeType.ImageResult    = "#444",
            CSpecs.NodeType.Blur           = "#9013FE",
            CSpecs.NodeType.Brightness     = "#F5A623",
            CSpecs.NodeType.Contrast       = "#E91E63"
        ];
    }

    //! Scene Selection Model
    selectionModel: SelectionModel {
            existObjects: [...Object.keys(nodes), ...Object.keys(links), ...Object.keys(containers)]
        }

    /* Property Declarations
     * ****************************************************************************************/
    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    property Timer _upateDataTimer: Timer {
        repeat: false
        running: false
        interval: 1

        onTriggered: scene.updateData();
    }

    /* Children
    * ****************************************************************************************/
    //! update node data when a link removed, node removed and link added.
    onLinkRemoved: _upateDataTimer.start();
    onNodeRemoved: _upateDataTimer.start();
    onLinkAdded:   updateData();

    /* Functions
     * ****************************************************************************************/
    //! Create a node with node type and its position
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string {
        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(nodeRegistry.imports, nodeType,
                                  nodeRegistry.nodeTypes[nodeType],
                                  nodeRegistry.nodeColors[nodeType],
                                  title, xPos, yPos);
    }

    //! Check some conditions and
    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function linkNodes(portA : string, portB : string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes ");
            return;
        }
        let link = Object.values(links).find(conObj =>
                                             conObj.inputPort._qsUuid === portA &&
                                             conObj.outputPort._qsUuid === portB);

        if (link === undefined)
            createLink(portA, portB);
    }

    //! The ability to create a link is detected in the canLinkNodes function.
    //! Rols:
    //!     - A link must be established between two specific links
    //!     - Link can not be duplicate
    //!     - A node cannot establish a link with itself
    //!     - An output port can connect to input ports
    //!     - Only one link can connected to input port.
    function canLinkNodes(portA : string, portB : string): bool {

        //! Sanity check
        if (portA.length === 0 || portB.length === 0)
            return false;

        // Just a input port can be link to output port
        var portAObj = findPort(portA);
        var portBObj = findPort(portB);
        if (portAObj.portType === NLSpec.PortType.Input)
            return false;
        if (portBObj.portType === NLSpec.PortType.Output)
            return false;

        // Find exist links with portA as input port and portB as output port.
        var sameLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
            HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));

        if (sameLinks.length > 0)
            return false;

        // An input port can accept only a single link.
        var portBObjLinks = Object.values(links).filter(link => HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));
        if (portBObjLinks.length)
            return false;

        // A node cannot establish a link with itself
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);
        if (HashCompareString.compareStringModels(nodeA, nodeB)
                    || nodeA.length === 0 || nodeB.length === 0) {
            return false;
        }

        // A node can be connect to another at one direction
        var sameReverseLinks = Object.values(links).filter(link =>
            findNodeId(link.outputPort._qsUuid) === nodeA &&
            findNodeId(link.inputPort._qsUuid) === nodeB);

        if (sameReverseLinks.length > 0)
            return false;

        return true;
    }

    //! Updata node data with connected links
    function updateData() {
        // Initialize node data for all operation and result nodes (reset them)
        Object.values(nodes).forEach(node => {
            switch (node.type) {
                case CSpecs.NodeType.Blur:
                case CSpecs.NodeType.Brightness:
                case CSpecs.NodeType.Contrast:
                     {
                        node.nodeData.data = null;
                        node.nodeData.input = null;
                     } break;

                case CSpecs.NodeType.ImageResult: {
                        node.nodeData.data = null;
                } break;

                default: {
                }
         }
        });

        // Get all links as an array
        var allLinks = Object.values(links);
        var processedLinks = [];
        var remainingLinks = allLinks.slice(); // Copy all links
        
        var maxIterations = 100; // Prevent infinite loop
        var iteration = 0;
        
        // Keep processing until all links are done or we hit max iterations
        while (remainingLinks.length > 0 && iteration < maxIterations) {
            iteration++;
            
            var linksProcessedThisIteration = [];
            var linksStillWaiting = [];
            
            // Try to process each remaining link
            remainingLinks.forEach(function(link) {
                var portA = link.inputPort._qsUuid;
                var portB = link.outputPort._qsUuid;

                var upstreamNode   = findNode(portA);
                var downStreamNode = findNode(portB);
                
                // Check if upstream node has data
                var upstreamHasData = upstreamNode.nodeData.data !== null && 
                                     upstreamNode.nodeData.data !== undefined;
                
                // ImageInput always has data (or should have it)
                if (upstreamNode.type === CSpecs.NodeType.ImageInput) {
                    upstreamHasData = true;
                }
                
                if (upstreamHasData) {
                    // Process this link now
                    upadateNodeData(upstreamNode, downStreamNode);
                    linksProcessedThisIteration.push(link);
                } else {
                    // Can't process yet, upstream doesn't have data
                    linksStillWaiting.push(link);
                }
            });
            
            // Update remaining links for next iteration
            remainingLinks = linksStillWaiting;
            
            // If no links were processed in this iteration, we can't make progress
            if (linksProcessedThisIteration.length === 0) {
                console.warn("No links processed in iteration", iteration, "- breaking");
                if (remainingLinks.length > 0) {
                    console.warn("Could not process", remainingLinks.length, "links - check for missing data");
                }
                break;
            }
        }
        
        if (iteration >= maxIterations) {
            console.error("Max iterations reached! Possible circular dependency");
        }
    }

    //! Update only downstream nodes from a specific starting node
    function updateDataFromNode(startingNode: Node) {
        
        // First, update the starting node itself (it may need to recalculate with new parameters)
        if (startingNode.type === CSpecs.NodeType.Blur ||
            startingNode.type === CSpecs.NodeType.Brightness ||
            startingNode.type === CSpecs.NodeType.Contrast) {
            // Re-run the operation with current input and new parameters
            startingNode.updataData();
        }
        
        // Find all downstream nodes and update them
        var nodesToUpdate = [startingNode];
        var processedNodes = [];
        var maxIterations = 100;
        var iteration = 0;
        
        while (nodesToUpdate.length > 0 && iteration < maxIterations) {
            iteration++;
            var currentNode = nodesToUpdate.shift(); // Get first node from queue
            processedNodes.push(currentNode._qsUuid);
            
            // Find all links where this node is upstream (output)
            var downstreamLinks = Object.values(links).filter(function(link) {
                var upstreamNodeId = findNodeId(link.inputPort._qsUuid);
                return upstreamNodeId === currentNode._qsUuid;
            });
                        
            // Process each downstream link
            downstreamLinks.forEach(function(link) {
                var portB = link.outputPort._qsUuid;
                var downStreamNode = findNode(portB);
                
                // Update the downstream node
                upadateNodeData(currentNode, downStreamNode);
                
                // Add to queue if not already processed
                if (processedNodes.indexOf(downStreamNode._qsUuid) === -1) {
                    nodesToUpdate.push(downStreamNode);
                }
            });
        }
    }

    //! Update node data
    function upadateNodeData(upstreamNode: Node, downStreamNode: Node) {
        switch (downStreamNode.type) {
            // Update operation nodes data
            case CSpecs.NodeType.Blur:
            case CSpecs.NodeType.Brightness:
            case CSpecs.NodeType.Contrast:
                 {
                    // Always update input from upstream node
                    downStreamNode.nodeData.input = upstreamNode.nodeData.data;

                    // Update downStreamNode data with specific operation
                    downStreamNode.updataData();
                 } break;

            case CSpecs.NodeType.ImageResult: {
                     downStreamNode.nodeData.data = upstreamNode.nodeData.data;
            } break;

            default: {
            }
        }
    }
}
