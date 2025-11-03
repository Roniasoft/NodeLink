import QtQuick
import QtQuick.Controls
import QtQuickStream
import NodeLink
import ChatBot

Window {
    id: window
    property ChatBotScene scene: null

    width: 1280
    height: 960
    visible: true
    title: "ChatBot Example"
    color: "#1e1e1e"
    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "ChatBot"])
        NLCore.defaultRepo.initRootObject("ChatBotScene")
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject })
    }

    ChatBotView {
        anchors.fill: parent
        scene: window.scene
    }
}
