import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * ResultNode in calculator example.
 * ************************************************************************************************/

Node {

    /* Object Properties
    * ****************************************************************************************/

    type: CSpecs.NodeType.StartNode
    nodeData: I_NodeData {}

    guiConfig.width: 100
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    //! Override function
    //! Handle clone node operation
    //! Empty the nodeData.data
    onCloneFrom: function (baseNode)  {
        nodeData.data = null;
    }

    /* Functions
     * ****************************************************************************************/

    //! Create ports for oeration nodes
    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right
        _port1.enable   = true

        addPort(_port1);
    }
}
