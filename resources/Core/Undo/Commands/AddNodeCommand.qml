import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * AddNodeCommand
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var node  // Node

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (isValidScene() && isValidNode(node))
            scene.addNode(node)
    }

    function undo() {
        if (isValidScene() && isValidNode(node)) {
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
