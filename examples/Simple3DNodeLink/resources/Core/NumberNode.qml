import QtQuick

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * NumberNode - A source node that outputs a number value
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property real outputValue: 0.0
    property bool _internalUpdate: false

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: Specs.NodeType.Number
    guiConfig.width: 160
    guiConfig.height: 100
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update output value
    function updateOutput(newValue) {
        if (_internalUpdate) return;
        
        _internalUpdate = true;
        if (newValue !== undefined && newValue !== null) {
            var numValue = parseFloat(newValue);
            if (isNaN(numValue)) {
                numValue = 0.0;
            }
            outputValue = numValue;
        }
        
        // Update the node data
        if (nodeData) {
            nodeData.data = outputValue;
        }
        
        _internalUpdate = false;
        
        // Trigger scene update to propagate changes downstream
        if (_qsRepo && _qsRepo.qsRootObject && _qsRepo.qsRootObject.updateDataFromNode) {
            _qsRepo.qsRootObject.updateDataFromNode(root);
        }
    }

    //! Initialize and create ports
    Component.onCompleted: {
        updateOutput(0.0);
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

    //! Create ports for number node
    function addPorts() {
        // Output port only
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "Number";
        addPort(outputPort);
    }
}


