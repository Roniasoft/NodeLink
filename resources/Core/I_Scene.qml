import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 *
 * ************************************************************************************************/
QSObject {
    id: scene

    /* Property Properties
     * ****************************************************************************************/
    //! Scene Title
    property string         title:          "<Untitled>"

    //! Nodes
    //! map<UUID, Node>
    property var            nodes:          ({})

    //! Keep Connection models
    //! map <UUID, Link>
    property var            links:          ({})

    //! Port positions (global)
    //! map<port uuid: string, global pos: vector2d>
    property var            portsPositions: ({})

    //! Scene Selection Model
    property SelectionModel selectionModel: SelectionModel {}

    /* Functions
     * ****************************************************************************************/
    //! Adds a node the to nodes map
    function addNode(node: Node) {
        //Sanity check
        if (nodes[node._qsUuid] === node) { return; }

        // Add to local administration
        nodes[node._qsUuid] = node;
        nodesChanged();

        node.onPortAdded.connect(onPortAdded);
        return node;
    }

    //! Create a node with node type and its position
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string{
        var node = NLCore.createNode();
        node.type = nodeType;
        node.guiConfig.position.x = xPos;
        node.guiConfig.position.y = yPos;
        node.guiConfig.color = NLStyle.nodeColors[nodeType]//Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
        scene.addNode(node)
        node.addPortByHardCode();

        scene.selectionModel.select(node);

        return node._qsUuid;
    }


    //! Deletes a node from the scene
    function deleteNode(nodeUUId: string) {
        //! delete the node ports from the portsPosition map
        Object.keys(nodes[nodeUUId].ports).forEach(portId => {
            // delete from portsPositions
            delete portsPositions[portId];

            // delete related links
            Object.entries(links).forEach(([key, value]) => {
                if (value.inputPort._qsUuid === portId ||
                        value.outputPort._qsUuid === portId) {
                    delete links[key];
                }
            });
        });


        if(selectionModel.selectedNode !== null && selectionModel.selectedNode._qsUuid === nodeUUId)
            selectionModel.clear();

        delete nodes[nodeUUId];

        portsPositionsChanged();
        linksChanged();
        nodesChanged();

    }


    //! duplicator (third button)
    function cloneNode(nodeUUId: string) {
        var node = NLCore.createNode();
        addNode(node);

        node.guiConfig.position.x = nodes[nodeUUId].guiConfig.position.x + 50
        node.guiConfig.position.y = nodes[nodeUUId].guiConfig.position.y + 50
        node.guiConfig.color = nodes[nodeUUId].guiConfig.color
        node.guiConfig.height = nodes[nodeUUId].guiConfig.height
        node.guiConfig.width = nodes[nodeUUId].guiConfig.width
        node.title = nodes[nodeUUId].title
        node.addPortByHardCode();
        selectionModel.select(node);
    }

    //! On port added
    function onPortAdded(portUUId : string) {

        // Add an empty position index
        portsPositions[portUUId] = Qt.vector2d(0, 0);;
        portsPositionsChanged();
    }

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
            let obj = NLCore.createLink();
            obj.inputPort  = findPort(portA);
            obj.outputPort = findPort(portB);
            links[obj._qsUuid] = obj;
            linksChanged();
        }
    }

    //! Unlink two ports
    function unlinkNodes(portA : string, portB : string) {

        //! clear deleted link selection
        selectionModel.clear();

        // delete related links
        Object.entries(links).forEach(([key, value]) => {
            if (value.inputPort._qsUuid === portA &&
                    value.outputPort._qsUuid === portB) {
                delete links[key];
            }
        });
        linksChanged();
    }

    //! Checks if two ports can be linked or not
    function canLinkNodes(portA : string, portB : string): bool {
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);

        // todo:
        // For very werid reasons this line of code is required to make this func works!
        // this might be a qt bug. I should test in different qt versions
        if (HashCompareString.compareStringModels(nodeA, nodeB) || nodeA.length === 0 || nodeB.length === 0)
            return false;

        return true;
    }

    function findNodeId(portId: string) : string {
        let foundNode = "";
        Object.values(nodes).find(node => {
            if (node.findPort(portId) !== null) {
                foundNode = node._qsUuid;
            }
        });
        return foundNode;
    }


    //! Find port object from port id
    function findPort(portId: string) : Port {
        var portObj = null;
        Object.values(nodes).find(node => {
            let foundPort = node.findPort(portId);
            if (foundPort !== null) {
                portObj = foundPort;
            }});
        return portObj;
    }
}
