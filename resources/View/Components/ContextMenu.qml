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

    /* Children
     * ****************************************************************************************/

    Repeater {
        model:  Object.keys(NLNodeRegistry.nodeTypes)

        delegate: ContextMenuItem {
            name: NLNodeRegistry.nodeNames[modelData]
            enabled: !(scene?.bannedNodes.includes(Number(modelData)) ?? true)
            iconStr: NLNodeRegistry.nodeIcons[modelData]
            onClicked: {    // \todo: move this implementation out of primitive comp.
                var nodeUuid = contextMenu.createNode(Number(modelData));
                if (nodeUuid)
                    nodeAdded(nodeUuid);
            }
        }
    }

    //! Create a node with node type and its position
    function createNode(nodeType : int) : string {

        if (scene.bannedNodes.includes(nodeType)) {
            console.info("The current node type (Node type: " + nodeType + ") cannot be created.");
            return null;
        }

        var node = QSSerializer.createQSObject(NLNodeRegistry.nodeTypes[nodeType],
                                               NLNodeRegistry.imports, NLCore.defaultRepo);
        node._qsRepo = NLCore.defaultRepo;
        node.type = nodeType;

        // Correct position with zoompoint and zoom factor into real position.
        var positionMapped = nodePosition?.times(1 / sceneSession.zoomManager.zoomFactor)

        node.guiConfig.position = positionMapped;


        node.guiConfig.color = NLNodeRegistry.nodeColors[nodeType];
        node.title = NLNodeRegistry.nodeNames[nodeType] + "_" + (Object.values(scene.nodes).filter(nodeObj => (nodeObj.type - nodeType) === 0).length + 1)

        scene.addNode(node)

        return node._qsUuid;
    }
}
