import QtQuick
import NodeLink

Flickable {
    property SceneManager scene


    Repeater {
        model: scene.nodes
        delegate: NodeView {
            node: modelData
        }
    }
}
