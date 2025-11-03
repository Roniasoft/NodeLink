import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.Source
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: {
        let port = NLCore.createPort()
        port.portType = NLSpec.PortType.Output
        port.portSide = NLSpec.PortPositionSide.Right
        addPort(port)
    }
}
