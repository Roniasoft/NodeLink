import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Specs - Specifications for NodeLink 3D Quick Scene
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    
    //! Node type definitions
    readonly property int sourceNodeType: 0
    readonly property int resultNodeType: 1
    
    //! 3D Scene specific properties
    readonly property real defaultNodeSpacing: 200.0
    readonly property real defaultLayerSpacing: 100.0
    readonly property real cameraDistance: 800.0
    readonly property real cameraFieldOfView: 45.0
    
    //! Color scheme for 3D scene
    readonly property color sourceNodeColor: "#4CAF50"
    readonly property color resultNodeColor: "#2196F3"
    readonly property color linkColor: "#FFC107"
    readonly property color backgroundColor: "#1e1e1e"
    readonly property color gridColor: "#333333"
    
    //! Animation settings
    readonly property int nodeAnimationDuration: 300
    readonly property int cameraAnimationDuration: 500
    
    //! Grid properties
    readonly property real gridSize: 50.0
    readonly property int gridLines: 20
    
    /* Functions
     * ****************************************************************************************/
    
    //! Get node color by type
    function getNodeColor(nodeType) {
        switch (nodeType) {
            case sourceNodeType: return sourceNodeColor;
            case resultNodeType: return resultNodeColor;
            default: return "#666666";
        }
    }
    
    //! Get node icon by type
    function getNodeIcon(nodeType) {
        switch (nodeType) {
            case sourceNodeType: return "\uf1c0"; // fa-database
            case resultNodeType: return "\uf06e"; // fa-eye
            default: return "\uf1c0";
        }
    }
    
    //! Get node name by type
    function getNodeName(nodeType) {
        switch (nodeType) {
            case sourceNodeType: return "Source Node";
            case resultNodeType: return "Result Node";
            default: return "Unknown Node";
        }
    }
}



