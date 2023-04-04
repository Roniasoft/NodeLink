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
    ContextMenuItem{
        id: addCard
        onClicked: {    // \todo: move this implementation out of primitive comp.
            var node = NLCore.createNode();
            node.guiConfig.position.x = contextMenu.x;
            node.guiConfig.position.y = contextMenu.y;
            node.guiConfig.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            scene.addNode(node)
            node.addPortByHardCode();

            nodeAdded(node._qsUuid);
            scene.selectionModel.select(node);
            contextMenu.close()
        }
    }

}
