import QtQuick
import QtQuick3D as Qt3D
import QtQuick3D.Helpers
import QtQuick.Controls
import QtQuick.Controls.Material

import Multiple3DEditors

/*! ***********************************************************************************************
 * Multiple3DEditorsView - Main 3D view with camera-following lighting
 * ************************************************************************************************/

/*! ***********************************************************************************************
 * Multiple3DEditorsView - Main 3D view with camera-following lighting
 * ************************************************************************************************/

Item {
    id: root
    
    // Ensure focus is maintained
    activeFocusOnTab: true

    /* Property Declarations
     * ****************************************************************************************/
    property Multiple3DEditorsScene scene
    
    // Camera control properties
    property real cameraX: 0
    property real cameraY: 50
    property real cameraZ: 400
    property real cameraRotationX: -15
    property real cameraRotationY: 0
    
    // Movement speed
    property real moveSpeed: 5.0
    property real rotationSpeed: 2.0
    property real mouseRotationSpeed: 0.5
    
    // Keyboard state
    property bool wPressed: false
    property bool sPressed: false
    property bool ePressed: false
    property bool qPressed: false
    property bool aPressed: false
    property bool dPressed: false
    property bool shiftPressed: false
    property bool spacePressed: false
    property bool rPressed: false
    property bool tPressed: false
    
    // Mouse rotation state
    property bool mouseRotating: false
    property point lastMousePos: Qt.point(0, 0)
    
    // Node dragging state
    property bool draggingNode: false
    property string draggedNodeId: ""
    property vector3d dragStartPos: Qt.vector3d(0, 0, 0)
    property point dragStartMouse: Qt.point(0, 0)
    
    // Resize state
    property bool resizingNode: false
    property string resizedNodeId: ""
    property vector3d resizeStartDims: Qt.vector3d(100, 100, 100)
    property vector3d resizeStartPos: Qt.vector3d(0, 0, 0)
    property int resizeHandleIndex: -1
    
    // View3D alias for access from child components
    property alias view3d: view3d
    
    //! Selected shape type for new nodes
    property string selectedShapeType: "Cube"

    /* Children
     * ****************************************************************************************/

    //! Background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0a0a0f" }  // Very dark blue-black at top
            GradientStop { position: 1.0; color: "#050508" }  // Even darker at bottom
        }
    }

    //! 3D Scene
    Qt3D.View3D {
        id: view3d
        anchors.fill: parent
        camera: camera

        //! Camera
        Qt3D.PerspectiveCamera {
            id: camera
            position: Qt.vector3d(cameraX, cameraY, cameraZ)
            eulerRotation: Qt.vector3d(cameraRotationX, cameraRotationY, 0)
            fieldOfView: 60
        }

        //! Environment
        environment: Qt3D.SceneEnvironment {
            clearColor: "#0a0a0f"  // Very dark blue-black background
            backgroundMode: Qt3D.SceneEnvironment.Color
            antialiasingMode: Qt3D.SceneEnvironment.MSAA
            antialiasingQuality: Qt3D.SceneEnvironment.High
            depthTestEnabled: true
            depthPrePassEnabled: true
            // Shadow settings
            lightProbe: null
        }

        //! Main directional light
        Qt3D.DirectionalLight {
            id: mainLight
            eulerRotation: Qt.vector3d(-45, -45, 0)
            color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
            brightness: 1.5
            castsShadow: true
        }
        
        // Visible light source for main directional light
        Qt3D.Model {
            source: "#Sphere"
            scale: Qt.vector3d(0.5, 0.5, 0.5)
            position: Qt.vector3d(0, 1000, 0)  // Position above scene
            materials: [
                Qt3D.PrincipledMaterial {
                    baseColor: mainLight.color
                    emissiveFactor: Qt.vector3d(3, 3, 3)
                    metalness: 0.0
                    roughness: 0.0
                }
            ]
        }

        //! Axes Helper - Shows X (red), Y (green), Z (blue) axes (disabled)
        // AxisHelper {
        //     id: axesHelper
        //     scale: Qt.vector3d(1, 1, 1)
        // }

        //! Ground Plane - Large square surface for reference
        Qt3D.Model {
            id: groundPlane
            source: "#Rectangle"
            scale: Qt.vector3d(10000, 10000, 1)  // Very large square ground plane (10000m x 10000m)
            position: Qt.vector3d(0, 0, 0)
            eulerRotation: Qt.vector3d(-90, 0, 0)  // Rotate to be horizontal (flat on XZ plane) - same as cube's initial rotation
            objectName: "groundPlane"  // Set objectName for picking
            
            materials: [
                Qt3D.PrincipledMaterial {
                    baseColor: "#1a1a20"  // Dark blue-gray ground plane
                    roughness: 0.95
                    metalness: 0.0
                    emissiveFactor: Qt.vector3d(0.02, 0.02, 0.03)  // Very subtle blue emission
                }
            ]
            
            pickable: true  // Enable picking for ground plane
            receivesShadows: true
        }

        //! Custom 3D Nodes Container
        Qt3D.Node {
            id: nodesContainer
            
            // Component for creating nodes
            Component {
                id: nodeComponent
                Custom3DNode { }
            }
            
            // Track created nodes
            property var createdNodes: ({})
            
            // Function to update nodes
            function updateNodes() {
                if (!scene || !scene.nodes) return;
                
                var currentKeys = Object.keys(scene.nodes || {});
                var createdKeys = Object.keys(createdNodes || {});
                
                // Remove nodes that no longer exist
                for (var i = 0; i < createdKeys.length; i++) {
                    var key = createdKeys[i];
                    if (currentKeys.indexOf(key) === -1) {
                        if (createdNodes[key]) {
                            createdNodes[key].destroy();
                            delete createdNodes[key];
                        }
                    }
                }
                
                // Create/update nodes
                for (var j = 0; j < currentKeys.length; j++) {
                    var nodeId = currentKeys[j];
                    var nodeData = scene.nodes[nodeId];
                    
                    if (!createdNodes[nodeId]) {
                        var node = nodeComponent.createObject(nodesContainer, {
                            nodeId: nodeId,
                            nodeData: nodeData,
                            scene: root.scene,
                            selected: scene.selectedNodeId === nodeId
                        });
                        createdNodes[nodeId] = node;
                    } else {
                        // Update existing node
                        var existingNode = createdNodes[nodeId];
                        existingNode.nodeId = nodeId;
                        existingNode.nodeData = nodeData;
                        existingNode.selected = scene.selectedNodeId === nodeId;
                    }
                }
            }
            
            // Update when scene.nodes changes
            Connections {
                target: scene
                function onNodesChanged() {
                    nodesContainer.updateNodes();
                }
                function onSelectedNodeIdChanged() {
                    // Update selection state of all nodes
                    if (!scene || !nodesContainer.createdNodes) return;
                    for (var nodeId in nodesContainer.createdNodes) {
                        var node = nodesContainer.createdNodes[nodeId];
                        if (node) {
                            node.selected = scene.selectedNodeId === nodeId;
                        }
                    }
                }
            }
            
            Component.onCompleted: {
                updateNodes();
            }
        }
    }

    //! Toolbar for creating nodes
    Rectangle {
        id: toolbar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        width: 300  // Same width as help panel
        height: 50
        color: "#2a2a2a"
        radius: 8
        border.color: "#555"
        border.width: 1
        z: 2000  // Above help panel
        
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            
            Text {
                text: "Shape:"
                color: "#ffffff"
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
            
            ComboBox {
                id: shapeCombo
                width: 120
                height: 32
                Material.theme: Material.Dark
                model: ["Cube", "Sphere", "Cylinder", "Cone", "Rectangle"]
                currentIndex: 0
                anchors.verticalCenter: parent.verticalCenter
                onCurrentIndexChanged: {
                    root.selectedShapeType = model[currentIndex];
                }
                Component.onCompleted: {
                    root.selectedShapeType = model[currentIndex];
                }
            }
            
            Button {
                width: 40
                height: 40
                Material.accent: Material.Blue
                Material.theme: Material.Dark
                anchors.verticalCenter: parent.verticalCenter
                
                contentItem: Text {
                    text: "\uf067"  // Font Awesome plus icon
                    font.family: "Font Awesome 6 Pro"
                    font.weight: 900
                    font.pixelSize: 18
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    // Create node at camera position + forward direction
                    var rotX = cameraRotationX * Math.PI / 180;
                    var rotY = cameraRotationY * Math.PI / 180;
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    var spawnPos = Qt.vector3d(cameraX, cameraY, cameraZ)
                        .plus(forward.times(200));
                    // Place node on ground: y = half height (0.25m for 50cm)
                    scene.createNode(spawnPos.x, 0.25, spawnPos.z, root.selectedShapeType);
                }
            }
        }
    }

    //! Help Panel - Instructions for keyboard and mouse controls
    Rectangle {
        id: helpPanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        anchors.topMargin: 80  // Below toolbar
        width: 300
        height: helpContent.height + 40
        color: "#2a2a2a"
        radius: 8
        border.color: "#555"
        border.width: 1
        visible: true
        z: 1000

        Column {
            id: helpContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 15
            spacing: 10

            Text {
                text: "Controls"
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }

            Text {
                text: "Camera Movement:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "W / S - Move forward/backward\nQ / E - Move left/right\nShift / Space - Move up/down"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Camera Rotation:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "A / D - Rotate left/right\nR / T - Rotate up/down\nRight Click + Drag - Rotate camera"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Node Creation:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "Double Click - Create node at click position\nToolbar Button - Create node in front of camera"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Node Selection:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "Left Click - Select/Deselect node\nLeft Click + Drag - Move node\nDrag Resize Handles - Resize node (Cube/Rectangle only)"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Node Movement (when selected):"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "W / S - Move forward/backward\nQ / E - Move left/right\nShift / Space - Move up/down\nA / D - Rotate horizontally\nR / T - Rotate vertically"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    //! Property Panel
    PropertyPanel {
        id: propertyPanel
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 15
        width: 380
        visible: {
            var hasSelection = scene && scene.selectedNodeId && scene.selectedNodeId !== "" && scene.selectedNodeId !== undefined;
            return hasSelection;
        }
        scene: root.scene
        z: 1500  // Above toolbar and help panel
    }

    //! 2D Axes Helper - Shows X (red), Y (green), Z (blue) axes based on camera rotation
    Rectangle {
        id: axesHelperPanel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
        width: 180
        height: 180
        color: "#2a2a2a"
        radius: 8
        border.color: "#555"
        border.width: 1
        z: 2000  // Above other panels
        
        // Center point
        property real centerX: width / 2
        property real centerY: height / 2
        property real axisLength: 60
        
        // Calculate axis directions based on camera rotation
        property real rotX: cameraRotationX * Math.PI / 180
        property real rotY: cameraRotationY * Math.PI / 180
        
        // Forward direction (camera looks toward -Z)
        property vector2d forwardDir: {
            var fx = -Math.sin(rotY) * Math.cos(rotX);
            var fy = Math.sin(rotX);
            return Qt.vector2d(fx, -fy);  // Flip Y for screen coordinates
        }
        
        // Right direction
        property vector2d rightDir: {
            var rx = Math.cos(rotY);
            var ry = 0;
            return Qt.vector2d(rx, ry);
        }
        
        // Up direction
        property vector2d upDir: {
            var ux = Math.sin(rotY) * Math.sin(rotX);
            var uy = Math.cos(rotX);
            return Qt.vector2d(ux, -uy);  // Flip Y for screen coordinates
        }
        
        // Title
        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10
            text: "Axes"
            color: "#ffffff"
            font.pixelSize: 13
            font.bold: true
        }
        
        // Axes Canvas - Draws all three axes
        Canvas {
            id: axesCanvas
            anchors.fill: parent
            anchors.margins: 25
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                
                var centerX = width / 2;
                var centerY = height / 2;
                var length = axesHelperPanel.axisLength;
                var arrowSize = 6;
                
                // Helper function to draw an axis
                function drawAxis(color, direction, label) {
                    ctx.strokeStyle = color;
                    ctx.fillStyle = color;
                    ctx.lineWidth = 2;
                    
                    var endX = centerX + direction.x * length;
                    var endY = centerY + direction.y * length;
                    
                    // Draw line
                    ctx.beginPath();
                    ctx.moveTo(centerX, centerY);
                    ctx.lineTo(endX, endY);
                    ctx.stroke();
                    
                    // Draw arrow head
                    var angle = Math.atan2(direction.y, direction.x);
                    ctx.beginPath();
                    ctx.moveTo(endX, endY);
                    ctx.lineTo(endX - arrowSize * Math.cos(angle - Math.PI / 6), 
                              endY - arrowSize * Math.sin(angle - Math.PI / 6));
                    ctx.moveTo(endX, endY);
                    ctx.lineTo(endX - arrowSize * Math.cos(angle + Math.PI / 6), 
                              endY - arrowSize * Math.sin(angle + Math.PI / 6));
                    ctx.stroke();
                    
                    // Draw label
                    ctx.font = "12px sans-serif";
                    ctx.fillText(label, endX + 10, endY + 5);
                }
                
                // Draw X axis (red) - right direction
                drawAxis("#ff4444", axesHelperPanel.rightDir, "X");
                
                // Draw Y axis (green) - up direction
                drawAxis("#44ff44", axesHelperPanel.upDir, "Y");
                
                // Draw Z axis (blue) - forward direction
                drawAxis("#4444ff", axesHelperPanel.forwardDir, "Z");
            }
        }
        
        // Update canvas when camera rotation changes
        Connections {
            target: root
            function onCameraRotationXChanged() {
                axesCanvas.requestPaint();
            }
            function onCameraRotationYChanged() {
                axesCanvas.requestPaint();
            }
        }
    }

    //! Keyboard handling for camera control
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_W) {
            wPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_S) {
            sPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_Q) {
            qPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_E) {
            ePressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_Shift) {
            shiftPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_Space) {
            spacePressed = true;
            event.accepted = true;  // Prevent default behavior (scroll)
        } else if (event.key === Qt.Key_R) {
            rPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_T) {
            tPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_A) {
            aPressed = true;
            event.accepted = true;
        } else if (event.key === Qt.Key_D) {
            dPressed = true;
            event.accepted = true;
        }
    }
    
    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_W) {
            wPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_S) {
            sPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_Q) {
            qPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_E) {
            ePressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_Shift) {
            shiftPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_Space) {
            spacePressed = false;
            event.accepted = true;  // Prevent default behavior
        } else if (event.key === Qt.Key_R) {
            rPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_T) {
            tPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_A) {
            aPressed = false;
            event.accepted = true;
        } else if (event.key === Qt.Key_D) {
            dPressed = false;
            event.accepted = true;
        }
    }
    
    focus: true
    Keys.forwardTo: []  // Don't forward keys to children
    
    // Shortcut for Space key to ensure it works
    Shortcut {
        sequence: "Space"
        onActivated: {
            spacePressed = true;
        }
    }
    
    Shortcut {
        sequence: "Shift+Space"
        onActivated: {
            spacePressed = true;
        }
    }
    
    // Ensure focus is maintained
    onActiveFocusChanged: {
        if (!activeFocus) {
            forceActiveFocus();
        }
    }
    
    //! Update camera position or node position based on keyboard input
    Timer {
        interval: 16  // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            // Check if a node is selected
            var hasSelectedNode = scene && scene.selectedNodeId && scene.selectedNodeId !== "" && scene.selectedNodeId !== undefined;
            
            if (hasSelectedNode) {
                // Move/rotate selected node
                var nodeId = scene.selectedNodeId;
                var node = scene.nodes[nodeId];
                if (node) {
                    var rotX = cameraRotationX * Math.PI / 180;
                    var rotY = cameraRotationY * Math.PI / 180;
                    
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    
                    var right = Qt.vector3d(
                        Math.cos(rotY),
                        0,
                        -Math.sin(rotY)
                    ).normalized();
                    
                    var up = Qt.vector3d(0, 1, 0);
                    
                    var newPos = node.position ? node.position : Qt.vector3d(0, 0, 0);
                    var newRot = node.rotation ? node.rotation : Qt.vector3d(0, 0, 0);
                    
                    // Movement in horizontal plane (forward/backward)
                    if (wPressed) {
                        var forwardHorizontal = Qt.vector3d(forward.x, 0, forward.z).normalized();
                        newPos = newPos.plus(forwardHorizontal.times(moveSpeed));
                    }
                    if (sPressed) {
                        var forwardHorizontal = Qt.vector3d(forward.x, 0, forward.z).normalized();
                        newPos = newPos.minus(forwardHorizontal.times(moveSpeed));
                    }
                    
                    // Movement in horizontal plane (left/right)
                    if (qPressed) {
                        newPos = newPos.minus(right.times(moveSpeed));
                    }
                    if (ePressed) {
                        newPos = newPos.plus(right.times(moveSpeed));
                    }
                    
                    // Vertical movement (up/down)
                    if (shiftPressed) {
                        newPos = newPos.minus(up.times(moveSpeed));
                    }
                    if (spacePressed) {
                        newPos = newPos.plus(up.times(moveSpeed));
                    }
                    
                    // Rotation (vertical - R/T)
                    if (rPressed) {
                        newRot = Qt.vector3d(newRot.x - rotationSpeed, newRot.y, newRot.z);
                    }
                    if (tPressed) {
                        newRot = Qt.vector3d(newRot.x + rotationSpeed, newRot.y, newRot.z);
                    }
                    
                    // Rotation (horizontal - A/D)
                    if (aPressed) {
                        newRot = Qt.vector3d(newRot.x, newRot.y - rotationSpeed, newRot.z);
                    }
                    if (dPressed) {
                        newRot = Qt.vector3d(newRot.x, newRot.y + rotationSpeed, newRot.z);
                    }
                    
                    // Update node position and rotation
                    if (newPos !== node.position) {
                        scene.updateNodeProperty(nodeId, "position", newPos);
                    }
                    if (newRot !== node.rotation) {
                        scene.updateNodeProperty(nodeId, "rotation", newRot);
                    }
                }
            } else {
                // Move camera (when no node is selected)
                var rotX = cameraRotationX * Math.PI / 180;
                var rotY = cameraRotationY * Math.PI / 180;
                
                var forward = Qt.vector3d(
                    -Math.sin(rotY) * Math.cos(rotX),
                    Math.sin(rotX),
                    -Math.cos(rotY) * Math.cos(rotX)
                ).normalized();
                
                var right = Qt.vector3d(
                    Math.cos(rotY),
                    0,
                    -Math.sin(rotY)
                ).normalized();
                
                // Movement in horizontal plane (forward/backward)
                if (wPressed) {
                    cameraX += forward.x * moveSpeed;
                    cameraZ += forward.z * moveSpeed;
                    // Don't change Y when moving forward/backward
                }
                if (sPressed) {
                    cameraX -= forward.x * moveSpeed;
                    cameraZ -= forward.z * moveSpeed;
                    // Don't change Y when moving forward/backward
                }
                
                // Movement in horizontal plane (left/right)
                if (qPressed) {
                    cameraX -= right.x * moveSpeed;
                    cameraZ -= right.z * moveSpeed;
                }
                if (ePressed) {
                    cameraX += right.x * moveSpeed;
                    cameraZ += right.z * moveSpeed;
                }
                
                // Vertical movement (up/down) - only changes Y, no rotation change
                if (shiftPressed) {
                    cameraY -= moveSpeed;
                }
                if (spacePressed) {
                    cameraY += moveSpeed;
                }
                
                // Rotation (vertical - R/T)
                if (rPressed) {
                    cameraRotationX -= rotationSpeed;
                    cameraRotationX = Math.max(-89, Math.min(89, cameraRotationX));  // Clamp
                }
                if (tPressed) {
                    cameraRotationX += rotationSpeed;
                    cameraRotationX = Math.max(-89, Math.min(89, cameraRotationX));  // Clamp
                }
                
                // Rotation (horizontal - A/D)
                if (aPressed) {
                    cameraRotationY -= rotationSpeed;
                }
                if (dPressed) {
                    cameraRotationY += rotationSpeed;
                }
            }
        }
    }
    
    //! Mouse handling for camera rotation and node creation/selection
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        focus: false  // Don't take focus from parent
        propagateComposedEvents: false
        z: -1  // Behind other elements
        
        onPressed: (mouse) => {
            // Force focus back to root item
            root.forceActiveFocus();
            
            if (mouse.button === Qt.RightButton) {
                mouseRotating = true;
                lastMousePos = Qt.point(mouse.x, mouse.y);
            } else if (mouse.button === Qt.LeftButton) {
                // Prevent camera rotation when clicking
                mouseRotating = false;
                
                // Check if clicking on a node
                var pickResult = view3d.pick(mouse.x, mouse.y);
                var clickedNodeId = null;
                
                // Always use scenePosition to find closest node (more reliable)
                if (pickResult && pickResult.scenePosition && scene && scene.nodes) {
                    var pickPos = pickResult.scenePosition;
                    var minDist = Infinity;
                    var bestNodeId = null;
                    
                    // Find closest node by position
                    for (var nodeId in scene.nodes) {
                        var node = scene.nodes[nodeId];
                        if (!node || !node.position) continue;
                        
                        var nodePos = node.position;
                        var dist = Math.sqrt(
                            Math.pow(pickPos.x - nodePos.x, 2) +
                            Math.pow(pickPos.y - nodePos.y, 2) +
                            Math.pow(pickPos.z - nodePos.z, 2)
                        );
                        
                        // Check if within node bounds (approximate)
                        // Convert dimensions from cm to meters and calculate bounding sphere radius
                        var maxDim = Math.max(node.dimensions.x, node.dimensions.y, node.dimensions.z) * 0.01;
                        var nodeRadius = maxDim * 1.5; // Half diagonal of the box * 1.5 for easier clicking
                        
                        if (dist < nodeRadius && dist < minDist) {
                            minDist = dist;
                            bestNodeId = nodeId;
                        }
                    }
                    
                    if (bestNodeId) {
                        clickedNodeId = bestNodeId;
                    }
                }
                
                // Also try objectHit if available
                if (!clickedNodeId && pickResult && pickResult.objectHit) {
                    var objectHit = pickResult.objectHit;
                    var objectName = objectHit.objectName;
                    
                    if (objectName && objectName.startsWith("node_")) {
                        clickedNodeId = objectName;
                    } else {
                        // Try to find the parent Node
                        var parentNode = objectHit.parent;
                        var depth = 0;
                        while (parentNode && depth < 10) {
                            if (parentNode.objectName && parentNode.objectName.startsWith("node_")) {
                                clickedNodeId = parentNode.objectName;
                                break;
                            }
                            parentNode = parentNode.parent;
                            depth++;
                        }
                    }
                }
                
                if (clickedNodeId) {
                    // Select the clicked node
                    scene.selectNode(clickedNodeId);
                    
                    // Start dragging
                    draggingNode = true;
                    draggedNodeId = clickedNodeId;
                    var node = scene.nodes[clickedNodeId];
                    if (node && node.position) {
                        dragStartPos = node.position;
                    }
                    dragStartMouse = Qt.point(mouse.x, mouse.y);
                } else {
                    // No node clicked - just deselect
                    scene.deselectAll();
                    draggingNode = false;
                    draggedNodeId = "";
                }
            }
        }
        
        onDoubleClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // Double click - create a new node at click position
                var pickResult = view3d.pick(mouse.x, mouse.y);
                
                // Calculate 3D position from click
                var spawnPos = Qt.vector3d(0, 0.25, 0);
                
                // First try to use pick result if it hit ground plane
                if (pickResult && pickResult.objectHit) {
                    var hitObject = pickResult.objectHit;
                    if (hitObject.objectName === "groundPlane" && pickResult.scenePosition) {
                        spawnPos = pickResult.scenePosition;
                        spawnPos.y = 0.25; // Place on ground
                    } else if (pickResult.scenePosition) {
                        // Hit something else, use its position
                        spawnPos = pickResult.scenePosition;
                        spawnPos.y = 0.25; // Place on ground
                    }
                }
                
                // If we don't have a valid position from picking, use ray casting
                if (spawnPos.x === 0 && spawnPos.z === 0) {
                    // Calculate position using ray casting to ground plane
                    var camera = view3d.camera;
                    var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                    
                    // Calculate ray direction from camera through mouse position
                    var rotX = cameraRotationX * Math.PI / 180;
                    var rotY = cameraRotationY * Math.PI / 180;
                    
                    // Forward direction
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    
                    // Right direction (horizontal)
                    var right = Qt.vector3d(
                        Math.cos(rotY),
                        0,
                        -Math.sin(rotY)
                    ).normalized();
                    
                    // Up direction (perpendicular to forward and right)
                    var up = forward.crossProduct(right).normalized();
                    
                    // Calculate screen center
                    var centerX = view3d.width / 2;
                    var centerY = view3d.height / 2;
                    
                    // Calculate offset from center (normalized to -1 to 1)
                    var offsetX = (mouse.x - centerX) / view3d.width;
                    var offsetY = (mouse.y - centerY) / view3d.height;
                    
                    // Calculate FOV-based scaling
                    var fov = camera.fieldOfView * Math.PI / 180;
                    var aspectRatio = view3d.width / view3d.height;
                    var tanHalfFov = Math.tan(fov / 2);
                    
                    // Calculate ray direction in world space
                    var rayDir = forward
                        .plus(right.times(offsetX * tanHalfFov * aspectRatio * 2))
                        .plus(up.times(-offsetY * tanHalfFov * 2))
                        .normalized();
                    
                    // Intersect with ground plane (y = 0)
                    // Ray equation: P = cameraPos + t * rayDir
                    // Ground plane: y = 0
                    // Solve: cameraY + t * rayDir.y = 0
                    if (Math.abs(rayDir.y) > 0.001) {
                        var t = -cameraY / rayDir.y;
                        if (t > 0) {
                            spawnPos = cameraPos.plus(rayDir.times(t));
                            spawnPos.y = 0.25; // Place on ground (half height of 50cm cube)
                        } else {
                            // Ray pointing up, create in front of camera
                            spawnPos = cameraPos.plus(forward.times(200));
                            spawnPos.y = 0.25;
                        }
                    } else {
                        // Ray parallel to ground, create in front of camera
                        spawnPos = cameraPos.plus(forward.times(200));
                        spawnPos.y = 0.25;
                    }
                }
                
                // Create node at calculated position
                scene.createNode(spawnPos.x, spawnPos.y, spawnPos.z, root.selectedShapeType);
            }
        }
        
        onPositionChanged: (mouse) => {
            if (mouseRotating) {
                var deltaX = mouse.x - lastMousePos.x;
                var deltaY = mouse.y - lastMousePos.y;
                
                cameraRotationY -= deltaX * mouseRotationSpeed;
                cameraRotationX -= deltaY * mouseRotationSpeed;
                
                // Clamp vertical rotation
                cameraRotationX = Math.max(-89, Math.min(89, cameraRotationX));
                
                lastMousePos = Qt.point(mouse.x, mouse.y);
            } else if (resizingNode && resizedNodeId && resizeHandleIndex >= 0 && scene && scene.nodes[resizedNodeId]) {
                // Resize the node
                var node = scene.nodes[resizedNodeId];
                if (!node || !node.dimensions) return;
                
                // Calculate mouse delta
                var deltaX = mouse.x - resizeStartMouse.x;
                var deltaY = mouse.y - resizeStartMouse.y;
                
                // Calculate distance from camera to node
                var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                var toNode = resizeStartPos.minus(cameraPos);
                var distance = Math.sqrt(toNode.x * toNode.x + toNode.y * toNode.y + toNode.z * toNode.z);
                
                // Calculate FOV-based scaling
                var fov = 60.0 * Math.PI / 180;
                var aspectRatio = view3d.width / view3d.height;
                var scaleX = Math.tan(fov / 2) * distance * 2;
                var scaleY = scaleX / aspectRatio;
                
                // Convert screen delta to 3D world delta
                var worldDelta = Math.sqrt(
                    Math.pow((deltaX / view3d.width) * scaleX, 2) +
                    Math.pow((deltaY / view3d.height) * scaleY, 2)
                ) * 100; // Convert to cm
                
                // Determine which dimensions to resize based on handle index
                // Handle indices: 0=TRF, 1=TLF, 2=TRB, 3=TLB, 4=BRF, 5=BLF, 6=BRB, 7=BLB
                // T=Top, B=Bottom, R=Right, L=Left, F=Front, B=Back
                var newDims = resizeStartDims;
                var scaleFactor = 1.0 + (worldDelta / 100.0); // Scale factor
                
                // Resize based on corner position
                // For simplicity, resize all dimensions proportionally
                // You can make it more sophisticated by checking handle index
                newDims = Qt.vector3d(
                    Math.max(10, resizeStartDims.x * scaleFactor),
                    Math.max(10, resizeStartDims.y * scaleFactor),
                    Math.max(10, resizeStartDims.z * scaleFactor)
                );
                
                scene.updateNodeProperty(resizedNodeId, "dimensions", newDims);
            } else if (draggingNode && draggedNodeId && scene && scene.nodes[draggedNodeId]) {
                // Drag the selected node
                var node = scene.nodes[draggedNodeId];
                if (!node || !node.position) return;
                
                // Calculate mouse delta
                var deltaX = mouse.x - dragStartMouse.x;
                var deltaY = mouse.y - dragStartMouse.y;
                
                // Calculate camera vectors
                var rotX = cameraRotationX * Math.PI / 180;
                var rotY = cameraRotationY * Math.PI / 180;
                
                var forward = Qt.vector3d(
                    -Math.sin(rotY) * Math.cos(rotX),
                    Math.sin(rotX),
                    -Math.cos(rotY) * Math.cos(rotX)
                ).normalized();
                
                var right = Qt.vector3d(
                    Math.cos(rotY),
                    0,
                    -Math.sin(rotY)
                ).normalized();
                
                var up = Qt.vector3d(0, 1, 0);
                
                // Calculate distance from camera to node
                var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                var toNode = dragStartPos.minus(cameraPos);
                var distance = Math.sqrt(toNode.x * toNode.x + toNode.y * toNode.y + toNode.z * toNode.z);
                
                // Calculate FOV-based scaling
                var fov = 60.0 * Math.PI / 180;
                var aspectRatio = view3d.width / view3d.height;
                var scaleX = Math.tan(fov / 2) * distance * 2;
                var scaleY = scaleX / aspectRatio;
                
                // Convert screen delta to 3D world delta
                var worldDeltaX = (deltaX / view3d.width) * scaleX;
                var worldDeltaY = (deltaY / view3d.height) * scaleY;
                
                // Calculate new 3D position
                var newPos = dragStartPos
                    .plus(right.times(worldDeltaX))
                    .plus(up.times(-worldDeltaY)); // Negative Y because screen Y is inverted
                
                // Update node position
                scene.updateNodeProperty(draggedNodeId, "position", newPos);
            }
        }
        
        onReleased: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                mouseRotating = false;
            } else if (mouse.button === Qt.LeftButton) {
                draggingNode = false;
                draggedNodeId = "";
                resizingNode = false;
                resizedNodeId = "";
                resizeHandleIndex = -1;
            }
        }
        
    }
    
}

