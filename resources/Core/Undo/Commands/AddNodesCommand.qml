import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * AddNodesCommand - Handles undo/redo for batch node additions
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var nodes: [] // Array of Node objects

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (isValidScene() && nodes && nodes.length > 0) {
            scene.addNodes(nodes, false)
        }
    }

    function undo() {
        if (isValidScene() && nodes && nodes.length > 0) {
            // Simply remove nodes from scene (don't delete from memory)
            // This allows redo to restore them
            // Links will be handled by their own CreateLinkCommand
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i]
                // Skip null or invalid nodes
                if (!isValidNode(node)) {
                    continue;
                }
                if (scene.nodes[node._qsUuid]) {
                    scene.selectionModel.remove(node._qsUuid)
                    scene.nodeRemoved(node)
                    delete scene.nodes[node._qsUuid]
                }
            }
            scene.nodesChanged()
        }
    }
}

