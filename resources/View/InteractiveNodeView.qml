import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import NodeLink

I_NodeView {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    //! Node is selected or not
    property bool isSelected: scene?.selectionModel?.isSelected(node?._qsUuid ?? "") ?? false

    //! A node is resizeable or not
    property bool isResizable: true

    //! A node is editable or not
    property bool         isNodeEditable: !node.guiConfig.locked && (sceneSession?.isSceneEditable ?? true)


    //! Does the top/ bottom/ right / left borders have mouse?
    //! Note: Other MouseArea properties are not allowed.
    property bool         topBorderContainsMouse:    topMouseArea.containsMouse
    property bool         bottomBorderContainsMouse: bottomMouseArea.containsMouse
    property bool         leftBorderContainsMouse:   leftMouseArea.containsMouse
    property bool         rightBorderContainsMouse:  rightMouseArea.containsMouse

    /* Object Properties
    * ****************************************************************************************/

    color: Qt.darker(node.guiConfig.color, 10)
    border.color: node.guiConfig.locked ? NLStyle.node.borderLockColor : Qt.lighter(node.guiConfig.color, isSelected ? 1.2 : 1)
    border.width: (isSelected ? (NLStyle.node.borderWidth + 1) : NLStyle.node.borderWidth)
    opacity: isSelected ? NLStyle.node.selectedOpacity : NLStyle.node.defaultOpacity

    // Z factor to manage node view order, maximum is 3
    z: node.guiConfig.locked ? 1 : (isSelected ? 3 : 2)
    radius: NLStyle.radiusAmount.nodeView

    /* Keys
    * ****************************************************************************************/

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if (!isSelected)
            return;

        if (!isNodeEditable) {
            infoPopup.open();
            return;
        }

        if (sceneSession.isDeletePromptEnable)
            deletePopup.open();
         else
            delTimer.start();
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
    //! Delete handlers
    //! *****************

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
        sceneSession: root.sceneSession
        onAccepted: delTimer.start();
    }

    //! Information of a process
    ConfirmPopUp {
        id: infoPopup

        confirmText: "Can not be deleted! either the scene or the node is not editable."
        sceneSession: root.sceneSession
        keyButtons: [MessageDialog.Ok]
    }


    //! Resize by sides
    //! *****************

    //! Top Side Mouse Area
    MouseArea {
        id: topMouseArea
        width: parent.width
        hoverEnabled: true
        enabled: isResizable && !sceneSession.connectingMode
        height: 20
        cursorShape: Qt.SizeVerCursor
        anchors.top: parent.top
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        //! Change visibility of top ports when contain mouse changed.
        onContainsMouseChanged: {
            if(!isContainer) {
                var topPorts = Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top).map(port => port._qsUuid);

                topPorts.forEach(qsUuid => {
                                      sceneSession.portsVisibility[qsUuid] = containsMouse;
                                  });

                sceneSession.portsVisibilityChanged();
            }
        }

        //! Resize properties
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
        id: bottomMouseArea
        width: parent.width
        hoverEnabled: true
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeVerCursor
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        //! Change visibility of bottom ports when contain mouse changed.
        onContainsMouseChanged: {
            if(!isContainer) {
                var bottomPorts = Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom).map(port => port._qsUuid);

                bottomPorts.forEach(qsUuid => {
                                      sceneSession.portsVisibility[qsUuid] = containsMouse;
                                  });

                sceneSession.portsVisibilityChanged();
            }
        }

        //! Resize properties
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
        id: leftMouseArea
        width: 20
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: isResizable && !sceneSession.connectingMode
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true

        //! Change visibility of left ports when contain mouse changed.
        onContainsMouseChanged: {
            if(!isContainer) {
                var leftPorts = Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left).map(port => port._qsUuid);

                leftPorts.forEach(qsUuid => {
                                      sceneSession.portsVisibility[qsUuid] = containsMouse;
                                  });

                sceneSession.portsVisibilityChanged();
            }
        }

        //! Resize properties
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
        id: rightMouseArea
        width: 12
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: isResizable && !sceneSession.connectingMode
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true

        //! Change visibility of right ports when contain mouse changed.
        onContainsMouseChanged: {
            if(!isContainer) {
                var rightPorts = Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right).map(port => port._qsUuid);

                rightPorts.forEach(qsUuid => {
                                      sceneSession.portsVisibility[qsUuid] = containsMouse;
                                  });

                sceneSession.portsVisibilityChanged();
            }
        }

        //! Resize properties
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

    //! Resize by corners
    //! *****************

    //! Upper right sizing area
    MouseArea {
        id: rightTopCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
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
        enabled: isResizable && !sceneSession.connectingMode
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
        enabled: isResizable && !sceneSession.connectingMode
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
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeBDiagCursor
        hoverEnabled: true
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        //! Movment properties
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

    //! Manage ports (View and interactions)
    //! ************************************

    //! Top Ports
    Row {
        id: topRowPort
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(topRowPort.x + x + NLStyle.portView.size / 2,
                                                              topRowPort.y + y + NLStyle.portView.size / 2)

                globalX: root.x + positionMapped.x
                globalY: root.y + positionMapped.y
            }
        }
    }

    //! Left Ports
    Column {
        id: leftColumnPort
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(leftColumnPort.x + x + NLStyle.portView.size / 2,
                                                     leftColumnPort.y + y + NLStyle.portView.size / 2)

                globalX: root.x + positionMapped.x
                globalY: root.y + positionMapped.y
            }
        }
    }

    //! Right Ports
    Column {
        id: rightColumnPort
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(rightColumnPort.x + x + NLStyle.portView.size / 2,
                                                              rightColumnPort.y + y + NLStyle.portView.size / 2)

                globalX: root.x + positionMapped.x
                globalY: root.y + positionMapped.y
            }
        }
    }

    //! Bottom Ports
    Row {
        id: bottomRowPort
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5          // this can also be defined in the style file

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(bottomRowPort.x + x + NLStyle.portView.size / 2,
                                                              bottomRowPort.y + y + NLStyle.portView.size / 2)

                globalX: root.x + positionMapped.x
                globalY: root.y + positionMapped.y
            }
        }
    }

    /* Functions
    * ****************************************************************************************/
    //! Handle dimension change
    function dimensionChanged(containsNothing) {
        if(root.isSelected)
            scene?.selectionModel?.selectedObjectChanged();
        else if (!containsNothing) {
            scene?.selectionModel?.clearAllExcept(node._qsUuid)
            scene?.selectionModel?.selectNode(node)
        }
    }
}
