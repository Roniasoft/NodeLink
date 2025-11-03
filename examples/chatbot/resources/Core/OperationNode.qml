import QtQuick
import NodeLink

Node {
    property int operationType: CSpecs.OperationType.Regex
    type: CSpecs.NodeType.Regex
    nodeData: OperationNodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: {
        let inPort = NLCore.createPort()
        inPort.portType = NLSpec.PortType.Input
        inPort.portSide = NLSpec.PortPositionSide.Left
        addPort(inPort)

        let outPort = NLCore.createPort()
        outPort.portType = NLSpec.PortType.Output
        outPort.portSide = NLSpec.PortPositionSide.Right
        addPort(outPort)
    }
}
