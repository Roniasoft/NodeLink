import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Port is a QSObject model that manage port properties..
 * ************************************************************************************************/
QSObject {
    Component.onDestruction: _qsRepo?.unregisterObject(this)
    /* Property Declarations
     * ****************************************************************************************/
    //! Node (parent) of the port
    property var    node

    //! Color of node
    property string color:      "white"

    //! port side in node
    property int    portSide:   NLSpec.PortPositionSide.Top

    //! Type of port, input or output
    property int    portType:   NLSpec.PortType.InAndOut

    //! Port is enable or not
    property bool enable: true

    //! _position is a vector2d to calculated with global position of port in UI and just cache it.
    property vector2d _position: Qt.vector2d(-1, -1)

    //Port title to be Always Visible
    property string title: "title"

    //! Measured title width for auto-sizing (set by the view)
    property real _measuredTitleWidth: -1
}
