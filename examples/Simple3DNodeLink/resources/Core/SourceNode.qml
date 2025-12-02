import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * SourceNode - A source node for 3D quick scene
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property real outputValue: 0.0

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: 0  // SourceNode type
    guiConfig.width: 160
    guiConfig.height: 100
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update output value
    function updateOutput(newValue) {
        outputValue = newValue;
        // Update the node data
        if (nodeData) {
            nodeData.data = newValue;
        }
        
        // Update all children (connected ResultNodes)
        Object.values(children).forEach(function(child) {
            if (child && child.updateInput) {
                child.updateInput(newValue);
            }
        });
    }

    //! Initialize and create ports
    Component.onCompleted: {
        updateOutput(0.0);
        addPorts();
    }
    
    //! When children change (link created), update them with current value
    onChildrenChanged: {
        // Use Qt.callLater to ensure the link is fully established
        Qt.callLater(function() {
            if (nodeData && nodeData.data !== null && nodeData.data !== undefined) {
                Object.values(children).forEach(function(child) {
                    if (child && child.updateInput) {
                        child.updateInput(nodeData.data);
                    }
                });
            }
        });
    }

    //! Create ports for source node
    function addPorts() {
        let outputPort = NLCore.createPort();

        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "Output";

        addPort(outputPort);
    }
}

