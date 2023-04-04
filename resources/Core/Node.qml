import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
I_Node  {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    //! Title
    property string         title:      "<Unknown>"

    //! GUI Config
    property NodeGuiConfig  guiConfig:  NodeGuiConfig {
         _qsRepo: root._qsRepo
    }

    //! Node Type
    property int            type:       NLSpec.NodeType.General

    //! Port list
    //! map<uuid, Port>
    property var            ports:      ({})


    /* Signals
     * ****************************************************************************************/
    signal portAdded(var portId);

    /* Functions
     * ****************************************************************************************/
    //! Temp function to add port by code.
    function addPortByHardCode () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();
        let _port4 = NLCore.createPort();
        let _port5 = NLCore.createPort();
        let _port6 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Top

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Bottom

        _port3.portType = NLSpec.PortType.Input
        _port3.portSide = NLSpec.PortPositionSide.Left

        _port4.portType = NLSpec.PortType.Output
        _port4.portSide = NLSpec.PortPositionSide.Right

        _port5.portType = NLSpec.PortType.Output
        _port5.portSide = NLSpec.PortPositionSide.Right

        _port6.portType = NLSpec.PortType.Output
        _port6.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
        addPort(_port4);
        addPort(_port5);
        addPort(_port6);
    }

    //! Adds a node the to nodes map
    function addPort(port : Port) {
        // Add to local administration
        ports[port._qsUuid] = port;
        portsChanged();

        portAdded(port._qsUuid);
    }

    function deletePort(port) {
    }


    //! find port with portUuid
    function findPort(portId: string): Port {
        if (Object.keys(ports).includes(portId)) {
            return ports[portId];
        }
            return null;
    }

    //! find port with specified port side.
    function findPortByPortSide(portSide : int) : Port {
                let foundedPort = null;
                Object.values(ports).find(port => {
                    if (port.portSide === portSide) {
                        foundedPort = port;
                    }
                });

                return foundedPort;
    }
}
