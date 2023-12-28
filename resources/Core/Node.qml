import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
I_Node  {
    id: root

    /* Property Declarations
     * ****************************************************************************************/

    //! GUI Config
    property NodeGuiConfig  guiConfig:  NodeGuiConfig {
         _qsRepo: root._qsRepo
    }


    //! Title
    property string         title:      "<No Title>"

    //! Node Type
    property int            type: 0

    //! Maps child node Id to actual node
    property var children: ({})

    //! Maps parent node Id to actual node
    property var parents:  ({})

    //! Port list
    //! map<uuid, Port>
    property var            ports:      ({})

    //! Image source picture
    property string         imageSource: ""

    /* Object Properties
    * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node

    /* Slots
     * ****************************************************************************************/

    //! Override function
    //! Handle clone node operation
    onCloneFrom: function (baseNode)  {

        // Copy direct properties in root.
        title = baseNode.title;
        type  = baseNode.type;
        imageSource = baseNode.imageSource

        root.guiConfig?.setProperties(baseNode.guiConfig);
    }

    /* Signals
     * ****************************************************************************************/
    signal portAdded(var portId);

    /* Functions
     * ****************************************************************************************/

    //! Adds a node the to nodes map
    function addPort(port : Port) {
        // Add to local administration
        ports[port._qsUuid] = port;
        portsChanged();

        portAdded(port._qsUuid);
    }

    function deletePort(port) {
    }


    //! find port with portUuid
    function findPort(portId: string): Port {
        if (Object.keys(ports).includes(portId)) {
            return ports[portId];
        }
            return null;
    }

    //! find port with specified port side.
    function findPortByPortSide(portSide : int) : Port {
                let foundedPort = null;
                Object.values(ports).find(port => {
                    if (port.portSide === portSide) {
                        foundedPort = port;
                    }
                });

                return foundedPort;
    }
}
