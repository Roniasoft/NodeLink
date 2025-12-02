import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * ResultNode - A result node for 3D quick scene
 * ************************************************************************************************/

Node {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property real inputValue: 0.0

    /* Object Properties
     * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node
    type: 1  // ResultNode type
    guiConfig.width: 160
    guiConfig.height: 100
    
    nodeData: I_NodeData {}

    /* Functions
     * ****************************************************************************************/

    //! Update input value
    function updateInput(newValue) {
        inputValue = newValue;
        // Update the node data
        if (nodeData) {
            nodeData.data = newValue;
        }
    }

    //! Initialize and create ports
    Component.onCompleted: {
        addPorts();
    }
    
    //! When parents change (link created), get value from parent
    onParentsChanged: {
        // Use Qt.callLater to ensure the link is fully established
        Qt.callLater(function() {
            // Get value from first parent (SourceNode)
            var parentKeys = Object.keys(parents);
            if (parentKeys.length > 0) {
                var parent = parents[parentKeys[0]];
                if (parent && parent.nodeData && parent.nodeData.data !== null && parent.nodeData.data !== undefined) {
                    updateInput(parent.nodeData.data);
                }
            }
        });
    }

    //! Create ports for result node
    function addPorts() {
        let inputPort = NLCore.createPort();

        inputPort.portType = NLSpec.PortType.Input;
        inputPort.portSide = NLSpec.PortPositionSide.Left;
        inputPort.title = "Input";

        addPort(inputPort);
    }
}

