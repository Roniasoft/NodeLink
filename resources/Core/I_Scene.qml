import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and connections between them.
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
    //! Array <Connection>
    property var connections: []

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

    //! Deletes a node from the scene
    function deleteNode(nodeUUId: string) {
        //! delete the node ports from the portsPosition map
        Object.keys(nodes[nodeUUId].ports).forEach(portId => {
            delete portsPositions[portId];

            connections = connections.filter(linkObj => (linkObj.inputPort._qsUuid !== portId &&
                                                         linkObj.outputPort._qsUuid !== portId));

        });

        delete nodes[nodeUUId];

        portsPositionsChanged();
        connectionsChanged();
        nodesChanged();

        console.log()
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

        let foundedConnection = connections.find(conObj =>
                                                 conObj.inputPort._qsUuid === portA &&
                                                 conObj.outputPort._qsUuid === portB);

        if (foundedConnection === undefined) {
            let obj = NLCore.createConnection();

            obj.inputPort = findPort(portA);
            obj.outputPort   = findPort(portB);
            connections.push(obj);
        }
        connectionsChanged();
    }

    //! Unlink two ports
    function unlinkNodes(portA : string, portB : string) {
        connections = connections.filter(linkObj => (linkObj.inputPort._qsUuid !== portA &&
                                                     linkObj.outputPort._qsUuid !== portB));
        connectionsChanged();
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
