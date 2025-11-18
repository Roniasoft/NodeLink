// import QtQuick
// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * InputNode represents a boolean input with interactive ON/OFF switch
//  * ************************************************************************************************/
// LogicNode {
//     nodeType: LSpecs.NodeType.Input

//     // Initialize node data
//     Component.onCompleted: {
//         nodeData.currentState = false;
//         nodeData.output = false;
//         nodeData.displayValue = "OFF";
//     }

//     /* Functions
//      * ****************************************************************************************/

//     //! Toggle between ON and OFF states
//     function toggleState() {
//         nodeData.currentState = !nodeData.currentState;
//         nodeData.output = nodeData.currentState;
//         nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

//         // Update the entire circuit
//         // Try to find scene through repo
//         var mainScene = _qsRepo ? _qsRepo.qsRootObject : null;
//         if (mainScene && mainScene.updateLogic) {
//             mainScene.updateLogic();
//         }
//         // triggerCircuitUpdate();
//     }
// }


import QtQuick
import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * InputNode represents a boolean input with interactive ON/OFF switch
 * ************************************************************************************************/
LogicNode {
    nodeType: LSpecs.NodeType.Input

    // Initialize node data
    Component.onCompleted: {
        nodeData.currentState = false;
        nodeData.output = false;
        nodeData.displayValue = "OFF";
    }

    /* Functions
     * ****************************************************************************************/

    //! Toggle between ON and OFF states
    function toggleState() {
        nodeData.currentState = !nodeData.currentState;
        nodeData.output = nodeData.currentState;
        nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

        // Update the entire circuit - use the working method
        var mainScene = _qsRepo ? _qsRepo.qsRootObject : null;
        if (mainScene && mainScene.updateLogic) {
            mainScene.updateLogic();
        }
    }
}
