import QtQuick
import QtQuickStream
import NodeLink

/*! ***********************************************************************************************
 * Link keep the Input, outPut ports and line points to detect mouse connection selection.
 * ************************************************************************************************/
I_Node {

    /* Property Declarations
    * ****************************************************************************************/

    //! Input port
    property Port       inputPort :     Port {}

    //! Output port
    property Port       outputPort :    Port {}

    //! First control point
    property vector2d   controlPoint1:  Qt.vector2d(0, 0)

    //! Secound control point
    property vector2d   controlPoint2:  Qt.vector2d(0, 0)

    //! Type of Connection
    property int        linkType:       NLSpec.LinkType.Bezier

    /* Functions
     * ****************************************************************************************/
}
