import QtQuick

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * ColorNode - A source node that outputs a color value (hex string)
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property string outputColor: "#8080FF"  // Default blue color
    property bool _internalUpdate: false

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: Specs.NodeType.Color
    guiConfig.width: 200
    guiConfig.height: 100
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update output color value
    function updateOutput(newValue) {
        if (_internalUpdate) return;
        
        _internalUpdate = true;
        if (newValue !== undefined && newValue !== null) {
            var colorStr = String(newValue);
            // Validate hex color format
            if (colorStr.match(/^#[0-9A-Fa-f]{6}$/)) {
                outputColor = colorStr;
            } else if (colorStr.match(/^[0-9A-Fa-f]{6}$/)) {
                // Add # if missing
                outputColor = "#" + colorStr;
            } else {
                // Try to parse as color name or keep current
                try {
                    var testColor = Qt.color(colorStr);
                    if (testColor.a > 0) {
                        // Convert to hex
                        var r = Math.round(testColor.r * 255).toString(16).padStart(2, '0');
                        var g = Math.round(testColor.g * 255).toString(16).padStart(2, '0');
                        var b = Math.round(testColor.b * 255).toString(16).padStart(2, '0');
                        outputColor = "#" + r + g + b;
                    }
                } catch (e) {
                    // Invalid color, keep current
                }
            }
        }
        
        // Update the node data
        if (nodeData) {
            nodeData.data = outputColor;
        }
        
        _internalUpdate = false;
        
        // Trigger scene update to propagate changes downstream
        if (_qsRepo && _qsRepo.qsRootObject && _qsRepo.qsRootObject.updateDataFromNode) {
            _qsRepo.qsRootObject.updateDataFromNode(root);
        }
    }

    //! Initialize and create ports
    Component.onCompleted: {
        updateOutput("#8080FF");
        addPorts();
    }
    
    //! When children change (link created), update children
    onChildrenChanged: {
        // Use Qt.callLater to ensure the link is fully established
        Qt.callLater(function() {
            // Trigger update to propagate to children
            if (_qsRepo && _qsRepo.qsRootObject && _qsRepo.qsRootObject.updateDataFromNode) {
                _qsRepo.qsRootObject.updateDataFromNode(root);
            }
        });
    }

    //! Create ports for color node
    function addPorts() {
        // Output port only
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "Color";
        addPort(outputPort);
    }
}

