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
    autoSize: false

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

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "inpuasdasdadasdasdasdt 1";

        _port2.portType = NLSpec.PortType.Input
        _port2.portSide = NLSpec.PortPositionSide.Left
        _port2.enable   = false;
        _port2.title    = "input 2";

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right
        _port3.title    = "result";

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }
}
