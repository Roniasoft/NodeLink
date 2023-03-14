import QtQuick
import NodeLink
import QtQuick.Controls 2.12

Window {
    id: window
    width: 1280
    height: 960
    visible: true
    title: qsTr("Simple NodeLink Example")
    color: "#1e1e1e"

    property Scene scene: NLCore.scene

    NLView {
        scene: window.scene
        anchors.fill: parent
    }
}
