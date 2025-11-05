import QtQuick
import NodeLink

QtObject {
    id: root

    property var scene // I_Scene
    property string inputPortUuid
    property string outputPortUuid

    function redo() {
        if (!scene || !inputPortUuid || !outputPortUuid) return
        scene.unlinkNodes(inputPortUuid, outputPortUuid)
    }

    function undo() {
        if (!scene || !inputPortUuid || !outputPortUuid) return
        scene.createLink(inputPortUuid, outputPortUuid)
    }
}



