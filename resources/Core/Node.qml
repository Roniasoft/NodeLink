import QtQuick 2.15

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
QtObject {
    id: root
    /* Property Declarations
     * ****************************************************************************************/
    property string name:   "<unknown>"

    property string title: "<Unknown>"

    property int x:         0

    property int y:         0

    property int width:     200

    property int height:    120

    property string color: "pink"

    property int type:      NLSpec.NodeType.General

    //! Port list
    property var ports:     [_port1, _port2, _port3, _port4, _port5]

    property QtObject privateProperty: QtObject {
        // isLoadingPorts block the onPortsChanged during position calculation process.
        property bool isLoadingPorts: false
    }



    property Port _port1: Port {
        portID: "port1"
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Top
    }

    property Port _port2: Port {
        portID: "port2"
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Bottom
    }

    property Port _port3: Port {
        portID: "port3"
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Left
    }

    property Port _port4: Port {
        portID: "port4"
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Right
    }

    property Port _port5: Port {
        portID: "port5"
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Right
    }

    /* Functions
     * ****************************************************************************************/
    function createPort() {

    }

    function deletePort(port: Port) {

    }
}
