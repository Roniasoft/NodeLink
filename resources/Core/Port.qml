import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Port is a QSObject model that manage port properties..
 * ************************************************************************************************/
QSObject {

    /* Property Declarations
     * ****************************************************************************************/
    //! Node (parent) of the port
    property var    node

    //! Color of node
    property string color:      "white"

    //! port side in node
    property int    portSide:   NLSpec.PortPositionSide.Top

    //! Type of port, input or output
    property int    portType:   NLSpec.PortType.Input

    //! Port is enable or not
    property bool enable: true
}
