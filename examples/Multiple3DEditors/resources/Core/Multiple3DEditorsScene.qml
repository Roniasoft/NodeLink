import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Multiple3DEditorsScene - A 3D scene with custom 3D rectangular nodes
 * ************************************************************************************************/

QtObject {
    id: scene

    /* Property Declarations
     * ****************************************************************************************/
    
    //! List of 3D nodes
    property var nodes: ({})
    
    //! Selected node ID
    property string selectedNodeId: ""
    
    //! Node counter for unique IDs
    property int nodeCounter: 0
    
    /* Functions
     * ****************************************************************************************/

    //! Create a new 3D node
    function createNode(x: real, y: real, z: real, shapeType: string): string {
        var nodeId = "node_" + nodeCounter++;
        var node = {
            id: nodeId,
            position: Qt.vector3d(x, y, z),
            rotation: Qt.vector3d(0, 0, 0),
            scale: Qt.vector3d(1, 1, 1),
            dimensions: Qt.vector3d(50, 50, 50),  // Smaller initial size (50cm = 0.5m)
            shapeType: shapeType || "Cube",  // Default to Cube
            color: Qt.rgba(0.5, 0.7, 1.0, 1.0),
            materialType: "DefaultMaterial",
            metallic: 0.0,
            roughness: 0.5,
            emissiveColor: Qt.rgba(0, 0, 0, 1),
            emissivePower: 0.0
        };
        
        var newNodes = {};
        for (var key in nodes) {
            newNodes[key] = nodes[key];
        }
        newNodes[nodeId] = node;
        nodes = newNodes;
        
        return nodeId;
    }
    
    //! Delete a node
    function deleteNode(nodeId: string) {
        var newNodes = {};
        for (var key in nodes) {
            if (key !== nodeId) {
                newNodes[key] = nodes[key];
            }
        }
        nodes = newNodes;
        if (selectedNodeId === nodeId) {
            selectedNodeId = "";
        }
    }
    
    //! Update node property
    function updateNodeProperty(nodeId: string, propertyName: string, value: var) {
        if (nodes[nodeId]) {
            var oldNode = nodes[nodeId];
            // Create a new node object to ensure QML detects the change
            var newNode = {
                id: oldNode.id,
                position: propertyName === "position" ? value : oldNode.position,
                rotation: propertyName === "rotation" ? value : oldNode.rotation,
                scale: propertyName === "scale" ? value : oldNode.scale,
                dimensions: propertyName === "dimensions" ? value : oldNode.dimensions,
                shapeType: propertyName === "shapeType" ? value : (oldNode.shapeType || "Cube"),
                color: propertyName === "color" ? value : oldNode.color,
                materialType: propertyName === "materialType" ? value : oldNode.materialType,
                metallic: propertyName === "metallic" ? value : oldNode.metallic,
                roughness: propertyName === "roughness" ? value : oldNode.roughness,
                emissiveColor: propertyName === "emissiveColor" ? value : oldNode.emissiveColor,
                emissivePower: propertyName === "emissivePower" ? value : oldNode.emissivePower
            };
            
            var newNodes = {};
            for (var key in nodes) {
                if (key === nodeId) {
                    newNodes[key] = newNode;
                } else {
                    newNodes[key] = nodes[key];
                }
            }
            nodes = newNodes;
        }
    }
    
    //! Select a node
    function selectNode(nodeId: string) {
        selectedNodeId = nodeId;
    }
    
    //! Deselect all nodes
    function deselectAll() {
        selectedNodeId = "";
    }
}

