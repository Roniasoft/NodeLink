import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * AddNodeCommand
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property var scene // I_Scene
    property var node  // Node

    /* Functions
    * ****************************************************************************************/
    function redo() {
        if (scene && node)
            scene.addNode(node)
    }

    function undo() {
        if (scene && node)
            scene.deleteNode(node._qsUuid)
    }
}
