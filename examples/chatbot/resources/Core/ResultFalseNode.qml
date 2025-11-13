import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.ResultFalse
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode)  {
        nodeData.data = null;
    }

    //! Create ports for oeration nodes    
    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;

        addPort(_port1);
    }
}
