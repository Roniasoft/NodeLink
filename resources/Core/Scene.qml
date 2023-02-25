import QtQuick 2.15

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and connections between them.
 *
 * ************************************************************************************************/
QtObject {
    id: scene

    /* Property Properties
     * ****************************************************************************************/

    //! Scene Title
    property string title:              "<Untitled>"

    //! Nodes
    //! map<id, Node>
    property var    nodes:             ({})

    //! Container of Node line links A -> { B, C }
    //! map<Current Node port id, Dest port id>
    property var    portsUpstream:     ({})

    //! Container of Node line links Z -> { X, Y }
    //! map<Current Node port id, Dest port id>
    property var    portsDownstream:   ({})

    //! Port positions (global)
    //! map<port id: int, global pos: point>
    property var    portsPositions:    ({})

    //! Scene Selection Model
    property SelectionModel selectionModel: SelectionModel {}


    Component.onCompleted: {
        // adding example nodes
        for (var i = 0; i < 5; i++) {
            var node = NLCore.createNode();
            node.guiConfig.position.x = Math.random() * 1000;
            node.guiConfig.position.y = Math.random() * 1000;
            node.guiConfig.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            addNode(node);
        }
    }

    property Timer _tier: Timer {
        interval: 300
        repeat: false
        running: true
        onTriggered: {
            // example link
//            linkNodes(Object.keys(_node1.ports)[0], Object.keys(_node2.ports)[2]);
//            linkNodes(Object.keys(_node1.ports)[1], Object.keys(_node3.ports)[3]);
//            linkNodes(Object.keys(_node1.ports)[2], Object.keys(_node4.ports)[3]);
        }
    }

    /* Functions
     * ****************************************************************************************/
    //! Adds a node the to nodes map
    function addNode(node: Node) {
        node.id = Object.keys(nodes).length;  // move this to fun createNode
        //Sanity check
        if (nodes[node.id] === node) { return; }

        // Add to local administration
        nodes[node.id] = node;
        nodesChanged();

        node.onPortAdded.connect(onPortAdded);
    }

    //! Deletes a node from the scene
    function deleteNode(nodeId: int) {

        //! delete the node ports fromt the portsPosition map
        Object.keys(nodes[nodeId].ports).forEach(portId => {
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

        delete nodes[nodeId];
        nodesChanged();
    }

    //! duplicator (third button)
    function cloneNode(nodeId: int) {
        var node = NLCore.createNode();
        node.guiConfig.position.x = nodes[nodeId].guiConfig.position.x+50
        node.guiConfig.position.y = nodes[nodeId].guiConfig.position.y+50
        node.guiConfig.color = nodes[nodeId].guiConfig.color
        node.guiConfig.height = nodes[nodeId].guiConfig.height
        node.guiConfig.width = nodes[nodeId].guiConfig.width
        node.title = nodes[nodeId].title
        addNode(node);
    }

    //! On port added
    function onPortAdded(portId) {

        // Create upstream links
        portsUpstream[portId] = [];
        portsUpstreamChanged();

        // Create downstream links
        portsDownstream[portId] = [];
        portsDownstreamChanged();

        // Add an empty position index
        portsPositions[portId] = Qt.point(0,0);
        portsPositionsChanged();
    }

    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function linkNodes(portA : int, portB : int) {
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

    function unlinkNodes(portA : Port, portB : Port) {
    }

    function canLinkNodes(portA : int, portB : int): bool {
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);

        if (nodeA === nodeB || nodeA === -1 || nodeB === -1)
            return false;

        return true;
    }

    function findNodeId(portId: int): int {
        let foundNode = -1;
        Object.values(nodes).find(node => {
            if (node.findPort(portId) !== null) {
                foundNode = node.id;
            }
        });
        return foundNode;
    }



}
