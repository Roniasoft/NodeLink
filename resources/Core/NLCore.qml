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
    function createScene() {
        let obj = Qt.createQmlObject("import NodeLink;" + "Scene" + "{}", core);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    function createPort() {
        let obj = Qt.createQmlObject("import NodeLink;" + "Port" + "{}", core);
        obj._qsRepo = defaultRepo;
        return obj;
    }

    function createNode() {
        let obj = Qt.createQmlObject("import NodeLink;" + "Node" + "{}", core);
        obj._qsRepo = defaultRepo;
        return obj;
    }


}
