import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * AddNodeCommand
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene // I_Scene
    property var node  // Node

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (scene && node) {
            scene.addNode(node)
        }
    }

    function undo() {
        if (scene && node) {
            // Simply remove the node from scene (don't delete from memory)
            // Links will be handled by their own CreateLinkCommand
            if (scene.nodes[node._qsUuid]) {
                scene.selectionModel.remove(node._qsUuid)
                scene.nodeRemoved(node)
                delete scene.nodes[node._qsUuid]
                scene.nodesChanged()
            }
        }
    }
}
