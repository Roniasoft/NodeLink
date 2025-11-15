import QtQuick

import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * LogicNode is a model that manage Logic nodes in LogicCircuit.
 * ************************************************************************************************/

Node {
    /* Property Declarations
     * ****************************************************************************************/
    property int nodeType: LSpecs.NodeType.AND

    /* Object Properties
    * ****************************************************************************************/
    type: LSpecs.NodeType.Logic
    nodeData: LogicNodeData {}

    // Enable auto-sizing (enabled by default, but explicit is good)
    guiConfig.autoSize: false

    // You can still set minimum sizes if needed
    guiConfig.width: 100
    guiConfig.height: 80

    Component.onCompleted: addPorts();

    /* Functions
     * ****************************************************************************************/

    //! Create ports for operation nodes
    function addPorts() {
        let inputPort1 = NLCore.createPort();
        inputPort1.portType = NLSpec.PortType.Input
        inputPort1.portSide = NLSpec.PortPositionSide.Left
        inputPort1.title = ""
        addPort(inputPort1);

        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output
        outputPort.portSide = NLSpec.PortPositionSide.Right
        outputPort.title = ""
        addPort(outputPort);

        if(nodeType == LSpecs.NodeType.OR)
            return;

        let inputPort2 = NLCore.createPort();
        inputPort2.portType = NLSpec.PortType.Input
        inputPort2.portSide = NLSpec.PortPositionSide.Left
        inputPort2.title = ""
        addPort(inputPort2);
    }
}
