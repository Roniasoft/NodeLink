pragma Singleton

import QtQuick

/*! ***********************************************************************************************
 *
 * \todo Decide if all colors are necasary or if some can be merged
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/

    /* Button related
     * ****************************************************************************************/

    /* Port
     * ****************************************************************************************/
    readonly property QtObject portView: QtObject {
        property int size:          18
        property int borderSize:    2
    }
}
