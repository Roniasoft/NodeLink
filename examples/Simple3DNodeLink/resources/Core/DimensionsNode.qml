import QtQuick

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * DimensionsNode - Combines w, h, d inputs into a dimensions vector3d output
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property real inputW: 100.0
    property real inputH: 100.0
    property real inputD: 100.0
    property vector3d outputDimensions: Qt.vector3d(100, 100, 100)

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: Specs.NodeType.Dimensions
    guiConfig.width: 160
    guiConfig.height: 140
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update input values
    function updateInputW(newValue) {
        inputW = newValue;
        updateOutput();
    }
    
    function updateInputH(newValue) {
        inputH = newValue;
        updateOutput();
    }
    
    function updateInputD(newValue) {
        inputD = newValue;
        updateOutput();
    }
    
    function updateInput(portTitle, newValue) {
        // Handle both number and vector3d inputs
        if (portTitle === "W") {
            var wValue = (typeof newValue === "number") ? newValue : (newValue && typeof newValue.x !== "undefined" ? newValue.x : 100.0);
            updateInputW(wValue);
        } else if (portTitle === "H") {
            var hValue = (typeof newValue === "number") ? newValue : (newValue && typeof newValue.y !== "undefined" ? newValue.y : 100.0);
            updateInputH(hValue);
        } else if (portTitle === "D") {
            var dValue = (typeof newValue === "number") ? newValue : (newValue && typeof newValue.z !== "undefined" ? newValue.z : 100.0);
            updateInputD(dValue);
        }
    }

    //! Update output dimensions
    function updateOutput() {
        outputDimensions = Qt.vector3d(inputW, inputH, inputD);
        // Update the node data
        if (nodeData) {
            nodeData.data = outputDimensions;
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

    //! Create ports for dimensions node
    function addPorts() {
        // Input ports
        let inputPortW = NLCore.createPort();
        inputPortW.portType = NLSpec.PortType.Input;
        inputPortW.portSide = NLSpec.PortPositionSide.Left;
        inputPortW.title = "W";
        addPort(inputPortW);
        
        let inputPortH = NLCore.createPort();
        inputPortH.portType = NLSpec.PortType.Input;
        inputPortH.portSide = NLSpec.PortPositionSide.Left;
        inputPortH.title = "H";
        addPort(inputPortH);
        
        let inputPortD = NLCore.createPort();
        inputPortD.portType = NLSpec.PortType.Input;
        inputPortD.portSide = NLSpec.PortPositionSide.Left;
        inputPortD.title = "D";
        addPort(inputPortD);
        
        // Output port
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "Dimensions";
        addPort(outputPort);
    }
}

