import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * RemoveContainerCommand
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
            scene.deleteContainer(container._qsUuid)
    }

    function undo() {
        if (isValidScene() && isValidContainer(container))
            scene.addContainer(container)
    }
}
