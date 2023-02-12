import QtQuick 2.15
import NodeLink 1.0

Flickable {
    property SceneManager scene


    Repeater {
        model: scene.nodes
        delegate: NodeView {
            node: modelData
        }
    }
}
