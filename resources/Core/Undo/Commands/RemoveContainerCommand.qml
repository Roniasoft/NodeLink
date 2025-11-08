import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * RemoveContainerCommand
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene // I_Scene
    property var container // Container

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (scene && container)
            scene.deleteContainer(container._qsUuid)
    }

    function undo() {
        if (scene && container)
            scene.addContainer(container)
    }
}
