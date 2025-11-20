import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * AddContainerCommand
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var container // Container

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (isValidScene() && isValidContainer(container))
            scene.addContainer(container)
    }

    function undo() {
        if (isValidScene() && isValidContainer(container)) {
            // Simply remove the container from scene (don't delete from memory)
            // This allows redo to restore it
            if (scene.containers[container._qsUuid]) {
                scene.selectionModel.remove(container._qsUuid)
                scene.containerRemoved(container)
                delete scene.containers[container._qsUuid]
                scene.containersChanged()
            }
        }
    }
}
