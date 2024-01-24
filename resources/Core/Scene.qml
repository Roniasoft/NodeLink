import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 *
 * ************************************************************************************************/
I_Scene {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    //! Scene Selection Model
    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: root
    }

    /* Children
     * ****************************************************************************************/
    //    Component.onCompleted: {
    //        // adding example nodes
    //        for (var i = 0; i < 5; i++) {
    //            var node = NLCore.createNode();
    //            node.guiConfig.position.x = Math.random() * 1000;
    //            node.guiConfig.position.y = Math.random() * 1000;
    //            node.guiConfig.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
    //            addNode(node);
    //        }
    //        _timer.start();
    //    }
    // Adding example links
    property Timer _timer: Timer {
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            // example link
            linkNodes(Object.keys(Object.values(nodes)[1].ports)[1], Object.keys(Object.values(nodes)[2].ports)[3]);
            linkNodes(Object.keys(Object.values(nodes)[1].ports)[1], Object.keys(Object.values(nodes)[3].ports)[3]);
            linkNodes(Object.keys(Object.values(nodes)[2].ports)[0], Object.keys(Object.values(nodes)[0].ports)[2]);
        }
    }

    /* Functions
     * ****************************************************************************************/

    function automaticNodeReorder(nodes, rootId, keepRootPosition) {
        var cursor = [];
        var nodesByLevel = [[]];

        var vertical = false

        var LEVEL_SPACING = 60;
        var NODE_SPACING = 20;

        if (vertical) {
            for (var nodeId in nodes) {
                nodes[nodeId].guiConfig.width = nodes[nodeId].guiConfig.height;
                nodes[nodeId].guiConfig.height = nodes[nodeId].guiConfig.width;
                nodes[nodeId].guiConfig.position = Qt.vector2d(nodes[nodeId].guiConfig.position.y, nodes[nodeId].guiConfig.position.x);
            }
        }

        var recursiveStep = function(level, node) {
            if (!keepRootPosition || level > 0) {
                node.guiConfig.position.y = cursor[level];
                nodesByLevel[level].push(node);
            }

            if (Object.keys(node.children).length === 0) {
                return;
            }

            var recommendedPos = NODE_SPACING * 0.5;
            level++;

            recommendedPos += node.guiConfig.position.y + node.guiConfig.height * 0.5;

            for (var childId in node.children) {
                var childNode = nodes[childId];
                recommendedPos -= (childNode.guiConfig.height + NODE_SPACING) * 0.5;
            }

            if (level >= cursor.length) {
                cursor.push(recommendedPos);
                nodesByLevel.push([]);
            } else {
                recommendedPos = Math.max(recommendedPos, cursor[level]);
                cursor[level] = recommendedPos;
            }

            var topY = cursor[level];

            for (var childId in node.children) {
                var childNode = nodes[childId];
                recursiveStep(level, childNode);
                cursor[level] += childNode.guiConfig.height + NODE_SPACING;
            }

            var bottomY = cursor[level];

            if (Object.keys(node.children).length > 0) {
                var first = nodes[Object.keys(node.children)[0]];
                var last = nodes[Object.keys(node.children)[Object.keys(node.children).length - 1]];

                topY = first.guiConfig.position.y + first.guiConfig.height * 0.5;
                bottomY = last.guiConfig.position.y + last.guiConfig.height * 0.5;
            }

            var newY = (topY + bottomY) * 0.5 - node.guiConfig.height * 0.5;
            var posOffset = -(node.guiConfig.position.y - newY);

            if (posOffset > 0) {
                node.guiConfig.position.y += posOffset;
                cursor[level - 1] += posOffset;
            }
        };

        var root_node = nodes[rootId];
        cursor.push({});
        recursiveStep(0, root_node);

        var offset = root_node.guiConfig.position.x + root_node.guiConfig.width + LEVEL_SPACING;

        for (var i = 1; i < nodesByLevel.length; i++) {
            var maxWidth = 0;

            for (var j in nodesByLevel[i]) {
                var node = nodesByLevel[i][j];
                maxWidth = Math.max(maxWidth, node.guiConfig.width);
                node.guiConfig.position.x = offset;
            }

            offset += maxWidth + LEVEL_SPACING;
        }

        if (vertical) {
            for (var nodeId in nodes) {
                nodes[nodeId].guiConfig.position = Qt.vector2d(nodes[nodeId].guiConfig.position.y, nodes[nodeId].guiConfig.position.x);
            }
        }
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

    //! Override this function in your scene
    //! The ability to create a link is detected in the canLinkNodes function.
    //! Rols:
    //!     - A link must be established between two specific links
    //!     - Link can not be duplicate
    //!     - A node cannot establish a link with itself
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

    //! Snapped Position for when snap is enabled
    function snappedPosition (position) {
        return Qt.vector2d(Math.round(position.x / NLStyle.backgroundGrid.spacing) * NLStyle.backgroundGrid.spacing,
                           Math.round(position.y / NLStyle.backgroundGrid.spacing) * NLStyle.backgroundGrid.spacing);
    }
}
