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

    //! Input port \todo: shouldn't be uuid?!
    property Port       inputPort :     Port {}

    //! Output port \todo: shouldn't be uuid?!
    property Port       outputPort :    Port {}

    //! Control points array (including start/end points)
    property var        controlPoints:  []

    //! Direction
    property int        direction:      NLSpec.LinkDirection.Unidirectional

    //! Link Ui properties
    property LinkGUIConfig guiConfig: LinkGUIConfig {
        _qsRepo: root._qsRepo
    }

    /* Object Properties
    * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Link

    /* Functions
     * ****************************************************************************************/
    //! Function for handling link guiconfgi when copying and pasting
    onCloneFrom: function (baseLink)  {
        root.guiConfig?.setProperties(baseLink.guiConfig);
    }
}
