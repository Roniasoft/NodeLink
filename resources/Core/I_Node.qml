import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The I_Node is the interface/base class for all objects inside the scene
 *
 * ************************************************************************************************/
QSObject {

    //! NodeData
    property I_NodeData         nodeData:       null

    //! Entry Condition
    property I_EntryCondition   entryCondition: I_EntryCondition {}


    /* Functions
     * ****************************************************************************************/
    function canEnter() : bool {
        return entryCondition.evaluate(null);
    }
}
