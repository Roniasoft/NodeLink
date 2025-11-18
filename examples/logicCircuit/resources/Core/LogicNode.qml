import QtQuick
import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * LogicNode is a model that manage Logic nodes in LogicCircuit.
 * ************************************************************************************************/
Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property int nodeType: LSpecs.NodeType.AND

    /* Object Properties
    * ****************************************************************************************/
    type: LSpecs.NodeType.Logic
    nodeData: LogicNodeData {}

    // Scene reference for circuit updates
    property var logicScene: null

    // Enable auto-sizing
    guiConfig.autoSize: false
    guiConfig.minWidth: 20
    guiConfig.minHeight: 20

    Component.onCompleted: {
        addPorts();
        // Get scene reference for updates
        logicScene = _qsRepo ? _qsRepo.qsRootObject : null;
    }

    /* Functions
     * ****************************************************************************************/

    //! Create ports for operation nodes
    function addPorts() {
        if (nodeType == LSpecs.NodeType.OR || nodeType == LSpecs.NodeType.AND) {
            addPortsInput();
            addPortsInput();
            addPortsOutput();
        } else if (nodeType == LSpecs.NodeType.Input) {
            addPortsOutput();
        } else if (nodeType == LSpecs.NodeType.Output) {
            addPortsInput();
        } else if (nodeType == LSpecs.NodeType.NOT) {
            addPortsInput();
            addPortsOutput();
        }
    }

    function addPortsInput() {
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input;
        inputPort.portSide = NLSpec.PortPositionSide.Left;
        inputPort.title = "";
        addPort(inputPort);
    }

    function addPortsOutput() {
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "";
        addPort(outputPort);
    }

    //! Default updateData function - should be overridden by child nodes
    function updateData() {
        // Base implementation - child nodes should override this
    }

    //! Helper function to trigger circuit update
    function triggerCircuitUpdate() {
        if (logicScene && logicScene.updateLogic) {
            logicScene.updateLogic();
        }
    }
}
