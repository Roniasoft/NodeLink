import QtQuick

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * RectangleNode - A rectangle shape node with position, rotation, scale, dimensions, and material inputs
 * No output - renders shape in 3D scene
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property vector3d inputPosition: Qt.vector3d(0, 0, 0)
    property vector3d inputRotation: Qt.vector3d(0, 0, 0)
    property vector3d inputScale: Qt.vector3d(1, 1, 1)
    property vector3d inputDimensions: Qt.vector3d(100, 100, 100)
    property var inputMaterial: null
    
    property string shapeType: "Rectangle"

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: Specs.NodeType.Rectangle
    guiConfig.width: 120
    guiConfig.height: 200
    
    nodeData: I_NodeData {
        data: {
            return {
                shapeType: root.shapeType,
                position: root.inputPosition,
                rotation: root.inputRotation,
                scale: root.inputScale,
                dimensions: root.inputDimensions,
                material: root.inputMaterial
            };
        }
    }

    /* Functions
     * ****************************************************************************************/

    //! Update input values
    function updateInputPosition(newValue) {
        if (newValue && typeof newValue.x !== "undefined") {
            inputPosition = newValue;
            updateNodeData();
        }
    }
    
    function updateInputRotation(newValue) {
        if (newValue && typeof newValue.x !== "undefined") {
            inputRotation = newValue;
            updateNodeData();
        }
    }
    
    function updateInputScale(newValue) {
        if (newValue && typeof newValue.x !== "undefined") {
            inputScale = newValue;
            updateNodeData();
        }
    }
    
    function updateInputDimensions(newValue) {
        if (newValue && typeof newValue.x !== "undefined") {
            inputDimensions = newValue;
            updateNodeData();
        }
    }
    
    function updateInputMaterial(newValue) {
        inputMaterial = newValue;
        updateNodeData();
    }
    
    function updateInput(portTitle, newValue) {
        if (portTitle === "Position") {
            updateInputPosition(newValue);
        } else if (portTitle === "Rotation") {
            updateInputRotation(newValue);
        } else if (portTitle === "Scale") {
            updateInputScale(newValue);
        } else if (portTitle === "Dimensions") {
            updateInputDimensions(newValue);
        } else if (portTitle === "Material") {
            updateInputMaterial(newValue);
        }
    }
    
    function updateNodeData() {
        if (nodeData) {
            nodeData.data = {
                shapeType: root.shapeType,
                position: root.inputPosition,
                rotation: root.inputRotation,
                scale: root.inputScale,
                dimensions: root.inputDimensions,
                material: root.inputMaterial
            };
        }
    }

    //! Initialize and create ports
    Component.onCompleted: {
        updateNodeData();
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

    //! Create ports for rectangle node
    function addPorts() {
        // Input ports
        let inputPortPosition = NLCore.createPort();
        inputPortPosition.portType = NLSpec.PortType.Input;
        inputPortPosition.portSide = NLSpec.PortPositionSide.Left;
        inputPortPosition.title = "Position";
        addPort(inputPortPosition);
        
        let inputPortRotation = NLCore.createPort();
        inputPortRotation.portType = NLSpec.PortType.Input;
        inputPortRotation.portSide = NLSpec.PortPositionSide.Left;
        inputPortRotation.title = "Rotation";
        addPort(inputPortRotation);
        
        let inputPortScale = NLCore.createPort();
        inputPortScale.portType = NLSpec.PortType.Input;
        inputPortScale.portSide = NLSpec.PortPositionSide.Left;
        inputPortScale.title = "Scale";
        addPort(inputPortScale);
        
        let inputPortDimensions = NLCore.createPort();
        inputPortDimensions.portType = NLSpec.PortType.Input;
        inputPortDimensions.portSide = NLSpec.PortPositionSide.Left;
        inputPortDimensions.title = "Dimensions";
        addPort(inputPortDimensions);
        
        let inputPortMaterial = NLCore.createPort();
        inputPortMaterial.portType = NLSpec.PortType.Input;
        inputPortMaterial.portSide = NLSpec.PortPositionSide.Left;
        inputPortMaterial.title = "Material";
        addPort(inputPortMaterial);
        
        // No output port - shape nodes don't have outputs
    }
}

