pragma Singleton

import QtQuick
import QtQuickStream

/*! ***********************************************************************************************
 * The NLCore is responsible for creating the default repo Scene, and handling the top level functionalities,
 * such as de/serialization and network connectivity.
 * ************************************************************************************************/
QSCore {
    id: core

    /* Property Declarations
     * ****************************************************************************************/

    property QtObject _internal: QtObject {
        readonly property var imports: [ "QtQuickStream" ]
    }

    /* Object Properties
     * ****************************************************************************************/
    defaultRepo: createDefaultRepo(_internal.imports);


    /* Functions
     * ****************************************************************************************/

    //! Create scene
    function createScene() {
        let obj = QSSerializer.createQSObject("Scene", ["NodeLink"], core);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    //! Create Node
    function createNode() {
        let obj = QSSerializer.createQSObject("Node", ["NodeLink"], core);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    //! Create port
    function createPort() {
        let obj = QSSerializer.createQSObject("Port", ["NodeLink"], core);
        obj._qsRepo = defaultRepo;
        return obj;
    }
}
