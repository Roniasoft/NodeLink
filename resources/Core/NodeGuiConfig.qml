import QtQuick 2.15

QtObject {
    //! Display image
    property string     name:       "<node name>"

    //! \todo change to bytearray of image?
    property string     logoUrl:    ""

    //! Position in the world
    property vector2d   position:   Qt.vector2d(0,50)

    //! Width
    property int        width:      200

    //! Height
    property int        height:     120

    //! Color
    property string     color:      "pink"
}
