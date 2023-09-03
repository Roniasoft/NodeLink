import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * SourceNode is a model that manage souce node in calculator.
 * ************************************************************************************************/

Node {

    /* Object Properties
    * ****************************************************************************************/

    type: CSpecs.NodeType.Source

    nodeData: I_NodeData {}

    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    /* Functions
     * ****************************************************************************************/

    //! Create ports for oeration nodes
    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
    }
}
