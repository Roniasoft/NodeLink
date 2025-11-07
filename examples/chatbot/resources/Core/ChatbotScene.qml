import QtQuick
import QtQuick.Controls

import NodeLink
import Chatbot

I_Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["Chatbot"]

        defaultNode: CSpecs.NodeType.Source
        nodeTypes: [
            CSpecs.NodeType.Source      = "SourceNode",
            CSpecs.NodeType.Regex       = "RegexNode",
            CSpecs.NodeType.ResultTrue  = "ResultTrueNode",
            CSpecs.NodeType.ResultFalse = "ResultFalseNode"
        ];
        nodeNames: [
            CSpecs.NodeType.Source      = "Source",
            CSpecs.NodeType.Regex       = "Regex",
            CSpecs.NodeType.ResultTrue  = "ResultTrue",
            CSpecs.NodeType.ResultFalse = "ResultFalse"
        ];
        nodeIcons: [
            CSpecs.NodeType.Source      = "\ue4e2",
            CSpecs.NodeType.Regex       = "\uf002",
            CSpecs.NodeType.ResultTrue  = "\uf058",
            CSpecs.NodeType.ResultFalse = "\uf057"
        ];
        nodeColors: [
            CSpecs.NodeType.Source      = "#444",
            CSpecs.NodeType.Regex       = "#C69C6D",
            CSpecs.NodeType.ResultTrue  = "#4caf50",
            CSpecs.NodeType.ResultFalse = "#f44336"
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


    function updateData() {
        // Use notReadyLinks to detect links that be updated in future.
        var notReadyLinks = [];

        // initalize node data
        Object.values(nodes).forEach(node => {
            switch (node.type) {
                case CSpecs.NodeType.ResultTrue:
                case CSpecs.NodeType.ResultFalse:
                {
                    node.nodeData.data = null;
                } break;

                default:
                {
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
                                                                        {
                                                                            return linkObj
                                                                        }
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

    function upadateNodeData(upstreamNode: Node, downStreamNode: Node) {
        switch (downStreamNode.type) {
            case CSpecs.NodeType.Regex:
            {
                downStreamNode.inputFirst = upstreamNode.nodeData.data;

                // Update downStreamNode data with specefic operation
                downStreamNode.updataData();

            } break;

            case CSpecs.NodeType.ResultTrue:
            {
                downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "FOUND") ? "YES ..." : "";
            } break;
            case CSpecs.NodeType.ResultFalse:
            {
                downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "NOT_FOUND") ? "NO !!!" : "";
            } break;

            default: {
            }
        }
    }
}
