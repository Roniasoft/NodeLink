import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Container GUI Config.
 * ************************************************************************************************/
QSObject {
    /* Property Properties
     * ****************************************************************************************/
    //! Zoom factor
    property real     zoomFactor: 1.0

    //! Width and height
    property real     width:      200

    property real     height:     200

    //! Color
    property string   color:      NLStyle.primaryColor

    //! Color index
    property int      colorIndex: -1

    //! Position in scene
    property vector2d position:   Qt.vector2d(0.0, 0.0)

    //! Lock
    property bool     locked:     false
}
