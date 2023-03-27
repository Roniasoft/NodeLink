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

    property int    contentWidth

    property int    contentHeight

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

    Behavior on color {ColorAnimation {duration:100}}
    Behavior on border.color {ColorAnimation {duration:100}}


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
        focus: true
        clip : true
        hoverEnabled: true

        ScrollBar.vertical: ScrollBar {
            id: scrollerV
            policy: ScrollBar.AsNeeded
            x: view.mirrored ? 0 : view.width - width
            y: view.topPadding - 15
            minimumSize: 0.1
            contentItem: Rectangle {
                implicitHeight: view.height // doesn't change anything.
                implicitWidth: 4
                radius: 5
                color: scrollerV.hovered ? "#7f7f7f" : "#4b4b4b"
            }
            background: Rectangle {
                implicitWidth: 4
                color: "black"
                opacity: 0.8
            }
        }
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
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

    //! Node Tools (Node settings)
    NodeToolsRect {
        id: nodeTools
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 5
        opacity: isSelected ? 1.0 : 0.0
        scene: nodeView.scene
        node: nodeView.node

        //! To hide color picker if selected node is changed
        Connections {
            target: nodeView
            function onIsSelectedChanged() {
                nodeTools.colorPicker.visible = false
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
        hoverEnabled: true
        preventStealing: true
        enabled: !nodeView.edit && !sceneSession.connectingMode

        onDoubleClicked: {
            nodeView.edit = true;
        }

        cursorShape: (nodeMouseArea.containsMouse && !nodeView.edit)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse) => {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
            nodeView.clicked();
        }

        onReleased: (mouse) => {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;
                var deltaY = mouse.y - prevY;
                node.guiConfig.position.y += deltaY;
                if(NLStyle.snapEnabled){
                    node.guiConfig.position.y =  Math.ceil(node.guiConfig.position.y / 20) * 20;
                    node.guiConfig.position.x =  Math.ceil(node.guiConfig.position.x / 20) * 20;
                }
                node.guiConfig.positionChanged();
                prevY = mouse.y - deltaY;
                if(((node.guiConfig.position.x) < 0 && deltaX < 0)   ||
                   ((node.guiConfig.position.x + node.guiConfig.width ) > contentWidth) && deltaX > 0||
                   ((node.guiConfig.position.y) < 0 && deltaY < 0)   ||
                   ((node.guiConfig.position.y + node.guiConfig.height) > contentHeight) && deltaY > 0)
                    isDraging = false;
            }
        }

    }

    //! todo: encapsulate these mouse areas
    //! Top Side Mouse Area
    MouseArea {
        id: topPortsMouseArea
        width: parent.width
        hoverEnabled: true
        enabled: !sceneSession.connectingMode
        height: 20
        cursorShape: Qt.SizeVerCursor
        anchors.top: parent.top
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevY:      0

        onClicked: sceneSession.tempInputPort = null;
        onPressed: (mouse)=> {
            isDraging = true;
            prevY = mouse.y;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaY = mouse.y - prevY;
                node.guiConfig.position.y += deltaY;
                node.guiConfig.height -= deltaY;
                prevY = mouse.y - deltaY;
                if(node.guiConfig.height < 70){
                    node.guiConfig.height = 70;
                    if(deltaY>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //! Bottom Side Mouse Area
    MouseArea {
        id: bottomPortsMouseArea
        width: parent.width
        hoverEnabled: true
        height: 20
        enabled: !sceneSession.connectingMode
        cursorShape: Qt.SizeVerCursor
        anchors.bottom: parent.bottom
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevY:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevY = mouse.y;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaY = mouse.y - prevY;
                node.guiConfig.height += deltaY;
                prevY = mouse.y - deltaY;
                if(node.guiConfig.height <= 70){
                    node.guiConfig.height = 70
                }
            }
        }
    }

    //! Left Side Mouse Area
    MouseArea {
        id: leftPortsMouseArea
        width: 20
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: !sceneSession.connectingMode
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.position.x += deltaX;
                node.guiConfig.width -= deltaX
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                    if(deltaX>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //! Right Side Mouse Area
    MouseArea {
        id: rightPortsMouseArea
        width: 12
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: !sceneSession.connectingMode
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                }
            }
        }
    }

    //!upper right sizing area
    MouseArea {
        id: rightTopCornerMouseArea
        width: 20
        height: 20
        enabled: !sceneSession.connectingMode
        cursorShape: Qt.SizeBDiagCursor
        hoverEnabled: true
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                }
                var deltaY = mouse.y - prevY
                node.guiConfig.position.y += deltaY;
                node.guiConfig.height -= deltaY;
                prevY = mouse.y - deltaY;
                if(node.guiConfig.height <= 70){
                    node.guiConfig.height = 70
                    if(deltaY>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //!lower right sizing area
    MouseArea {
        id: rightDownCornerMouseArea
        width: 20
        height: 20
        enabled: !sceneSession.connectingMode
        cursorShape: Qt.SizeFDiagCursor
        hoverEnabled: true
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                }
                var deltaY = mouse.y - prevY
                node.guiConfig.height += deltaY;
                prevY = mouse.y - deltaY;
                if(node.guiConfig.height <= 70){
                    node.guiConfig.height = 70
                }
            }
        }
    }

    //!upper left sizing area
    MouseArea {
        id: leftTopCornerMouseArea
        width: 20
        height: 20
        enabled: !sceneSession.connectingMode
        cursorShape: Qt.SizeFDiagCursor
        hoverEnabled: true
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.width -= deltaX
                node.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                    if(deltaX>0){
                        isDraging = false
                    }
                }
                var deltaY = mouse.y - prevY
                node.guiConfig.position.y += deltaY;
                node.guiConfig.height -= deltaY;
                prevY = mouse.y - deltaY;
                if(node.guiConfig.height <= 70){
                    node.guiConfig.height = 70
                    if(deltaY>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //!lower left sizing area
    MouseArea {
        id: leftDownCornerMouseArea
        width: 20
        height: 20
        enabled: !sceneSession.connectingMode
        cursorShape: Qt.SizeBDiagCursor
        hoverEnabled: true
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onClicked: sceneSession.tempInputPort = null;

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            sceneSession.tempInputPort = null;
            isDraging = false;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.width -= deltaX
                node.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                    if(deltaX>0){
                        isDraging = false
                    }
                }
                var deltaY = mouse.y - prevY
                node.guiConfig.height += deltaY;
                prevY = mouse.y - deltaY;
                if(node.guiConfig.height <= 70){
                    node.guiConfig.height = 70
                }
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
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (topPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid])? 1 : 0
                globalX: nodeView.x + topRow.x + x + NLStyle.portView.size / 2
                globalY: nodeView.y + topRow.y + mapToItem(topRow, Qt.point(x, y)).y + NLStyle.portView.size / 2
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
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (leftPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid])? 1 : 0
                globalX: nodeView.x + leftColumn.x + mapToItem(leftColumn, Qt.point(x, y)).x + NLStyle.portView.size / 2
                globalY: nodeView.y + leftColumn.y + y + NLStyle.portView.size / 2
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
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (rightPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid]) ? 1 : 0
                globalX: nodeView.x + rightColumn.x + mapToItem(rightColumn, Qt.point(x, y)).x + NLStyle.portView.size / 2
                globalY: nodeView.y + rightColumn.y + y + NLStyle.portView.size / 2
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
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (bottomPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid]) ? 1 : 0
                globalX: nodeView.x + bottomRow.x + x + NLStyle.portView.size / 2
                globalY: nodeView.y + bottomRow.y + mapToItem(bottomRow, Qt.point(x, y)).y + NLStyle.portView.size / 2
            }
        }
    }

    //!Locks the node
    MouseArea {
        anchors.fill: parent
        anchors.margins: -10
        enabled: locked
        onClicked: nodeView.clicked()
        visible: locked
    }
}
