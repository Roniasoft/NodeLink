import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and connections between them.
 *
 * ************************************************************************************************/
I_Scene {
    id: scene

    /* Property Properties
     * ****************************************************************************************/
    //! Scene Title
    property string         title:          "<Untitled>"

    //! Nodes
    //! map<UUID, Node>
    property var            nodes:          ({})

    //! Container of Node line links A -> { B, C }
    //! map<Current Node port uuid: string, Dest port uuid: string>
    property var            portsUpstream:  ({})

    //! Container of Node line links Z -> { X, Y }
    //! map<Current Node port id, Dest port id>
    property var            portsDownstream:({})

    //! Port positions (global)
    //! map<port uuid: string, global pos: vector2d>
    property var            portsPositions: ({})

    //! Scene Selection Model
    property SelectionModel selectionModel: SelectionModel {}

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    Component.onCompleted: {
        // adding example nodes
        for (var i = 0; i < 5; i++) {
            var node = NLCore.createNode();
            node.guiConfig.position.x = Math.random() * 1000;
            node.guiConfig.position.y = Math.random() * 1000;
            node.guiConfig.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            addNode(node);
            node.addPortByHardCode();
        }
        _tier.start();
    }

    property Timer _tier: Timer {
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            // example link
//            linkNodes(Object.keys(nodes[0].ports)[0], Object.keys(nodes[1].ports)[2]);
            linkNodes(Object.keys(nodes[1].ports)[1], Object.keys(nodes[2].ports)[3]);
            linkNodes(Object.keys(nodes[1].ports)[1], Object.keys(nodes[3].ports)[3]);
            linkNodes(Object.keys(nodes[2].ports)[0], Object.keys(nodes[0].ports)[2]);
        }
    }

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
        //! delete the node ports fromt the portsPosition map
        Object.keys(nodes[nodeUUId].ports).forEach(portId => {
            delete portsPositions[portId];
        });

        Object.keys(portsUpstream).forEach(portId => {
            delete portsUpstream[portId];
        });

        Object.values(portsUpstream).forEach(portId => {
            delete portsUpstream[portId];
        });

        Object.keys(portsDownstream).forEach(portId => {
            delete portsDownstream[portId];
        });
        Object.values(portsDownstream).forEach(portId => {
            delete portsDownstream[portId];
        });

        portsPositionsChanged();
        portsUpstreamChanged();
        portsDownstreamChanged();

        delete nodes[nodeUUId];
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
        selectionModel.select(node);
    }

    //! On port added
    function onPortAdded(portUUId : string) {

        // Create upstream links
        portsUpstream[portUUId] = [];
        portsUpstreamChanged();

        // Create downstream links
        portsDownstream[portUUId] = [];
        portsDownstreamChanged();

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
        // Only add if not already there
        if (!portsDownstream[portA]?.includes(portB)) {
            portsDownstream[portA].push(portB);
            portsDownstreamChanged();
        }

        // Only add if not already there
        if (!portsUpstream[portB]?.includes(portA)) {
            portsUpstream[portB].push(portA);
            portsUpstreamChanged();
        }
    }

    //! Unlink two ports
    function unlinkNodes(portA : int, portB : int) {
        // Only Remove if not already there
        if (!portsDownstream[portA]?.includes(portB)) {
            portsDownstream[portA].remove(portB);
            portsDownstreamChanged();
        }
    }

    //! Checks if two ports can be linked or not
    function canLinkNodes(portA : int, portB : int): bool {
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);

        // todo:
        // For very werid reasons this line of code is required to make this func works!
        // this might be a qt bug. I should test in different qt versions
        console.log()

        if (nodeA === nodeB || nodeA === -1 || nodeB === -1)
            return false;

        return true;
    }

    function findNodeId(portId: string): int {
        let foundNode = -1;
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
