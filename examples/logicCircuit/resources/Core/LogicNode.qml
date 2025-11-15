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
        if(nodeType == LSpecs.NodeType.OR || nodeType == LSpecs.NodeType.AND){
            addPortsInput();
            addPortsInput();
            addPortsOutput();
        }

        else if(nodeType == LSpecs.NodeType.Input){
            addPortsOutput();
        }

        else if(nodeType == LSpecs.NodeType.Output){
            addPortsInput();
        }

        else if(nodeType == LSpecs.NodeType.NOT){
            addPortsInput();
            addPortsOutput();
        }
    }

    function addPortsInput(){
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input
        inputPort.portSide = NLSpec.PortPositionSide.Left
        inputPort.title = ""
        addPort(inputPort);
    }

    function addPortsOutput(){
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output
        outputPort.portSide = NLSpec.PortPositionSide.Right
        outputPort.title = ""
        addPort(outputPort);
    }
}
