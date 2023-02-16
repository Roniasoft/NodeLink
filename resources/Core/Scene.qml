import QtQuick 2.15

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and connections between them.
 *
 * ************************************************************************************************/
QtObject {
    id: scene

    /* Property Properties
     * ****************************************************************************************/

    //! Nodes
    //! map<id, Node>
    property var nodes: ({})

    //! Container of Node line links A -> { B, C }
    //! map<Current Node port id, Dest port id>
    property var            nodesUpstream: ({})

    //! Container of Node line links Z -> { X, Y }
    //! map<Current Node port id, Dest port id>
    property var            nodesDownstream: ({})

    //! Example Nodes
    property Node _node1: Node {
        guiConfig.position: Qt.vector2d(0, 0)
        guiConfig.color: "#8667e5"
    }
    property Node _node2: Node {
        guiConfig.position: Qt.vector2d(0, 200)
        guiConfig.color: "#53dfdd"
    }
    property Node _node3: Node {
        guiConfig.position: Qt.vector2d(150, 25)
        guiConfig.color: "#44cf6e"
    }
    property Node _node4: Node {
        guiConfig.position: Qt.vector2d(350, 200)
        guiConfig.color: "#e9973f"
    }

    //! Scene Selection Model
    property SelectionModel selectionModel: SelectionModel {}


    Component.onCompleted: {
        // adding example nodes
        addNode(_node1);
        addNode(_node2);
        addNode(_node3);
        addNode(_node4);

        // example link
//        linkNodes(_node1._port1, _node2._port3);
    }

    /* Functions
     * ****************************************************************************************/

    //! Adds a node the to nodes map
    function addNode(node: Node) {
        node.id = Object.keys(nodes).length;  // move this to fun createNode

        // Sanity check
        if (nodes[node.id] === node) { return; }

        // Add to local administration
        nodes[node.id] = node;
        nodesChanged();

        // Create upstream links
        nodesUpstream[node.id] = [];
        nodesUpstreamChanged();

        // Create downstream links
        nodesDownstream[node.id] = [];
        nodesDownstreamChanged();
    }

    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function linkNodes(portA : Port, portB : Port) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Node " + machineA.guiConfig.name +
                          " to " + machineB.guiConfig.name + " -- violates line rules!")
            return;
        }

        // Only add if not already there
        if (!nodesDownstream[portA.id].includes(portB.id)) {
            nodesDownstream[portA.id].push(portB.id);
            nodesDownstreamChanged();
        }

        // Only add if not already there
        if (!nodesUpstream[portB.id].includes(portA.id)) {
            nodesUpstream[portB.id].push(portA.id);
            nodesUpstreamChanged();
        }
    }

    function unlinkNodes(portA : Port, portB : Port) {
    }

    function canLinkNodes(portA : Port, portB : Port): bool {
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);

        if (nodeA === nodeB || nodeA === -1 || nodeB === -1)
            return false;

        return true;
    }

    function findNodeId(portId: int): int {
        Object.values(nodes).find(node => {
            if (node.findPort(portId) !== null)
                return node.id;
        });
        return -1;
    }
}
