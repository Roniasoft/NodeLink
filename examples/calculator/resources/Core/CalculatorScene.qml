import QtQuick
import QtQuick.Controls

import NodeLink
import Calculator

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 * ************************************************************************************************/

I_Scene {
    id: scene

    /* Property Properties
     * ****************************************************************************************/

    //! nodeRegistry
    nodeRegistry:      NLNodeRegistry {
        _qsRepo:  scene._qsRepo

        imports: ["Calculator"]

        defaultNode: CSpecs.NodeType.Source
        nodeTypes : [
            CSpecs.NodeType.Source      = "SourceNode",
            CSpecs.NodeType.Additive    = "AdditiveNode",
            CSpecs.NodeType.Multiplier  = "MultiplierNode",
            CSpecs.NodeType.Subtraction = "SubtractionNode",
            CSpecs.NodeType.Division    = "DivisionNode",
            CSpecs.NodeType.Result      = "ResultNode"
        ];

        nodeNames: [
            CSpecs.NodeType.Source      = "Source",
            CSpecs.NodeType.Additive    = "Additive",
            CSpecs.NodeType.Multiplier  = "Multiplier",
            CSpecs.NodeType.Subtraction = "Subtraction",
            CSpecs.NodeType.Division    = "Division",
            CSpecs.NodeType.Result      = "Result"
        ];

        nodeIcons: [
            CSpecs.NodeType.Source      = "\ue4e2",
            CSpecs.NodeType.Additive    = "+",
            CSpecs.NodeType.Multiplier  = "\uf00d",
            CSpecs.NodeType.Subtraction = "-",
            CSpecs.NodeType.Division    = "/",
            CSpecs.NodeType.Result      = "\uf11b",
        ];

        nodeColors: [
            CSpecs.NodeType.Source     = "#444",
            CSpecs.NodeType.Additive    = "#444",
            CSpecs.NodeType.Multiplier  = "#444",
            CSpecs.NodeType.Subtraction = "#444",
            CSpecs.NodeType.Division    = "#444",
            CSpecs.NodeType.Result      = "#444",
        ];
    }

    //! Scene Selection Model
    selectionModel: SelectionModel {
            existObjects: [...Object.keys(nodes), ...Object.keys(links)]
        }

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    //! update node data when a link removed, node removed and link added.
    onLinkRemoved: _upateDataTimer.start();
    onNodeRemoved: _upateDataTimer.start();
    onLinkAdded:   updateData();

    property Timer _upateDataTimer: Timer {
        repeat: false
        running: false
        interval: 1

        onTriggered: scene.updateData();
    }

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

        // Use notReadyLinks to detect links that be updated in future.
        var notReadyLinks = [];

        // initalize node data
        Object.values(nodes).forEach(node => {
            switch (node.type) {
                case CSpecs.NodeType.Additive:
                case CSpecs.NodeType.Multiplier:
                case CSpecs.NodeType.Subtraction:
                case CSpecs.NodeType.Division:
                     {
                        node.nodeData.data = null;
                        node.nodeData.inputFirst = null;
                        node.nodeData.inputSecond = null;


                     } break;

                case CSpecs.NodeType.Result: {
                          node.nodeData.data = null;
                } break;

                default: {
                }

         }
        });

        Object.values(links).forEach(link => {
            var portA = link.inputPort._qsUuid;
            var portB = link.outputPort._qsUuid;

            var upstreamNode   = findNode(portA);
            var downStreamNode = findNode(portB);


            // Find nodes with valid data that connected to upstreamNode
            var upstreamNodeLinks = Object.values(links).filter(linkObj => {
                                                                    var node = findNode(linkObj.outputPort._qsUuid);
                                                                    var inputNode = findNode(linkObj.inputPort._qsUuid);
                                                                    if (node._qsUuid === upstreamNode._qsUuid) {
                                                                        if(inputNode.nodeData.data)
                                                                        return linkObj
                                                                    }
                                                                });

            if (!upstreamNode.nodeData.data &&
                upstreamNode.type !== CSpecs.NodeType.Source) {
                if (upstreamNodeLinks.length > 1)
                    notReadyLinks.push(link);
                return;
            }

            upadateNodeData(upstreamNode, downStreamNode);

        });

        while (notReadyLinks.length > 0) {
            notReadyLinks.forEach((link, index ) => {
                                      var portA = link.inputPort._qsUuid;
                                      var portB = link.outputPort._qsUuid;

                                      // Find nodes
                                      var upstreamNode   = findNode(portA);
                                      var downStreamNode = findNode(portB);

                                      var upstreamNodeLinks = Object.values(links).filter(linkObj => findNodeId(linkObj.outputPort._qsUuid) === upstreamNode._qsUuid);

                                      //! remove link from notReadyLinks when
                                      //! upstreamNode.nodeData.data is not null
                                      if (upstreamNode.nodeData.data) {
                                          notReadyLinks.splice(index, 1);
                                      }

                                      // update node data
                                      upadateNodeData(upstreamNode, downStreamNode);
                                  });
        }
    }

    //! Update node data
    function upadateNodeData(upstreamNode: Node, downStreamNode: Node) {
        switch (downStreamNode.type) {
            // Update operation nodes data
            case CSpecs.NodeType.Additive:
            case CSpecs.NodeType.Multiplier:
            case CSpecs.NodeType.Subtraction:
            case CSpecs.NodeType.Division:
                 {
                     if (!downStreamNode.nodeData.inputFirst)
                     downStreamNode.nodeData.inputFirst = upstreamNode.nodeData.data;
                     else if (!downStreamNode.nodeData.inputSecond)
                     downStreamNode.nodeData.inputSecond = upstreamNode.nodeData.data;

                     // Update downStreamNode data with specefic operation
                     downStreamNode.updataData();


                 } break;

            case CSpecs.NodeType.Result: {
                     downStreamNode.nodeData.data = upstreamNode.nodeData.data;
            } break;

            default: {
            }
        }
    }
}
