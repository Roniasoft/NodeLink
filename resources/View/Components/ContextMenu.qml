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
    required property Scene         scene;
    required property SceneSession  sceneSession;

    /* Object Properties
     * ****************************************************************************************/
    width: 180
    padding: 5
    //background is overrided
    background: Rectangle{
        anchors.fill: parent
        radius: 5
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
    ContextMenuItem {
        name: "General Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.General]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = contextMenu.createNode(NLSpec.NodeType.General);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Root Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Root]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = contextMenu.createNode(NLSpec.NodeType.Root);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Step Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Step]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = contextMenu.createNode(NLSpec.NodeType.Step);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Transition Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Transition]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = contextMenu.createNode(NLSpec.NodeType.Transition);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Macro Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Macro]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = contextMenu.createNode(NLSpec.NodeType.Macro);
            nodeAdded(nodeUuid);
        }
    }

    //! Create a node with node type and its position
    function createNode(nodeType : int) : string{
        var node = QSSerializer.createQSObject(NLStyle.nodeNames[nodeType], ["NodeLink"], NLCore.defaultRepo);
        node._qsRepo = NLCore.defaultRepo;
        node.type = nodeType;

        var position = Qt.vector2d(contextMenu.x, contextMenu.y);

        // Correct position with zoompoint and zoom factor into real position.
        var positionCorrection = position?.times(1 / sceneSession.zoomManager.zoomFactor)


        node.guiConfig.position.x = positionCorrection.x;
        node.guiConfig.position.y = positionCorrection.y;


        node.guiConfig.color = NLStyle.nodeColors[nodeType]//Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
        node.title = NLStyle.objectTypesString[nodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1)
        scene.addNode(node)
        node.addPortByHardCode();

        return node._qsUuid;
    }
}
