import QtQuick
import NodeLink
import QtQuick.Controls

/*! ***********************************************************************************************
 * This class show node ui.
 * ************************************************************************************************/
Rectangle {
    id: nodeView

    /* Property Declarations
     * ****************************************************************************************/
    property Node   node

    property Scene  scene

    property SceneSession sceneSession

    property var    downstreamNodes: []

    property bool   edit:            textArea.activeFocus

    property bool   isSelected:      false

    property bool   locked:          false

    /* Object Properties
     * ****************************************************************************************/
    width: node.guiConfig.width
    height: node.guiConfig.height
    x: node.guiConfig.position.x
    y: node.guiConfig.position.y
    color: Qt.darker(node.guiConfig.color, 10)
    border.color: locked ? "gray" : Qt.lighter(node.guiConfig.color, nodeView.isSelected ? 1.2 : 1)
    border.width: nodeView.isSelected ? 3 : 2
    opacity: nodeView.isSelected ? 1 : 0.8
    z: locked ? 1 : (isSelected ? 3 : 2)
    radius: 10
    smooth: true
    antialiasing: true
    layer.enabled: false


    /* Signals
     * ****************************************************************************************/
    signal clicked();


    onEditChanged: {
        if (nodeView.edit) {
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
            onTextChanged: {
                if (node && node.title !== text)
                    node.title = text;
            }
            smooth: true
            antialiasing: true
            font.bold: true
            background: Rectangle {
                color: "transparent";
            }

            onActiveFocusChanged:
                if (!activeFocus)
                    nodeView.edit = false
        }
    }

    NodeTools {
        id: nodeTools
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 5
        opacity: isSelected ? 1.0 : 0.0
        scene: nodeView.scene

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
        enabled: !nodeView.edit

        onDoubleClicked: {
            nodeView.edit = true;
        }

        cursorShape: (nodeMouseArea.containsMouse && !nodeView.edit)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor

        onPressed: (mouse) => {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
            nodeView.clicked();
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

    //! todo: encapsulate these mouse areas
    //! Top Side Mouse Area
    MouseArea {
        id: topPortsMouseArea
        width: parent.width
        hoverEnabled: true
        height: 20
        cursorShape: Qt.SizeVerCursor
        anchors.top: parent.top
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaY = mouse.y - prevY;
                node.guiConfig.position.y += deltaY;
                node.guiConfig.height -= deltaY
                prevY = mouse.y - deltaY;
            }
        }
    }

    //! Bottom Side Mouse Area
    MouseArea {
        id: bottomPortsMouseArea
        width: parent.width
        hoverEnabled: true
        height: 20
        cursorShape: Qt.SizeVerCursor
        anchors.bottom: parent.bottom
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
                               console.log("bottom side " + mouseX)
            if (isDraging) {
                var deltaY = mouse.y - prevY;
                node.guiConfig.height += deltaY
                prevY = mouse.y - deltaY;
            }
        }
    }

    //! Left Side Mouse Area
    MouseArea {
        id: leftPortsMouseArea
        width: 20
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
        }

        onReleased: {
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.position.x += deltaX;
                node.guiConfig.width -= deltaX
                prevX = mouse.x - deltaX;
            }
        }
    }

    //! Right Side Mouse Area
    MouseArea {
        id: rightPortsMouseArea
        width: 20
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0

        onPressed: (mouse)=> {
                       console.log("node view pressed!");
            isDraging = true;
            prevX = mouse.x;
        }

        onReleased: {
            console.log("node view released!");
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
            }
        }
    }


    //! Top Ports
    Row {
        id: topRow
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top);
            delegate: PortView {
                port: modelData
                flickable: flickable
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: topPortsMouseArea.containsMouse ? 1 : 0
                globalX: nodeView.x + topRow.x + mapToItem(topRow, Qt.point(x, y)).x
                globalY: nodeView.y + topRow.y + mapToItem(topRow, Qt.point(x, y)).y
            }
        }
    }


    //! Left Ports
    Column {
        id: leftColumn
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left);
            delegate: PortView {
                port: modelData
                flickable: flickable
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: leftPortsMouseArea.containsMouse ? 1 : 0
                globalX: nodeView.x + leftColumn.x + mapToItem(leftColumn, Qt.point(x, y)).x
                globalY: nodeView.y + leftColumn.y + mapToItem(leftColumn, Qt.point(x, y)).y
            }
        }
    }

    //! Right Ports
    Column {
        id: rightColumn
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right);
            delegate: PortView {
                port: modelData
                flickable: flickable
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: rightPortsMouseArea.containsMouse ? 1 : 0
                globalX: nodeView.x + rightColumn.x + mapToItem(rightColumn, Qt.point(x, y)).x
                globalY: nodeView.y + rightColumn.y + mapToItem(rightColumn, Qt.point(x, y)).y
            }
        }
    }

    //! Bottom Ports
    Row {
        id: bottomRow
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5          // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom);
            delegate: PortView {
                port: modelData
                flickable: flickable
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: bottomPortsMouseArea.containsMouse ? 1 : 0
                globalX: nodeView.x + bottomRow.x + mapToItem(bottomRow, Qt.point(x, y)).x
                globalY: nodeView.y + bottomRow.y + mapToItem(bottomRow, Qt.point(x, y)).y
            }
        }
    }

    //!Locks the node
    MouseArea {
        anchors.fill: parent
        anchors.margins: -10
        enabled: locked
        onClicked: nodeView.clicked()
        z: locked? 10 : -1
    }
}
