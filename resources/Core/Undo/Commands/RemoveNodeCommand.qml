import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * RemoveNodeCommand
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var node  // Node
    // List of Link objects (not just port UUIDs, to preserve all properties)
    property var links: []

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (isValidScene() && isValidNode(node))
            scene.deleteNode(node._qsUuid)
    }

    function undo() {
        if (isValidScene() && isValidNode(node)) {
            scene.addNode(node)
            // Restore link objects (preserves all properties like color, etc.)
            if (links && links.length) {
                scene.restoreLinks(links)
            }
        }
    }
}
