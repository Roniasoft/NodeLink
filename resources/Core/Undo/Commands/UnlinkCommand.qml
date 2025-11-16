import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * UnlinkCommand
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene // I_Scene
    property string inputPortUuid
    property string outputPortUuid
    property var removedLink // Link object that was removed

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (!scene || !inputPortUuid || !outputPortUuid)
            return
        
        // Remove link from scene but don't destroy it
        if (removedLink && scene.links[removedLink._qsUuid]) {
            scene.linkRemoved(removedLink)
            delete scene.links[removedLink._qsUuid]
            scene.linksChanged()
        }
    }

    function undo() {
        if (!scene || !removedLink)
            return

        scene.restoreLinks([removedLink])
    }
}
