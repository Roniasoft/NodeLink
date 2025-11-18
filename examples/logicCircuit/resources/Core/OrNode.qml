import QtQuick
import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * ORNode performs logical OR operation
 * ************************************************************************************************/
LogicNode {
    nodeType: LSpecs.NodeType.OR

    /* Functions
     * ****************************************************************************************/

    function updateData() {
        // OR gate: output is true if at least one input is true
        if (nodeData.inputA !== null && nodeData.inputB !== null) {
            nodeData.output = nodeData.inputA || nodeData.inputB;
        } else {
            nodeData.output = null; // Output undefined if inputs incomplete
        }
    }
}
