import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * UnlinkCommand
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property string inputPortUuid
    property string outputPortUuid
    property var removedLink // Link object that was removed

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (!isValidScene() || !isValidUuid(inputPortUuid) || !isValidUuid(outputPortUuid))
            return

        // Use unlinkNodes to properly handle parent/children relationships
        // removedLink should already be set, but use the UUIDs from command
        scene.unlinkNodes(inputPortUuid, outputPortUuid)
    }

    function undo() {
        if (!isValidScene() || !isValidLink(removedLink))
            return

        scene.restoreLinks([removedLink])
    }
}
