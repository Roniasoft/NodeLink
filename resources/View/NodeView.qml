import QtQuick
import NodeLink
import QtQuick.Controls

/*! ***********************************************************************************************
 * This class show node ui.
 * ************************************************************************************************/
Rectangle {
    id: root
    /* Property Declarations
     * ****************************************************************************************/
    property Node node
    property SceneManager sceneManager

    /* Private Property Declarations
     * ****************************************************************************************/
    QtObject {
        id: privateVariables
        property bool nodeSelected: false
    }


    /* Object Properties
     * ****************************************************************************************/
    width: node.width
    height: node.height
    x: node.x
    y: node.y
    color: Qt.darker(node.color, 10)
    border.color: privateVariables.nodeSelected ? Qt.lighter(node.color, 1.5) : node.color
    border.width: 3
    radius: 12
    smooth: true
    antialiasing: true
    layer.enabled: false

    /* Children
    * ****************************************************************************************/
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

    Repeater {
        model: node.ports
        delegate: PortView {
            port: modelData
            sceneManager: root.sceneManager
        }
    }

    //! Manage node selection and position change.
    MouseArea {
        id: nodeMouseArea

        property int prevX: node.x
        property int prevY: node.y

        anchors.fill: parent
        propagateComposedEvents: true
        preventStealing: true


        onContainsMouseChanged: mouse => {
                                    if(containsMouse)
                                    nodeMouseArea.cursorShape = Qt.OpenHandCursor
                                    else
                                    nodeMouseArea.cursorShape = Qt.ArrowCursor;
                                }

        onPressed: mouse => {
                       prevX = mouse.x
                       prevY = mouse.y
                       privateVariables.nodeSelected = !privateVariables.nodeSelected;
                       nodeMouseArea.cursorShape = Qt.ClosedHandCursor

                   }

        onReleased: mouse => {
                        nodeMouseArea.cursorShape = Qt.OpenHandCursor
                    }

        onPositionChanged: mouse => {
                               privateVariables.nodeSelected = true
                               var deltaX = mouse.x - prevX
                               node.x += deltaX
                               prevX = mouse.x - deltaX

                               var deltaY = mouse.y - prevY
                               node.y += deltaY
                               prevY = mouse.y - deltaY
                           }
    }

}
