import QtQuick
import QtQuick3D as Qt3D

import Multiple3DEditors

/*! ***********************************************************************************************
 * Custom3DNode - A custom 3D rectangular node
 * ************************************************************************************************/

Qt3D.Node {
    id: root
    
    property string nodeId: ""
    property var nodeData: null
    property Multiple3DEditorsScene scene: null
    property bool selected: false
    
    // Set objectName on the Node itself for picking
    objectName: nodeId
    
    // Position, rotation, scale from nodeData
    position: nodeData ? nodeData.position : Qt.vector3d(0, 0, 0)
    eulerRotation: nodeData ? nodeData.rotation : Qt.vector3d(0, 0, 0)
    scale: nodeData ? nodeData.scale : Qt.vector3d(1, 1, 1)
    
    //! Main model (shape can be Cube, Sphere, Cylinder, Cone, Rectangle)
    Qt3D.Model {
        id: boxModel
        source: {
            if (!nodeData) return "#Cube";
            var shape = nodeData.shapeType || "Cube";
            switch(shape) {
                case "Sphere": return "#Sphere";
                case "Cylinder": return "#Cylinder";
                case "Cone": return "#Cone";
                case "Rectangle": return "#Rectangle";
                default: return "#Cube";
            }
        }
        scale: nodeData ? nodeData.dimensions.times(0.01) : Qt.vector3d(1, 1, 1)  // Convert cm to meters
        
        // Store nodeId for picking (using objectName as a workaround)
        objectName: root.nodeId
        
        // Enable picking
        pickable: true
        
        materials: [
            Qt3D.PrincipledMaterial {
                id: nodeMaterial
                baseColor: {
                    if (!nodeData) return Qt.rgba(0.5, 0.7, 1.0, 1.0);
                    var c = nodeData.color;
                    if (typeof c === "string") return Qt.color(c);
                    return c;
                }
                metalness: nodeData ? nodeData.metallic : 0.0
                roughness: nodeData ? nodeData.roughness : 0.5
                emissiveFactor: {
                    if (!nodeData) return Qt.vector3d(0, 0, 0);
                    var emissiveColor = nodeData.emissiveColor;
                    var power = nodeData.emissivePower;
                    // Convert string color to color object if needed
                    if (typeof emissiveColor === "string") {
                        emissiveColor = Qt.color(emissiveColor);
                    }
                    // emissiveFactor is RGB multiplied by intensity
                    return Qt.vector3d(
                        emissiveColor.r * power,
                        emissiveColor.g * power,
                        emissiveColor.b * power
                    );
                }
            }
        ]
        
        receivesShadows: true
    }
    
    //! Selection outline - matches the shape
    Qt3D.Model {
        id: selectionOutline
        source: {
            if (!nodeData) return "#Cube";
            var shape = nodeData.shapeType || "Cube";
            switch(shape) {
                case "Sphere": return "#Sphere";
                case "Cylinder": return "#Cylinder";
                case "Cone": return "#Cone";
                case "Rectangle": return "#Rectangle";
                default: return "#Cube";
            }
        }
        scale: nodeData ? nodeData.dimensions.times(0.0105) : Qt.vector3d(1.05, 1.05, 1.05)  // Slightly larger
        visible: root.selected
        
        materials: [
            Qt3D.PrincipledMaterial {
                baseColor: "#4488ff"  // Light blue
                metalness: 0.0
                roughness: 0.0
                emissiveFactor: Qt.vector3d(0.3, 0.5, 1.0)  // Light blue emissive
                alphaMode: Qt3D.PrincipledMaterial.Blend
                opacity: 0.3
                cullMode: Qt3D.Material.NoCulling
            }
        ]
    }
    
    //! Resize handles at corners (simplified - only show 4 corner handles for now)
    // Note: Repeater doesn't work with 3D Models in View3D, so we create them manually
    Component {
        id: resizeHandleComponent
        Qt3D.Model {
            source: "#Sphere"
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            pickable: true
            
            materials: [
                Qt3D.PrincipledMaterial {
                    baseColor: "#ff0000"
                    metalness: 0.0
                    roughness: 0.0
                    emissiveFactor: Qt.vector3d(2, 0, 0)  // Red emissive
                }
            ]
        }
    }
    
    // Create resize handles manually (simplified to 4 corners for now)
    property var resizeHandles: []
    
    function updateResizeHandles() {
        // Clear existing handles
        for (var i = 0; i < resizeHandles.length; i++) {
            if (resizeHandles[i]) {
                resizeHandles[i].destroy();
            }
        }
        resizeHandles = [];
        
        // Resize handles disabled - don't show red spheres
        // if (!root.selected || !nodeData) return;
        // 
        // // Only show resize handles for box-like shapes (Cube, Rectangle)
        // var shape = nodeData.shapeType || "Cube";
        // var showHandles = (shape === "Cube" || shape === "Rectangle");
        // 
        // if (!showHandles) return;
        // 
        // var dims = nodeData.dimensions.times(0.01);
        // // Create 4 corner handles (top corners)
        // var corners = [
        //     Qt.vector3d(dims.x, dims.y, dims.z),      // Top front right
        //     Qt.vector3d(-dims.x, dims.y, dims.z),     // Top front left
        //     Qt.vector3d(dims.x, dims.y, -dims.z),     // Top back right
        //     Qt.vector3d(-dims.x, dims.y, -dims.z)     // Top back left
        // ];
        // 
        // for (var i = 0; i < 4; i++) {
        //     var handle = resizeHandleComponent.createObject(root, {
        //         objectName: root.nodeId + "_resize_" + i,
        //         position: corners[i]
        //     });
        //     resizeHandles.push(handle);
        // }
    }
    
    onSelectedChanged: {
        updateResizeHandles();
    }
    
    onNodeDataChanged: {
        if (selected && nodeData && resizeHandles.length === 4) {
            // Update handle positions
            var dims = nodeData.dimensions.times(0.01);
            var corners = [
                Qt.vector3d(dims.x, dims.y, dims.z),
                Qt.vector3d(-dims.x, dims.y, dims.z),
                Qt.vector3d(dims.x, dims.y, -dims.z),
                Qt.vector3d(-dims.x, dims.y, -dims.z)
            ];
            for (var i = 0; i < 4; i++) {
                if (resizeHandles[i]) {
                    resizeHandles[i].position = corners[i];
                }
            }
        }
    }
    
    Component.onDestruction: {
        for (var i = 0; i < resizeHandles.length; i++) {
            if (resizeHandles[i]) {
                resizeHandles[i].destroy();
            }
        }
    }
    
    // Material properties are bound to nodeData, so they update automatically
}

