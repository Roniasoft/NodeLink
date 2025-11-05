import QtQuick
import NodeLink

QtObject {
    id: root

    property var scene // I_Scene
    property string inputPortUuid
    property string outputPortUuid
    property var createdLink // Link, set after redo

    function redo() {
        if (!scene || !inputPortUuid || !outputPortUuid) return
        createdLink = scene.createLink(inputPortUuid, outputPortUuid)
    }

    function undo() {
        if (!scene || !inputPortUuid || !outputPortUuid) return
        scene.unlinkNodes(inputPortUuid, outputPortUuid)
    }
}
