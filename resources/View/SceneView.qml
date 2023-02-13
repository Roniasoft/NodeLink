import QtQuick
import QtQuick.Controls
import NodeLink

Flickable {
    id: sceneView
    property SceneManager scene


    contentWidth: 2000
    contentHeight: 2000

    ScrollBar.vertical: ScrollBar {
        width: 5
        policy: ScrollBar.AsNeeded
    }

    ScrollBar.horizontal: ScrollBar {
        height: 5
        policy: ScrollBar.AsNeeded
    }


    Repeater {
        model: scene.nodes
        delegate: NodeView {
            node: modelData
        }
    }
}
