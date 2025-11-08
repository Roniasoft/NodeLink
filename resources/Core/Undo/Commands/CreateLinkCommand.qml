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
    property var createdLink // Link, set after redo

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (!scene || !inputPortUuid || !outputPortUuid)
            return

        createdLink = scene.createLink(inputPortUuid, outputPortUuid)
    }

    function undo() {
        if (!scene || !inputPortUuid || !outputPortUuid)
            return

        scene.unlinkNodes(inputPortUuid, outputPortUuid)
    }
}
