import QtQuick 2.15

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
QtObject {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    // Unique ID
    property int            id:         0

    //! Title
    property string     title:      "<Unknown>"

    //! GUI Config
    property NodeGuiConfig  guiConfig:  NodeGuiConfig {}

    //! Node Type
    property int            type:       NLSpec.NodeType.General

    //! Port list
    //! map<id, Port>
    property var            ports:      ({})

    Component.onCompleted: {
        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
        addPort(_port4);
        addPort(_port5);
    }



    property Port _port1: Port {
        node: root
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Top
    }

    property Port _port2: Port {
        node: root
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Bottom
    }

    property Port _port3: Port {
        node: root
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Left
    }

    property Port _port4: Port {
        node: root
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Right
    }

    property Port _port5: Port {
        node: root
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Right
    }

    /* Functions
     * ****************************************************************************************/
    function createPort() {

    }


    //! Adds a node the to nodes map
    function addPort(port) {
        port.id = Object.keys(ports).length;    // todo: this should be fixed


        // Add to local administration
        ports[port.id] = port;
        portsChanged();
    }

    function deletePort(port) {

    }

    function findPort(portId: int):int {
        if (Object.keys(ports).includes(portId))
            return ports[portId];

        return null;
    }
}
