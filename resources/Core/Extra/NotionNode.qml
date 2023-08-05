import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The NotionNode is the interface/base Node class for all extra nodes.
 * ************************************************************************************************/

Node {
    id: root

    //! Node Status
    enum NodeStatus {
        Active   = 0,
        Selected = 1,
        Inactive = 2,

        Unknown  = 99
    }

    /* Property Properties
     * ****************************************************************************************/

    //! Entry Condition
    property I_EntryCondition   entryCondition: I_EntryCondition {}

    //! Node status
    property int status: NotionNode.NodeStatus.Inactive

    /* Functions
     * ****************************************************************************************/
    function canEnter() : bool {
        return entryCondition.evaluate(null);
    }

    //! Update Node status
    function updateNodeStatus(status: int) {
        root.status = status;
    }

    //! Check the node status
    function checkNodeStatus(status: int) : bool {
            return root.status === status;
    }

}
