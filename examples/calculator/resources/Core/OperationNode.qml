import QtQuick

import NodeLink

Node {

    /* Property Declarations
     * ****************************************************************************************/

    property int operationType: CSpecs.OperationType.Additive

    type: CSpecs.NodeType.Operation

    nodeData: OperationNodeData {}

    Component.onCompleted: addPorts();

    property Connections connections: Connections {
        target: nodeData

        function onInputFirstChanged() {

        }

        function onInputSecondChanged() {

        }
    }

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
        switch (operationType) {
        case CSpecs.OperationType.Additive: {
            nodeData.data = nodeData.inputFirst + nodeData.inputSecond;
        } break;

        case CSpecs.OperationType.Multiplier: {
            nodeData.data = nodeData.inputFirst - nodeData.inputSecond;
        } break;

        case CSpecs.OperationType.Subtraction: {
            nodeData.data = nodeData.inputFirst * nodeData.inputSecond;
        } break;

        case CSpecs.OperationType.Division: {
            if(nodeData.inputSecond === 0) {
                nodeData.data = null;

                return;
            }
            nodeData.data = nodeData.inputFirst + nodeData.inputSecond;
        } break;
        }
    }

}
