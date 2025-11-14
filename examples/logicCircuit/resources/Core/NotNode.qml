import QtQuick
import NodeLink

import LogicCircuit
/*! ***********************************************************************************************
 * NOTNode performs logical NOT operation
 * ************************************************************************************************/
Node {
    id: root

    type: LSpecs.NodeType.NOT
    nodeData: LogicNodeData {}

    guiConfig.autoSize: true
    guiConfig.minWidth: 70
    guiConfig.minHeight: 60
    guiConfig.color: "#d32f2f"  // Red color for NOT gates

    Component.onCompleted: addPorts();

    //! Create ports for NOT node
    function addPorts() {
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input
        inputPort.portSide = NLSpec.PortPositionSide.Left
        inputPort.title = "A"
        addPort(inputPort);

        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output
        outputPort.portSide = NLSpec.PortPositionSide.Right
        outputPort.title = "¬A"
        addPort(outputPort);
    }

    //! Update node data with NOT operation
    function updateData() {
        if (nodeData.inputA === null) {
            nodeData.output = null;
            return;
        }

        nodeData.output = !nodeData.inputA;
        nodeData.displayValue = nodeData.output ? "ON" : "OFF";
    }
}

