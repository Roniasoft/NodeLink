import QtQuick
import NodeLink

import LogicCircuit

/*! ***********************************************************************************************
 * ORNode performs logical OR operation
 * ************************************************************************************************/
Node {
    id: root

    type: LSpecs.NodeType.OR
    nodeData: LogicNodeData {}

    guiConfig.autoSize: true
    guiConfig.minWidth: 80
    guiConfig.minHeight: 60
    guiConfig.color: "#7b1fa2"  // Purple color for OR gates

    Component.onCompleted: addPorts();

    //! Create ports for OR node
    function addPorts() {
        let inputPort1 = NLCore.createPort();
        inputPort1.portType = NLSpec.PortType.Input
        inputPort1.portSide = NLSpec.PortPositionSide.Left
        inputPort1.title = "A"
        addPort(inputPort1);

        let inputPort2 = NLCore.createPort();
        inputPort2.portType = NLSpec.PortType.Input
        inputPort2.portSide = NLSpec.PortPositionSide.Left
        inputPort2.title = "B"
        addPort(inputPort2);

        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output
        outputPort.portSide = NLSpec.PortPositionSide.Right
        outputPort.title = "A ∨ B"
        addPort(outputPort);
    }

    //! Update node data with OR operation
    function updateData() {
        if (nodeData.inputA === null || nodeData.inputB === null) {
            nodeData.output = null;
            return;
        }

        nodeData.output = nodeData.inputA || nodeData.inputB;
        nodeData.displayValue = nodeData.output ? "ON" : "OFF";
    }
}
