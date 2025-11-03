import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.ResultFalse
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: {
        let port = NLCore.createPort()
        port.portType = NLSpec.PortType.Input
        port.portSide = NLSpec.PortPositionSide.Left
        addPort(port)
    }

    onNodeDataChanged: {
        if (nodeData.data === "NOT_FOUND") nodeData.data = "Bye !!!"
        else nodeData.data = ""
    }
}
