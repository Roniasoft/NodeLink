import QtQuick 2.15


/*! ***********************************************************************************************
 * The MslCore is responsible for managing nodes and connections between them.
 *
 * ************************************************************************************************/
QtObject {
    property var nodes: []


    property Node _node1: Node {
        x: 100
        y: 20
        color: "#3b8a89"
    }
    property Node _node2: Node {
        x: 0
        y: 200
        color: "#3a9d57"
    }
    property Node _node3: Node {
        x: 150
        y: 25
        color: "#6e57b8"
    }
    property Node _node4: Node {
        x: 350
        y: 200
        color: "#fb464c"
    }

    Component.onCompleted: {
        nodes = nodes.concat(_node1, _node2, _node3, _node4);
    }

    // functions
}
