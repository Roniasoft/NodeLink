import QtQuick
import NodeLink

Rectangle {
    property Node node

    Rectangle {
        color: node.color
        height: 20
        width: parent.width
    }
    PortView {

    }
}
