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

    //! Override mainMouseArea to handle 3D dragging
    Connections {
        target: nodeView && nodeView.mainMouseArea ? nodeView.mainMouseArea : null
        
        function onPositionChanged(mouse) {
            // Check if objects are still valid
            if (!nodeView || !nodeView.mainMouseArea || !nodeView.mainMouseArea.isDraging || !node || !view3d) return;
            
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
                        if(nodeView.edit)
                            titleTextArea.forceActiveFocus();
                    }
                }
            }
        }

        // Description Text - Show node data
        NLTextField {
            id: textArea

            property bool _internalUpdate: false

            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5

            focus: false
            visible: !mainContentItem.iconOnly
            placeholderText: qsTr("Value")
            color: NLStyle.primaryTextColor
            text: {
                if (_internalUpdate) {
                    // Return current text to avoid binding loop
                    var currentText = textArea.text;
                    return currentText !== undefined ? currentText : "";
                }
                // Check if node and nodeData are still valid
                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                try {
                    var data = node.nodeData.data;
                    return data !== null && data !== undefined ? String(data) : "";
                } catch (e) {
                    // Object destroyed, return empty
                    return "";
                }
            }
            readOnly: !nodeView.edit || (node.type === 1)  // ResultNode type is 1
            wrapMode: TextEdit.WrapAnywhere
            onTextChanged: {
                if (_internalUpdate) return;
                // Check if objects are still valid
                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return;
                try {
                    var currentData = node.nodeData.data;
                    var currentDataStr = (currentData !== null && currentData !== undefined) ? String(currentData) : "";
                    if (currentDataStr !== text) {
                        if (node.type === 0) {  // SourceNode type is 0
                            _internalUpdate = true;
                            node.nodeData.data = text;
                            _internalUpdate = false;
                            if (scene && scene.updateData) {
                                scene.updateData();
                            }
                        }
                    }
                } catch (e) {
                    // Object destroyed during operation, ignore
                    _internalUpdate = false;
                }
            }
            smooth: true
            antialiasing: true
            font.bold: true
            font.pointSize: 9

            onPressed: (event) => {
                           if (event.button === Qt.RightButton) {
                               nodeView.edit = false;
                           }
                       }
            background: Rectangle {
                color: "transparent";
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
