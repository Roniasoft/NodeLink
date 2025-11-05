import QtQuick
import NodeLink

QtObject {
    id: root

    property var scene // I_Scene
    property var node  // Node

    function redo() {
        if (scene && node) scene.addNode(node)
    }

    function undo() {
        if (scene && node) scene.deleteNode(node._qsUuid)
    }
}



