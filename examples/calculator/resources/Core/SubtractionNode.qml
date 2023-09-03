import QtQuick

import Calculator

/*! ***********************************************************************************************
 * The SubtractionNode is responsible to subtract two sets of data.
 * ************************************************************************************************/

OperationNode {
    /* Property Properties
     * ****************************************************************************************/

    operationType: CSpecs.OperationType.Subtraction

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
        nodeData.data = input1 - input2;
    }
}
