import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.Source
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
    }
}
