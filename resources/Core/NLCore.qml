pragma Singleton

import QtQuick
import QtQuick.Controls
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
        readonly property var imports: [ "QtQuickStream", "NodeLink"]
    }

    /* Object Properties
     * ****************************************************************************************/
    defaultRepo: createDefaultRepo(_internal.imports);


    /* Functions
     * ****************************************************************************************/

    //! Create scene
    function createScene() {
        let obj = QSSerializer.createQSObject("Scene", ["NodeLink"], defaultRepo);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    //! Create Node
    function createNode() {
        let obj = QSSerializer.createQSObject("Node", ["NodeLink"], defaultRepo);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    //! Create port
    function createPort() {
        let obj = QSSerializer.createQSObject("Port", ["NodeLink"], defaultRepo);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    //! Create Link
    function createLink() {
        let obj = QSSerializer.createQSObject("Link", ["NodeLink"], defaultRepo);
        obj._qsRepo = defaultRepo;
        return obj;
    }
}
