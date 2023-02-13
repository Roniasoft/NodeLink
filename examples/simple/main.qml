import QtQuick
import NodeLink

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Simple NodeLink Example")
    color: "#5ad5ed"

    PortView {
        id: portview

        width: 50
        height: 50
        anchors.centerIn: parent
    }
}
