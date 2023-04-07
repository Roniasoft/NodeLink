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
            var nodeUuid = scene.createCustomizeNode(NLSpec.NodeType.General, contextMenu.x, contextMenu.y);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Root Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Root]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = scene.createCustomizeNode(NLSpec.NodeType.Root, contextMenu.x, contextMenu.y);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Step Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Step]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = scene.createCustomizeNode(NLSpec.NodeType.Step, contextMenu.x, contextMenu.y);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Transition Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Transition]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = scene.createCustomizeNode(NLSpec.NodeType.Transition, contextMenu.x, contextMenu.y);
            nodeAdded(nodeUuid);
        }
    }
    ContextMenuItem {
        name: "Macro Node"
        iconStr: NLStyle.nodeIcons[NLSpec.NodeType.Macro]
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var nodeUuid = scene.createCustomizeNode(NLSpec.NodeType.Macro, contextMenu.x, contextMenu.y);
            nodeAdded(nodeUuid);
        }
    }
}
