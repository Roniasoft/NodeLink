import QtQuick 2.15
import QtQuickStream
import NodeLink

NodeData {
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
}
