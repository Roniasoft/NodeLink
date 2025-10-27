import QtQuick
import NodeLink
import PerformanceAnalyzer
import QtQuickStream

I_Scene {
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
            existObjects: [...Object.keys(nodes), ...Object.keys(links)]
        }

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    function createPairNode(xPos, yPos, nodeName) {
        var startNode = createStartNode(xPos, yPos, nodeName + "_start")
        var endNode = createEndNode(xPos + 230, yPos + 30, nodeName + "_end")
        linkTwoNodes(startNode, endNode)
    }

    function linkTwoNodes(nodeId1, nodeId2) {
        var node1 = nodes[nodeId1]
        var node2 = nodes[nodeId2]

        if (!node1 || !node2) {
            console.error("One or both nodes not found")
            return false
        }

        var outputPortId = null
        for (var portId in node1.ports) {
            var port = node1.ports[portId]
            if (port.portType === NLSpec.PortType.Output) {
                outputPortId = port._qsUuid
                break
            }
        }

        var inputPortId = null
        for (var portId in node2.ports) {
            var port = node2.ports[portId]
            if (port.portType === NLSpec.PortType.Input) {
                inputPortId = port._qsUuid
                break
            }
        }

        if (!outputPortId || !inputPortId) {
            console.error("Required ports not found")
            return false
        }

        if (canLinkNodes(outputPortId, inputPortId))
            linkNodes(outputPortId, inputPortId)

        console.log("Successfully linked " + node1.title + " to " + node2.title)
        return true
    }

    function createEndNode(xPos, yPos, nodeName) {
        var node = NLCore.createNode()
        node.type = CSpecs.NodeType.EndNode
        node._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo
        node.title = nodeName || nodeRegistry.nodeNames[CSpecs.NodeType.EndNode]

        node.guiConfig.position.x = xPos
        node.guiConfig.position.y = yPos
        node.guiConfig.color = "#444444"
        node.guiConfig.width = 150
        node.guiConfig.height = 100

        var inputPort = NLCore.createPort()
        inputPort.portType = NLSpec.PortType.Input
        inputPort.portSide = NLSpec.PortPositionSide.Left
        node.addPort(inputPort)
        addNode(node)
        return node._qsUuid
    }

    function createStartNode(xPos, yPos, nodeName) {
        var node = NLCore.createNode()
        node.type = CSpecs.NodeType.StartNode
        node._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo
        node.title = nodeName || nodeRegistry.nodeNames[CSpecs.NodeType.StartNode]
        node.guiConfig.position.x = xPos
        node.guiConfig.position.y = yPos
        node.guiConfig.color = "#444444"
        node.guiConfig.width = 150
        node.guiConfig.height = 100

        var outputPort = NLCore.createPort()
        outputPort.portType = NLSpec.PortType.Output
        outputPort.portSide = NLSpec.PortPositionSide.Right
        node.addPort(outputPort)
        addNode(node)
        return node._qsUuid
    }

    //! Override this function in your scene
    //! Create a node with node type and its position
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string {
        var qsType = root.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var title = nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(root.nodes).filter(node => node.type === nodeType).length + 1);
        if (NLStyle.snapEnabled) {
            var position = snappedPosition(Qt.vector2d(xPos, yPos));
            xPos = position.x;
            yPos = position.y;
        }
        return createSpecificNode(nodeRegistry.imports, nodeType, qsType,
                                  nodeRegistry.nodeColors[nodeType],
                                  title, xPos, yPos);
    }

    //! Override this function in your scene
    //! Check some condition and
    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function linkNodes(portA : string, portB : string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes ");
            return;
        }

        let link = Object.values(links).find(conObj =>
                                             conObj.inputPort._qsUuid === portA &&
                                             conObj.outputPort._qsUuid === portB);

        if (link === undefined) {
            // Find the nodes to which portA and portB belong
            let nodeX = findNode(portA);
            let nodeY = findNode(portB);

            //! Updates children and parents when a link created successfully
            nodeX.children[nodeY._qsUuid] = nodeY;
            nodeX.childrenChanged()

            nodeY.parents[nodeX._qsUuid] = nodeX;
            nodeY.parentsChanged()

            // Create link
            createLink(portA, portB)
        }
    }

    function canLinkNodes(portA : string, portB : string): bool {

        //! Sanity check
        if (portA.length === 0 || portB.length === 0)
            return false;

        // Find exist links with portA as input port and portB as output port.
        var sameLinks = Object.values(links).filter(link =>
            HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
            HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));

        if (sameLinks.length > 0)
            return false;

        // A node cannot establish a link with itself
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);
        if (HashCompareString.compareStringModels(nodeA, nodeB)
                    || nodeA.length === 0 || nodeB.length === 0) {
            return false;
        }

        //! Just a input port can be link to output port, or input to inAndOut port
        var portAObj = findPort(portA);
        var portBObj = findPort(portB);
        if (portAObj.portType === NLSpec.PortType.Input)
            return false;
        if (portBObj.portType === NLSpec.PortType.Output)
            return false;

        return true;
    }

    function clearScene() {
        var nodeIds = Object.keys(nodes)
        for (var i = 0; i < nodeIds.length; i++) {
            scene.deleteNode(nodeIds[i])
        }

        var linkIds = Object.keys(links)
        for (var i = 0; i < linkIds.length; i++) {
            scene.deleteNode(linkIds[i])
        }

        console.log("Scene cleared")
    }

}
