import QtQuick 2.15
import QtQuickStream
import NodeLink

QSObject {

    enum ActionType {
        Additive    = 0,
        Subtractive = 1
    }

    //! Action Name
    property string         name:       "<untitled>"

    //! Action Type
    property int            actionType: Action.ActionType.Additive

    //! ActionValue
    property ActionValue    value:      ActionValue {}
}
