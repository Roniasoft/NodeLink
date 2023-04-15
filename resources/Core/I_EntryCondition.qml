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
    //! map <uuid, data<QSObject>>
    property var conditions: ({})

    /* Functions
     * ****************************************************************************************/
    function evaluate(evalData) : bool {
        return true;
    }

    //! Add entry condition
    function addCondition(ec) {
        addElement(conditions, ec, conditionsChanged);
    }

    //! Remove entry condition with Uuid
    function removeCondition(ecUuid : string) {
        let ec = conditions[ecUuid];

        if (ec === undefined) {
            console.warn("Item not found in container.");
            return;
        }
        removeElement(conditions, ec, conditionsChanged);
    }

    //! Check existence of condition in conditions list with Uuid
    function existCondition(ecUuid : string) : bool {
        return !(conditions[ecUuid] === undefined || conditions[ecUuid] === null)
    }

}
