import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * InputNode represents a boolean input with interactive ON/OFF switch
 * ************************************************************************************************/
Node {
    id: root

    type: LSpecs.NodeType.Input
    nodeData: LogicNodeData {
        currentState: false  // false = OFF, true = ON
        output: false
        displayValue: "OFF"
    }

    guiConfig.autoSize: true
    guiConfig.width: 120
    guiConfig.height: 80
    guiConfig.color: "#2e7d32"  // Green color for inputs

    Component.onCompleted: addPorts();

    //! Create ports for input node
    function addPorts() {
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output
        outputPort.portSide = NLSpec.PortPositionSide.Right
        outputPort.title = "output__"
        addPort(outputPort);
    }

    //! Toggle between ON and OFF states
    function toggleState() {
        nodeData.currentState = !nodeData.currentState;
        nodeData.output = nodeData.currentState;
        nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

        // Update the entire circuit
        if (scene && scene.updateLogic) {
            scene.updateLogic();
        }
    }
}
