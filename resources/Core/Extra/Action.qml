import QtQuick
import QtQuickStream
import NodeLink

/*! ***********************************************************************************************
 * Action is a specific data typr for step node to handle actions between any node types.
 * ************************************************************************************************/

QSObject {

    //! Action Type Enumeration
    enum ActionType {
        Additive    = 0,
        Subtractive = 1
    }

    /* Property Declarations
    * ****************************************************************************************/

    //! Action Name
    property string         name:       "<untitled>"

    //! Action Type
    property int            actionType: Action.ActionType.Additive

    //! ActionValue
    property ActionValue    value:      ActionValue {}
}
