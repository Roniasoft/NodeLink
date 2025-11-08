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


    //! Auto size properties (these will be set by the derived nodeview)
    property bool autoSize: true
    property int minWidth: 100
    property int minHeight: 70
    property int calculatedMinWidth: minWidth
    property int calculatedMinHeight: minHeight


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

    //! Top Side Mouse Area - Updated with minimum size enforcement
    MouseArea {
        id: topMouseArea
        width: parent.width
        hoverEnabled: true
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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

                var newHeight = node.guiConfig.height - correctedDeltaY;
                var newY = node.guiConfig.position.y + correctedDeltaY;

                // Enforce minimum height
                var minHeight = root.autoSize ? root.calculatedMinHeight : root.minHeight;
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    correctedDeltaY = node.guiConfig.height - minHeight;
                }

                node.guiConfig.position.y += correctedDeltaY;
                node.guiConfig.height = newHeight;
                prevY = mouse.y - deltaY;
            }
        }
    }

    //! Bottom Side Mouse Area - Updated with minimum size enforcement
    MouseArea {
        id: bottomMouseArea
        width: parent.width
        hoverEnabled: true
        height: 20
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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
                var newHeight = node.guiConfig.height + deltaY;

                // Enforce minimum height
                if (root.autoSize) {
                    newHeight = Math.max(newHeight, root.calculatedMinHeight);
                } else {
                    newHeight = Math.max(newHeight, root.minHeight);
                }

                node.guiConfig.height = newHeight;
                prevY = mouse.y - deltaY;
            }
        }
    }

    //! Left Side Mouse Area
    MouseArea {
        id: leftMouseArea
        width: 20
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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

                var newWidth = node.guiConfig.width - correctedDeltaX;
                var newX = node.guiConfig.position.x + correctedDeltaX;

                // Only enforce minimum size when autoSize is enabled
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.minWidth;
                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    correctedDeltaX = node.guiConfig.width - minWidth;
                }

                node.guiConfig.position.x += correctedDeltaX;
                node.guiConfig.width = newWidth;
                prevX = mouse.x - deltaX;
            }
        }
    }

    //! Right Side Mouse Area - Updated to allow smaller sizes when autoSize is false
    MouseArea {
        id: rightMouseArea
        width: 12
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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
                var newWidth = node.guiConfig.width + deltaX;

                // Only enforce minimum size when autoSize is enabled
                if (root.autoSize) {
                    newWidth = Math.max(newWidth, root.calculatedMinWidth);
                } else {
                    // When autoSize is false, allow smaller sizes but enforce absolute minimum
                    newWidth = Math.max(newWidth, root.minWidth);
                }

                node.guiConfig.width = newWidth;
                prevX = mouse.x - deltaX;
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
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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
                var deltaY = mouse.y - prevY;

                var newWidth = node.guiConfig.width + deltaX;
                var newHeight = node.guiConfig.height - deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.minWidth;
                var minHeight = root.autoSize ? root.calculatedMinHeight : root.minHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = newWidth - node.guiConfig.width;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = node.guiConfig.height - newHeight;
                }

                node.guiConfig.width = newWidth;
                node.guiConfig.position.y += deltaY;
                node.guiConfig.height = newHeight;

                prevX = mouse.x - deltaX;
                prevY = mouse.y - deltaY;
            }
        }
    }

    //! Lower right sizing area
    MouseArea {
        id: rightDownCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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
                var deltaY = mouse.y - prevY;

                var newWidth = node.guiConfig.width + deltaX;
                var newHeight = node.guiConfig.height + deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.minWidth;
                var minHeight = root.autoSize ? root.calculatedMinHeight : root.minHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = newWidth - node.guiConfig.width;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = newHeight - node.guiConfig.height;
                }

                node.guiConfig.width = newWidth;
                node.guiConfig.height = newHeight;

                prevX = mouse.x - deltaX;
                prevY = mouse.y - deltaY;
            }
        }
    }

    //! Upper left sizing area
    MouseArea {
        id: leftTopCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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
                var deltaY = mouse.y - prevY;

                var newWidth = node.guiConfig.width - deltaX;
                var newHeight = node.guiConfig.height - deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.minWidth;
                var minHeight = root.autoSize ? root.calculatedMinHeight : root.minHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = node.guiConfig.width - minWidth;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = node.guiConfig.height - minHeight;
                }

                node.guiConfig.position.x += deltaX;
                node.guiConfig.width = newWidth;
                node.guiConfig.position.y += deltaY;
                node.guiConfig.height = newHeight;

                prevX = mouse.x - deltaX;
                prevY = mouse.y - deltaY;
            }
        }
    }


    //! Lower left sizing area
    MouseArea {
        id: leftDownCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && sceneSession && !sceneSession.connectingMode
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
                var deltaY = mouse.y - prevY;

                var newWidth = node.guiConfig.width - deltaX;
                var newHeight = node.guiConfig.height + deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.minWidth;
                var minHeight = root.autoSize ? root.calculatedMinHeight : root.minHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = node.guiConfig.width - minWidth;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = newHeight - node.guiConfig.height;
                }

                node.guiConfig.position.x += deltaX;
                node.guiConfig.width = newWidth;
                node.guiConfig.height = newHeight;

                prevX = mouse.x - deltaX;
                prevY = mouse.y - deltaY;
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
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2
        spacing: 5

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession
                // Pass the actual node width
                nodeWidth: root.width

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
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2
        spacing: 5

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession
                // Pass the actual node width
                nodeWidth: root.width

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
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2
        spacing: 5

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession
                // Pass the actual node width
                nodeWidth: root.width

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
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - root.border.width) / 2
        spacing: 5

        Repeater {
            model: (!isContainer) ? Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom) : [];
            delegate: PortView {
                port: modelData
                scene: root.scene
                sceneSession: root.sceneSession
                // Pass the actual node width
                nodeWidth: root.width

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
