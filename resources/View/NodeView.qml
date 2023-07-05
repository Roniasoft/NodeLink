import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Layouts

/*! ***********************************************************************************************
 * This class show node ui.
 * ************************************************************************************************/
Rectangle {
    id: nodeView

    /* Property Declarations
     * ****************************************************************************************/
    property Node           node

    property Scene          scene

    property SceneSession   sceneSession

    property bool           edit

    property bool           isSelected:      false

    property real fontScale: {
        var checkParam = Math.floor(Math.abs(sceneSession.zoomManager.zoomFactor - 1) * 100 / 15);

        if(checkParam => 1)
            return sceneSession.zoomManager.zoomFactor;
        else
            return fontScale;

    }


    //! Correct position based on zoomPoint and zoomFactor
    property vector2d correctedPosition: node.guiConfig?.position?.
                                         times(sceneSession.zoomManager.zoomFactor)

    /* Object Properties
     * ****************************************************************************************/
    width: node.guiConfig.width * sceneSession.zoomManager.zoomFactor
    height: node.guiConfig.height * sceneSession.zoomManager.zoomFactor
    x: correctedPosition.x
    y: correctedPosition.y

    color: Qt.darker(node.guiConfig.color, 10)
    border.color: node.guiConfig.locked ? "gray" : Qt.lighter(node.guiConfig.color, nodeView.isSelected ? 1.2 : 1)
    border.width: (nodeView.isSelected ? 3 : 2) * sceneSession.zoomManager.zoomFactor
    opacity: nodeView.isSelected ? 1 : 0.8
    z: node.guiConfig.locked ? 1 : (isSelected ? 3 : 2)
    radius: 10
    smooth: true
    antialiasing: true
    layer.enabled: false


    Behavior on color {ColorAnimation {duration:100}}
    Behavior on border.color {ColorAnimation {duration:100}}


    /* Signals
     * ****************************************************************************************/

    //! When node is selected, width, height, x, and y
    //! changed must be sent into rubber band
    onWidthChanged: dimensionChanged();
    onHeightChanged: dimensionChanged();

    onXChanged: dimensionChanged();
    onYChanged: dimensionChanged();

    onEditChanged: {
        nodeView.edit ? titleTextArea.forceActiveFocus() :  nodeView.forceActiveFocus()
    }

    onIsSelectedChanged: {
        //! Current nodeView keep the focus, current focus handle in the upper layers.
        nodeView.forceActiveFocus();
        if(!nodeView.isSelected )
            nodeView.edit = false;

    }

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if(nodeView.isSelected)
            deletePopup.open();
    }

    //! Use Key to manage shift pressed to handle multiObject selection
    Keys.onPressed: (event)=> {
        if (event.key === Qt.Key_Shift)
            sceneSession.isShiftModifierPressed = true;
    }

    Keys.onReleased: (event)=> {
        if (event.key === Qt.Key_Shift)
            sceneSession.isShiftModifierPressed = false;
    }

    /* Children
    * ****************************************************************************************/
    //! Delete node
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: {
            scene.deleteSelectedObjects();
        }
    }

    //! Delete popup to confirm deletion process
    ConfirmPopUp {
        id: deletePopup
        confirmText: "Are you sure you want to delete " +
                                     (Object.keys(scene.selectionModel.selectedModel).length > 1 ?
                                         "these items?" : "this item?");
        sceneSession: nodeView.sceneSession
        onAccepted: delTimer.start();
    }

    //! Header Item
    Item {
        id: titleItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 12
        height: 20 * (fontScale >= 1.0 ? fontScale : 0.8)

        //! Icon
        Text {
            id: iconText
            font.family: "Font Awesome 6 Pro"
            font.pixelSize: 20 * fontScale
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: NLStyle.nodeIcons[node.type]
            color: node.guiConfig.color
            font.weight: 400
        }

        //! Title Text
        TextArea {
            id: titleTextArea

            anchors.right: parent.right
            anchors.left: iconText.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5
            height: 40 * (fontScale >= 0.95 ? fontScale : 0.8)

            rightPadding: 10

            readOnly: !nodeView.edit
            focus: false
            placeholderText: qsTr("Enter title")
            selectByMouse: true
            text: node.title
            verticalAlignment: Text.AlignVCenter
            onTextChanged: {
                if (node && node.title !== text)
                    node.title = text;
            }

            onPressed: (event) => {
                if (event.button === Qt.RightButton) {
                    nodeView.edit = false
                    nodeMouseArea.clicked(event)
                }
            }

            smooth: true
            antialiasing: true
            font.pointSize: 10 * fontScale
            font.bold: true
        }
    }

    //! ScrollView to manage scroll view in Text Area
    ScrollView {
        id: view

        anchors.top: titleItem.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 12
        anchors.topMargin: 5 * fontScale

        hoverEnabled: true
        clip: true
        focus: true

        ScrollBar.vertical: ScrollBar {
            id: scrollerV
            parent: view.parent
            anchors.top: view.top
            anchors.right: view.right
            anchors.bottom: view.bottom
            width: 5
            anchors.rightMargin: 1
        }

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        // Description Text
        TextArea {
            id: textArea

            focus: false
            placeholderText: qsTr("Enter description")
            color: "white"
            text: node.guiConfig.description
            readOnly: !nodeView.edit
            wrapMode:TextEdit.WrapAnywhere
            onTextChanged: {
                if (node && node.guiConfig.description !== text)
                    node.guiConfig.description = text;
            }
            smooth: true
            antialiasing: true
            font.bold: true
            font.pointSize: 9 * fontScale

            onPressed: (event) => {
                if (event.button === Qt.RightButton) {
                    nodeView.edit = false;
                    nodeMouseArea.clicked(event);
                }
            }
            background: Rectangle {
                color: "transparent";
            }
        }
    }


    //! Manage node selection and position change.
    MouseArea {
        id: nodeMouseArea

        property real    prevX:      node.guiConfig.position.x  * sceneSession.zoomManager.zoomFactor
        property real    prevY:      node.guiConfig.position.y * sceneSession.zoomManager.zoomFactor
        property bool   isDraging:  false

        anchors.fill: parent
        anchors.margins: 10
        hoverEnabled: true
        preventStealing: true
        enabled: !nodeView.edit && !sceneSession.connectingMode &&
                 !node.guiConfig.locked && !sceneSession.isCtrlPressed

        // To hide cursor when is disable
        visible: enabled

        onDoubleClicked: (mouse) => {
            // Clear all selected nodes
            scene.selectionModel.clearAllExcept(node._qsUuid);

            // Select current node
            scene.selectionModel.select(node);

            // Enable edit mode
            nodeView.edit = true;
            isDraging = false;
        }

        cursorShape: (nodeMouseArea.containsMouse && !nodeView.edit)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor


        //! Manage right and left click to select and
        //! show node contex menue.
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                // Ensure the isDraging is false.
                isDraging = false;

                // Clear all selected nodes
                scene.selectionModel.clearAllExcept(node._qsUuid);

                // Select current node
                scene.selectionModel.select(node);

                nodeContextMenu.popup(mouse.x, mouse.y);
            }
        }

        onPressed: (mouse) => {
            isDraging = true;
            prevX = mouse.x * sceneSession.zoomManager.zoomFactor;
            prevY = mouse.y * sceneSession.zoomManager.zoomFactor;
            _selectionTimer.start();
        }

        onReleased: (mouse) => {
            isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (isDraging) {
                var deltaX = mouse.x *  sceneSession.zoomManager.zoomFactor - prevX;
                node.guiConfig.position.x += deltaX / sceneSession.zoomManager.zoomFactor;
                prevX = mouse.x * sceneSession.zoomManager.zoomFactor - deltaX;
                var deltaY = mouse.y * sceneSession.zoomManager.zoomFactor - prevY;
                node.guiConfig.position.y += deltaY / sceneSession.zoomManager.zoomFactor;
                if(NLStyle.snapEnabled){
                    node.guiConfig.position.y =  Math.ceil(node.guiConfig.position.y / 20) * 20;
                    node.guiConfig.position.x =  Math.ceil(node.guiConfig.position.x / 20) * 20;
                }
                node.guiConfig.positionChanged();
                prevY = mouse.y * sceneSession.zoomManager.zoomFactor - deltaY;

                if((node.guiConfig.position.x < 0  && deltaX < 0) ||
                   (node.guiConfig.position.y < 0 && deltaY < 0))
                                 isDraging = false;

                 if (node.guiConfig.position.x + node.guiConfig.width > sceneSession.contentWidth && deltaX > 0)
                                 sceneSession.contentWidth += deltaX;

                 if(node.guiConfig.position.y + node.guiConfig.height > sceneSession.contentHeight && deltaY > 0)
                                 sceneSession.contentHeight += deltaY;
            }
        }

        NodeContextMenu {
            id: nodeContextMenu
            scene: nodeView.scene
            sceneSession: nodeView.sceneSession
            node: nodeView.node
            onEditNode: nodeView.edit = true;
        }

        //! Timer to manage pressed and clicked  events.
        //! They should be avoided at the same time
        Timer {
            id: _selectionTimer

            interval: 100
            repeat: false
            running: false

            onTriggered: {
                // Clear selection model when Shift key not pressed.
                const isModifiedOn = sceneSession.isShiftModifierPressed;

                if(!isModifiedOn)
                     scene.selectionModel.clearAllExcept(node._qsUuid);

                const isAlreadySel = scene.selectionModel.isSelected(node._qsUuid);
                // Select current node
                if(isAlreadySel && isModifiedOn)
                    scene.selectionModel.remove(node._qsUuid);
                else
                    scene.selectionModel.select(node);
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
                var correctedDeltaY = Math.floor(deltaY);

                node.guiConfig.position.y += correctedDeltaY;
                node.guiConfig.height -= correctedDeltaY;
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
        anchors.bottomMargin: -10
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
        property real    prevX:      0

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
                var correctedDeltaX = Math.floor(deltaX);

                node.guiConfig.position.x += correctedDeltaX;
                node.guiConfig.width -= correctedDeltaX;
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
                node.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(node.guiConfig.width < 100){
                    node.guiConfig.width = 100
                }
            }
        }
    }

    //! Upper right sizing area
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

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
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

    //! Lower right sizing area
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

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
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

    //! Upper left sizing area
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

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
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

    //! Lower left sizing area
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

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
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
        anchors.margins: -(NLStyle.portView.size * sceneSession.zoomManager.zoomFactor + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (topPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid])? 1 : 0
                globalX: nodeView.x + topRow.x + x + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
                globalY: nodeView.y + topRow.y + mapToItem(topRow, Qt.point(x, y)).y + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
            }
        }
    }

    //! Left Ports
    Column {
        id: leftColumn
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size * sceneSession.zoomManager.zoomFactor + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (leftPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid])? 1 : 0
                globalX: nodeView.x + leftColumn.x + mapToItem(leftColumn, Qt.point(x, y)).x + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
                globalY: nodeView.y + leftColumn.y + y + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
            }
        }
    }

    //! Right Ports
    Column {
        id: rightColumn
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size * sceneSession.zoomManager.zoomFactor+ NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (rightPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid]) ? 1 : 0
                globalX: nodeView.x + rightColumn.x + mapToItem(rightColumn, Qt.point(x, y)).x + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
                globalY: nodeView.y + rightColumn.y + y + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
            }
        }
    }

    //! Bottom Ports
    Row {
        id: bottomRow
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size * sceneSession.zoomManager.zoomFactor + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5          // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (bottomPortsMouseArea.containsMouse || sceneSession.portsVisibility[modelData._qsUuid]) ? 1 : 0
                globalX: nodeView.x + bottomRow.x + x + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
                globalY: nodeView.y + bottomRow.y + mapToItem(bottomRow, Qt.point(x, y)).y + NLStyle.portView.size / 2 * sceneSession.zoomManager.zoomFactor
            }
        }
    }

    //!Locks the node
    MouseArea {
        anchors.fill: parent
        anchors.margins: -10
        enabled: node.guiConfig.locked
        onClicked: _selectionTimer.start();
        visible: node.guiConfig.locked
    }

    //! Reset some properties when selection model changed.
    Connections {
        target: scene.selectionModel

        function onSelectedModelChanged() {
            if(!scene.selectionModel.isSelected(node._qsUuid))
                nodeView.edit = false;
        }
    }


    /* Functions
     * ****************************************************************************************/

    //! Handle dimension change
    function dimensionChanged() {
        if(nodeView.isSelected)
            scene.selectionModel.selectedObjectChanged();
    }
}
