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
        Source      = 0,
        Additive    = 1,
        Multiplier  = 2,
        Subtraction = 3,
        Division    = 4,
        Result      = 5,

        Operation   = 6,

        Unknown     = 99
    }

    //! Object types
    enum OperationType {
        Additive     = 0,
        Multiplier   = 1,
        Subtraction  = 2,
        Division     = 3,

        Unknown = 99
    }

}
