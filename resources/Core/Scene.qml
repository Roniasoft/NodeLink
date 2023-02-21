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

    property var nodes:             ({})

    //! Container of Node line links A -> { B, C }
    //! map<Current Node port id, Dest port id>
    property var portsUpstream:     ({})

    //! Container of Node line links Z -> { X, Y }
    //! map<Current Node port id, Dest port id>
    property var portsDownstream:   ({})

    //! Port positions (global)
    //! map<port id: int, global pos: point>
    property var portsPositions:    ({})

    //! Example Nodes
//    property Node _node1: Node {
//        guiConfig.position: Qt.point(0, 0)
//        guiConfig.color: "#8667e5"
//    }
//    property Node _node2: Node {
//        guiConfig.position: Qt.point(0, 200)
//        guiConfig.color: "#53dfdd"
//    }
//    property Node _node3: Node {
//        guiConfig.position: Qt.point(150, 25)
//        guiConfig.color: "#44cf6e"
//    }
//    property Node _node4: Node {
//        guiConfig.position: Qt.point(350, 200)
//        guiConfig.color: "#e9973f"
//    }

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
    property int count : 0
    //! Adds a node the to nodes map
    function addNode(node: Node) {
//        node.id = Object.keys(nodes).length;  // move this to fun createNode
        node.id = count + 2;
        count = count + 2;
        // Sanity check
//        if (nodes[node.id] === node) { return; }

        // Add to local administration
        nodes[node.id] = node;
        nodesChanged();

        var keys = Object.keys(nodes);
        for (var i = 0; i < keys.length; i++) {
            console.log(" index is: "+ i +" id is: "+ keys[i] +" node is: "+nodes[keys[i]]);
        }

        node.onPortAdded.connect(onPortAdded);

    }
    function deleteNode(x) {

        console.log(Object.keys(nodes).length)
        var keys = Object.keys(nodes);
        for(var i=0; i<keys.length; i++){
//            console.log("X is: "+x+" id is: "+keys[i]);
//            console.log("type of x "+ typeof x+" type of keys[i] "+ typeof +keys[i])
            if(+keys[i] === x){
                delete nodes[keys[i]];
                nodesChanged();
            }
        }
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
