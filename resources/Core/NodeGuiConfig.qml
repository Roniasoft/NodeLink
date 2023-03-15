import QtQuick 2.15

import QtQuickStream

QSObject {
    //! Display image
    property string     name:       "<node name>"

    //! \todo change to bytearray of image?
    property string     logoUrl:    ""

    //! Position in the world
    property vector2d   position: Qt.vector2d(0, 0);

    //! Width
    property int        width:      200

    //! Height
    property int        height:     150

    //! Color
    property string     color:      "pink"
}
