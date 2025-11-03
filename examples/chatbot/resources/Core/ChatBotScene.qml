import QtQuick
import NodeLink
import ChatBot

I_Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["ChatBot"]

        defaultNode: CSpecs.NodeType.Source
        nodeTypes: [
            CSpecs.NodeType.Source      = "SourceNode",
            CSpecs.NodeType.Regex       = "RegexNode",
            CSpecs.NodeType.ResultTrue  = "ResultTrueNode",
            CSpecs.NodeType.ResultFalse = "ResultFalseNode"
        ]
        nodeNames: [
            CSpecs.NodeType.Source      = "Source",
            CSpecs.NodeType.Regex       = "Regex",
            CSpecs.NodeType.ResultTrue  = "ResultTrue",
            CSpecs.NodeType.ResultFalse = "ResultFalse"
        ]
        nodeIcons: [
            CSpecs.NodeType.Source      = "\ue4e2",
            CSpecs.NodeType.Regex       = "\uf002",
            CSpecs.NodeType.ResultTrue  = "\uf058",
            CSpecs.NodeType.ResultFalse = "\uf057"
        ]
        nodeColors: [
            CSpecs.NodeType.Source      = "#444",
            CSpecs.NodeType.Regex       = "#888",
            CSpecs.NodeType.ResultTrue  = "#4caf50",
            CSpecs.NodeType.ResultFalse = "#f44336"
        ]
    }

    function updateData() {
        Object.values(nodes).forEach(node => node.nodeData.data = null)

        Object.values(links).forEach(link => {
            var up = findNode(link.inputPort._qsUuid)
            var down = findNode(link.outputPort._qsUuid)
            if (up && down) upadateNodeData(up, down)
        })
    }

    function upadateNodeData(up, down) {
        if (down.type === CSpecs.NodeType.Regex) down.updataData(up.nodeData.data)
        else if (down.type === CSpecs.NodeType.ResultTrue || down.type === CSpecs.NodeType.ResultFalse)
            down.nodeData.data = up.nodeData.data
    }
}
