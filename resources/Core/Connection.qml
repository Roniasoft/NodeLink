import QtQuick
import QtQuickStream

/*! ***********************************************************************************************
 * Connection keep the Input, outPut ports and line points to detect mouse connection selection.
 * ************************************************************************************************/

QSObject {

    /* Property Declarations
    * ****************************************************************************************/

    //! Input port
    property Port inputPort : Port {}

    //! Output port
    property Port outputPort : Port {}

    //! First control point
//    property vector2d controlPoint1: Qt.vector2d(0, 0)

    //! Secound control point
//    property vector2d controlPoint2: Qt.vector2d(0, 0)

    //! Type of Connection
    property int connectionType: NLSpec.ConnectionType.Bezier

    //! Link is selected or not.
    property bool isSelected: false

    /* Functions
     * ****************************************************************************************/


}
