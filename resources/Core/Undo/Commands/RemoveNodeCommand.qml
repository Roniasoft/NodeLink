import QtQuick
import NodeLink

QtObject {
    id: root

    property var scene // I_Scene
    property var node  // Node
    // List of { inputPortUuid, outputPortUuid }
    property var links: []

    function redo() {
        if (scene && node) scene.deleteNode(node._qsUuid)
    }

    function undo() {
        if (scene && node) {
            scene.addNode(node)
            // Restore links connected to this node
            if (links && links.length) {
                for (var i = 0; i < links.length; ++i) {
                    var p = links[i]
                    if (p && p.inputPortUuid && p.outputPortUuid) {
                        scene.createLink(p.inputPortUuid, p.outputPortUuid)
                    }
                }
            }
        }
    }
}


