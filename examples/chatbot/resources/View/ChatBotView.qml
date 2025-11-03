import QtQuick
import QtQuick.Controls
import NodeLink
import ChatBot

Item {
    id: view
    property ChatBotScene scene

    NodesScene {
        anchors.fill: parent
        scene: view.scene
        sceneSession: SceneSession { enabledOverview: false; doNodesNeedImage: false }
        sceneContent: NodesRect {
            scene: view.scene
            nodeViewComponent: Qt.createComponent("ChatBotNodeView.qml")
        }
    }
}
