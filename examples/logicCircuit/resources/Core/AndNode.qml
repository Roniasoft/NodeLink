import QtQuick

import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * AndNode performs logical AND operation
 * ************************************************************************************************/
LogicNode {
    nodeType: LSpecs.NodeType.AND

    /* Functions
     * ****************************************************************************************/

    function updateData() {
        // AND gate: output is true ONLY if both inputs are true
        if (nodeData.inputA !== null && nodeData.inputB !== null) {
            nodeData.output = nodeData.inputA && nodeData.inputB;
        } else {
            nodeData.output = null; // Output undefined if inputs incomplete
        }
    }
}
