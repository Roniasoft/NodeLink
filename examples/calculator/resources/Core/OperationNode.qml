// import QtQuick

// import NodeLink

// /*! ***********************************************************************************************
//  * OperationNode is a model that manage operation nodes in calculator.
//  * ************************************************************************************************/

// Node {

//     /* Property Declarations
//      * ****************************************************************************************/

//     property int operationType: CSpecs.OperationType.Additive

//     /* Object Properties
//     * ****************************************************************************************/

//     type: CSpecs.NodeType.Operation

//     nodeData: OperationNodeData {}


//     guiConfig.width: 100
//     guiConfig.height: 70

//     Component.onCompleted: addPorts();

//     /* Functions
//      * ****************************************************************************************/

//     //! Create ports for oeration nodes
//     function addPorts () {
//         let _port1 = NLCore.createPort();
//         let _port2 = NLCore.createPort();
//         let _port3 = NLCore.createPort();

//         _port1.portType = NLSpec.PortType.Input
//         _port1.portSide = NLSpec.PortPositionSide.Left
//         _port1.enable   = false;

//         _port2.portType = NLSpec.PortType.Input
//         _port2.portSide = NLSpec.PortPositionSide.Left
//         _port2.enable   = false;

//         _port3.portType = NLSpec.PortType.Output
//         _port3.portSide = NLSpec.PortPositionSide.Right

//         addPort(_port1);
//         addPort(_port2);
//         addPort(_port3);
//     }
// }


import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * OperationNode is a model that manage operation nodes in calculator.
 * ************************************************************************************************/

Node {
    /* Property Declarations
     * ****************************************************************************************/
    property int operationType: CSpecs.OperationType.Additive

    /* Object Properties
    * ****************************************************************************************/
    type: CSpecs.NodeType.Operation
    nodeData: OperationNodeData {}


    // Enable auto-sizing (enabled by default, but explicit is good)
    autoSize: true

    // You can still set minimum sizes if needed
    minWidth: 120
    minHeight: 80

    Component.onCompleted: addPorts();

    /* Functions
     * ****************************************************************************************/

    //! Create ports for operation nodes
    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        let _port4 = NLCore.createPort();
        let _port5 = NLCore.createPort();
        let _port6 = NLCore.createPort();
        let _port7 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "inputqweqweqweqweq2341";

        _port4.portType = NLSpec.PortType.Input
        _port4.portSide = NLSpec.PortPositionSide.Left
        _port4.enable   = false;
        _port4.title    = "inputqweqweqweqweq2341";

        _port5.portType = NLSpec.PortType.Input
        _port5.portSide = NLSpec.PortPositionSide.Left
        _port5.enable   = false;
        _port5.title    = "inputqweqweqweqweq2341";

        _port6.portType = NLSpec.PortType.Input
        _port6.portSide = NLSpec.PortPositionSide.Left
        _port6.enable   = false;
        _port6.title    = "inputqweqweqweqweq2341";

        _port7.portType = NLSpec.PortType.Input
        _port7.portSide = NLSpec.PortPositionSide.Left
        _port7.enable   = false;
        _port7.title    = "inputqweqweqweqweq2341";

        _port2.portType = NLSpec.PortType.Input
        _port2.portSide = NLSpec.PortPositionSide.Left
        _port2.enable   = false;
        _port2.title    = "input2";

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right
        _port3.title    = "result";

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
        addPort(_port4);
        addPort(_port5);
        addPort(_port6);
        addPort(_port7);
    }
}
