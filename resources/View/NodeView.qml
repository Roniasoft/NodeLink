import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import NodeLink

/*! ***********************************************************************************************
 * This class show node ui.
 * ************************************************************************************************/
InteractiveNodeView {
    id: nodeView

    /* Property Declarations
     * ****************************************************************************************/
    property bool         edit

    //! Node is in minimal state or not (based in zoom factor)
    property bool         isNodeMinimal:  sceneSession?.zoomManager?.zoomFactor < sceneSession?.zoomManager?.minimalZoomNode

    //! nodeMouseArea
    //! Simply capture mouse area properties and avoid overwriting anything carelessly.
    //! such as onPositionChanged, onPressed and etc.
    property alias        mainMouseArea:  nodeMouseArea

    //! Node Context menu, required in image MouseArea
    property alias        nodeContextMenu: nodeContextMenu

    //! Dynamic port spacing properties
    property int minPortSpacing: 2  // Minimum space between ports
    property int maxPortSpacing: 200 // Maximum space between ports
    property int basePortHeight: 24 // Height per port including some margin
    property int cornerHandleSpace: 50;// Reserve space for corner resize handles (20px top and bottom)

    /* Object Properties
     * ****************************************************************************************/
    opacity: isSelected ? 1 : isNodeMinimal ? 0.6 : 0.8

    // Set initial size when node is created
    Component.onCompleted: {
        Qt.callLater(calculateOptimalSize);
    }

    /* Slots
     * ****************************************************************************************/
    signal mainMouseAreaClicked(event: var);

    /* Slots
     * ****************************************************************************************/

    onMainMouseAreaClicked: event => {
                                // Sanity check
                                if (event.button === Qt.RightButton) {
                                    edit = false;
                                    nodeMouseArea.clicked(event);
                                }
                            }


    onEditChanged: {

        // When Node is editting and zoomFactor is less than minimalZoomNode,
        // and need a node to be edit
        // The zoom will change to the minimum editable value
        if(nodeView.edit && nodeView.isNodeMinimal)
            sceneSession.zoomManager.zoomToNodeSignal(node, sceneSession.zoomManager.nodeEditZoom);

        if (!nodeView.edit)
             nodeView.forceActiveFocus();
    }

    onIsSelectedChanged: {
        //! Current nodeView keep the focus, current focus handle in the upper layers.
        nodeView.forceActiveFocus();
        if (!nodeView.isSelected)
            nodeView.edit = false;

    }

    /* Functions
     * ****************************************************************************************/

    // Called by PortView after it measured label widths.
    function requestRecalculateFromPort() {
        // debounce to next tick
        Qt.callLater(calculateOptimalSize)
    }

    //! Calculate optimal node size based on content and port titles - SYMMETRIC VERSION
    function calculateOptimalSize() {

        // Find the longest port title from BOTH left and right sides
        var maxTitleWidth = 0;

        // Check all ports (both left and right)
        Object.values(node.ports).forEach(function(port) {
            if (port.title) {
                var estimatedWidth = (typeof port._measuredTitleWidth === "number" && port._measuredTitleWidth > 0)
                                     ? port._measuredTitleWidth
                                     : estimateTextWidth(port.title)

                if (estimatedWidth > maxTitleWidth) {
                    maxTitleWidth = estimatedWidth;
                }
            }
        });

        // Symmetric formula: longest title + base content + longest title
        // This ensures both sides have equal space for titles
        var requiredWidth = Math.max(minWidth, (maxTitleWidth * 2) + baseContentWidth);

        // Calculate height based on number of ports - use the new function
        var requiredHeight = calculateRequiredHeight();

        // Update calculated minimum dimensions
        calculatedMinWidth = requiredWidth;
        calculatedMinHeight = requiredHeight;

        node.guiConfig.width = requiredWidth;
        node.guiConfig.height = requiredHeight;
    }

    //! Calculate required height based on number of ports with proper spacing
    function calculateRequiredHeight() {
        var leftPortCount = getPortCountBySide(NLSpec.PortPositionSide.Left);
        var rightPortCount = getPortCountBySide(NLSpec.PortPositionSide.Right);
        var maxPortCount = Math.max(leftPortCount, rightPortCount);

        var totalPortsHeight = maxPortCount * basePortHeight;

        // Calculate the height needed to achieve at least minPortSpacing between ports
        var requiredSpacingHeight = (maxPortCount - 1) * minPortSpacing;
        var requiredHeight = totalPortsHeight + requiredSpacingHeight + (cornerHandleSpace * 2);

        return Math.max(minHeight, requiredHeight);
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

    //! Get port count by side
    function getPortCountBySide(side) {
        return Object.values(node.ports).filter(function(port) {
            return port.portSide === side;
        }).length;
    }

    //! Estimate text width (simplified calculation)
    function estimateTextWidth(text) {
        if (!text) return 0;
        // Rough estimation: ~7 pixels per character for the font size used in ports
        // This accounts for the actual rendered width better
        return text.length * 7 + 15; // +15 for padding/margins
    }

    /* Children
    * ****************************************************************************************/

    //! contentItem, All things that are shown in a nodeView.
    //! Only show this Loader if contentItem is not set (i.e., use default contentItemComponent)
    //! If contentItem is set, I_NodeView's Loader will handle it
    Loader {
        id: contentLoader
        anchors.fill: parent
        active: (contentItem === null) && (nodeView.edit || nodeView.isSelected || !nodeView.isNodeMinimal)
        sourceComponent: contentItemComponent
    }

    Component {
        id: contentItemComponent
        Item {
            anchors.fill: parent

            // Header
            Item {
                id: titleItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12
                visible: !nodeView.isNodeMinimal
                height: 20

                Text {
                    id: iconText
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                }

                NLTextArea {
                    id: titleTextArea
                    anchors.right: parent.right
                    anchors.left: iconText.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: 40
                    rightPadding: 10
                    readOnly: !nodeView.edit
                    focus: false
                    placeholderText: qsTr("Enter title")
                    color: NLStyle.primaryTextColor
                    selectByMouse: true
                    text: node.title
                    verticalAlignment: Text.AlignVCenter
                    onTextChanged: { if(node && node.title !== text) node.title = text }
                    smooth: true
                    antialiasing: true
                    font.pointSize: NLStyle.node.fontSizeTitle
                    font.bold: true
                }
            }

            // Scrollable description
            ScrollView {
                id: view
                anchors.top: titleItem.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                anchors.topMargin: 5
                hoverEnabled: true
                clip: true
                visible: !nodeView.isNodeMinimal

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                NLTextArea {
                    id: textArea
                    focus: false
                    placeholderText: qsTr("Enter description")
                    color: NLStyle.primaryTextColor
                    text: node.guiConfig.description
                    readOnly: !nodeView.edit
                    wrapMode: TextEdit.WrapAnywhere
                    onTextChanged: { 
                        if(node && node.guiConfig.description !== text)
                         node.guiConfig.description = text 
                    }
                    smooth: true
                    antialiasing: true
                    font.bold: true
                    font.pointSize: NLStyle.node.fontSize
                    background: Rectangle { color: "transparent" }
                }
            }
        }
    }
    //! Minimal nodeview in low zoomFactor: forgrond
    Rectangle {
        id: minimalRectangle
        anchors.fill: parent
        anchors.margins: 10
        color: nodeView.isNodeMinimal ? "#282828" : "transparent"
        radius: NLStyle.radiusAmount.nodeView

        OpacityAnimator {
            target: minimalRectangle
            from: minimalRectangle.opacity
            to: nodeView.isNodeMinimal ? 0.7 : 0
            duration: 200
            running: true
        }

        Image {
            id: nodeImageMinimal
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: (node.imagesModel.coverImageIndex !== -1) ? node.imagesModel.imagesSources[node.imagesModel.coverImageIndex] : ""
            visible: node.imagesModel.coverImageIndex !== -1
        }

        Text {
            font.family: NLStyle.fontType.font6Pro
            font.pixelSize: node.imagesModel.coverImageIndex !== -1 ? 30 : 60
            anchors.centerIn: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: node.imagesModel.coverImageIndex !== -1 ? 3 : 0
            text: scene?.nodeRegistry?.nodeIcons[node.type] ?? ""
            color: node.guiConfig.color
            font.weight: 400
            visible: nodeView.isNodeMinimal
        }
    }

    //! Manage node selection and position change.
    MouseArea {
        id: nodeMouseArea

        property real    prevX:      node.guiConfig.position.x
        property real    prevY:      node.guiConfig.position.y
        property bool   isDraging:  false

        anchors.fill: parent
        anchors.margins: 10
        hoverEnabled: true
        preventStealing: true
        enabled: !nodeView.edit && sceneSession && !sceneSession.connectingMode &&
                 !node.guiConfig.locked && !sceneSession.isCtrlPressed &&
                 isNodeEditable

        // To hide cursor when is disable
        visible: enabled

        //! Manage zoom in nodeview and pass it to zoomManager
        onWheel: (wheel) => {
                     //! active zoom with no modifier.
                     if(wheel.modifiers === sceneSession.zoomModifier) {
                         sceneSession.zoomManager.zoomNodeSignal(
                             Qt.point(wheel.x, wheel.y),
                             this,
                             wheel.angleDelta.y);
                     }
                 }

        onDoubleClicked: (mouse) => {
            // Clear all selected nodes
            scene.selectionModel.clearAllExcept(node._qsUuid);

            // Select current node
            scene.selectionModel.selectNode(node);

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
            if (isNodeEditable && mouse.button === Qt.RightButton) {
                // Ensure the isDraging is false.
                isDraging = false;

                // Clear all selected nodes
                scene.selectionModel.clearAllExcept(node._qsUuid);

                // Select current node
                scene.selectionModel.selectNode(node);

                nodeContextMenu.popup(mouse.x, mouse.y);
            }
        }

        onPressed: (mouse) => {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
            _selectionTimer.start();
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
                if(NLStyle.snapEnabled)
                    node.guiConfig.position = scene.snappedPosition(node.guiConfig.position)
                node.guiConfig.positionChanged();
                prevY = mouse.y - deltaY;

                if((node.guiConfig.position.x < 0  && deltaX < 0) ||
                   (node.guiConfig.position.y < 0 && deltaY < 0))
                                 isDraging = false;

                 if (node.guiConfig.position.x + node.guiConfig.width > scene.sceneGuiConfig.contentWidth && deltaX > 0)
                                 scene.sceneGuiConfig.contentWidth += deltaX;

                 if(node.guiConfig.position.y + node.guiConfig.height > scene.sceneGuiConfig.contentHeight && deltaY > 0)
                                 scene.sceneGuiConfig.contentHeight += deltaY;
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
                    scene.selectionModel.selectNode(node);
            }
        }
    }

    //! Locks the node
    MouseArea {
        anchors.fill: parent
        anchors.margins: -10
        enabled: node.guiConfig.locked || !isNodeEditable
        onClicked: _selectionTimer.start();
        visible: node.guiConfig.locked || !isNodeEditable

        //! Manage zoom in nodeview and pass it to zoomManager in lock mode.
        onWheel: (wheel) => {
                     //! active zoom with no modifier.
                     if(wheel.modifiers === Qt.NoModifier) {
                         sceneSession.zoomManager.zoomNodeSignal(
                             Qt.point(wheel.x, wheel.y),
                             this,
                             wheel.angleDelta.y);
                     }
                 }

    }


    //! Reset some properties when selection model changed.
    Connections {
        target: scene.selectionModel

        function onSelectedModelChanged() {
            if(!scene.selectionModel.isSelected(node._qsUuid))
                nodeView.edit = false;
        }
    }

    //! When node is selected, width, height, x, and y
    //! changed must be sent into rubber bandd.
    Connections {
        target: node.guiConfig

        function onPositionChanged() {
            dimensionChanged(true);
        }

        function onWidthChanged() {
            dimensionChanged(true);
        }

        function onHeightChanged() {
            dimensionChanged(true);
        }
    }

    /* Connections for Auto-sizing
    * ****************************************************************************************/

    //! Handle title changes for auto-sizing
    Connections {
        target: node
        function onTitleChanged() {
            if(autoSize)
                calculateOptimalSize();
        }
    }

    //! Handle port changes for auto-sizing
    Connections {
        target: node
        function onPortsChanged() {
            if(autoSize)
                calculateOptimalSize();
        }
    }

    //! Handle port additions for auto-sizing
    Connections {
        target: node
        function onPortAdded(portId) {
            // Small delay to ensure port is properly initialized
            if(autoSize)
                calculateOptimalSize();
        }
    }
}
