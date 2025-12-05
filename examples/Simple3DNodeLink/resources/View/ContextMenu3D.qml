import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Context Menu for 3D Scene - Creates nodes with 3D positioning
 * ************************************************************************************************/
Menu {
    id: contextMenu

    /* Property Declarations
     * ****************************************************************************************/
    required property I_Scene       scene;
    required property SceneSession  sceneSession;

    //! node create in nodePosition (2D screen position)
    property vector2d nodePosition: Qt.vector2d(x, y);
    
    //! 3D world position for node creation
    property vector3d nodePosition3D: Qt.vector3d(0, 0, 0);

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
        model: Object.keys(scene.nodeRegistry?.nodeTypes ?? ({})).filter(function(key) {
                return key !== NLSpec.NodeType.CustomNode.toString();
            })

        delegate: ContextMenuItem {
            name: scene.nodeRegistry.nodeNames[modelData]
            iconStr: scene.nodeRegistry.nodeIcons[modelData]
            onClicked: {    // \todo: move this implementation out of primitive comp.
                var nodeUuid = contextMenu.createNode(Number(modelData));
                if (nodeUuid)
                    nodeAdded(nodeUuid);
            }
        }
    }

    //! Create a node with node type and its position (uses createCustomizeNode3D for 3D positioning)
    function createNode(nodeType : int) : string {
        // Use scene.createCustomizeNode3D which handles 3D positioning
        if (scene && scene.createCustomizeNode3D) {
            try {
                return scene.createCustomizeNode3D(nodeType, nodePosition.x, nodePosition.y, 
                                                   nodePosition3D.x, nodePosition3D.y, nodePosition3D.z);
            } catch (e) {
                console.error("Error creating node with createCustomizeNode3D:", e);
            }
        }
        // Fallback to createCustomizeNode
        if (scene && scene.createCustomizeNode) {
            try {
                return scene.createCustomizeNode(nodeType, nodePosition.x, nodePosition.y);
            } catch (e) {
                console.error("Error creating node with createCustomizeNode:", e);
            }
        }
        
        // Fallback to standard node creation (should not be reached if createCustomizeNode3D works)
        console.warn("Using fallback node creation for type:", nodeType);
        var qsType = scene.nodeRegistry?.nodeTypes?.[nodeType];
        if (!qsType || qsType === "") {
            console.error("The current node type (Node type: " + nodeType + ") cannot be created. qsType is:", qsType);
            return null;
        }

        try {
            var node = QSSerializer.createQSObject(qsType, scene.nodeRegistry.imports || ["QtQuickStream", "NodeLink", "Simple3DNodeLink"], scene?._qsRepo ?? NLCore.defaultRepo);
            if (!node) {
                console.error("Failed to create QSObject with type:", qsType);
                return null;
            }
            
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
        } catch (e) {
            console.error("Error in fallback node creation:", e);
            return null;
        }
    }
}

