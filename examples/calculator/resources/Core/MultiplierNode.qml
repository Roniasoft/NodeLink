import QtQuick

import Calculator

/*! ***********************************************************************************************
 * The MultiplierNode is responsible to add two sets of data.
 * ************************************************************************************************/

OperationNode {
    /* Property Properties
     * ****************************************************************************************/

    operationType: CSpecs.OperationType.Multiplier

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
        nodeData.data = input1 * input2;
    }
}
