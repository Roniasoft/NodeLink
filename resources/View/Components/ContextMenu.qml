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
    required property Scene  scene;

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

    /* Signals
     * ****************************************************************************************/

    signal nodeAdded(nodeUUid : string);

    /* Children
     * ****************************************************************************************/
    ContextMenuItem {
        name: "General Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.General]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            addNode(NLSpec.NodeType.General);
        }
    }
    ContextMenuItem {
        name: "Root Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Root]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            addNode(NLSpec.NodeType.Root);
        }
    }
    ContextMenuItem {
        name: "Step Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Step]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            addNode(NLSpec.NodeType.Step);
        }
    }
    ContextMenuItem {
        name: "Transition Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Transition]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            addNode(NLSpec.NodeType.Transition);
        }
    }
    ContextMenuItem {
        name: "Macro Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Macro]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            addNode(NLSpec.NodeType.Macro);
        }
    }


    function addNode (nodeType) {
        var node = NLCore.createNode();
        node.type = nodeType;
        node.guiConfig.position.x = contextMenu.x;
        node.guiConfig.position.y = contextMenu.y;
        node.guiConfig.color = NLStyle.nodeColors[nodeType]//Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
        scene.addNode(node)
        node.addPortByHardCode();

        nodeAdded(node._qsUuid);
        contextMenu.close()
    }

}
