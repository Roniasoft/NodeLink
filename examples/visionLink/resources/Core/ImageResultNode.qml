import QtQuick
import QtQuickStream
import QtQuick.Dialogs
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * ImageResultNode displays the final processed image result
 * ************************************************************************************************/
Node {

    /* Object Properties
     * ****************************************************************************************/
    type: CSpecs.NodeType.ImageResult
    nodeData: I_NodeData {}

    guiConfig.width: 250
    guiConfig.height: 220

    /* Children
    * ****************************************************************************************/
    Component.onCompleted: addPorts();

    //! Override function
    //! Handle clone node operation
    //! Empty the nodeData.data
    onCloneFrom: function (baseNode)  {
        nodeData.data = null;
    }

    /* Functions
     * ****************************************************************************************/
    //! Create ports for operation nodes
    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left

        addPort(_port1);
    }
}
