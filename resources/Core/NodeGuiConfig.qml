import QtQuick

import QtQuickStream

/*! ***********************************************************************************************
 * The NodeGuiConfig is a QSObject that keep the Ui Node properties.
 * ************************************************************************************************/
QSObject {

    /* Property Properties
     * ****************************************************************************************/

    //! Description
    property string     description:    "<No Description>"

    //! \todo change to bytearray of image?
    property string     logoUrl:    ""

    //! Position in the world
    property vector2d   position:   Qt.vector2d(0, 0);

    //! Width
    property int        width:      200

    //! Height
    property int        height:     150

    //! Color
    property string     color:      "pink"

}
