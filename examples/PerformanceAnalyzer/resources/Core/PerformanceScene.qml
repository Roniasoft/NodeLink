import QtQuick
import NodeLink
import PerformanceAnalyzer
import QtQuickStream

Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo

        imports: ["PerformanceAnalyzer"]

        defaultNode: CSpecs.NodeType.StartNode

        nodeTypes : [
            CSpecs.NodeType.StartNode   = "StartNode",
            CSpecs.NodeType.EndNode     = "EndNode"
        ];

        nodeNames: [
            CSpecs.NodeType.StartNode   = "Start",
            CSpecs.NodeType.EndNode     = "End"
        ];

        nodeIcons: [
            CSpecs.NodeType.StartNode   = "\uf04b",
            CSpecs.NodeType.EndNode     = "\uf11e"
        ];

        nodeColors: [
            CSpecs.NodeType.StartNode   = "#444",
            CSpecs.NodeType.EndNode     = "#444"
        ];
    }

    //! Scene Selection Model
    selectionModel: SelectionModel {
            existObjects: [...Object.keys(nodes), ...Object.keys(links), ...Object.keys(containers)]
        }

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    //! Adds multiple links at once
    function createLinks(linkDataArray) {
        if (!linkDataArray || linkDataArray.length === 0) {
            return;
        }

        for (var i = 0; i < linkDataArray.length; i++) {
            var linkData = linkDataArray[i];

            // Validate the link can be created
            if (!canLinkNodes(linkData.portA, linkData.portB)) {
                console.warn("Cannot create link between " + linkData.portA + " and " + linkData.portB);
                continue;
            }

            // createLink already handles parent/children relationships and signals
            createLink(linkData.portA, linkData.portB);
        }
    }

    //! function to create multiple pairs at once
    function createPairNodes(pairs) {// pairs format: [{xPos, yPos, nodeName}, {xPos, yPos, nodeName}, ...]
        var nodesToAdd = []
        var linksToCreate = []
        if (!pairs || pairs.length === 0) return;


        // Pre-allocate arrays for better performance
        nodesToAdd.length = pairs.length * 2;
        linksToCreate.length = pairs.length;

        var nodeIndex = 0;

        for (var i = 0; i < pairs.length; i++) {
            var pair = pairs[i]

            // Create start node
            var startNode = NLCore.createNode()
            startNode.type = CSpecs.NodeType.StartNode
            startNode._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo
            startNode.title = pair.nodeName + "_start"
            startNode.guiConfig.position.x = pair.xPos
            startNode.guiConfig.position.y = pair.yPos
            startNode.guiConfig.color = "#444444"
            startNode.guiConfig.width = 150
            startNode.guiConfig.height = 100

            var outputPort = NLCore.createPort()
            outputPort.portType = NLSpec.PortType.Output
            outputPort.portSide = NLSpec.PortPositionSide.Right
            startNode.addPort(outputPort)

            // Create end node
            var endNode = NLCore.createNode()
            endNode.type = CSpecs.NodeType.EndNode
            endNode._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo
            endNode.title = pair.nodeName + "_end"
            endNode.guiConfig.position.x = pair.xPos + 230
            endNode.guiConfig.position.y = pair.yPos + 30
            endNode.guiConfig.color = "#444444"
            endNode.guiConfig.width = 150
            endNode.guiConfig.height = 100

            var inputPort = NLCore.createPort()
            inputPort.portType = NLSpec.PortType.Input
            inputPort.portSide = NLSpec.PortPositionSide.Left
            endNode.addPort(inputPort)

            nodesToAdd[nodeIndex++] = startNode;
            nodesToAdd[nodeIndex++] = endNode;

            linksToCreate[i] = {
                nodeA: startNode,
                nodeB: endNode,
                portA: outputPort._qsUuid,
                portB: inputPort._qsUuid,
            };
        }

        addNodes(nodesToAdd, false)

        // Create all links at once
        createLinks(linksToCreate)
    }


    function clearScene() {
        console.time("Scene_clear")
        gc()
        scene.selectionModel.clear()
        var nodeIds = Object.keys(nodes)
        scene.deleteNodes(nodeIds)
        links = []
        console.timeEnd("Scene_clear")
    }

}
