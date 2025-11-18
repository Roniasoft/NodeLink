import QtQuick
import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * NOTNode performs logical NOT operation
 * ************************************************************************************************/
LogicNode {
    nodeType: LSpecs.NodeType.NOT

    /* Functions
     * ****************************************************************************************/

    function updateData() {
        // NOT gate: output is the inverse of the single input
        if (nodeData.inputA !== null) {
            nodeData.output = !nodeData.inputA;
        } else {
            nodeData.output = null; // Output undefined if no input
        }
    }
}
