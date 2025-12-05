import QtQuick
import QtQuick3D as Qt3D
import QtQuick3D.Helpers
import QtQuick.Controls
import QtQuick.Controls.Material

import NodeLink
import QtQuickStream
import Simple3DNodeLink

/*! ***********************************************************************************************
 * Simple3DNodeLinkView - Main 3D view for displaying nodes in 3D space using QtQuick3D
 * ************************************************************************************************/

Item {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property Simple3DNodeLinkScene scene
    property SceneSession sceneSession: SceneSession {
        enabledOverview: false
        doNodesNeedImage: false
    }

    // Camera control properties
    property real cameraX: 0
    property real cameraY: 50
    property real cameraZ: 400
    property real cameraRotationX: -15
    property real cameraRotationY: 0
    
    // Movement speed
    property real moveSpeed: 5.0
    property real rotationSpeed: 2.0
    property real mouseRotationSpeed: 0.5  // Mouse rotation sensitivity
    
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
    
    // Perspective scaling
    property real baseDistance: 500.0  // Base distance for scale calculation
    property real minScale: 0.3  // Minimum scale when far away
    property real maxScale: 1.5  // Maximum scale when close
    property real fadeStartDistance: 1800.0  // Start fading at this distance
    property real fadeEndDistance: 1800.0  // Completely invisible at this distance
    
    // View3D alias for access from child components
    property alias view3d: view3d
    
    // Ensure focus is maintained
    activeFocusOnTab: true

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
        }

        //! Main directional light
        Qt3D.DirectionalLight {
            id: mainLight
            eulerRotation: Qt.vector3d(-45, -45, 0)
            color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
            brightness: 1.5
            castsShadow: true
        }
        
        //! Ground Plane - Large square surface for reference
        Qt3D.Model {
            id: groundPlane
            source: "#Rectangle"
            scale: Qt.vector3d(10000, 10000, 1)  // Very large square ground plane (10000m x 10000m)
            position: Qt.vector3d(0, 0, 0)
            eulerRotation: Qt.vector3d(-90, 0, 0)  // Rotate to be horizontal (flat on XZ plane)
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

        //! 3D Shapes Container - Renders shapes from shape nodes
        Qt3D.Node {
            id: shapesContainer
            
            // Component for creating 3D shape models
            Component {
                id: shapeModelComponent
                Qt3D.Node {
                    id: shapeNode
                    property var shapeData: null
                    property string nodeName: ""
                    property var rootView: null  // Reference to root view for camera access
                    
                    // Position, rotation, scale from shapeData
                    position: {
                        if (!shapeData || !shapeData.position) return Qt.vector3d(0, 0, 0);
                        var _ = shapeData.position.x + shapeData.position.y + shapeData.position.z; // Force dependency
                        return shapeData.position;
                    }
                    eulerRotation: {
                        if (!shapeData || !shapeData.rotation) return Qt.vector3d(0, 0, 0);
                        var _ = shapeData.rotation.x + shapeData.rotation.y + shapeData.rotation.z; // Force dependency
                        return shapeData.rotation;
                    }
                    scale: {
                        if (!shapeData) return Qt.vector3d(1, 1, 1);
                        var baseScale = shapeData.scale ? shapeData.scale : Qt.vector3d(1, 1, 1);
                        var dims = shapeData.dimensions ? shapeData.dimensions : Qt.vector3d(100, 100, 100);
                        // Force dependency on all values
                        var _ = baseScale.x + baseScale.y + baseScale.z + dims.x + dims.y + dims.z;
                        // Convert dimensions from cm to meters and apply scale
                        return Qt.vector3d(
                            baseScale.x * dims.x * 0.01,
                            baseScale.y * dims.y * 0.01,
                            baseScale.z * dims.z * 0.01
                        );
                    }
                    
                    // Shape model
                    Qt3D.Model {
                        id: shapeModel
                        
                        // Shape source based on shapeType
                        source: {
                            if (!shapeData || !shapeData.shapeType) return "#Cube";
                            var _ = shapeData.shapeType; // Force dependency
                            switch(shapeData.shapeType) {
                                case "Sphere": return "#Sphere";
                                case "Cylinder": return "#Cylinder";
                                case "Cone": return "#Cone";
                                case "Plane": return "#Rectangle";
                                case "Rectangle": return "#Rectangle";
                                default: return "#Cube";
                            }
                        }
                        
                        // Material properties
                        materials: [
                            Qt3D.PrincipledMaterial {
                                id: shapeMaterial
                                baseColor: {
                                    if (!shapeData || !shapeData.material) return Qt.rgba(0.5, 0.7, 1.0, 1.0);
                                    // Default colors based on material type
                                    switch(shapeData.material.type) {
                                        case "Metal": return Qt.rgba(0.7, 0.7, 0.7, 1.0);
                                        case "Plastic": return Qt.rgba(0.5, 0.5, 0.8, 1.0);
                                        case "Glass": return Qt.rgba(0.8, 0.9, 1.0, 0.5);
                                        case "Rubber": return Qt.rgba(0.2, 0.2, 0.2, 1.0);
                                        case "Wood": return Qt.rgba(0.6, 0.4, 0.2, 1.0);
                                        default: return Qt.rgba(0.5, 0.7, 1.0, 1.0);
                                    }
                                }
                                metalness: shapeData && shapeData.material ? (shapeData.material.metallic || 0.0) : 0.0
                                roughness: shapeData && shapeData.material ? (shapeData.material.roughness || 0.5) : 0.5
                                emissiveFactor: {
                                    if (!shapeData || !shapeData.material) return Qt.vector3d(0, 0, 0);
                                    var power = shapeData.material.emissivePower || 0.0;
                                    return Qt.vector3d(power, power, power);
                                }
                                opacity: (shapeData && shapeData.material && shapeData.material.type === "Glass") ? 0.5 : 1.0
                            }
                        ]
                        
                        receivesShadows: true
                    }
                    
                }
            }
            
            // Track created shape models
            property var createdShapes: ({})
            
            // Function to update shapes
            function updateShapes() {
                if (!scene || !scene.nodes) return;
                
                var currentKeys = Object.keys(scene.nodes || {});
                var createdKeys = Object.keys(createdShapes || {});
                
                // Remove shapes that no longer exist or are not shape nodes
                for (var i = 0; i < createdKeys.length; i++) {
                    var key = createdKeys[i];
                    var node = scene.nodes[key];
                    if (!node || node.type < Specs.NodeType.Cube || node.type > Specs.NodeType.Rectangle) {
                        // Not a shape node or node doesn't exist
                        if (createdShapes[key]) {
                            createdShapes[key].destroy();
                            delete createdShapes[key];
                        }
                    }
                }
                
                // Create/update shapes for shape nodes (type 12-17)
                for (var j = 0; j < currentKeys.length; j++) {
                    var nodeId = currentKeys[j];
                    var nodeData = scene.nodes[nodeId];
                    
                    if (!nodeData || nodeData.type < 12 || nodeData.type > 17) {
                        continue; // Not a shape node
                    }
                    
                    // Get node's 3D position for default position calculation
                    var nodePos3D = nodeData.guiConfig?.position3D;
                    var defaultPosition = Qt.vector3d(0, 0, 0);
                    if (nodePos3D) {
                        // Position shape 100 units to the right (in +X direction) from node
                        defaultPosition = Qt.vector3d(nodePos3D.x + 100, nodePos3D.y, nodePos3D.z);
                    }
                    
                    // Check if this is a new shape (not created yet)
                    var isNewShape = !createdShapes[nodeId];
                    
                    // Get shape data from node - create a new object to ensure reactivity
                    var shapeData = null;
                    var needsPositionUpdate = false;
                    
                    if (nodeData.nodeData && nodeData.nodeData.data) {
                        var data = nodeData.nodeData.data;
                        
                        // If position is not set and this is a new shape, use default position based on node position
                        var finalPosition = data.position ? Qt.vector3d(data.position.x, data.position.y, data.position.z) : null;
                        
                        if (!finalPosition || (finalPosition.x === 0 && finalPosition.y === 0 && finalPosition.z === 0)) {
                            // Position is not set or is (0,0,0), use default position based on node
                            if (isNewShape && nodePos3D) {
                                finalPosition = defaultPosition;
                                needsPositionUpdate = true;
                            } else {
                                finalPosition = Qt.vector3d(0, 0, 0);
                            }
                        }
                        
                        // Create a new object to ensure QML detects the change
                        shapeData = {
                            shapeType: data.shapeType || "Cube",
                            position: finalPosition,
                            rotation: data.rotation ? Qt.vector3d(data.rotation.x, data.rotation.y, data.rotation.z) : Qt.vector3d(0, 0, 0),
                            scale: data.scale ? Qt.vector3d(data.scale.x, data.scale.y, data.scale.z) : Qt.vector3d(1, 1, 1),
                            dimensions: data.dimensions ? Qt.vector3d(data.dimensions.x, data.dimensions.y, data.dimensions.z) : Qt.vector3d(100, 100, 100),
                            material: data.material || null
                        };
                        
                        // If we need to update position, save it to nodeData
                        if (needsPositionUpdate && nodeData.updateInputPosition) {
                            nodeData.updateInputPosition(finalPosition);
                        } else if (needsPositionUpdate && nodeData.nodeData) {
                            // Fallback: directly update nodeData
                            var currentData = nodeData.nodeData.data || {};
                            nodeData.nodeData.data = {
                                shapeType: currentData.shapeType || shapeData.shapeType,
                                position: finalPosition,
                                rotation: currentData.rotation || shapeData.rotation,
                                scale: currentData.scale || shapeData.scale,
                                dimensions: currentData.dimensions || shapeData.dimensions,
                                material: currentData.material || shapeData.material
                            };
                        }
                    } else {
                        // Default shape data - use node position + offset for new shapes
                        if (isNewShape && nodePos3D) {
                            shapeData = {
                                shapeType: "Cube",
                                position: defaultPosition,
                                rotation: Qt.vector3d(0, 0, 0),
                                scale: Qt.vector3d(1, 1, 1),
                                dimensions: Qt.vector3d(100, 100, 100),
                                material: null
                            };
                            // Save default position to nodeData
                            if (nodeData.nodeData) {
                                nodeData.nodeData.data = shapeData;
                            }
                        } else {
                            shapeData = {
                                shapeType: "Cube",
                                position: Qt.vector3d(0, 0, 0),
                                rotation: Qt.vector3d(0, 0, 0),
                                scale: Qt.vector3d(1, 1, 1),
                                dimensions: Qt.vector3d(100, 100, 100),
                                material: null
                            };
                        }
                    }
                    
                    // Get node name/title
                    var nodeName = nodeData.title || nodeData.guiConfig?.title || "";
                    if (!nodeName || nodeName === "") {
                        // Fallback to node type name
                        if (scene && scene.nodeRegistry) {
                            var nodeTypeName = scene.nodeRegistry.getNodeName(nodeData.type);
                            nodeName = nodeTypeName || "";
                        }
                    }
                    
                    if (!createdShapes[nodeId]) {
                        // Create new shape model
                        var shapeModel = shapeModelComponent.createObject(shapesContainer, {
                            shapeData: shapeData,
                            nodeName: nodeName,
                            rootView: root,  // Pass root view reference for camera access
                            objectName: "shape_" + nodeId
                        });
                        createdShapes[nodeId] = shapeModel;
                    } else {
                        // Update existing shape model - assign new object to trigger updates
                        // IMPORTANT: Don't update position when node moves - shape position is independent
                        var existingShape = createdShapes[nodeId];
                        // Update node name
                        existingShape.nodeName = nodeName;
                        // Only update if position is explicitly set in nodeData (not from node position)
                        var currentData = nodeData.nodeData && nodeData.nodeData.data ? nodeData.nodeData.data : null;
                        if (currentData && currentData.position) {
                            // Position is explicitly set, use it
                            existingShape.shapeData = shapeData;
                        } else {
                            // Position is not set, keep existing position (don't update based on node position)
                            var existingPosition = existingShape.shapeData && existingShape.shapeData.position ? 
                                existingShape.shapeData.position : Qt.vector3d(0, 0, 0);
                            shapeData.position = existingPosition;
                            existingShape.shapeData = shapeData;
                        }
                    }
                }
            }
            
            // Update when scene.nodes changes
            Connections {
                target: scene
                function onNodesChanged() {
                    shapesContainer.updateShapes();
                }
                function onLinkAdded(link) {
                    Qt.callLater(function() {
                        shapesContainer.updateShapes();
                    });
                }
                function onLinkRemoved(link) {
                    Qt.callLater(function() {
                        shapesContainer.updateShapes();
                    });
                }
            }
            
            // Timer to periodically update shapes (in case nodeData changes)
            Timer {
                interval: 50  // Update every 50ms for more responsive updates
                running: true
                repeat: true
                onTriggered: {
                    shapesContainer.updateShapes();
                }
            }
            
            Component.onCompleted: {
                updateShapes();
            }
        }

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
                
                node: nodeData
                scene: root.scene
                sceneSession: root.sceneSession
                
                // Pass view3d and camera properties for 3D dragging
                view3d: root.view3d
                cameraX: root.cameraX
                cameraY: root.cameraY
                cameraZ: root.cameraZ
                cameraRotationX: root.cameraRotationX
                cameraRotationY: root.cameraRotationY
                
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
                        origin.x: (nodeData?.guiConfig?.width ?? 240) / 2
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
                            return pos2D.x - (nodeData.guiConfig?.width ?? 240) / 2;
                        }
                        return -10000;
                    }
                    
                    // Convert 3D world coordinates to 2D screen coordinates
                    var screenPos = v3d.mapFrom3DScene(Qt.vector3d(pos3D.x, pos3D.y, pos3D.z));
                    
                    // Check if screenPos is valid and node is in front of camera
                    if (isNaN(screenPos.x) || isNaN(screenPos.y)) {
                        return -10000;
                    }
                    
                    // Check if node is behind camera
                    if (root.isBehindCamera(pos3D)) {
                        return -10000;
                    }
                    
                    // Center the node on the screen position
                    return screenPos.x - (nodeData.guiConfig?.width ?? 240) / 2;
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
                    
                    // Check if node is behind camera
                    if (root.isBehindCamera(pos3D)) {
                        return -10000;
                    }
                    
                    // Center the node on the screen position
                    return screenPos.y - (nodeData.guiConfig?.height ?? 100) / 2;
                }
                
                // Handle node selection - transfer focus to node when selected
                Connections {
                    target: scene && scene.selectionModel ? scene.selectionModel : null
                    function onSelectedObjectChanged() {
                        // Check if objects are still valid
                        if (!scene || !scene.selectionModel || !nodeData) return;
                        try {
                            var isSelected = scene.selectionModel.isSelected(nodeData._qsUuid);
                            if (isSelected) {
                                // Node is selected - remove focus from root and give to node
                                if (root) root.focus = false;
                                // Give focus to nodeView to enable keyboard input
                                Qt.callLater(function() {
                                    if (overlayNodeView) {
                                        overlayNodeView.forceActiveFocus();
                                    }
                                });
                            } else {
                                // Node is not selected - check if any node is selected
                                var selectedCount = Object.keys(scene.selectionModel.selectedModel || {}).length;
                                if (selectedCount === 0 && root) {
                                    // No nodes selected - give focus back to root for camera control
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
        
        //! Shape name labels - Display node names above shapes
        Repeater {
            model: scene ? Object.keys(scene.nodes || {}).filter(function(nodeId) {
                var node = scene.nodes[nodeId];
                return node && node.type >= Specs.NodeType.Cube && node.type <= Specs.NodeType.Rectangle;
            }) : []
            
            delegate: Item {
                id: shapeLabel
                property var nodeData: scene?.nodes?.[modelData]
                property var shapeData: nodeData?.nodeData?.data
                property string nodeName: {
                    if (!nodeData) return "";
                    var name = nodeData.title || nodeData.guiConfig?.title || "";
                    if (!name || name === "") {
                        if (scene && scene.nodeRegistry) {
                            name = scene.nodeRegistry.getNodeName(nodeData.type) || "";
                        }
                    }
                    return name;
                }
                property var shapePosition3D: shapeData && shapeData.position ? shapeData.position : null
                
                visible: nodeName !== "" && shapePosition3D !== null
                z: 2000  // Above nodes and links
                
                // Calculate label position above shape
                property var labelWorldPos: {
                    if (!shapePosition3D) return null;
                    // Get shape dimensions to calculate height
                    var dims = shapeData && shapeData.dimensions ? shapeData.dimensions : Qt.vector3d(100, 100, 100);
                    var baseScale = shapeData && shapeData.scale ? shapeData.scale : Qt.vector3d(1, 1, 1);
                    var height = dims.y * baseScale.y * 0.01; // Convert to meters
                    // Position label 0.5m above the top of the shape
                    return Qt.vector3d(
                        shapePosition3D.x,
                        shapePosition3D.y + height / 2 + 0.5,
                        shapePosition3D.z
                    );
                }
                
                x: {
                    if (!labelWorldPos) return -10000;
                    var v3d = root.view3d;
                    if (!v3d) return -10000;
                    
                    // Force dependency on camera properties
                    var _ = root.cameraX + root.cameraY + root.cameraZ + root.cameraRotationX + root.cameraRotationY;
                    
                    var screenPos = v3d.mapFrom3DScene(labelWorldPos);
                    if (isNaN(screenPos.x) || isNaN(screenPos.y)) return -10000;
                    
                    // Check if behind camera
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    var toLabel = labelWorldPos.minus(cameraPos);
                    var rotX = root.cameraRotationX * Math.PI / 180;
                    var rotY = root.cameraRotationY * Math.PI / 180;
                    var forward = Qt.vector3d(
                        -Math.sin(rotY) * Math.cos(rotX),
                        Math.sin(rotX),
                        -Math.cos(rotY) * Math.cos(rotX)
                    ).normalized();
                    var dotProduct = toLabel.x * forward.x + toLabel.y * forward.y + toLabel.z * forward.z;
                    if (dotProduct < 0) return -10000;
                    
                    return screenPos.x - shapeLabelText.width / 2;
                }
                
                y: {
                    if (!labelWorldPos) return -10000;
                    var v3d = root.view3d;
                    if (!v3d) return -10000;
                    
                    // Force dependency on camera properties
                    var _ = root.cameraX + root.cameraY + root.cameraZ + root.cameraRotationX + root.cameraRotationY;
                    
                    var screenPos = v3d.mapFrom3DScene(labelWorldPos);
                    if (isNaN(screenPos.x) || isNaN(screenPos.y)) return -10000;
                    
                    // Check if behind camera
                    if (root.isBehindCamera(labelWorldPos)) return -10000;
                    
                    return screenPos.y - shapeLabelText.height;
                }
                
                Rectangle {
                    id: shapeLabelBackground
                    anchors.centerIn: parent
                    width: shapeLabelText.width + 16
                    height: shapeLabelText.height + 8
                    color: Qt.rgba(0.2, 0.2, 0.2, 0.9)
                    border.color: Qt.rgba(1.0, 1.0, 1.0, 0.8)
                    border.width: 2
                    radius: 4
                }
                
                Text {
                    id: shapeLabelText
                    anchors.centerIn: parent
                    text: shapeLabel.nodeName
                    color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
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
                    // But also check if port._position exists and is valid
                    // IMPORTANT: If port._position is not set yet (new link), don't hide the link
                    // Instead, trigger an update and wait for port positions to be calculated
                    var inputPort = linkData?.inputPort;
                    var outputPort = linkData?.outputPort;
                    
                    // If ports don't exist, hide the link
                    if (!inputPort || !outputPort) return false;
                    
                    // If port._position is not set yet, trigger update and show link anyway
                    // The portUpdateTimer will set the position soon
                    var inputPosValid = inputPort._position && 
                                       !isNaN(inputPort._position.x) && !isNaN(inputPort._position.y) &&
                                       inputPort._position.x > -10000 && inputPort._position.y > -10000;
                    var outputPosValid = outputPort._position && 
                                        !isNaN(outputPort._position.x) && !isNaN(outputPort._position.y) &&
                                        outputPort._position.x > -10000 && outputPort._position.y > -10000;
                    
                    // If positions are not valid, trigger update but don't hide the link yet
                    // This allows new links to be visible while positions are being calculated
                    if (!inputPosValid || !outputPosValid) {
                        // Trigger port position update
                        Qt.callLater(function() {
                            if (nodesOverlay.portUpdateTimer) {
                                nodesOverlay.portUpdateTimer.restart();
                            }
                        });
                        // Show link anyway - positions will be updated soon
                        // Only hide if positions are clearly invalid (off-screen)
                        if (inputPort._position && (inputPort._position.x < -10000 || inputPort._position.y < -10000)) {
                            return false;
                        }
                        if (outputPort._position && (outputPort._position.x < -10000 || outputPort._position.y < -10000)) {
                            return false;
                        }
                        // Allow link to be visible while positions are being calculated
                        return true;
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
                
                // Force update to ensure port positions are always current
                // This prevents links from disappearing when nodes move
                
                var v3d = root.view3d;
                // Update port positions for all nodes
                Object.values(scene.nodes).forEach(function(node) {
                    if (!node || !node.ports || !node.guiConfig) return;
                    
                    var pos3D = node.guiConfig.position3D;
                    if (!pos3D) return;
                    
                    // Check if node is behind camera
                    if (root.isBehindCamera(pos3D)) {
                        return;
                    }
                    
                    // Calculate distance from camera to node
                    var cameraPos = Qt.vector3d(root.cameraX, root.cameraY, root.cameraZ);
                    var toNode = pos3D.minus(cameraPos);
                    var distance = Math.sqrt(toNode.x * toNode.x + toNode.y * toNode.y + toNode.z * toNode.z);
                    
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
                            nodeScreenPos.x - (node.guiConfig?.width ?? 240) / 2,
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
                    var baseScale = 1.0;
                    if (distance > 0) {
                        baseScale = root.baseDistance / distance;
                    }
                    
                    // Calculate view direction for perspective
                    var viewDirection = root.calculateForwardVector(root.cameraRotationX, root.cameraRotationY);
                    
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
                    
                    if (!overlayNodeView) {
                        // Node view not found, skip port updates
                        return;
                    }
                    
                    // Try to get port positions from PortView components in overlayNodeView
                    // This is more accurate than manual calculation
                    function findPortViews(parent, portViews) {
                        if (!parent || !parent.children) return;
                        for (var i = 0; i < parent.children.length; i++) {
                            var child = parent.children[i];
                            // Check if this is a PortView (has port, globalX, and globalY properties)
                            if (child && child.port && typeof child.globalX !== 'undefined' && typeof child.globalY !== 'undefined') {
                                // This is a PortView
                                // In InteractiveNodeView: globalX = root.x + positionMapped.x
                                // where root is NodeView and positionMapped is relative to NodeView
                                // So globalX/Y is the absolute position in scene coordinates
                                // In Simple3DNodeLinkView, overlayNodeView is in nodesOverlay
                                // We need to convert PortView center to nodesOverlay coordinates
                                try {
                                    // PortView.globalX/Y is the center of the port in scene coordinates
                                    // But we need it in nodesOverlay coordinates
                                    // Use mapToItem to convert PortView center (width/2, height/2) to nodesOverlay
                                    var portViewCenter = Qt.point(child.width / 2, child.height / 2);
                                    var mappedPos = child.mapToItem(nodesOverlay, portViewCenter.x, portViewCenter.y);
                                    portViews[child.port._qsUuid] = {
                                        x: mappedPos.x,
                                        y: mappedPos.y,
                                        portView: child
                                    };
                                } catch (e) {
                                    // If mapToItem fails, try using port._position that PortView already set
                                    // PortView sets port._position from globalPos, but it might be in wrong coordinate system
                                    if (child.port && child.port._position) {
                                        // Try to use the position that PortView already calculated
                                        // But we need to verify it's correct
                                        portViews[child.port._qsUuid] = {
                                            x: child.port._position.x,
                                            y: child.port._position.y,
                                            portView: child,
                                            usePortPosition: true
                                        };
                                    }
                                }
                            }
                            // Recursively search children
                            findPortViews(child, portViews);
                        }
                    }
                    
                    var portViews = {};
                    findPortViews(overlayNodeView, portViews);
                    
                    // Update port positions - use PortView positions if available, otherwise fallback to manual calculation
                    Object.values(node.ports).forEach(function(port) {
                        if (!port) return;
                        
                        // First, try to use position from PortView if available (most accurate)
                        if (portViews[port._qsUuid]) {
                            var portViewPos = portViews[port._qsUuid];
                            if (portViewPos.usePortPosition) {
                                // Use port._position that PortView already set
                                // But verify it's in the correct coordinate system
                                // If port._position seems wrong (off-screen), recalculate
                                if (port._position && port._position.x > -10000 && port._position.y > -10000 &&
                                    !isNaN(port._position.x) && !isNaN(port._position.y)) {
                                    // Position seems valid, but force update to ensure it's current
                                    // Create new vector2d to trigger QML change detection
                                    var currentX = port._position.x;
                                    var currentY = port._position.y;
                                    port._position = Qt.vector2d(currentX, currentY);
                                } else {
                                    // Position seems invalid, use mapped position
                                    port._position = Qt.vector2d(portViewPos.x, portViewPos.y);
                                }
                            } else {
                                // Use mapped position (already in nodesOverlay coordinates)
                                // Always create new vector2d to ensure QML detects the change
                                port._position = Qt.vector2d(portViewPos.x, portViewPos.y);
                            }
                            return; // Skip manual calculation
                        }
                        
                        // Fallback to manual calculation if PortView not found
                        // This should rarely happen, but provides a backup
                        var nodeWidth = node.guiConfig?.width ?? 240;
                        var nodeHeight = node.guiConfig?.height ?? 100;
                        
                        // Simple fallback: just use node center + basic offset
                        // This is not ideal but better than nothing
                        var portOffsetX = 0;
                        var portOffsetY = 0;
                        
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
                        
                        // Use average scale for port offset calculation
                        var actualScaleX = overlayNodeView.perspectiveScaleX;
                        var actualScaleY = overlayNodeView.perspectiveScaleY;
                        var actualScale = (actualScaleX + actualScaleY) / 2;
                        
                        portOffsetX = portOffsetX * actualScale;
                        portOffsetY = portOffsetY * actualScale;
                        
                        var portScreenPos = Qt.vector2d(
                            nodeScreenPos.x + portOffsetX,
                            nodeScreenPos.y + portOffsetY
                        );
                        
                        // Always create new vector2d to ensure QML detects the change
                        port._position = Qt.vector2d(portScreenPos.x, portScreenPos.y);
                    });
                });
            }
        }
        
        //! Force update port positions when camera moves or nodes change
        //! This ensures links are always visible and correctly positioned
        Connections {
            target: scene
            function onNodesChanged() {
                // Trigger port position update when nodes change
                if (nodesOverlay.portUpdateTimer) {
                    nodesOverlay.portUpdateTimer.restart();
                }
            }
            function onLinkAdded(link) {
                // Immediately update port positions for the new link
                // This ensures the link is visible right away
                if (link && nodesOverlay.portUpdateTimer) {
                    // Force immediate timer trigger to update port positions
                    nodesOverlay.portUpdateTimer.restart();
                }
                
                // Trigger additional updates after delays to ensure PortView components are created
                Qt.callLater(function() {
                    if (nodesOverlay.portUpdateTimer) {
                        nodesOverlay.portUpdateTimer.restart();
                    }
                }, 0);
                
                Qt.callLater(function() {
                    if (nodesOverlay.portUpdateTimer) {
                        nodesOverlay.portUpdateTimer.restart();
                    }
                }, 16);  // After one frame
                
                Qt.callLater(function() {
                    if (nodesOverlay.portUpdateTimer) {
                        nodesOverlay.portUpdateTimer.restart();
                    }
                }, 50);  // After a short delay
            }
            function onLinkRemoved(link) {
                // Trigger port position update when link is removed
                Qt.callLater(function() {
                    if (nodesOverlay.portUpdateTimer) {
                        nodesOverlay.portUpdateTimer.restart();
                    }
                });
            }
        }
        
        //! Force update port positions when camera moves
        //! This ensures links are always visible when camera position changes
        Connections {
            target: root
            function onCameraXChanged() {
                if (nodesOverlay.portUpdateTimer) {
                    nodesOverlay.portUpdateTimer.restart();
                }
            }
            function onCameraYChanged() {
                if (nodesOverlay.portUpdateTimer) {
                    nodesOverlay.portUpdateTimer.restart();
                }
            }
            function onCameraZChanged() {
                if (nodesOverlay.portUpdateTimer) {
                    nodesOverlay.portUpdateTimer.restart();
                }
            }
            function onCameraRotationXChanged() {
                if (nodesOverlay.portUpdateTimer) {
                    nodesOverlay.portUpdateTimer.restart();
                }
            }
            function onCameraRotationYChanged() {
                if (nodesOverlay.portUpdateTimer) {
                    nodesOverlay.portUpdateTimer.restart();
                }
            }
        }
        }

    //! Mouse area for double-click node creation, focus management, and camera rotation
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        focus: false  // Don't take focus from parent
        propagateComposedEvents: false
        z: -1  // Behind other elements
        enabled: !sceneSession?.connectingMode  // Disable when connecting
        
        // Handle right mouse button press for camera rotation (Ctrl+RightClick) or context menu
        onPressed: (mouse) => {
            // Force focus back to root item
            root.forceActiveFocus();
            
            if (mouse.button === Qt.RightButton) {
                // Check if Ctrl is pressed for camera rotation
                if (mouse.modifiers & Qt.ControlModifier) {
                    // Ctrl + Right Click - start camera rotation
                    mouseRotating = true;
                    lastMousePos = Qt.point(mouse.x, mouse.y);
                    mouse.accepted = true;
                } else {
                    // Right click without Ctrl - show context menu
                    mouseRotating = false;
                    
                    // Calculate 3D position from mouse position
                    var v3d = root.view3d;
                    var result = v3d.pick(mouse.x, mouse.y);
                    var worldPos;
                    
                    // First try to use pick result if it hit ground plane
                    if (result && result.objectHit) {
                        var hitObject = result.objectHit;
                        if (hitObject.objectName === "groundPlane" && result.scenePosition) {
                            worldPos = result.scenePosition;
                            worldPos.y = 0.25; // Place on ground
                        } else if (result.scenePosition) {
                            // Hit something else, use its position
                            worldPos = result.scenePosition;
                            worldPos.y = 0.25; // Place on ground
                        }
                    }
                    
                    // If we don't have a valid position from picking, use ray casting
                    if (!worldPos || (worldPos.x === 0 && worldPos.z === 0)) {
                        // Calculate position using ray casting to ground plane
                        var camera = view3d.camera;
                        var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                        
                        // Calculate ray direction from camera through mouse position
                        var forward = root.calculateForwardVector(cameraRotationX, cameraRotationY);
                        var right = root.calculateRightVector(cameraRotationY);
                        
                        // Up direction (perpendicular to forward and right)
                        var up = forward.crossProduct(right).normalized();
                        
                        // Calculate screen center
                        var centerX = v3d.width / 2;
                        var centerY = v3d.height / 2;
                        
                        // Calculate offset from center (normalized to -1 to 1)
                        var offsetX = (mouse.x - centerX) / v3d.width;
                        var offsetY = (mouse.y - centerY) / v3d.height;
                        
                        // Calculate FOV-based scaling
                        var fov = camera.fieldOfView * Math.PI / 180;
                        var aspectRatio = v3d.width / v3d.height;
                        var tanHalfFov = Math.tan(fov / 2);
                        
                        // Calculate ray direction in world space
                        var rayDir = forward
                            .plus(right.times(offsetX * tanHalfFov * aspectRatio * 2))
                            .plus(up.times(-offsetY * tanHalfFov * 2))
                            .normalized();
                        
                        // Intersect with ground plane (y = 0)
                        if (Math.abs(rayDir.y) > 0.001) {
                            var t = -cameraY / rayDir.y;
                            if (t > 0) {
                                worldPos = cameraPos.plus(rayDir.times(t));
                                worldPos.y = 0.25; // Place on ground
                            } else {
                                // Ray pointing up, create in front of camera
                                worldPos = cameraPos.plus(forward.times(200));
                                worldPos.y = 0.25;
                            }
                        } else {
                            // Ray parallel to ground, create in front of camera
                            worldPos = cameraPos.plus(forward.times(200));
                            worldPos.y = 0.25;
                        }
                    }
                    
                    // Calculate 2D position for context menu
                    var initialScreenPos = v3d.mapFrom3DScene(Qt.vector3d(worldPos.x, worldPos.y, worldPos.z));
                    
                    contextMenu3D.nodePosition = Qt.vector2d(initialScreenPos.x, initialScreenPos.y);
                    contextMenu3D.nodePosition3D = worldPos;
                    contextMenu3D.popup(mouse.x, mouse.y);
                    mouse.accepted = true;
                }
            } else if (mouse.button === Qt.LeftButton) {
                // Prevent camera rotation when clicking
                mouseRotating = false;
                
                // Check if clicking on a node (handled by NodeView)
                // Just ensure focus is maintained
                root.forceActiveFocus();
            }
        }
        
        // Handle mouse move for camera rotation (only when Ctrl+RightClick)
        onPositionChanged: (mouse) => {
            if (mouseRotating && mouse.buttons & Qt.RightButton && mouse.modifiers & Qt.ControlModifier) {
                var deltaX = mouse.x - lastMousePos.x;
                var deltaY = mouse.y - lastMousePos.y;
                
                // Rotate camera based on mouse movement
                cameraRotationY -= deltaX * mouseRotationSpeed;
                cameraRotationX -= deltaY * mouseRotationSpeed;  // Invert Y for natural feel
                
                // Clamp vertical rotation to prevent flipping
                cameraRotationX = Math.max(-89, Math.min(89, cameraRotationX));
                
                lastMousePos = Qt.point(mouse.x, mouse.y);
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
                // Check if click is on a node view in the overlay
                var clickedOnNode = false;
                
                // Check if click is within any node view bounds by iterating through nodesOverlay children
                // The node views are created by the Repeater and are children of nodesOverlay
                if (nodesOverlay && nodesOverlay.children) {
                    for (var i = 0; i < nodesOverlay.children.length; i++) {
                        var child = nodesOverlay.children[i];
                        // Check if this is a Simple3DNodeLinkNodeView (node view) - it has nodeData property
                        if (child && child.nodeData && child.visible) {
                            // Check if mouse position is within this node view bounds
                            var nodePos = root.mapToItem(child, mouse.x, mouse.y);
                            if (nodePos.x >= 0 && nodePos.x <= child.width && 
                                nodePos.y >= 0 && nodePos.y <= child.height) {
                                clickedOnNode = true;
                                break;
                            }
                        }
                    }
                }
                
                // Also check using 3D pick for node models
                if (!clickedOnNode) {
                    var result = root.view3d.pick(mouse.x, mouse.y);
                    if (result && result.objectHit) {
                        var hitObject = result.objectHit;
                        var objectName = hitObject.objectName ? hitObject.objectName.toString() : "";
                        // Check if it's a node model (not ground plane or other models)
                        if (objectName.includes("NodeModel") || 
                            (objectName.includes("Model") && objectName !== "groundPlane" && hitObject !== root.view3d.scene)) {
                            clickedOnNode = true;
                        }
                    }
                }
                
                if (!clickedOnNode) {
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
                
                // First try to use pick result if it hit ground plane
                if (result && result.objectHit) {
                    var hitObject = result.objectHit;
                    if (hitObject.objectName === "groundPlane" && result.scenePosition) {
                        worldPos = result.scenePosition;
                        worldPos.y = 0.25; // Place on ground
                    } else if (result.scenePosition) {
                        // Hit something else, use its position
                        worldPos = result.scenePosition;
                        worldPos.y = 0.25; // Place on ground
                    }
                }
                
                // If we don't have a valid position from picking, use ray casting
                if (!worldPos || (worldPos.x === 0 && worldPos.z === 0)) {
                    // Calculate position using ray casting to ground plane
                    var camera = view3d.camera;
                    var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
                    
                    // Calculate ray direction from camera through mouse position
                    var forward = root.calculateForwardVector(cameraRotationX, cameraRotationY);
                    var right = root.calculateRightVector(cameraRotationY);
                    
                    // Up direction (perpendicular to forward and right)
                    var up = forward.crossProduct(right).normalized();
                    
                    // Calculate screen center
                    var centerX = v3d.width / 2;
                    var centerY = v3d.height / 2;
                    
                    // Calculate offset from center (normalized to -1 to 1)
                    var offsetX = (mouse.x - centerX) / v3d.width;
                    var offsetY = (mouse.y - centerY) / v3d.height;
                    
                    // Calculate FOV-based scaling
                    var fov = camera.fieldOfView * Math.PI / 180;
                    var aspectRatio = v3d.width / v3d.height;
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
                            worldPos = cameraPos.plus(rayDir.times(t));
                            worldPos.y = 0.25; // Place on ground (half height of 50cm cube)
                        } else {
                            // Ray pointing up, create in front of camera
                            worldPos = cameraPos.plus(forward.times(200));
                            worldPos.y = 0.25;
                        }
                    } else {
                        // Ray parallel to ground, create in front of camera
                        worldPos = cameraPos.plus(forward.times(200));
                        worldPos.y = 0.25;
                    }
                }
                
                // Create node with 3D position
                // 2D position will be calculated from 3D position and updated with camera movement
                
                // Calculate initial 2D position from 3D position for guiConfig.position
                var initialScreenPos = v3d.mapFrom3DScene(Qt.vector3d(worldPos.x, worldPos.y, worldPos.z));
                
                // Create node with default type (Number)
                var defaultNodeType = Specs.NodeType.Number;
                var nodeId = scene.createSpecificNode3D(
                    scene.nodeRegistry.imports,
                    defaultNodeType,
                    scene.nodeRegistry.nodeTypes[defaultNodeType],
                    scene.nodeRegistry.nodeColors[defaultNodeType],
                    scene.nodeRegistry.nodeNames[defaultNodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === defaultNodeType).length + 1),
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
    // Only handle keys when no node is selected or no node is in edit mode
    Keys.enabled: {
        if (!scene || !scene.selectionModel) return true;
        var selectedCount = Object.keys(scene.selectionModel.selectedModel || {}).length;
        if (selectedCount === 0) return true;
        
        // Check if any selected node is in edit mode
        var hasEditingNode = false;
        Object.keys(scene.selectionModel.selectedModel || {}).forEach(function(nodeId) {
            var node = scene.nodes[nodeId];
            if (node) {
                // Try to find the nodeView for this node
                // If node is selected and might be editing, disable camera keys
                hasEditingNode = true;
            }
        });
        
        // Disable camera keys when node is selected (to allow text editing)
        return false;
    }
    
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
    
    // Ensure focus is maintained only when no node is selected
    onActiveFocusChanged: {
        if (!activeFocus) {
            // Only force focus if no node is selected
            if (!scene || !scene.selectionModel) {
                forceActiveFocus();
            } else {
                var selectedCount = Object.keys(scene.selectionModel.selectedModel || {}).length;
                if (selectedCount === 0) {
                    forceActiveFocus();
                }
            }
        }
    }

    //! Update camera position based on keyboard input
    Timer {
        interval: 16  // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            // Move camera (when no node is selected or always for camera control)
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

    /* Functions
     * ****************************************************************************************/
    
    //! Calculate forward direction vector from camera rotation
    function calculateForwardVector(rotX, rotY) {
        var rotXRad = rotX * Math.PI / 180;
        var rotYRad = rotY * Math.PI / 180;
        return Qt.vector3d(
            -Math.sin(rotYRad) * Math.cos(rotXRad),
            Math.sin(rotXRad),
            -Math.cos(rotYRad) * Math.cos(rotXRad)
        ).normalized();
    }
    
    //! Calculate right direction vector from camera rotation
    function calculateRightVector(rotY) {
        var rotYRad = rotY * Math.PI / 180;
        return Qt.vector3d(
            Math.cos(rotYRad),
            0,
            -Math.sin(rotYRad)
        ).normalized();
    }
    
    //! Check if a 3D point is behind camera
    function isBehindCamera(point3D) {
        var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
        var toPoint = point3D.minus(cameraPos);
        var forward = calculateForwardVector(cameraRotationX, cameraRotationY);
        var dotProduct = toPoint.x * forward.x + toPoint.y * forward.y + toPoint.z * forward.z;
        return dotProduct < 0;
    }
    
    //! Reset camera to default position
    function resetCamera() {
        cameraX = 0;
        cameraY = 50;
        cameraZ = 400;
        cameraRotationX = -15;
        cameraRotationY = 0;
    }
    
}

