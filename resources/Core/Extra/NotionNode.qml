import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The NotionNode is the interface/base Node class for all extra nodes.
 * ************************************************************************************************/

Node {

    /* Property Properties
     * ****************************************************************************************/

    //! Entry Condition
    property I_EntryCondition   entryCondition: I_EntryCondition {}

    /* Functions
     * ****************************************************************************************/
    function canEnter() : bool {
        return entryCondition.evaluate(null);
    }

}
