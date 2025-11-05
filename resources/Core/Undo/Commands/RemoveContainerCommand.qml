import QtQuick
import NodeLink

QtObject {
    id: root

    property var scene // I_Scene
    property var container // Container

    function redo() {
        if (scene && container) scene.deleteContainer(container._qsUuid)
    }

    function undo() {
        if (scene && container) scene.addContainer(container)
    }
}



