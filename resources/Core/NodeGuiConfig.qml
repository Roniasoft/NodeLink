import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The NodeGuiConfig is a QSObject that keep the Ui Node properties.
 * ************************************************************************************************/
QSObject {
    Component.onDestruction: _qsRepo?.unregisterObject(this)
    /* Property Properties
     * ****************************************************************************************/

    //! Description
    property string     description:    "<No Description>"

    //! \todo change to bytearray of image?
    property string     logoUrl:    ""

    //! Position in the world
    property vector2d   position:   Qt.vector2d(0.0, 0.0);

    //! Width
    property int        width:      NLStyle.node.width

    //! Height
    property int        height:     NLStyle.node.height

    //! Color
    property string     color:      NLStyle.node.color

    property  int       colorIndex: -1

    //! Opacity
    property real       opacity:    NLStyle.node.opacity

    //! Lock
    property bool       locked:     false

    //! Auto size node based on content and port titles
    property bool autoSize: true

    //! Minimum node dimensions
    property int minWidth: 100
    property int minHeight: 70

    //! Base content width (space for operation/image in the middle)
    property int baseContentWidth: 100

    //! Calculated minimum dimensions (read-only, for internal use)
    property int calculatedMinWidth: minWidth
    property int calculatedMinHeight: minHeight

}
