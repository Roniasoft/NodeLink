import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * RemoveNodesCommand - Handles undo/redo for batch node deletions
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene     // I_Scene
    property var nodes: [] // Array of Node objects
    // List of link data: [{ inputPortUuid, outputPortUuid }, ...]
    property var links: []

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (scene && nodes && nodes.length > 0) {
            var nodeUUIDs = []
            for (var i = 0; i < nodes.length; i++) {
                nodeUUIDs.push(nodes[i]._qsUuid)
            }
            scene.deleteNodes(nodeUUIDs)
        }
    }

    function undo() {
        if (scene && nodes && nodes.length > 0) {
            // Restore all nodes
            scene.addNodes(nodes, false)
            
            // Restore all link objects (preserves all properties like color, etc.)
            if (links && links.length > 0) {
                scene.restoreLinks(links)
            }
        }
    }
}

