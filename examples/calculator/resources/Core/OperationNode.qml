import QtQuick

import NodeLink

Node {

    property int operationType: CSpecs.OperationType.Additive

    type: CSpecs.NodeType.Operation

    nodeData: I_NodeData {}

    Component.onCompleted: addPorts();

    //! Create ports for oeration nodes
    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left

        _port2.portType = NLSpec.PortType.Input
        _port2.portSide = NLSpec.PortPositionSide.Left

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }



}
