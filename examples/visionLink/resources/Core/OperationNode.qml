import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * OperationNode is a base model that manages operation nodes in VisionLink.
 * ************************************************************************************************/
Node {

    /* Property Declarations
     * ****************************************************************************************/
    property int operationType: CSpecs.OperationType.Blur

    /* Object Properties
    * ****************************************************************************************/
    type: CSpecs.NodeType.Operation
    nodeData: OperationNodeData {}

    guiConfig.width: 250
    guiConfig.height: 70

    /* Children
    * ****************************************************************************************/
    Component.onCompleted: addPorts();

    /* Functions
     * ****************************************************************************************/
    //! Create ports for operation nodes
    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
    }
}

