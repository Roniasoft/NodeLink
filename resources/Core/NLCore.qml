pragma Singleton

import QtQuick

/*! ***********************************************************************************************
 * The NLCore is responsible for creating the Scene, and handling the top level functionalities,
 * such as de/serialization and network connectivity.
 * ************************************************************************************************/
QtObject {
    id: core

    /* Property Declarations
     * ****************************************************************************************/
    property Scene scene: Scene {}


    property QtObject _internal: QtObject {
        property int portCounter: 0
    }

    /* Object Properties
     * ****************************************************************************************/


    /* Functions
     * ****************************************************************************************/
    function createPort() {
        let obj = Qt.createQmlObject("import NodeLink;" + "Port" + "{}", core);
        core._internal.portCounter++;
        obj.id = core._internal.portCounter;
        return obj;
    }

    function createNode() {
        let obj = Qt.createQmlObject("import NodeLink;" + "Node" + "{}", core);
        return obj;
    }




}
