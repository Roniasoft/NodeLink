pragma Singleton

import QtQuick

/*! ***********************************************************************************************
 *  CSpecs contains constant pre-defined properties.
 * ************************************************************************************************/

QtObject {

    /* Enums
     * ****************************************************************************************/

    //! Type of node.
    enum NodeType {
        ImageInput      = 0,
        ImageResult     = 1,
        Blur            = 2,
        Brightness      = 3,
        Contrast        = 4,

        Operation       = 5,

        Unknown     = 99
    }

    //! Object types
    enum OperationType {
        Blur            = 0,
        Brightness      = 1,
        Contrast        = 2,

        Unknown = 99
    }

}
