import QtQuick
import NodeLink

Node {
    property int operationType: CSpecs.OperationType.Regex
    type: CSpecs.NodeType.Regex
    nodeData: OperationNodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Right

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }
}
