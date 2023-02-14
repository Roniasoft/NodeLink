import QtQuick 2.15


/*! ***********************************************************************************************
 * The SceneManager is responsible for managing nodes, ports and connections between them.
 *
 * ************************************************************************************************/
QtObject {
    property var nodes: []

    property Port _port1: Port {
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Top
    }

    property Port _port2: Port {
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Botton
    }

    property Port _port3: Port {
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Left
    }

    property Port _port4: Port {
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Right
    }

    property Node _node1: Node {
        x: 0
        y: 0
        color: "#3b8a89"

        ports: [_port1, _port2, _port3, _port4]
    }
    property Node _node2: Node {
        x: 0
        y: 200
        color: "#3a9d57"
        ports: [_port1, _port2, _port3, _port4]
    }
    property Node _node3: Node {
        x: 150
        y: 25
        color: "#6e57b8"
        ports: [_port1, _port2, _port3, _port4]
    }
    property Node _node4: Node {
        x: 350
        y: 200
        color: "#fb464c"
        ports: [_port1, _port2, _port3, _port4]
    }

    Component.onCompleted: {
        nodes = nodes.concat(_node1, _node2, _node3, _node4);
    }

    // functions
}
