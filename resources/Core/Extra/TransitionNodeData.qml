import QtQuick
import QtQuickStream
import NodeLink

/*! ***********************************************************************************************
 * TransitionNodeData keep/manage transition node data types.
 * ************************************************************************************************/

NodeData {

    /* Property Declarations
    * ****************************************************************************************/

    //! Data is a node uuid that transition to it.
    data: ""

    /* Functions
     * ****************************************************************************************/

    //! Add transition
    function addTransition(uuid: string) {
        if(uuid !== undefined)
            data = uuid;
    }

    //! Remove transition
    function removeTransition() {
        data = "";
    }
}
