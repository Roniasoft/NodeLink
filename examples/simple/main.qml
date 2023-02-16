import QtQuick
import NodeLink
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Simple NodeLink Example")
    color: "#1e1e1e"
    Material.theme: Material.Dark
    Material.accent: Material.Purple
    property Scene scene: Scene {}

    SceneView {
        scene: window.scene
        anchors.fill: parent
    }
}
