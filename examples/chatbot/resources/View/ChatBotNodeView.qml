import QtQuick
import NodeLink
import ChatBot

NodeView {
    id: nodeView
    contentItem: Text {
        anchors.centerIn: parent
        text: node?.nodeData?.data ?? ""
        color: "white"
        font.bold: true
    }
}
