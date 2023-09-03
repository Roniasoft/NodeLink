import QtQuick

import Calculator

/*! ***********************************************************************************************
 * The DivisionNode is tasked with performing the division of two sets of data.
 * ************************************************************************************************/

OperationNode {

    /* Property Properties
     * ****************************************************************************************/

    operationType: CSpecs.OperationType.Division

    /* Functions
     * ****************************************************************************************/

    //! Update nodedata with the ADD process
    function updataData() {
        if (!nodeData.inputFirst || !nodeData.inputSecond) {
            nodeData.data = null;
            return;
        }

        var input1 = parseFloat(nodeData.inputFirst);
        var input2 = parseFloat(nodeData.inputSecond)
        if (input2 !== 0)
            nodeData.data = input1 / input2;
        else
            nodeData.data = "undefined (Divide by zero)"
    }
}
