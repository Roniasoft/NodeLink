import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * ResultNode in calculator example.
 * ************************************************************************************************/

Node {

    type: CSpecs.NodeType.Result
    nodeData: I_NodeData {}

    Component.onCompleted: addPorts();

    //! Create ports for oeration nodes
    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left

        addPort(_port1);
    }
}
