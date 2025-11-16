import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * AddNodesCommand - Handles undo/redo for batch node additions
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene     // I_Scene
    property var nodes: [] // Array of Node objects

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (scene && nodes && nodes.length > 0) {
            scene.addNodes(nodes, false)
        }
    }

    function undo() {
        if (scene && nodes && nodes.length > 0) {
            // Simply remove nodes from scene (don't delete from memory)
            // Links will be handled by their own CreateLinkCommand
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i]
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

