import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * EntryCondition is a condition that is applied in simulation.
 * The condition is evaluated while deciding the node can be
 * entered or not.
 *
 * ************************************************************************************************/
QSObject {

    //! Conditions
    //! array (uuids of actions)
    property var conditions: []

    /* Functions
     * ****************************************************************************************/
    function evaluate(evalData) : bool {
        return true;
    }

    //! Add entry condition
    function addCondition(conditionId: string) {
        conditions.push(conditionId);
        conditionsChanged();
    }

    //! Remove entry condition with Uuid
    function removeCondition(conditionId : string) {
        var indexOfAction = conditions.indexOf(conditionId);
        conditions.splice(indexOfAction, 1);
        conditionsChanged();
    }

    //! Check existence of condition in conditions list with Uuid
    function existCondition(conditionId : string) : bool {
        return conditions.indexOf(conditionId) >= 0 ? true : false;
    }

}
