import QtQuick

import NodeLink

Node {

    /* Property Declarations
     * ****************************************************************************************/

    property int operationType: CSpecs.OperationType.Additive

    type: CSpecs.NodeType.Operation

    nodeData: OperationNodeData {}

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

        _port2.portType = NLSpec.PortType.Input
        _port2.portSide = NLSpec.PortPositionSide.Left

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }


    function updataData() {
        console.log("operationType = ",operationType, nodeData.inputSecond, nodeData.inputFirst)
        if (!nodeData.inputFirst || !nodeData.inputSecond) {
            nodeData.data = null;
            return;
        }

        var input1 = parseFloat(nodeData.inputFirst);
        var input2 = parseFloat(nodeData.inputSecond)

        switch (operationType) {
        case CSpecs.OperationType.Additive: {
            nodeData.data = input1 + input2;
        } break;

        case CSpecs.OperationType.Multiplier: {
            nodeData.data = input1 * input2;
        } break;

        case CSpecs.OperationType.Subtraction: {
            nodeData.data = input1 - input2;
        } break;

        case CSpecs.OperationType.Division: {
            if(input2 === 0) {
                nodeData.data = null;

                return;
            }
            nodeData.data = input1 / input2;
        } break;
        }
    }

}
