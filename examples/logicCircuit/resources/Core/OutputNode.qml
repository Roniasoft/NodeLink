import QtQuick
import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * OutputNode displays the final result of the logic circuit
 * ************************************************************************************************/
LogicNode {
    nodeType: LSpecs.NodeType.Output

    // Fixed colors for consistent appearance
    property color undefinedColor: "#9E9E9E"  // Gray for undefined
    property color offColor: "#F44336"        // Red for OFF
    property color onColor: "#4CAF50"         // Green for ON

    // Override the guiConfig color to be fixed
    Component.onCompleted: {
        // Set a fixed color that won't change with state
        guiConfig.color = "#2A2A2A"; // Dark gray background
        updateDisplay(nodeData.inputA);
    }

    /* Functions
     * ****************************************************************************************/

    function updateDisplay(value) {
        if (value === null) {
            nodeData.displayValue = "UNDEFINED";
            // Don't change the node color, just the display value
        } else {
            nodeData.displayValue = value ? "ON" : "OFF";
        }

        // Emit a signal or set a property that the view can use for inner color
        nodeData.statusColor = getStatusColor(value);
    }

    function getStatusColor(value) {
        if (value === null) return undefinedColor;
        return value ? onColor : offColor;
    }

    function updateData() {
        // Output node just displays the input value
        updateDisplay(nodeData.inputA);
    }
}
