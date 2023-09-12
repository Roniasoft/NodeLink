import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * ResultNode in calculator example.
 * ************************************************************************************************/

Node {

    /* Object Properties
    * ****************************************************************************************/

    type: CSpecs.NodeType.Result
    nodeData: I_NodeData {}

    guiConfig.width: 150
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

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;

        addPort(_port1);
    }
}
