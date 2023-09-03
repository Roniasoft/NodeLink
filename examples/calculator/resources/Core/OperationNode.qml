import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * OperationNode is a model that manage operation nodes in calculator.
 * ************************************************************************************************/

Node {

    /* Property Declarations
     * ****************************************************************************************/

    property int operationType: CSpecs.OperationType.Additive

    /* Object Properties
    * ****************************************************************************************/

    type: CSpecs.NodeType.Operation

    nodeData: OperationNodeData {}


    guiConfig.width: 100
    guiConfig.height: 70

    Component.onCompleted: addPorts();

    /* Functions
     * ****************************************************************************************/

    //! Create ports for oeration nodes
    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;

        _port2.portType = NLSpec.PortType.Input
        _port2.portSide = NLSpec.PortPositionSide.Left
        _port2.enable   = false;

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }
}
