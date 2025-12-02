import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Controls

import NodeLink
import QtQuickStream
import simple3DNodeLink

/*! ***********************************************************************************************
 * Simple3DNodeLinkView - Main 3D view for displaying nodes in 3D space using QtQuick3D
 * ************************************************************************************************/

Item {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property Simple3DNodeLinkScene scene
    property SceneSession sceneSession: SceneSession {}

    // Camera control properties
    property real cameraX: 150
    property real cameraY: 100
    property real cameraZ: 600
    property real cameraRotationX: -25
    property real cameraRotationY: 20
    
    // Movement speed
    property real moveSpeed: 5.0
    property real rotationSpeed: 2.0
    property real mouseRotationSpeed: 0.5  // Mouse rotation sensitivity
    
    // Perspective scaling
    property real baseDistance: 500.0  // Base distance for scale calculation
    property real minScale: 0.3  // Minimum scale when far away
    property real maxScale: 1.5  // Maximum scale when close
    property real fadeStartDistance: 1800.0  // Start fading at this distance
    property real fadeEndDistance: 1800.0  // Completely invisible at this distance
    
    // Keyboard state
    property bool wPressed: false
    property bool sPressed: false
    property bool ePressed: false
    property bool qPressed: false
    property bool shiftPressed: false
    property bool spacePressed: false
    property bool rPressed: false
    property bool tPressed: false
    
    // Mouse rotation state
    property bool mouseRotating: false
    property point lastMousePos: Qt.point(0, 0)
    
    // View3D alias for access from child components
    property alias view3d: view3d

    /* Children
     * ****************************************************************************************/

    //! Background
    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a1a" }
            GradientStop { position: 1.0; color: "#0d0d0d" }
        }
    }

    //! 3D Scene
    View3D {
        id: view3d
        anchors.fill: parent
        camera: camera

        //! Camera
        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(cameraX, cameraY, cameraZ)
            eulerRotation: Qt.vector3d(cameraRotationX, cameraRotationY, 0)
        }

        //! Environment
        environment: SceneEnvironment {
            clearColor: "#1a1a1a"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }

        //! Lighting
        DirectionalLight {
            id: mainLight
            eulerRotation: Qt.vector3d(-45, -45, 0)
            color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
            brightness: 0.8
        }

        //! Ambient lighting (using a second directional light)
        DirectionalLight {
            eulerRotation: Qt.vector3d(-90, 0, 0)
            color: Qt.rgba(0.3, 0.3, 0.4, 1.0)
            brightness: 0.3
        }


        //! Axes Helper - Shows X (red), Y (green), Z (blue) axes
        AxisHelper {
            id: axesHelper
            scale: Qt.vector3d(1, 1, 1)
        }

        //! Nodes are rendered as 2D overlay (not 3D models) for full interactivity

        //! Links are rendered in the 2D overlay (see below) - no 3D cylinder needed
    }

    //! Overlay for nodes, links, and interaction (2D overlay for full interactivity)
    Item {
        id: nodesOverlay
        anchors.fill: parent
        z: 1
        
        //! Nodes as direct QML Items (fully interactive like 2D examples)
        Repeater {
            model: scene ? Object.keys(scene.nodes || {}) : []
            delegate: Simple3DNodeLinkNodeView {
                id: overlayNodeView
                property var nodeData: {
                    try {
                        return scene?.nodes?.[modelData];
                    } catch (e) {
                        return null;
                    }
                }
                property var pos3D: {
                    try {
                        if (!nodeData || !nodeData.guiConfig) return Qt.vector3d(0, 0, 0);
                        return Qt.vector3d(
                            nodeData.guiConfig?.position3D?.x ?? 0,
                            nodeData.guiConfig?.position3D?.y ?? 0,
                            nodeData.guiConfig?.position3D?.z ?? 0
                        );
                    } catch (e) {
                        return Qt.vector3d(0, 0, 0);
                    }
                }
                
                property bool _firstXCalc: false
                property bool _firstYCalc: false
                
                node: nodeData
                scene: root.scene
                sceneSession: root.sceneSession
                
                visible: {
                    if (nodeData === null || nodeData === undefined) return false;
                    
                    // Hide node if it's too far away (beyond fadeEndDistance)
                    var distance = distanceFromCamera;
                    if (distance > root.fadeEndDistance) return false;
                    
                    return true;
                }
                
                // Calculate distance from camera to node for scaling
                property real distanceFromCamera: {
                    try {
                        if (!nodeData || !nodeData.guiConfig || !nodeData.guiConfig.position3D) return root.baseDistance;
                        var pos3D = nodeData.guiConfig.position3D;
                        var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                        var diff = pos3D.minus(cameraPos);
                        return Math.sqrt(diff.x * diff.x + diff.y * diff.y + diff.z * diff.z);
                    } catch (e) {
                        // Object destroyed, return base distance
                        return root.baseDistance;
                    }
                }
                
                // Calculate view direction (camera forward vector)
                property vector3d viewDirection: {
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    return Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                }
                
                // Calculate node normal (assuming nodes are in XY plane, facing +Z)
                property vector3d nodeNormal: Qt.vector3d(0, 0, 1)
                
                // Calculate angle between view direction and node normal
                property real viewAngle: {
                    var dot = viewDirection.x * nodeNormal.x + viewDirection.y * nodeNormal.y + viewDirection.z * nodeNormal.z;
                    // Clamp dot product to [-1, 1] to avoid NaN in acos
                    dot = Math.max(-1, Math.min(1, dot));
                    return Math.acos(dot) * 180 / Math.PI; // Convert to degrees
                }
                
                // Calculate camera right and up vectors for perspective calculation
                property vector3d cameraRight: {
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    return Qt.vector3d(
                        Math.cos(rotY),
                        0,
                        Math.sin(rotY)
                    ).normalized();
                }
                
                property vector3d cameraUp: {
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    return Qt.vector3d(
                        Math.sin(rotY) * Math.sin(rotX),
                        Math.cos(rotX),
                        Math.cos(rotY) * Math.sin(rotX)
                    ).normalized();
                }
                
                // Calculate perspective scale factors (independent X and Y scaling)
                // For proper perspective, we need to consider the angle between view direction and node plane
                property real perspectiveScaleX: {
                    // Force dependency on camera properties for reactive updates
                    var _ = root.cameraX + root.cameraY + root.cameraZ + root.cameraRotationX + root.cameraRotationY;
                    
                    var distance = distanceFromCamera;
                    if (distance <= 0) return 1.0;
                    
                    // Base scale based on distance
                    var baseScale = root.baseDistance / distance;
                    
                    // Calculate the angle between view direction and node normal
                    // When view direction is parallel to node normal (looking straight at node), scale should be normal
                    // When view direction is perpendicular (looking from side), scale should be smaller
                    var viewDot = viewDirection.x * nodeNormal.x + viewDirection.y * nodeNormal.y + viewDirection.z * nodeNormal.z;
                    viewDot = Math.max(-1, Math.min(1, viewDot)); // Clamp to avoid NaN
                    var angleToNormal = Math.acos(Math.abs(viewDot)) * 180 / Math.PI; // Angle in degrees
                    
                    // Calculate X perspective factor based on how much we're looking from the side (X direction)
                    // Project view direction onto XZ plane to see X component
                    var viewDirXZ = Qt.vector3d(viewDirection.x, 0, viewDirection.z);
                    if (viewDirXZ.length() > 0.001) {
                        viewDirXZ = viewDirXZ.normalized();
                    } else {
                        viewDirXZ = Qt.vector3d(1, 0, 0);
                    }
                    var xAxis = Qt.vector3d(1, 0, 0);
                    var xDot = Math.max(-1, Math.min(1, viewDirXZ.x * xAxis.x + viewDirXZ.z * xAxis.z));
                    var xAngle = Math.acos(xDot) * 180 / Math.PI;
                    // When xAngle is 0 or 180 (looking along X axis), X scale should be smaller
                    // When xAngle is 90 (looking perpendicular to X), X scale should be normal
                    var xPerspectiveFactor = Math.sin(xAngle * Math.PI / 180);
                    xPerspectiveFactor = Math.max(0.3, xPerspectiveFactor); // Minimum 30% to avoid too small
                    
                    var scaleX = baseScale * xPerspectiveFactor;
                    
                    // Clamp scale between min and max
                    if (scaleX < root.minScale) scaleX = root.minScale;
                    if (scaleX > root.maxScale) scaleX = root.maxScale;
                    
                    return scaleX;
                }
                
                property real perspectiveScaleY: {
                    // Force dependency on camera properties for reactive updates
                    var _ = root.cameraX + root.cameraY + root.cameraZ + root.cameraRotationX + root.cameraRotationY;
                    
                    var distance = distanceFromCamera;
                    if (distance <= 0) return 1.0;
                    
                    // Base scale based on distance
                    var baseScale = root.baseDistance / distance;
                    
                    // Calculate Y perspective factor based on how much we're looking from top/bottom (Y direction)
                    // Project view direction onto YZ plane to see Y component
                    var viewDirYZ = Qt.vector3d(0, viewDirection.y, viewDirection.z);
                    if (viewDirYZ.length() > 0.001) {
                        viewDirYZ = viewDirYZ.normalized();
                    } else {
                        viewDirYZ = Qt.vector3d(0, 1, 0);
                    }
                    var yAxis = Qt.vector3d(0, 1, 0);
                    var yDot = Math.max(-1, Math.min(1, viewDirYZ.y * yAxis.y + viewDirYZ.z * yAxis.z));
                    var yAngle = Math.acos(yDot) * 180 / Math.PI;
                    // When yAngle is 0 or 180 (looking along Y axis), Y scale should be smaller
                    // When yAngle is 90 (looking perpendicular to Y), Y scale should be normal
                    var yPerspectiveFactor = Math.sin(yAngle * Math.PI / 180);
                    yPerspectiveFactor = Math.max(0.3, yPerspectiveFactor); // Minimum 30% to avoid too small
                    
                    var scaleY = baseScale * yPerspectiveFactor;
                    
                    // Clamp scale between min and max
                    if (scaleY < root.minScale) scaleY = root.minScale;
                    if (scaleY > root.maxScale) scaleY = root.maxScale;
                    
                    return scaleY;
                }
                
                // Apply perspective transform with independent X and Y scaling
                transform: [
                    Scale {
                        xScale: overlayNodeView.perspectiveScaleX
                        yScale: overlayNodeView.perspectiveScaleY
                        origin.x: (nodeData?.guiConfig?.width ?? 160) / 2
                        origin.y: (nodeData?.guiConfig?.height ?? 100) / 2
                    }
                ]
                
                // Opacity based on distance - fade out when too far
                opacity: {
                    // Force dependency on camera position for reactive updates
                    var _ = root.cameraX + root.cameraY + root.cameraZ;
                    
                    var distance = distanceFromCamera;
                    if (distance <= 0) return 1.0;
                    
                    // Start fading at fadeStartDistance, completely invisible at fadeEndDistance
                    if (distance > root.fadeStartDistance) {
                        var fadeRange = root.fadeEndDistance - root.fadeStartDistance;
                        var fadeProgress = (distance - root.fadeStartDistance) / fadeRange;
                        // Clamp fadeProgress between 0 and 1
                        fadeProgress = Math.max(0, Math.min(1, fadeProgress));
                        return 1.0 - fadeProgress;  // Fade from 1.0 to 0.0
                    }
                    return 1.0;  // Fully visible when close
                }
                
                // Convert 3D position to 2D screen coordinates (updates with camera movement)
                x: {
                    var v3d = root.view3d;
                    if (!nodeData || !v3d) return -10000;
                    
                    // Force dependency on camera properties for reactive updates
                    var _ = root.cameraX + root.cameraY + root.cameraZ + root.cameraRotationX + root.cameraRotationY;
                    
                    var pos3D = nodeData.guiConfig?.position3D;
                    if (!pos3D) {
                        // Fallback: use 2D position
                        var pos2D = nodeData.guiConfig?.position;
                        if (pos2D) {
                            return pos2D.x - (nodeData.guiConfig?.width ?? 160) / 2;
                        }
                        return -10000;
                    }
                    
                    // Convert 3D world coordinates to 2D screen coordinates
                    var screenPos = v3d.mapFrom3DScene(Qt.vector3d(pos3D.x, pos3D.y, pos3D.z));
                    
                    // Check if screenPos is valid and node is in front of camera
                    if (isNaN(screenPos.x) || isNaN(screenPos.y)) {
                        return -10000;
                    }
                    
                    // Check if node is behind camera (z < 0 in camera space)
                    // If behind camera, don't show it (return off-screen)
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    var toNode = pos3D.minus(cameraPos);
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    var dotProduct = toNode.x * forward.x + toNode.y * forward.y + toNode.z * forward.z;
                    if (dotProduct < 0) {
                        // Node is behind camera
                        return -10000;
                    }
                    
                    // Center the node on the screen position
                    return screenPos.x - (nodeData.guiConfig?.width ?? 160) / 2;
                }
                y: {
                    var v3d = root.view3d;
                    if (!nodeData || !v3d) return -10000;
                    
                    // Force dependency on camera properties for reactive updates
                    var _ = root.cameraX + root.cameraY + root.cameraZ + root.cameraRotationX + root.cameraRotationY;
                    
                    var pos3D = nodeData.guiConfig?.position3D;
                    if (!pos3D) {
                        // Fallback: use 2D position
                        var pos2D = nodeData.guiConfig?.position;
                        if (pos2D) {
                            return pos2D.y - (nodeData.guiConfig?.height ?? 100) / 2;
                        }
                        return -10000;
                    }
                    
                    // Convert 3D world coordinates to 2D screen coordinates
                    var screenPos = v3d.mapFrom3DScene(Qt.vector3d(pos3D.x, pos3D.y, pos3D.z));
                    
                    // Check if screenPos is valid and node is in front of camera
                    if (isNaN(screenPos.x) || isNaN(screenPos.y)) {
                        return -10000;
                    }
                    
                    // Check if node is behind camera (same check as in x binding)
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    var toNode = pos3D.minus(cameraPos);
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    var dotProduct = toNode.x * forward.x + toNode.y * forward.y + toNode.z * forward.z;
                    if (dotProduct < 0) {
                        // Node is behind camera
                        return -10000;
                    }
                    
                    // Center the node on the screen position
                    return screenPos.y - (nodeData.guiConfig?.height ?? 100) / 2;
                }
                
                // PortView components inside NodeView automatically update port._position
                // via their globalX/globalY properties based on overlayNodeView.x and overlayNodeView.y
                // Since overlayNodeView.x and overlayNodeView.y are reactive bindings that update with camera movement,
                // PortView will automatically update port._position when the node position changes
                // No manual update needed - QML bindings handle the updates automatically
                
                Component.onCompleted: {
                    // Node view created
                }
                
                // Handle node selection - remove focus from root when node is selected
                Connections {
                    target: scene && scene.selectionModel ? scene.selectionModel : null
                    function onSelectedObjectChanged() {
                        // Check if objects are still valid
                        if (!scene || !scene.selectionModel || !nodeData) return;
                        try {
                            var isSelected = scene.selectionModel.isSelected(nodeData._qsUuid);
                            if (isSelected) {
                                if (root) root.focus = false;
                            } else {
                                var selectedCount = Object.keys(scene.selectionModel.selectedModel || {}).length;
                                if (selectedCount === 0 && root) {
                                    root.forceActiveFocus();
                                }
                            }
                        } catch (e) {
                            // Object destroyed during operation, ignore
                        }
                    }
                }
            }
        }
        
        //! Links representation using LinkView (for interaction)
        Repeater {
            model: scene ? Object.keys(scene.links || {}) : []
            delegate: LinkView {
                id: linkViewItem
                property var linkData: scene?.links?.[modelData]
                property var inputNode: scene?.nodes?.[scene?.findNodeId(linkData?.inputPort?._qsUuid)]
                property var outputNode: scene?.nodes?.[scene?.findNodeId(linkData?.outputPort?._qsUuid)]
                
                link: linkData
                scene: root.scene
                sceneSession: root.sceneSession
                z: 0  // Links behind nodes
                
                // Calculate distance from camera to link (average of input and output nodes)
                property real distanceFromCamera: {
                    if (!inputNode || !outputNode) return root.baseDistance;
                    
                    var inputPos3D = inputNode.guiConfig?.position3D;
                    var outputPos3D = outputNode.guiConfig?.position3D;
                    
                    if (!inputPos3D || !outputPos3D) return root.baseDistance;
                    
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    
                    // Calculate distance to input node
                    var toInput = inputPos3D.minus(cameraPos);
                    var distInput = Math.sqrt(toInput.x * toInput.x + toInput.y * toInput.y + toInput.z * toInput.z);
                    
                    // Calculate distance to output node
                    var toOutput = outputPos3D.minus(cameraPos);
                    var distOutput = Math.sqrt(toOutput.x * toOutput.x + toOutput.y * toOutput.y + toOutput.z * toOutput.z);
                    
                    // Return average distance
                    return (distInput + distOutput) / 2;
                }
                
                // Opacity based on distance - fade out when too far (same as nodes)
                opacity: {
                    // Force dependency on camera position for reactive updates
                    var _ = root.cameraX + root.cameraY + root.cameraZ;
                    
                    var distance = distanceFromCamera;
                    if (distance <= 0) return 1.0;
                    
                    // Start fading at fadeStartDistance, completely invisible at fadeEndDistance
                    if (distance > root.fadeStartDistance) {
                        var fadeRange = root.fadeEndDistance - root.fadeStartDistance;
                        var fadeProgress = (distance - root.fadeStartDistance) / fadeRange;
                        // Clamp fadeProgress between 0 and 1
                        fadeProgress = Math.max(0, Math.min(1, fadeProgress));
                        return 1.0 - fadeProgress;  // Fade from 1.0 to 0.0
                    }
                    return 1.0;  // Fully visible when close
                }
                
                // Hide link if either node is too far away or behind camera
                visible: {
                    if (!inputNode || !outputNode) return false;
                    
                    // Check if nodes are behind camera
                    var inputPos3D = inputNode.guiConfig?.position3D;
                    var outputPos3D = outputNode.guiConfig?.position3D;
                    
                    if (!inputPos3D || !outputPos3D) return false;
                    
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    
                    // Check if input node is behind camera
                    var toInput = inputPos3D.minus(cameraPos);
                    var dotInput = toInput.x * forward.x + toInput.y * forward.y + toInput.z * forward.z;
                    
                    // Check if output node is behind camera
                    var toOutput = outputPos3D.minus(cameraPos);
                    var dotOutput = toOutput.x * forward.x + toOutput.y * forward.y + toOutput.z * forward.z;
                    
                    // Hide link if both nodes are behind camera
                    if (dotInput < 0 && dotOutput < 0) return false;
                    
                    // Check if port positions are valid (not off-screen)
                    // LinkView uses inputPos and outputPos which come from port._position
                    // If ports are off-screen (position < -1000), hide the link
                    var inputPort = linkData?.inputPort;
                    var outputPort = linkData?.outputPort;
                    if (inputPort && inputPort._position && 
                        (inputPort._position.x < -1000 || inputPort._position.y < -1000)) {
                        return false;
                    }
                    if (outputPort && outputPort._position && 
                        (outputPort._position.x < -1000 || outputPort._position.y < -1000)) {
                        return false;
                    }
                    
                    var distance = distanceFromCamera;
                    if (distance > root.fadeEndDistance) return false;
                    
                    return true;
                }
            }
        }

        //! LinkHelperView3D for connecting nodes in 3D space
        LinkHelperView3D {
            id: linkHelperView
            anchors.fill: parent
            scene: root.scene
            sceneSession: root.sceneSession
            view3d: root.view3d
            cameraX: root.cameraX
            cameraY: root.cameraY
            cameraZ: root.cameraZ
            cameraRotationX: root.cameraRotationX
            cameraRotationY: root.cameraRotationY
            z: 2000  // Above everything
        }
        
        //! Timer to update port positions for LinkView
        //! This ensures port._position is always accurate based on 3D positions
        //! Port positions are calculated directly from 3D node positions for precision
        //! This timer runs at high frequency to ensure links always connect precisely to ports
        Timer {
            id: portUpdateTimer
            interval: 16  // ~60 FPS - high frequency for smooth updates
            running: true
            repeat: true
            onTriggered: {
                if (!scene || !root.view3d) return;
                
                var v3d = root.view3d;
                // Update port positions for all nodes
                Object.values(scene.nodes).forEach(function(node) {
                    if (!node || !node.ports || !node.guiConfig) return;
                    
                    var pos3D = node.guiConfig.position3D;
                    if (!pos3D) return;
                    
                    // Check if node is behind camera
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    var toNode = pos3D.minus(cameraPos);
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    var dotProduct = toNode.x * forward.x + toNode.y * forward.y + toNode.z * forward.z;
                    if (dotProduct < 0) {
                        // Node is behind camera, skip port updates
                        return;
                    }
                    
                    // Convert 3D node position to 2D screen coordinates
                    // This gives us the center of the node on screen
                    var nodeScreenPos = v3d.mapFrom3DScene(Qt.vector3d(pos3D.x, pos3D.y, pos3D.z));
                    
                    // Check if screenPos is valid
                    if (isNaN(nodeScreenPos.x) || isNaN(nodeScreenPos.y)) {
                        return;
                    }
                    
                    // Update node's 2D position for LinkHelperView (it uses node.guiConfig.position)
                    // This is needed for findClosestPort to work correctly
                    try {
                        if (!node || !node.guiConfig) return;
                        var node2DPos = Qt.vector2d(
                            nodeScreenPos.x - (node.guiConfig?.width ?? 160) / 2,
                            nodeScreenPos.y - (node.guiConfig?.height ?? 100) / 2
                        );
                        // Always update to ensure it's correct
                        node.guiConfig.position.x = node2DPos.x;
                        node.guiConfig.position.y = node2DPos.y;
                    } catch (e) {
                        // Object destroyed during operation, skip
                        return;
                    }
                    
                    // Calculate node scale factors (same as overlayNodeView perspectiveScaleX/Y)
                    var distance = Math.sqrt(toNode.x * toNode.x + toNode.y * toNode.y + toNode.z * toNode.z);
                    var baseScale = 1.0;
                    if (distance > 0) {
                        baseScale = root.baseDistance / distance;
                    }
                    
                    // Calculate view direction for perspective
                    var viewDirection = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    
                    var nodeNormal = Qt.vector3d(0, 0, 1);
                    
                    // Calculate X perspective factor
                    var viewDirXZ = Qt.vector3d(viewDirection.x, 0, viewDirection.z);
                    if (viewDirXZ.length() > 0.001) {
                        viewDirXZ = viewDirXZ.normalized();
                    } else {
                        viewDirXZ = Qt.vector3d(1, 0, 0);
                    }
                    var xAxis = Qt.vector3d(1, 0, 0);
                    var xDot = Math.max(-1, Math.min(1, viewDirXZ.x * xAxis.x + viewDirXZ.z * xAxis.z));
                    var xAngle = Math.acos(xDot) * 180 / Math.PI;
                    var xPerspectiveFactor = Math.sin(xAngle * Math.PI / 180);
                    xPerspectiveFactor = Math.max(0.3, xPerspectiveFactor);
                    var scaleX = baseScale * xPerspectiveFactor;
                    if (scaleX < root.minScale) scaleX = root.minScale;
                    if (scaleX > root.maxScale) scaleX = root.maxScale;
                    
                    // Calculate Y perspective factor
                    var viewDirYZ = Qt.vector3d(0, viewDirection.y, viewDirection.z);
                    if (viewDirYZ.length() > 0.001) {
                        viewDirYZ = viewDirYZ.normalized();
                    } else {
                        viewDirYZ = Qt.vector3d(0, 1, 0);
                    }
                    var yAxis = Qt.vector3d(0, 1, 0);
                    var yDot = Math.max(-1, Math.min(1, viewDirYZ.y * yAxis.y + viewDirYZ.z * yAxis.z));
                    var yAngle = Math.acos(yDot) * 180 / Math.PI;
                    var yPerspectiveFactor = Math.sin(yAngle * Math.PI / 180);
                    yPerspectiveFactor = Math.max(0.3, yPerspectiveFactor);
                    var scaleY = baseScale * yPerspectiveFactor;
                    if (scaleY < root.minScale) scaleY = root.minScale;
                    if (scaleY > root.maxScale) scaleY = root.maxScale;
                    
                    // Find the overlayNodeView for this node to get its actual rendered position and scale
                    var overlayNodeView = null;
                    for (var i = 0; i < nodesOverlay.children.length; i++) {
                        var child = nodesOverlay.children[i];
                        if (child && child.nodeData && child.nodeData._qsUuid === node._qsUuid) {
                            overlayNodeView = child;
                            break;
                        }
                    }
                    
                    // Use overlayNodeView scale if available (more accurate), otherwise use calculated values
                    var actualScaleX = overlayNodeView ? overlayNodeView.perspectiveScaleX : scaleX;
                    var actualScaleY = overlayNodeView ? overlayNodeView.perspectiveScaleY : scaleY;
                    // Use average scale for port offset calculation (or we could use separate X/Y for each port side)
                    var actualScale = (actualScaleX + actualScaleY) / 2;
                    
                    // Update port positions based on node's screen position
                    // Calculate port positions relative to node center, then add node position
                    // IMPORTANT: Port offsets must be multiplied by scale factor because nodes are scaled
                    Object.values(node.ports).forEach(function(port) {
                        if (!port) return;
                        
                        // Calculate port offset from node center based on port side
                        var portOffsetX = 0;
                        var portOffsetY = 0;
                        
                        var nodeWidth = node.guiConfig?.width ?? 160;
                        var nodeHeight = node.guiConfig?.height ?? 100;
                        
                        // Port position relative to node center (before scaling)
                        // This matches how ports are positioned in InteractiveNodeView
                        switch(port.portSide) {
                            case NLSpec.PortPositionSide.Left:
                                portOffsetX = -nodeWidth / 2;
                                break;
                            case NLSpec.PortPositionSide.Right:
                                portOffsetX = nodeWidth / 2;
                                break;
                            case NLSpec.PortPositionSide.Top:
                                portOffsetY = -nodeHeight / 2;
                                break;
                            case NLSpec.PortPositionSide.Bottom:
                                portOffsetY = nodeHeight / 2;
                                break;
                        }
                        
                        // CRITICAL: Multiply port offset by scale factor
                        // When node is scaled, port positions must also be scaled
                        // This ensures links always connect precisely to ports regardless of zoom level
                        portOffsetX = portOffsetX * actualScale;
                        portOffsetY = portOffsetY * actualScale;
                        
                        // Calculate port's absolute 2D screen position (center of port)
                        // nodeScreenPos is the center of the node on screen
                        // portOffsetX/Y is the scaled offset from node center to port center
                        // port._position must be the center of the port circle for LinkPainter
                        var portScreenPos = Qt.vector2d(
                            nodeScreenPos.x + portOffsetX,
                            nodeScreenPos.y + portOffsetY
                        );
                        
                        // Always update port._position to ensure it's accurate
                        // This is critical for LinkView to draw links correctly
                        // LinkPainter uses port._position as startPos/endPos for bezier curves
                        // The control points are calculated from these positions
                        // Always create a new vector2d to ensure QML detects the change
                        // This ensures links always connect precisely to ports, regardless of camera movement or zoom
                        port._position = Qt.vector2d(portScreenPos.x, portScreenPos.y);
                    });
                });
            }
        }
        }

    //! Mouse area for double-click node creation, focus management, and camera rotation
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        enabled: !sceneSession?.connectingMode  // Disable when connecting
        
        // Handle right mouse button press for camera rotation (Ctrl+RightClick) or context menu
        onPressed: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                // Check if Ctrl is pressed for camera rotation
                if (mouse.modifiers & Qt.ControlModifier) {
                    mouseRotating = true;
                    lastMousePos = Qt.point(mouse.x, mouse.y);
                    mouse.accepted = true;
                } else {
                    // Right click without Ctrl - show context menu immediately
                    var v3d = root.view3d;
                    var result = v3d.pick(mouse.x, mouse.y);
                    var worldPos;
                    
                    if (result.objectHit) {
                        worldPos = result.scenePosition;
                    } else {
                        // Calculate 3D position from mouse position
                        var depth = 200.0;
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
                            Math.sin(rotY)
                        ).normalized();
                        
                        var up = Qt.vector3d(
                            Math.sin(rotY) * Math.sin(rotX),
                            Math.cos(rotX),
                            Math.cos(rotY) * Math.sin(rotX)
                        ).normalized();
                        
                        var centerX = v3d.width / 2;
                        var centerY = v3d.height / 2;
                        var offsetX = (mouse.x - centerX) / v3d.width;
                        var offsetY = (mouse.y - centerY) / v3d.height;
                        
                        var fov = camera.fieldOfView * Math.PI / 180;
                        var aspectRatio = v3d.width / v3d.height;
                        var scaleX = Math.tan(fov / 2) * depth * 2;
                        var scaleY = scaleX / aspectRatio;
                        
                        var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                        worldPos = cameraPos
                            .plus(forward.times(depth))
                            .plus(right.times(offsetX * scaleX))
                            .plus(up.times(offsetY * scaleY));
                    }
                    
                    // Calculate 2D position for context menu
                    var initialScreenPos = v3d.mapFrom3DScene(Qt.vector3d(worldPos.x, worldPos.y, worldPos.z));
                    
                    contextMenu3D.nodePosition = Qt.vector2d(initialScreenPos.x, initialScreenPos.y);
                    contextMenu3D.nodePosition3D = worldPos;
                    contextMenu3D.popup(mouse.x, mouse.y);
                    mouse.accepted = true;
                }
            }
        }
        
        // Handle mouse move for camera rotation (only when Ctrl+RightClick)
        onPositionChanged: (mouse) => {
            if (mouseRotating && mouse.buttons & Qt.RightButton && mouse.modifiers & Qt.ControlModifier) {
                var deltaX = mouse.x - lastMousePos.x;
                var deltaY = mouse.y - lastMousePos.y;
                
                // Rotate camera based on mouse movement
                cameraRotationY += deltaX * mouseRotationSpeed;
                cameraRotationX -= deltaY * mouseRotationSpeed;  // Invert Y for natural feel
                
                // Clamp vertical rotation to prevent flipping
                if (cameraRotationX > 89) cameraRotationX = 89;
                if (cameraRotationX < -89) cameraRotationX = -89;
                
                lastMousePos = Qt.point(mouse.x, mouse.y);
                mouse.accepted = true;
            }
        }
        
        // Handle right mouse button release
        onReleased: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                mouseRotating = false;
            }
        }
        
        // Handle click events
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton && scene && !sceneSession?.connectingMode) {
                // Left click - handle empty space click
                // Check if click is on a node (using pick)
                var result = root.view3d.pick(mouse.x, mouse.y);
                // Check if we hit a node model
                var hitNode = false;
                if (result.objectHit) {
                    // Check if the hit object is a node model
                    var hitObjectStr = result.objectHit.toString();
                    if (hitObjectStr.includes("Model") && result.objectHit !== root.view3d.scene) {
                        // Check if it's a node model (not ground plane or other models)
                        hitNode = true;
                    }
                }
                
                if (!hitNode) {
                    // Clicked on empty space - clear selection and give focus to root
                    if (scene.selectionModel) {
                        scene.selectionModel.clear();
                    }
                    root.forceActiveFocus();  // Give focus back to root for keyboard control
                }
            }
        }
        
        // Double-click to create node
        onDoubleClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton && scene && !sceneSession?.connectingMode) {
                var v3d = root.view3d;
                // Convert screen coordinates to 3D world coordinates
                var result = v3d.pick(mouse.x, mouse.y);
                var worldPos;
                
                if (result.objectHit && result.objectHit.objectName && result.objectHit.objectName.toString().includes("NodeModel")) {
                    // Clicked on a node - don't create new node
                    return;
                }
                
                if (result.objectHit) {
                    // Create node at hit position (e.g., ground plane)
                    worldPos = result.scenePosition;
                } else {
                    // Create node at exact mouse position in 3D space
                    // Use the same forward/right/up calculation as camera movement for consistency
                    var depth = 200.0; // Distance from camera
                    
                    var rotX = cameraRotationX * Math.PI / 180;
                    var rotY = cameraRotationY * Math.PI / 180;
                    
                    // Forward direction: camera looks toward -Z
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    
                    // Right direction: perpendicular to forward, on horizontal plane
                    var right = Qt.vector3d(
                        Math.cos(rotY),
                        0,
                        Math.sin(rotY)
                    ).normalized();
                    
                    // Up direction: perpendicular to forward and right
                    var up = Qt.vector3d(
                        Math.sin(rotY) * Math.sin(rotX),
                        Math.cos(rotX),
                        Math.cos(rotY) * Math.sin(rotX)
                    ).normalized();
                    
                    // Calculate screen center
                    var centerX = v3d.width / 2;
                    var centerY = v3d.height / 2;
                    
                    // Calculate offset from center (normalized to -1 to 1)
                    var offsetX = (mouse.x - centerX) / v3d.width;
                    var offsetY = (mouse.y - centerY) / v3d.height;
                    
                    // Calculate FOV-based scaling
                    var fov = camera.fieldOfView * Math.PI / 180;
                    var aspectRatio = v3d.width / v3d.height;
                    var scaleX = Math.tan(fov / 2) * depth * 2;
                    var scaleY = scaleX / aspectRatio;
                    
                    // Calculate 3D position
                    var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                    worldPos = cameraPos
                        .plus(forward.times(depth))
                        .plus(right.times(offsetX * scaleX))
                        .plus(up.times(offsetY * scaleY));
                }
                
                // Create node with 3D position
                // 2D position will be calculated from 3D position and updated with camera movement
                
                // Calculate initial 2D position from 3D position for guiConfig.position
                var initialScreenPos = v3d.mapFrom3DScene(Qt.vector3d(worldPos.x, worldPos.y, worldPos.z));
                
                var nodeId = scene.createSpecificNode3D(
                    scene.nodeRegistry.imports,
                    0,
                    scene.nodeRegistry.nodeTypes[0],
                    scene.nodeRegistry.nodeColors[0],
                    scene.nodeRegistry.nodeNames[0] + "_" + (Object.values(scene.nodes).filter(node => node.type === 0).length + 1),
                    initialScreenPos.x,  // Initial 2D X position (will be updated with camera)
                    initialScreenPos.y,  // Initial 2D Y position (will be updated with camera)
                    worldPos.x,  // 3D X position
                    worldPos.y,  // 3D Y position
                    worldPos.z   // 3D Z position
                );
            }
        }
    }
    
    //! Context menu for creating nodes
    ContextMenu3D {
        id: contextMenu3D
        scene: root.scene
        sceneSession: root.sceneSession
    }

    //! Keyboard handling for camera control
    // Only enable keyboard control when no node is selected
    focus: true
    Keys.enabled: {
        if (!scene || !scene.selectionModel) return true;
        var selectedCount = Object.keys(scene.selectionModel.selectedModel || {}).length;
        return selectedCount === 0;
    }
    
    Keys.onPressed: (event) => {
        switch(event.key) {
            case Qt.Key_W:
                wPressed = true;
                break;
            case Qt.Key_S:
                sPressed = true;
                break;
            case Qt.Key_E:
                ePressed = true;
                break;
            case Qt.Key_Q:
                qPressed = true;
                break;
            case Qt.Key_Shift:
                shiftPressed = true;
                break;
            case Qt.Key_Space:
                spacePressed = true;
                break;
            case Qt.Key_R:
                rPressed = true;
                break;
            case Qt.Key_T:
                tPressed = true;
                break;
        }
    }

    Keys.onReleased: (event) => {
        switch(event.key) {
            case Qt.Key_W:
                wPressed = false;
                break;
            case Qt.Key_S:
                sPressed = false;
                break;
            case Qt.Key_E:
                ePressed = false;
                break;
            case Qt.Key_Q:
                qPressed = false;
                break;
            case Qt.Key_Shift:
                shiftPressed = false;
                break;
            case Qt.Key_Space:
                spacePressed = false;
                break;
            case Qt.Key_R:
                rPressed = false;
                break;
            case Qt.Key_T:
                tPressed = false;
                break;
        }
    }

    //! Timer for smooth camera movement
    Timer {
        id: cameraTimer
        interval: 16 // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            // Rectangular (world-axis) movement instead of spherical (camera-relative) movement
            // Movement is always in world axes, independent of camera rotation
            // This gives a "window" feel instead of "orbital" feel
            
            // Apply movement in world axes:
            // W = +Z (forward in world space)
            // S = -Z (backward in world space)
            // Q = -X (left in world space)
            // E = +X (right in world space)
            // Shift = +Y (up in world space)
            // Space = -Y (down in world space)
            
            if (wPressed) {
                // Move forward in world Z axis
                cameraZ += moveSpeed;
            }
            if (sPressed) {
                // Move backward in world Z axis
                cameraZ -= moveSpeed;
            }
            if (ePressed) {
                // Move right in world X axis
                cameraX += moveSpeed;
            }
            if (qPressed) {
                // Move left in world X axis
                cameraX -= moveSpeed;
            }
            
            // Apply vertical movement: Shift (up), Space (down)
            if (shiftPressed) {
                cameraY += moveSpeed;
            }
            if (spacePressed) {
                cameraY -= moveSpeed;
            }
            
            // Apply rotation: R (rotate left), T (rotate right)
            // Rotation only changes viewing angle, not movement direction
            if (rPressed) {
                cameraRotationY -= rotationSpeed;
            }
            if (tPressed) {
                cameraRotationY += rotationSpeed;
            }
        }
    }

    /* Functions
     * ****************************************************************************************/
    
    //! Reset camera to default position
    function resetCamera() {
        cameraX = 0;
        cameraY = 0;
        cameraZ = 500;
        cameraRotationX = -20;
        cameraRotationY = 0;
    }
    
    //! Copy nodes functionality
    function copyNodes() {
        if (scene && scene.selectionModel) {
            // Copy nodes functionality
        }
    }
    
    //! Paste nodes functionality  
    function pasteNodes() {
        if (scene && scene.selectionModel) {
            // Paste nodes functionality
        }
    }
}

