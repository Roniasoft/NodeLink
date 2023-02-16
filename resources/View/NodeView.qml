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
    property Scene scene
    property var downstreamNodes: []
    property bool edit: textArea.activeFocus
    property bool isSelected: false

    /* Object Properties
     * ****************************************************************************************/
    width: node.guiConfig.width
    height: node.guiConfig.height
    x: node.guiConfig.position.x
    y: node.guiConfig.position.y
    color: Qt.darker(node.guiConfig.color, 10)
    border.color: Qt.lighter(node.guiConfig.color, root.isSelected ? 1.2 : 1)
    border.width: root.isSelected ? 4 : 3
    radius: 12
    smooth: true
    antialiasing: true
    layer.enabled: false


    /* Signals
     * ****************************************************************************************/
    signal clicked();


    onEditChanged: {
        if (root.edit) {
            textArea.forceActiveFocus();
        }
    }

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
            smooth: true
            antialiasing: true
            font.bold: true
            background: Rectangle {
                color: "transparent";
            }

            onActiveFocusChanged:
                if (!activeFocus)
                    root.edit = false
        }
    }

    //! Top Ports
    Row {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -3 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top);
            delegate: PortView {
                port: modelData
                scene: root.scene
                opacity: topPortsMouseArea.containsMouse ? 0.9 : 0
            }
        }

    }


    //! Left Ports
    Column {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -3 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left);
            delegate: PortView {
                port: modelData
                scene: root.scene
                opacity: leftPortsMouseArea.containsMouse ? 0.9 : 0
            }
        }
    }

    //! Right Ports
    Column {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -3 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right);
            delegate: PortView {
                port: modelData
                scene: root.scene
                opacity: rightPortsMouseArea.containsMouse ? 0.9 : 0
            }
        }
    }

    //! Bottom Ports
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -3 // we should use the size/2 of port from global style file
        spacing: 5          // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom);
            delegate: PortView {
                port: modelData
                scene: root.scene
                opacity: bottomPortsMouseArea.containsMouse ? 0.9 : 0
            }
        }
    }


    //! Manage node selection and position change.
    MouseArea {
        id: nodeMouseArea

        property int    prevX:      node.guiConfig.position.x
        property int    prevY:      node.guiConfig.position.y
        property bool   isDraging:  false

        anchors.fill: parent
//        propagateComposedEvents: true
        hoverEnabled: true
        preventStealing: true
        enabled: !root.edit

        onDoubleClicked: {
            root.edit = true;
        }

        cursorShape: (nodeMouseArea.containsMouse && !root.edit)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor

        onPressed: (mouse) => {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
            root.clicked();
        }

        onReleased: (mouse) => {
            isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;

                var deltaY = mouse.y - prevY;
                node.guiConfig.position.y += deltaY;
                prevY = mouse.y - deltaY;
            }
        }
    }


    MouseArea {
        id: topPortsMouseArea
        width: parent.width
        hoverEnabled: true
        height: 10
        anchors.top: parent.top
        anchors.topMargin: -5
        anchors.horizontalCenter: parent.horizontalCenter
    }
    MouseArea {
        id: bottomPortsMouseArea
        width: parent.width
        hoverEnabled: true
        height: 10
        anchors.bottom: parent.bottom
        anchors.topMargin: -5
        anchors.horizontalCenter: parent.horizontalCenter
    }
    MouseArea {
        id: leftPortsMouseArea
        width: 10
        hoverEnabled: true
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -5
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        id: rightPortsMouseArea
        width: 10
        hoverEnabled: true
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: -5
        anchors.verticalCenter: parent.verticalCenter
    }
}
