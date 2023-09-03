import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The NotionNode is the interface/base Node class for all extra nodes.
 * ************************************************************************************************/

Node {
    id: root

    //! Node Status
    enum NodeStatus {
        Active   = 0,
        Selected = 1,
        Inactive = 2,

        Unknown  = 99
    }

    /* Property Properties
     * ****************************************************************************************/

    //! Entry Condition
    property I_EntryCondition   entryCondition: I_EntryCondition {}

    //! Node status
    property int status: NotionNode.NodeStatus.Inactive

    //! Unmet conditions and the nodes they're related to
    property var _unMetConditions: []

    /* Functions
     * ****************************************************************************************/

    Component.onCompleted: addPorts();

    //! Temp function to add port by code.
    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();
        let _port4 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Top

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Bottom

        _port3.portType = NLSpec.PortType.Input
        _port3.portSide = NLSpec.PortPositionSide.Left

        _port4.portType = NLSpec.PortType.Output
        _port4.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
        addPort(_port4);
    }

    function canEnter() : bool {
        return entryCondition.evaluate(null);
    }

    //! Update Node status
    function updateNodeStatus(status: int) {
        root.status = status;
    }

    //! Check the node status
    function checkNodeStatus(status: int) : bool {
            return root.status === status;
    }

}
