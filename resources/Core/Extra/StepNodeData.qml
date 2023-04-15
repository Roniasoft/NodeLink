import QtQuick
import QtQuickStream
import NodeLink

NodeData {

    /* Property Declarations
    * ****************************************************************************************/

    //! Data is a map of Actions
    data: ({})

    /* Functions
     * ****************************************************************************************/

    //! Create action
    function createAction() {
        let obj = QSSerializer.createQSObject("Action", ["NodeLink"], NLCore.defaultRepo);
        obj._qsRepo = NLCore.defaultRepo;
        return obj;
    }

    //! Add action
    function addAction(action: Action) {
        addElement(data, action, dataChanged);
    }

    //! Remove action
    function removeAction(action: Action) {
        removeElement(data, action, dataChanged);
    }
}
