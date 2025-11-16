import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * CreateLinkCommand
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene // I_Scene
    property string inputPortUuid
    property string outputPortUuid
    property var createdLink // Link object (saved for undo/redo)

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (!scene || !inputPortUuid || !outputPortUuid)
            return

        if (createdLink) {
            // Restore the existing link object (preserves all properties)
            scene.restoreLinks([createdLink])
        } else {
            // First time: create new link
            createdLink = scene.createLink(inputPortUuid, outputPortUuid)
        }
    }

    function undo() {
        if (!scene || !createdLink)
            return
        
        // Remove link from scene but DON'T destroy it (we need it for redo)
        if (scene.links[createdLink._qsUuid]) {
            scene.linkRemoved(createdLink)
            delete scene.links[createdLink._qsUuid]
            scene.linksChanged()
        }
    }
}
