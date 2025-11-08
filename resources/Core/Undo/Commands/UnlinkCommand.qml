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

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (!scene || !inputPortUuid || !outputPortUuid)
            return

        scene.unlinkNodes(inputPortUuid, outputPortUuid)
    }

    function undo() {
        if (!scene || !inputPortUuid || !outputPortUuid)
            return

        scene.createLink(inputPortUuid, outputPortUuid)
    }
}
