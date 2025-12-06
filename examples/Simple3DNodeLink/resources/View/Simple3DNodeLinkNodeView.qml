import QtQuick
import QtQuick.Controls

import NodeLink
import Simple3DNodeLink

/*! ***********************************************************************************************
 * Simple3DNodeLinkNodeView is nodeView to show nodeView in 3D space.
 * This is similar to CalculatorNodeView but for 3D environment.
 * ************************************************************************************************/

NodeView {
    id: nodeView

    /* Property Declarations
    * ****************************************************************************************/
    
    //! Access to parent view3d for 3D coordinate conversion
    property var view3d: null
    property var cameraX: 0
    property var cameraY: 0
    property var cameraZ: 500
    property var cameraRotationX: -20
    property var cameraRotationY: 0

    /* Object Properties
     * ****************************************************************************************/
    
    //! Handle selection changes - don't auto-enable edit mode, just reset dragging
    Connections {
        target: nodeView
        function onIsSelectedChanged() {
            // Reset dragging state when selection changes
            if (nodeView.mainMouseArea) {
                nodeView.mainMouseArea.isDraging = false;
            }
            
            if (!nodeView.isSelected) {
                // When node is deselected, disable edit mode
                nodeView.edit = false;
                // Clear focus from text fields
                Qt.callLater(function() {
                    if (!nodeView || !nodeView.contentItem) return;
                    var contentItem = nodeView.contentItem;
                    
                    function findChildByObjectName(parent, name) {
                        if (!parent) return null;
                        if (parent.objectName === name) return parent;
                        if (parent.children) {
                            for (var i = 0; i < parent.children.length; i++) {
                                var child = findChildByObjectName(parent.children[i], name);
                                if (child) return child;
                            }
                        }
                        return null;
                    }
                    
                    var foundTextArea = findChildByObjectName(contentItem, "textArea");
                    var foundTitleTextArea = findChildByObjectName(contentItem, "titleTextArea");
                    
                    if (foundTextArea && foundTextArea.activeFocus) {
                        foundTextArea.focus = false;
                    }
                    if (foundTitleTextArea && foundTitleTextArea.activeFocus) {
                        foundTitleTextArea.focus = false;
                    }
                });
            }
        }
    }
    
    //! Handle edit mode changes - focus on appropriate field
    Connections {
        target: nodeView
        function onEditChanged() {
            // When edit mode is enabled, focus on appropriate field
            if (nodeView.edit && node) {
                // Reset dragging state to prevent accidental dragging
                if (nodeView.mainMouseArea) {
                    nodeView.mainMouseArea.isDraging = false;
                }
                Qt.callLater(function() {
                    if (!nodeView || !nodeView.contentItem) return;
                    // Find textArea and titleTextArea by objectName
                    var contentItem = nodeView.contentItem;
                    var foundTextArea = null;
                    var foundTitleTextArea = null;
                    
                    function findChildByObjectName(parent, name) {
                        if (!parent) return null;
                        if (parent.objectName === name) return parent;
                        if (parent.children) {
                            for (var i = 0; i < parent.children.length; i++) {
                                var child = findChildByObjectName(parent.children[i], name);
                                if (child) return child;
                            }
                        }
                        return null;
                    }
                    
                    foundTextArea = findChildByObjectName(contentItem, "textArea");
                    foundTitleTextArea = findChildByObjectName(contentItem, "titleTextArea");
                    
                    // For NumberNode, focus on textArea
                    if (node.type === Specs.NodeType.Number && foundTextArea) {
                        foundTextArea.forceActiveFocus();
                        foundTextArea.cursorPosition = foundTextArea.length;
                    } else if (foundTitleTextArea) {
                        // For other nodes, focus on title
                        foundTitleTextArea.forceActiveFocus();
                    }
                });
            } else if (!nodeView.edit) {
                // When edit mode is disabled, clear focus from text fields
                Qt.callLater(function() {
                    if (!nodeView || !nodeView.contentItem) return;
                    var contentItem = nodeView.contentItem;
                    
                    function findChildByObjectName(parent, name) {
                        if (!parent) return null;
                        if (parent.objectName === name) return parent;
                        if (parent.children) {
                            for (var i = 0; i < parent.children.length; i++) {
                                var child = findChildByObjectName(parent.children[i], name);
                                if (child) return child;
                            }
                        }
                        return null;
                    }
                    
                    var foundTextArea = findChildByObjectName(contentItem, "textArea");
                    var foundTitleTextArea = findChildByObjectName(contentItem, "titleTextArea");
                    
                    if (foundTextArea && foundTextArea.activeFocus) {
                        foundTextArea.focus = false;
                    }
                    if (foundTitleTextArea && foundTitleTextArea.activeFocus) {
                        foundTitleTextArea.focus = false;
                    }
                });
            }
        }
    }

    /* Keys
    * ****************************************************************************************/

    //! Handle key pressed (Del: delete selected node)
    Keys.onDeletePressed: {
        if (!nodeView.isSelected)
            return;

        if (!nodeView.isNodeEditable) {
            return;
        }

        if (sceneSession && sceneSession.isDeletePromptEnable) {
            deletePopup.open();
        } else {
            delTimer.start();
        }
    }

    //! Delete handlers
    //! *****************

    //! Delete node
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: {
            if (scene && scene.deleteSelectedObjects) {
                scene.deleteSelectedObjects();
            }
        }
    }

    //! Delete popup to confirm deletion process
    ConfirmPopUp {
        id: deletePopup
        sceneSession: nodeView.sceneSession
        onAccepted: delTimer.start();
    }

    //! Override mainMouseArea to handle 3D dragging
    Connections {
        target: nodeView && nodeView.mainMouseArea ? nodeView.mainMouseArea : null
        
        function onPositionChanged(mouse) {
            // Check if objects are still valid
            if (!nodeView || !nodeView.mainMouseArea || !nodeView.mainMouseArea.isDraging || !node || !view3d) return;
            
            // Don't drag if edit mode is on
            if (nodeView.edit) {
                nodeView.mainMouseArea.isDraging = false;
                return;
            }
            
            // Get current 3D position
            var currentPos3D = node.guiConfig?.position3D;
            if (!currentPos3D) return;
            
            // Calculate delta in screen space
            var deltaX = mouse.x - nodeView.mainMouseArea.prevX;
            var deltaY = mouse.y - nodeView.mainMouseArea.prevY;
            
            // Convert screen delta to 3D world delta
            // We need to calculate how much 3D movement corresponds to screen movement
            var rotX = cameraRotationX * Math.PI / 180;
            var rotY = cameraRotationY * Math.PI / 180;
            
            // Calculate camera vectors
            var forward = Qt.vector3d(
                -Math.sin(rotY) * Math.cos(rotX),
                Math.sin(rotX),
                -Math.cos(rotY) * Math.cos(rotX)
            ).normalized();
            
            var right = Qt.vector3d(
                Math.cos(rotY),
                0,
                Math.sin(rotY)
            ).normalized();
            
            var up = Qt.vector3d(
                Math.sin(rotY) * Math.sin(rotX),
                Math.cos(rotX),
                Math.cos(rotY) * Math.sin(rotX)
            ).normalized();
            
            // Calculate distance from camera to node
            var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
            var toNode = currentPos3D.minus(cameraPos);
            var distance = Math.sqrt(toNode.x * toNode.x + toNode.y * toNode.y + toNode.z * toNode.z);
            
            // Calculate FOV-based scaling
            var fov = 60.0 * Math.PI / 180; // Default FOV
            var aspectRatio = view3d.width / view3d.height;
            var scaleX = Math.tan(fov / 2) * distance * 2;
            var scaleY = scaleX / aspectRatio;
            
            // Convert screen delta to 3D world delta
            var worldDeltaX = (deltaX / view3d.width) * scaleX;
            var worldDeltaY = (deltaY / view3d.height) * scaleY;
            
            // Calculate new 3D position
            var newPos3D = currentPos3D
                .plus(right.times(worldDeltaX))
                .plus(up.times(-worldDeltaY)); // Negative Y because screen Y is inverted
            
            // Update 3D position
            node.guiConfig.position3D = newPos3D;
            
            // Update 2D position (will be recalculated from 3D in the view)
            try {
                if (!view3d || !node || !node.guiConfig) return;
                var newScreenPos = view3d.mapFrom3DScene(newPos3D);
                if (!isNaN(newScreenPos.x) && !isNaN(newScreenPos.y)) {
                    node.guiConfig.position.x = newScreenPos.x - (node.guiConfig?.width ?? 160) / 2;
                    node.guiConfig.position.y = newScreenPos.y - (node.guiConfig?.height ?? 100) / 2;
                    if (node.guiConfig.positionChanged) {
                        node.guiConfig.positionChanged();
                    }
                }
                
                // Update prevX and prevY for next movement
                if (nodeView && nodeView.mainMouseArea) {
                    nodeView.mainMouseArea.prevX = mouse.x;
                    nodeView.mainMouseArea.prevY = mouse.y;
                }
            } catch (e) {
                // Object destroyed during operation, ignore
            }
        }
    }

    contentItem: Item {
        id: mainContentItem
        property bool iconOnly: nodeView.isNodeMinimal
        
        //! Header Item
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12

            visible: !mainContentItem.iconOnly
            height: 20

            //! Icon
            Text {
                id: iconText
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: scene?.nodeRegistry?.nodeIcons?.[node.type] ?? ""
                color: node.guiConfig.color
                font.weight: 400
            }

            //! Title Text
            NLTextArea {
                id: titleTextArea
                objectName: "titleTextArea"  // Add objectName for easy access

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
                onTextChanged: {
                    if (node && node.title !== text)
                        node.title = text;
                }

                onPressed: (event) => {
                               if (event.button === Qt.RightButton) {
                                   nodeView.edit = false
                               } else if (event.button === Qt.LeftButton) {
                                   // Enable edit mode when clicking on title
                                   if (!nodeView.edit) {
                                       nodeView.edit = true;
                                   }
                               }
                           }

                smooth: true
                antialiasing: true
                font.pointSize: 10
                font.bold: true

                //! Connections to forceActiveFocus when
                //! nodeView.edit is true
                Connections {
                    target: nodeView && nodeView.edit !== undefined ? nodeView : null

                    function onEditChanged() {
                        // Check if objects are still valid
                        if (!nodeView || !titleTextArea) return;
                        if(nodeView.edit) {
                            // For NumberNode, focus on textArea instead of title
                            if (node && (node.type === Specs.NodeType.Number || node.type === Specs.NodeType.Color)) {
                                Qt.callLater(function() {
                                    if (node.type === Specs.NodeType.Number && textArea) {
                                        textArea.forceActiveFocus();
                                    } else if (node.type === Specs.NodeType.Color && colorTextField) {
                                        colorTextField.forceActiveFocus();
                                    }
                                });
                            } else {
                                titleTextArea.forceActiveFocus();
                            }
                        }
                    }
                }
            }
        }

        // Value display area - Show node data in a clean format (only for NumberNode)
        ScrollView {
            id: valueScrollView
            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: footerItem.top
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            
            visible: !mainContentItem.iconOnly
            clip: true
            
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            
            Column {
                id: valueColumn
                width: parent.width
                spacing: 6
                
                // ColorNode - Hex color input
                Row {
                    id: colorInputRow
                    width: parent.width
                    spacing: 8
                    visible: node && node.type === Specs.NodeType.Color
                    
                    // Color preview rectangle
                    Rectangle {
                        id: colorPreview
                        width: 40
                        height: 30
                        radius: 4
                        border.width: 1
                        border.color: NLStyle.borderColor || "#363636"
                        color: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "#8080FF";
                            try {
                                var data = node.nodeData.data;
                                if (data && typeof data === "string" && data.length > 0) {
                                    try {
                                        var colorObj = Qt.color(data);
                                        if (colorObj && colorObj.a > 0) {
                                            return data;
                                        }
                                    } catch (e) {
                                        // Invalid color, use default
                                    }
                                }
                                return "#8080FF";
                            } catch (e) {
                                return "#8080FF";
                            }
                        }
                    }
                    
                    // Color hex input field with fixed #
                    Row {
                        spacing: 0
                        width: parent.width - colorPreview.width - parent.spacing
                        
                        // Fixed # symbol
                        Text {
                            text: "#"
                            color: NLStyle.primaryTextColor
                            font.bold: true
                            font.pointSize: 9
                            anchors.verticalCenter: parent.verticalCenter
                            width: 10
                        }
                        
                        // Hex value input (without #)
                        NLTextField {
                            id: colorTextField
                            objectName: "colorTextField"
                            width: parent.width - 10
                            
                            property bool _internalUpdate: false
                            
                            placeholderText: qsTr("RRGGBB")
                            color: NLStyle.primaryTextColor
                            
                            text: {
                                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "8080FF";
                                try {
                                    var _ = node.nodeData.data;
                                    var data = node.nodeData.data;
                                    if (_internalUpdate) return colorTextField.text || "";
                                    if (node.type === Specs.NodeType.Color && colorTextField.activeFocus) {
                                        return colorTextField.text || "";
                                    }
                                    if (data !== null && data !== undefined) {
                                        var colorStr = String(data);
                                        // Remove # if present
                                        if (colorStr.startsWith("#")) {
                                            return colorStr.substring(1);
                                        }
                                        return colorStr;
                                    }
                                    return "8080FF";
                                } catch (e) {
                                    return "8080FF";
                                }
                            }
                            
                            readOnly: !nodeView.edit
                            wrapMode: TextEdit.NoWrap
                            
                            // Only allow hex characters (0-9, A-F, a-f)
                            inputMethodHints: Qt.ImhNoAutoUppercase
                            
                            onTextChanged: {
                                if (_internalUpdate) return;
                                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return;
                                try {
                                    if (node.type === Specs.NodeType.Color) {
                                        var hexStr = text.trim().toUpperCase();
                                        // Remove any non-hex characters
                                        hexStr = hexStr.replace(/[^0-9A-F]/g, '');
                                        
                                        // Limit to 6 characters
                                        if (hexStr.length > 6) {
                                            hexStr = hexStr.substring(0, 6);
                                        }
                                        
                                        // Update text if it was filtered
                                        if (hexStr !== text) {
                                            _internalUpdate = true;
                                            colorTextField.text = hexStr;
                                            _internalUpdate = false;
                                        }
                                        
                                        // Only update nodeData when we have 6 hex digits
                                        if (hexStr.length === 6) {
                                            var fullColorStr = "#" + hexStr;
                                            _internalUpdate = true;
                                            node.nodeData.data = fullColorStr;
                                            if (node.updateOutput) {
                                                node.updateOutput(fullColorStr);
                                            } else if (scene && scene.updateDataFromNode) {
                                                scene.updateDataFromNode(node);
                                            }
                                            _internalUpdate = false;
                                        }
                                    }
                                } catch (e) {
                                    _internalUpdate = false;
                                }
                            }
                            
                            onEditingFinished: {
                                if (node && node.type === Specs.NodeType.Color && !_internalUpdate) {
                                    var hexStr = text.trim().toUpperCase().replace(/[^0-9A-F]/g, '');
                                    
                                    // Pad with zeros if less than 6 characters, or truncate if more
                                    if (hexStr.length < 6) {
                                        hexStr = (hexStr + "000000").substring(0, 6);
                                    } else if (hexStr.length > 6) {
                                        hexStr = hexStr.substring(0, 6);
                                    }
                                    
                                    var fullColorStr = "#" + hexStr;
                                    _internalUpdate = true;
                                    colorTextField.text = hexStr;
                                    node.nodeData.data = fullColorStr;
                                    if (node.updateOutput) {
                                        node.updateOutput(fullColorStr);
                                    }
                                    _internalUpdate = false;
                                }
                            }
                            
                            smooth: true
                            antialiasing: true
                            font.bold: true
                            font.pointSize: 9
                            
                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    if (nodeView && !nodeView.edit) {
                                        nodeView.edit = true;
                                    }
                                }
                            }
                        }
                    }
                }
                
                // NumberNode - Single value input
                NLTextField {
                    id: textArea
                    objectName: "textArea"
                    width: parent.width
                    visible: node && node.type === Specs.NodeType.Number
                    
                    property bool _internalUpdate: false
                    
                    placeholderText: qsTr("Value")
                    color: NLStyle.primaryTextColor
                    
                    DoubleValidator {
                        id: numberValidator
                        bottom: -Infinity
                        top: Infinity
                        decimals: 10
                        notation: DoubleValidator.StandardNotation
                    }
                    
                    validator: numberValidator
                    
                    text: {
                        if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                        try {
                            var _ = node.nodeData.data;
                            var data = node.nodeData.data;
                            if (_internalUpdate) return textArea.text || "";
                            if (node.type === Specs.NodeType.Number && textArea.activeFocus) {
                                return textArea.text || "";
                            }
                            return data !== null && data !== undefined ? String(data) : "";
                        } catch (e) {
                            return "";
                        }
                    }
                    
                    readOnly: !nodeView.edit
                    wrapMode: TextEdit.WrapAnywhere
            onTextChanged: {
                if (_internalUpdate) return;
                // Check if objects are still valid
                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return;
                try {
                    // Handle NumberNode
                    if (node.type === Specs.NodeType.Number) {
                        // Only update nodeData when text is acceptable (complete number)
                        // This allows user to type decimal point without losing it
                        if (text === "" || text === "-" || text === "." || text === "-.") {
                            // User is still typing, don't update yet
                            return;
                        }
                        
                        var numValue = parseFloat(text);
                        if (!isNaN(numValue)) {
                            var currentData = node.nodeData.data;
                            // Only update if value actually changed
                            if (currentData !== numValue) {
                                _internalUpdate = true;
                                // Update node data
                                node.nodeData.data = numValue;
                                // Call updateOutput if available (for NumberNode)
                                if (node.updateOutput) {
                                    node.updateOutput(numValue);
                                } else if (scene && scene.updateDataFromNode) {
                                    // Use updateDataFromNode for better propagation
                                    scene.updateDataFromNode(node);
                                } else if (scene && scene.updateData) {
                                    // Fallback to scene updateData
                                    scene.updateData();
                                }
                                _internalUpdate = false;
                            }
                        }
                    }
                } catch (e) {
                    // Object destroyed during operation, ignore
                    _internalUpdate = false;
                }
            }
            
            onEditingFinished: {
                // When editing is finished, ensure the value is properly formatted
                if (node && node.type === Specs.NodeType.Number && !_internalUpdate) {
                    var numValue = parseFloat(text);
                    if (!isNaN(numValue)) {
                        _internalUpdate = true;
                        // Update text to properly formatted number (preserves decimal if needed)
                        textArea.text = String(numValue);
                        node.nodeData.data = numValue;
                        if (node.updateOutput) {
                            node.updateOutput(numValue);
                        }
                        _internalUpdate = false;
                    }
                }
            }
            smooth: true
            antialiasing: true
            font.bold: true
            font.pointSize: 9

            // Handle focus to enable editing
            onActiveFocusChanged: {
                if (activeFocus) {
                    // When text field gets focus, enable edit mode
                    if (nodeView && !nodeView.edit) {
                        nodeView.edit = true;
                    }
                }
            }
            
            // Handle clicks - enable edit mode when clicking on text field
            // Use a MouseArea that doesn't block text input
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                propagateComposedEvents: true
                z: -1  // Behind text field
                enabled: textArea.readOnly  // Only active when read-only
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        // Enable edit mode when clicking
                        if (nodeView) {
                            nodeView.edit = true;
                        }
                        // Focus text field
                        Qt.callLater(function() {
                            if (textArea) {
                                textArea.forceActiveFocus();
                                textArea.cursorPosition = textArea.length;
                            }
                        });
                        mouse.accepted = false; // Allow text field to handle
                    } else if (mouse.button === Qt.RightButton) {
                        if (nodeView) {
                            nodeView.edit = false;
                        }
                        mouse.accepted = false;
                    }
                }
            }
                    background: Rectangle {
                        color: "transparent";
                    }
                }
            }
        }
        
        // Footer Item - Display values at the bottom (similar to title at top)
        Item {
            id: footerItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 12
            
            visible: !mainContentItem.iconOnly
            height: {
                // Calculate height based on content
                if (node && node.type >= Specs.NodeType.Position && node.type <= Specs.NodeType.Dimensions) {
                    return 40; // Vector3D nodes
                } else if (node && node.type >= Specs.NodeType.Metal && node.type <= Specs.NodeType.Wood) {
                    return 60; // Material nodes
                }
                return 0; // No footer for other nodes
            }
            
            // Vector3D nodes (Position, Rotation, Scale, Dimensions) - Display formatted values
            Column {
                id: vector3dDisplay
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: node && (node.type === Specs.NodeType.Position || 
                                  node.type === Specs.NodeType.Rotation || 
                                  node.type === Specs.NodeType.Scale || 
                                  node.type === Specs.NodeType.Dimensions)
                spacing: 3
                
                Text {
                    width: parent.width
                    color: NLStyle.primaryTextColor
                    font.pointSize: 8
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (!node) return "";
                        if (node.type === Specs.NodeType.Position) return "Position";
                        else if (node.type === Specs.NodeType.Rotation) return "Rotation";
                        else if (node.type === Specs.NodeType.Scale) return "Scale";
                        else if (node.type === Specs.NodeType.Dimensions) return "Dimensions";
                        return "";
                    }
                }
                
                Text {
                    width: parent.width
                    color: NLStyle.primaryTextColor
                    font.pointSize: 7
                    opacity: 0.9
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                        try {
                            var _ = node.nodeData.data;
                            var data = node.nodeData.data;
                            if (!data || typeof data.x === 'undefined') return "";
                            
                            return "X: " + data.x.toFixed(2) + "  Y: " + data.y.toFixed(2) + "  Z: " + data.z.toFixed(2);
                        } catch (e) {
                            return "";
                        }
                    }
                }
            }
            
            // Material nodes - Display formatted values
            Column {
                id: materialDisplay
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: node && node.type >= Specs.NodeType.Metal && node.type <= Specs.NodeType.Wood
                spacing: 4
                
                Text {
                    width: parent.width
                    color: NLStyle.primaryTextColor
                    font.pointSize: 8
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    text: {
                        if (!node) return "";
                        if (node.type === Specs.NodeType.Metal) return "Metal Material";
                        else if (node.type === Specs.NodeType.Plastic) return "Plastic Material";
                        else if (node.type === Specs.NodeType.Glass) return "Glass Material";
                        else if (node.type === Specs.NodeType.Rubber) return "Rubber Material";
                        else if (node.type === Specs.NodeType.Wood) return "Wood Material";
                        return "";
                    }
                }
                
                Column {
                    width: parent.width
                    spacing: 2
                    
                    Text {
                        width: parent.width
                        color: NLStyle.primaryTextColor
                        font.pointSize: 7
                        opacity: 0.9
                        horizontalAlignment: Text.AlignHCenter
                        visible: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return false;
                            try {
                                var data = node.nodeData.data;
                                return data && typeof data.metallic !== 'undefined';
                            } catch (e) {
                                return false;
                            }
                        }
                        text: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                            try {
                                var _ = node.nodeData.data;
                                var data = node.nodeData.data;
                                if (!data || typeof data.metallic === 'undefined') return "";
                                return "Metallic: " + data.metallic.toFixed(2);
                            } catch (e) {
                                return "";
                            }
                        }
                    }
                    
                    Text {
                        width: parent.width
                        color: NLStyle.primaryTextColor
                        font.pointSize: 7
                        opacity: 0.9
                        horizontalAlignment: Text.AlignHCenter
                        visible: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return false;
                            try {
                                var data = node.nodeData.data;
                                return data && typeof data.roughness !== 'undefined';
                            } catch (e) {
                                return false;
                            }
                        }
                        text: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                            try {
                                var _ = node.nodeData.data;
                                var data = node.nodeData.data;
                                if (!data || typeof data.roughness === 'undefined') return "";
                                return "Roughness: " + data.roughness.toFixed(2);
                            } catch (e) {
                                return "";
                            }
                        }
                    }
                    
                    Text {
                        width: parent.width
                        color: NLStyle.primaryTextColor
                        font.pointSize: 7
                        opacity: 0.9
                        horizontalAlignment: Text.AlignHCenter
                        visible: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return false;
                            try {
                                var data = node.nodeData.data;
                                return data && typeof data.emissivePower !== 'undefined';
                            } catch (e) {
                                return false;
                            }
                        }
                        text: {
                            if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                            try {
                                var _ = node.nodeData.data;
                                var data = node.nodeData.data;
                                if (!data || typeof data.emissivePower === 'undefined') return "";
                                return "Emissive: " + data.emissivePower.toFixed(2);
                            } catch (e) {
                                return "";
                            }
                        }
                    }
                }
            }
        }

        //! Minimal nodeview in low zoomFactor: forgrond
        Rectangle {
            id: minimalRectangle
            anchors.fill: parent
            anchors.margins: 10

            color: mainContentItem.iconOnly ? "#282828" : "transparent"
            radius: NLStyle.radiusAmount.nodeView

            //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0.7
            OpacityAnimator {
                target: minimalRectangle

                from: minimalRectangle.opacity
                to: 0.7
                duration: 200
                running: mainContentItem.iconOnly
            }

            //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0
            OpacityAnimator {
                target: minimalRectangle

                from: minimalRectangle.opacity
                to: 0
                duration: 200
                running: !mainContentItem.iconOnly
            }

            //! Text Icon
            Text {
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 60
                anchors.centerIn: parent
                text: scene?.nodeRegistry?.nodeIcons?.[node.type] ?? ""
                color: node.guiConfig.color
                font.weight: 400
                visible: mainContentItem.iconOnly
            }
        }
    }
}
