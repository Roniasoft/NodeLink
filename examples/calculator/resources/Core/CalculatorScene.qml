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
    //! Scene Selection Model
    selectionModel: SelectionModel {}

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    /* Functions
     * ****************************************************************************************/

    //! Create a node with node type and its position
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string {
        var title = NLNodeRegistry.nodeNames[nodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(NLNodeRegistry.imports, nodeType,
                                  NLNodeRegistry.nodeTypes[nodeType],
                                  NLNodeRegistry.nodeColors[nodeType],
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

        if (link === undefined) {
            createLink(portA, portB);





        }
    }

    //! The ability to create a link is detected in the canLinkNodes function.
    //! Rols:
    //!     - A link must be established between two specific links
    //!     - Link can not be duplicate
    //!     - A node cannot establish a link with itself
    function canLinkNodes(portA : string, portB : string): bool {

        //! Sanity check
        if (portA.length === 0 || portB.length === 0)
            return false;

        // Just a input port can be link to output port
        var portAObj = findPort(portA);
        var portBObj = findPort(portB);
        if (portAObj.portType !== NLSpec.PortType.Output ||
            portBObj.portType !== NLSpec.PortType.Input) {
            return false
        }

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

        return true;
    }

    function updateData() {
        Object.values(links).forEach(link => {
                                         var portA = link.inputPort._qsUuid;
                                         var portB = link.outputPort._qsUuid;

                                         var nodeA = findNodeId(portA);
                                         var nodeB = findNodeId(portB);

                                         switch (nodeB.type) {
                                            case CSpecs.NodeType.Operation: {

                                            } break;

                                            case CSpecs.NodeType.Result: {

                                            } break;

                                            case CSpecs.NodeType.Source: {

                                            } break;
                                         }
                                     });
    }
}
