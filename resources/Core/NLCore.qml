pragma Singleton

import QtQuick
import QtQuickStream

/*! ***********************************************************************************************
 * The NLCore is responsible for creating the Scene, and handling the top level functionalities,
 * such as de/serialization and network connectivity.
 * ************************************************************************************************/
QtObject {
    id: core

    /* Property Declarations
     * ****************************************************************************************/
//    required property  QSRepository qsRepo
    property Scene scene: Scene {
//        _qsRepo: core.qsRepo
    }


    property QtObject _internal: QtObject {
        property int portCounter: 0
    }

    /* Object Properties
     * ****************************************************************************************/


    /* Functions
     * ****************************************************************************************/
    function createScene(parentRepo: QSRepository) {
        let obj = Qt.createQmlObject("import NodeLink;" + "Scene" + "{}", core);
        obj._qsRepo = parentRepo;
        return obj;
    }

    function createPort(parentRepo: QSRepository) {
        let obj = Qt.createQmlObject("import NodeLink;" + "Port" + "{}", core);
        core._internal.portCounter++;
        obj._qsRepo = parentRepo;
        obj.id = core._internal.portCounter;
        return obj;
    }

    function createNode(parentRepo: QSRepository) {
        let obj = Qt.createQmlObject("import NodeLink;" + "Node" + "{}", core);
        obj._qsRepo = parentRepo;
        return obj;
    }


}
