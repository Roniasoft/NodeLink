import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * OutputNode displays the final boolean result as a fixed switch
 * ************************************************************************************************/
Node {
    id: root

    type: LSpecs.NodeType.Output
    nodeData: LogicNodeData {
        displayValue: "OFF"  // Start with OFF
    }

    // guiConfig.autoSize: true
    // guiConfig.width: 120
    // guiConfig.height: 80
    guiConfig.autoSize: false
    guiConfig.width: 50
    guiConfig.height: 50
    guiConfig.color: "#f57c00"  // Orange color for outputs

    Component.onCompleted: addPorts();

    //! Create ports for output node
    function addPorts() {
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input
        inputPort.portSide = NLSpec.PortPositionSide.Left
        inputPort.title = ""
        addPort(inputPort);
    }

    //! Update display value
    function updateDisplay(value) {
        if (value === null || value === undefined) {
            nodeData.displayValue = "UNDEFINED";
        } else {
            nodeData.displayValue = value ? "ON" : "OFF";
        }
    }
}
