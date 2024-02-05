pragma Singleton

import QtQuick
import QtQuick.Controls
import QtQuickStream
import NodeLink

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

    //! Shallow Copied Nodes, to be used in paste when needed
    property var     _copiedNodes: ({})

    //! Shallow Copied links, to be used in paste when needed
    property var     _copiedLinks: ({})

    property var     _copiedContainers: ({})

    /* Object Properties
     * ****************************************************************************************/


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
    function createPort(qsRepo = null) {
        if (!qsRepo)
            qsRepo = defaultRepo;

        let obj = QSSerializer.createQSObject("Port", ["NodeLink"], qsRepo);
        obj._qsRepo = qsRepo;
        return obj;
    }

    //! Create Link
    function createLink() {
        let obj = QSSerializer.createQSObject("Link", ["NodeLink"], defaultRepo);
        obj._qsRepo = defaultRepo;
        return obj;
    }
}
