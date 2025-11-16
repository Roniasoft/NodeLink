// import QtQuick

// import LogicCircuit
// import NodeLink

// /*! ***********************************************************************************************
//  * InputNode represents a boolean input with interactive ON/OFF switch
//  * ************************************************************************************************/
// Node {
//     id: root

//     type: LSpecs.NodeType.Input
//     nodeData: LogicNodeData {
//         currentState: false  // false = OFF, true = ON
//         output: false
//         displayValue: "OFF"
//     }

//     // guiConfig.autoSize: true
//     // guiConfig.width: 120
//     // guiConfig.height: 80

//     guiConfig.autoSize: false
//     guiConfig.width: 80
//     guiConfig.height: 50

//     guiConfig.color: "#2e7d32"  // Green color for inputs

//     Component.onCompleted: addPorts();

//     //! Create ports for input node
//     function addPorts() {
//         let outputPort = NLCore.createPort();
//         outputPort.portType = NLSpec.PortType.Output
//         outputPort.portSide = NLSpec.PortPositionSide.Right
//         outputPort.title = ""
//         addPort(outputPort);
//     }

//     //! Toggle between ON and OFF states
//     function toggleState() {
//         nodeData.currentState = !nodeData.currentState;
//         nodeData.output = nodeData.currentState;
//         nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

//         // Update the entire circuit
//         if (scene && scene.updateLogic) {
//             scene.updateLogic();
//         }
//     }
// }

import QtQuick
import NodeLink

import LogicCircuit

/*! ***********************************************************************************************
 * InputNode represents a boolean input with interactive ON/OFF switch
 * ************************************************************************************************/
LogicNode {

    /* Property Properties
     * ****************************************************************************************/

    nodeType: LSpecs.NodeType.Input

    nodeData: LogicNodeData {
        currentState: false  // false = OFF, true = ON
        output: false
        displayValue: "OFF"
    }

    /* Functions
     * ****************************************************************************************/

    //! Toggle between ON and OFF states
    // function toggleState() {
    //     nodeData.currentState = !nodeData.currentState;
    //     nodeData.output = nodeData.currentState;
    //     nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

    //     // Update the entire circuit
    //     /*if (scene && scene.updateLogic)*/ {
    //         logicScene.updateLogic();
    //     }
    // }

    function toggleState() {
        nodeData.currentState = !nodeData.currentState;
        nodeData.output = nodeData.currentState;
        nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

        // Try to find scene through repo
        var mainScene = _qsRepo ? _qsRepo.qsRootObject : null;
        if (mainScene && mainScene.updateLogic) {
            mainScene.updateLogic();
        }
    }
}

