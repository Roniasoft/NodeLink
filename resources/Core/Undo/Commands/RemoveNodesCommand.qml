import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * RemoveNodesCommand - Handles undo/redo for batch node deletions
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var nodes: [] // Array of Node objects
    // List of link data: [{ inputPortUuid, outputPortUuid }, ...]
    property var links: []

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (isValidScene() && nodes && nodes.length > 0) {
            var nodeUUIDs = []
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i]
                // Skip null or invalid nodes
                if (!isValidNode(node)) {
                    continue;
                }
                nodeUUIDs.push(node._qsUuid)
            }
            if (nodeUUIDs.length > 0) {
                scene.deleteNodes(nodeUUIDs)
            }
        }
    }

    function undo() {
        if (isValidScene() && nodes && nodes.length > 0) {
            // Filter out null or invalid nodes before restoring
            var validNodes = []
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i]
                if (isValidNode(node)) {
                    validNodes.push(node)
                }
            }
            
            // Restore all valid nodes
            if (validNodes.length > 0) {
                scene.addNodes(validNodes, false)
            }

            // Restore all link objects (preserves all properties like color, etc.)
            if (links && links.length > 0) {
                scene.restoreLinks(links)
            }
        }
    }
}

