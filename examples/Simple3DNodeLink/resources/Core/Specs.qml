pragma Singleton

import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Specs - Specifications for NodeLink 3D Quick Scene
 * ************************************************************************************************/

QtObject {
    id: root

    /* Enums
     * ****************************************************************************************/
    
    //! Type of node
    enum NodeType {
        Number      = 2,
        Position    = 3,
        Rotation    = 4,
        Scale       = 5,
        Dimensions  = 6,
        Metal       = 7,
        Plastic     = 8,
        Glass       = 9,
        Rubber      = 10,
        Wood        = 11,
        Cube        = 12,
        Sphere      = 13,
        Cylinder    = 14,
        Cone        = 15,
        Plane       = 16,
        Rectangle   = 17,
        
        Unknown     = 99
    }

    /* Property Declarations
     * ****************************************************************************************/
    
    /* Functions
     * ****************************************************************************************/
    
}



