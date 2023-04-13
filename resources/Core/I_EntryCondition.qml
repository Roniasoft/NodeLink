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
    property var conditions: []

    /* Functions
     * ****************************************************************************************/
    function evaluate(evalData) : bool {
        return true;
    }
}
