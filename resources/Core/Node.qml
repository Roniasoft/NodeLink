import QtQuick 2.15

import QtQuickStream

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
QSObject  {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    // Unique ID
    property int            id:         0

    //! Title
    property string         title:      "<Unknown>"

    //! GUI Config
    property NodeGuiConfig  guiConfig:  NodeGuiConfig {
         _qsRepo: root._qsRepo
    }

    //! Node Type
    property int            type:       NLSpec.NodeType.General

    //! Port list
    //! map<id, Port>
    property var            ports:      ({})


    /* Signals
     * ****************************************************************************************/
    signal portAdded(var portId);

    /* Functions
     * ****************************************************************************************/



    //! Adds a node the to nodes map
    function addPort(port) {
        // Add to local administration
        ports[port.id] = port;
        portsChanged();

        portAdded(port.id);
    }

    function deletePort(port) {

    }

    function findPort(portId: int): Port {
        if (Object.keys(ports).includes(portId)) {
            return ports[portId];
        }

        return null;
    }
}
