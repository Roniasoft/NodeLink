import QtQuick
import NodeLink
import QtQuick.Controls

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
Rectangle {
    /* Property Declarations
     * ****************************************************************************************/
    property Node node

    /* Object Properties
     * ****************************************************************************************/
    width: node.width
    height: node.height
    x: node.x
    y: node.y
    color: Qt.darker(node.color, 10)
    border.color: node.color
    border.width: 3
    radius: 12
    smooth: true
    antialiasing: true
    layer.enabled: false


    ScrollView {
        id: view
        anchors.fill: parent
        anchors.margins: 5
        ScrollBar.vertical.width: 5
        ScrollBar.horizontal.height: 5
        TextArea {
            id: textArea
            focus: true
            placeholderText: qsTr("Enter description")
            color: "white"
            selectByMouse: true
            text: node.title
            background: Rectangle {
                color: "transparent";
            }
        }
    }
}
