import QtQuick

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * PlasticMaterialNode - Material node with metallic, roughness, emissivePower inputs
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property real inputMetallic: 0.0
    property real inputRoughness: 0.4
    property real inputEmissivePower: 0.0
    property var outputMaterial: null

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: Specs.NodeType.Plastic
    guiConfig.width: 280
    guiConfig.height: 160
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update input values
    function updateInputMetallic(newValue) {
        inputMetallic = newValue;
        updateOutput();
    }
    
    function updateInputRoughness(newValue) {
        inputRoughness = newValue;
        updateOutput();
    }
    
    function updateInputEmissivePower(newValue) {
        inputEmissivePower = newValue;
        updateOutput();
    }
    
    function updateInput(portTitle, newValue) {
        // Handle number inputs
        var numValue = (typeof newValue === "number") ? newValue : 0.0;
        if (portTitle === "Metallic") {
            updateInputMetallic(numValue);
        } else if (portTitle === "Roughness") {
            updateInputRoughness(numValue);
        } else if (portTitle === "Emissive Power") {
            updateInputEmissivePower(numValue);
        }
    }

    //! Update output material
    function updateOutput() {
        outputMaterial = {
            type: "Plastic",
            metallic: inputMetallic,
            roughness: inputRoughness,
            emissivePower: inputEmissivePower
        };
        // Update the node data
        if (nodeData) {
            nodeData.data = outputMaterial;
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

    //! Create ports for material node
    function addPorts() {
        // Input ports
        let inputPortMetallic = NLCore.createPort();
        inputPortMetallic.portType = NLSpec.PortType.Input;
        inputPortMetallic.portSide = NLSpec.PortPositionSide.Left;
        inputPortMetallic.title = "Metallic";
        addPort(inputPortMetallic);
        
        let inputPortRoughness = NLCore.createPort();
        inputPortRoughness.portType = NLSpec.PortType.Input;
        inputPortRoughness.portSide = NLSpec.PortPositionSide.Left;
        inputPortRoughness.title = "Roughness";
        addPort(inputPortRoughness);
        
        let inputPortEmissivePower = NLCore.createPort();
        inputPortEmissivePower.portType = NLSpec.PortType.Input;
        inputPortEmissivePower.portSide = NLSpec.PortPositionSide.Left;
        inputPortEmissivePower.title = "Emissive Power";
        addPort(inputPortEmissivePower);
        
        // Output port
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "Material";
        addPort(outputPort);
    }
}

