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


    // Provide defaults that bind to model with fallbacks
    property bool autoSize: node?.guiConfig?.autoSize ?? true
    property int minWidth: node?.guiConfig?.minWidth ?? 100
    property int minHeight: node?.guiConfig?.minHeight ?? 70
    property int baseContentWidth: node?.guiConfig?.baseContentWidth ?? 100

    //! Dynamic port spacing properties
    property int minPortSpacing: 2  // Minimum space between ports
    property int maxPortSpacing: 200 // Maximum space between ports
    property int basePortHeight: 24 // Height per port including some margin
    property int cornerHandleSpace: 50;// Reserve space for corner resize handles (20px top and bottom)

    // Calculated properties - these are view-only
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
                                     (Object.keys(scene?.selectionModel?.selectedModel ?? {}).length > 1 ?
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

                var newHeight = root.node.guiConfig.height - correctedDeltaY;

                var minHeight = root.calculatedMinHeight;

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

                var newHeight = root.node.guiConfig.height + deltaY;

                var minHeight = root.calculatedMinHeight ;

                if (newHeight < minHeight) {
                    newHeight = minHeight;
                }

                root.node.guiConfig.height = newHeight;
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

                var newWidth = root.node.guiConfig.width - correctedDeltaX;

                var minWidth = root.autoSize ? root.calculatedMinWidth : root.node.guiConfig.minWidth;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    correctedDeltaX = root.node.guiConfig.width - minWidth;
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

                var newWidth = root.node.guiConfig.width + deltaX;

                var minWidth = root.autoSize ? root.calculatedMinWidth : root.node.guiConfig.minWidth;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
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

                var newWidth = root.node.guiConfig.width + deltaX;
                var newHeight = root.node.guiConfig.height - deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.node.guiConfig.minWidth;
                var minHeight = root.calculatedMinHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = newWidth - root.node.guiConfig.width;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = root.node.guiConfig.height - newHeight;
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

                var newWidth = root.node.guiConfig.width + deltaX;
                var newHeight = node.guiConfig.height + deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.node.guiConfig.minWidth;
                var minHeight = root.calculatedMinHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = newWidth - root.node.guiConfig.width;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = newHeight - root.node.guiConfig.height;
                }

                root.node.guiConfig.width = newWidth;
                root.node.guiConfig.height = newHeight;

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

                var newWidth = root.node.guiConfig.width - deltaX;
                var newHeight = root.node.guiConfig.height - deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.node.guiConfig.minWidth;
                var minHeight = root.calculatedMinHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = root.node.guiConfig.width - minWidth;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = root.node.guiConfig.height - minHeight;
                }

                root.node.guiConfig.position.x += deltaX;
                root.node.guiConfig.width = newWidth;
                root.node.guiConfig.position.y += deltaY;
                root.node.guiConfig.height = newHeight;

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

                var newWidth = root.node.guiConfig.width - deltaX;
                var newHeight = root.node.guiConfig.height + deltaY;

                // Enforce minimum dimensions
                var minWidth = root.autoSize ? root.calculatedMinWidth : root.node.guiConfig.minWidth;
                var minHeight = root.calculatedMinHeight;

                if (newWidth < minWidth) {
                    newWidth = minWidth;
                    deltaX = root.node.guiConfig.width - minWidth;
                }
                if (newHeight < minHeight) {
                    newHeight = minHeight;
                    deltaY = newHeight - root.node.guiConfig.height;
                }

                root.node.guiConfig.position.x += deltaX;
                root.node.guiConfig.width = newWidth;
                root.node.guiConfig.height = newHeight;

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
        

        // Reserve space for corner handles
        anchors.topMargin: 20
        anchors.bottomMargin: 20

        spacing: calculateLeftPortSpacing()

        function calculateLeftPortSpacing() {
            var leftPortCount = Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left).length;
            return root.calculatePortSpacing(leftPortCount);
        }

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

        // Reserve space for corner handles
        anchors.topMargin: 20
        anchors.bottomMargin: 20

        spacing: calculateRightPortSpacing()

        function calculateRightPortSpacing() {
            var rightPortCount = Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right).length;
            return root.calculatePortSpacing(rightPortCount);
        }

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
    /* Connections for dynamic spacing
    * ****************************************************************************************/

    // Update port spacing when node height changes
    Connections {
        target: node.guiConfig
        function onHeightChanged() {
            // Trigger recalculation of port spacing
            leftColumnPort.spacing = leftColumnPort.calculateLeftPortSpacing();
            rightColumnPort.spacing = rightColumnPort.calculateRightPortSpacing();
        }
    }

    // Update port spacing when ports change
    Connections {
        target: node
        function onPortsChanged() {
            // Trigger recalculation of port spacing
            leftColumnPort.spacing = leftColumnPort.calculateLeftPortSpacing();
            rightColumnPort.spacing = rightColumnPort.calculateRightPortSpacing();

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

    //! Calculate optimal port spacing based on current node height and port count
    function calculatePortSpacing(portCount) {
        var availableHeight = node.guiConfig.height - (cornerHandleSpace  * 2);
        var totalPortsHeight = portCount * basePortHeight;
        var remainingSpace = availableHeight - totalPortsHeight;

        if (remainingSpace <= 0) return minPortSpacing;

        var calculatedSpacing = remainingSpace / (portCount - 1);
        return Math.max(minPortSpacing, Math.min(maxPortSpacing, calculatedSpacing));
    }

}
