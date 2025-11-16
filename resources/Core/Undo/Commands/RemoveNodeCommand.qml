import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * RemoveNodeCommand
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene // I_Scene
    property var node  // Node
    // List of Link objects (not just port UUIDs, to preserve all properties)
    property var links: []

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (scene && node) {
            scene.deleteNode(node._qsUuid)
        }
    }

    function undo() {
        if (scene && node) {
            scene.addNode(node)
            // Restore link objects (preserves all properties like color, etc.)
            if (links && links.length) {
                scene.restoreLinks(links)
            }
        }
    }
}
