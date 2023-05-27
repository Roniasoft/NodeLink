import QtQuick
import QtQuickStream
import NodeLink

/*! ***********************************************************************************************
 * Link keep the Input, outPut ports and line points to detect mouse connection selection.
 * ************************************************************************************************/
I_Node {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Input port
    property Port       inputPort :     Port {}

    //! Output port
    property Port       outputPort :    Port {}

    //! Control points array (including start/end points)
    property var        controlPoints:  []

    //! Direction
    property int        direction:      NLSpec.LinkDirection.Unidirectional

    //! Link Ui properties
    property LinkGUIConfig guiConfig: LinkGUIConfig {
        _qsRepo: root._qsRepo
    }

    /* Functions
     * ****************************************************************************************/
}
