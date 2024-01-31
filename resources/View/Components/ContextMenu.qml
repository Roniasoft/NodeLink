import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Context Menu
 * ************************************************************************************************/
Menu {
    id: contextMenu

    /* Property Declarations
     * ****************************************************************************************/
    required property I_Scene       scene;
    required property SceneSession  sceneSession;

    //! node create in nodePosition
    property vector2d nodePosition: Qt.vector2d(x, y);

    /* Object Properties
     * ****************************************************************************************/
    width: 180
    padding: 5
    //background is overrided
    background: Rectangle{
        anchors.fill: parent
        radius: NLStyle.radiusAmount.itemButton
        color: "#262626"
        border.width: 1
        border.color: "#1c1c1c"
    }

    //! Move focus on the scene
    onClosed: sceneSession.sceneForceFocus();

    /* Signals
     * ****************************************************************************************/

    signal nodeAdded(nodeUUid : string);

    signal containerAdded(containerUUid: string)

    /* Children
     * ****************************************************************************************/

    Repeater {
        model: Object.keys(scene.nodeRegistry?.nodeTypes ?? ({})).filter(function(key) {
                return key !== NLSpec.NodeType.CustomNode.toString();
            })

        delegate: ContextMenuItem {
            name: scene.nodeRegistry.nodeNames[modelData]
            iconStr: scene.nodeRegistry.nodeIcons[modelData]
            onClicked: {    // \todo: move this implementation out of primitive comp.
                if (scene.nodeRegistry.nodeNames[modelData] !== "Container") {
                    var nodeUuid = contextMenu.createNode(Number(modelData));
                    if (nodeUuid)
                        nodeAdded(nodeUuid);
                }
                else {
                    var containerUuid = contextMenu.createContainer(Number(modelData));
                    if (containerUuid)
                        containerAdded(containerUuid);
                }
            }
        }
    }

    //! Creates and adds a container
    function createContainer(nodeType : int) {
        var qsType = scene.nodeRegistry.nodeTypes[nodeType];
        var container = QSSerializer.createQSObject(qsType, scene.nodeRegistry.imports, scene?._qsRepo ?? NLCore.defaultRepo);
        container._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo._qsRepo;
        container.guiConfig.position = nodePosition;
        container.guiConfig.color = scene.nodeRegistry.nodeColors[nodeType];
        scene.addContainer(container);

        return container._qsUuid;
    }

    //! Create a node with node type and its position
    function createNode(nodeType : int) : string {
        var qsType = scene.nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var node = QSSerializer.createQSObject(qsType, scene.nodeRegistry.imports, scene?._qsRepo ?? NLCore.defaultRepo);
        node._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo;
        node.type = nodeType;

        // Correct position with zoompoint and zoom factor into real position.
        var positionMapped = nodePosition

        if (NLStyle.snapEnabled)
            node.guiConfig.position = scene.snappedPosition(positionMapped);
        else
            node.guiConfig.position = positionMapped

        node.guiConfig.color = scene.nodeRegistry.nodeColors[nodeType];
        node.guiConfig.colorIndex = 0;
        node.title = scene.nodeRegistry.nodeNames[nodeType] + "_" + (Object.values(scene.nodes).filter(nodeObj => (nodeObj.type - nodeType) === 0).length + 1)

        scene.addNode(node)

        return node._qsUuid;
    }
}
