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
        return QSSerializer.createQSObject("Scene", ["NodeLink"], core);
    }

    //! Create Node
    function createNode() {
        return QSSerializer.createQSObject("Node", ["NodeLink"], core);
    }

    //! Create port
    function createPort() {
        return QSSerializer.createQSObject("Port", ["NodeLink"], core);
    }
}
