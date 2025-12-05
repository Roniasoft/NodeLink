import QtQuick

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * RotationNode - Combines x, y, z inputs into a rotation vector3d output
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property real inputX: 0.0
    property real inputY: 0.0
    property real inputZ: 0.0
    property vector3d outputRotation: Qt.vector3d(0, 0, 0)

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: Specs.NodeType.Rotation
    guiConfig.width: 160
    guiConfig.height: 140
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update input values
    function updateInputX(newValue) {
        inputX = newValue;
        updateOutput();
    }
    
    function updateInputY(newValue) {
        inputY = newValue;
        updateOutput();
    }
    
    function updateInputZ(newValue) {
        inputZ = newValue;
        updateOutput();
    }
    
    function updateInput(portTitle, newValue) {
        // Handle both number and vector3d inputs
        if (portTitle === "X") {
            var xValue = (typeof newValue === "number") ? newValue : (newValue && typeof newValue.x !== "undefined" ? newValue.x : 0.0);
            updateInputX(xValue);
        } else if (portTitle === "Y") {
            var yValue = (typeof newValue === "number") ? newValue : (newValue && typeof newValue.y !== "undefined" ? newValue.y : 0.0);
            updateInputY(yValue);
        } else if (portTitle === "Z") {
            var zValue = (typeof newValue === "number") ? newValue : (newValue && typeof newValue.z !== "undefined" ? newValue.z : 0.0);
            updateInputZ(zValue);
        }
    }

    //! Update output rotation
    function updateOutput() {
        outputRotation = Qt.vector3d(inputX, inputY, inputZ);
        // Update the node data
        if (nodeData) {
            nodeData.data = outputRotation;
        }
        
        // Trigger scene update to propagate changes downstream
        if (_qsRepo && _qsRepo.qsRootObject && _qsRepo.qsRootObject.updateDataFromNode) {
            _qsRepo.qsRootObject.updateDataFromNode(root);
        }
    }

    //! Initialize and create ports
    Component.onCompleted: {
        updateOutput();
        addPorts();
    }
    
    //! When parents change (link created), get values from parents
    onParentsChanged: {
        // Use Qt.callLater to ensure the link is fully established
        Qt.callLater(function() {
            // Get values from connected parents by finding links
            if (!_qsRepo || !_qsRepo.qsRootObject) return;
            var scene = _qsRepo.qsRootObject;
            if (!scene || !scene.links) return;
            
            // Find all links that connect to this node's input ports
            Object.values(scene.links).forEach(function(link) {
                if (!link || !link.outputPort || !link.inputPort) return;
                
                // Check if this link connects to one of our input ports
                var inputPort = link.outputPort; // outputPort in link is the input port of downstream node
                if (inputPort.node && inputPort.node._qsUuid === root._qsUuid) {
                    // This link connects to our node
                    var outputPort = link.inputPort; // inputPort in link is the output port of upstream node
                    var upstreamNode = outputPort.node;
                    
                    if (upstreamNode && upstreamNode.nodeData && upstreamNode.nodeData.data !== null && upstreamNode.nodeData.data !== undefined) {
                        // Update the input port with the data from upstream node
                        updateInput(inputPort.title, upstreamNode.nodeData.data);
                    }
                }
            });
        });
    }

    //! Create ports for rotation node
    function addPorts() {
        // Input ports
        let inputPortX = NLCore.createPort();
        inputPortX.portType = NLSpec.PortType.Input;
        inputPortX.portSide = NLSpec.PortPositionSide.Left;
        inputPortX.title = "X";
        addPort(inputPortX);
        
        let inputPortY = NLCore.createPort();
        inputPortY.portType = NLSpec.PortType.Input;
        inputPortY.portSide = NLSpec.PortPositionSide.Left;
        inputPortY.title = "Y";
        addPort(inputPortY);
        
        let inputPortZ = NLCore.createPort();
        inputPortZ.portType = NLSpec.PortType.Input;
        inputPortZ.portSide = NLSpec.PortPositionSide.Left;
        inputPortZ.title = "Z";
        addPort(inputPortZ);
        
        // Output port
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "Rotation";
        addPort(outputPort);
    }
}

