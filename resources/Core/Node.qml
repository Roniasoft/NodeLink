// import QtQuick
// import QtQuickStream

// import NodeLink

// /*! ***********************************************************************************************
//  * Node is a model that manage node properties..
//  * ************************************************************************************************/
// I_Node  {
//     id: root

//     /* Property Declarations
//      * ****************************************************************************************/

//     //! GUI Config
//     property NodeGuiConfig  guiConfig:  NodeGuiConfig {
//          _qsRepo: root._qsRepo
//     }


//     //! Title
//     property string         title:      "<No Title>"

//     //! Node Type
//     property int            type: 0

//     //! Maps child node Id to actual node
//     property var children: ({})

//     //! Maps parent node Id to actual node
//     property var parents:  ({})

//     //! Port list
//     //! map<uuid, Port>
//     property var            ports:      ({})

//     //! Manages node images
//     property ImagesModel    imagesModel: ImagesModel {}

//     /* Object Properties
//     * ****************************************************************************************/
//     objectType: NLSpec.ObjectType.Node

//     /* Slots
//      * ****************************************************************************************/

//     //! adds functionionality for this layer
//     //! Handle clone node operation
//     onCloneFrom: function (baseNode)  {
//         // Copy direct properties in root.
//         title = baseNode.title;
//         type  = baseNode.type;

//         root.imagesModel?.setProperties(baseNode.imagesModel);
//         root.guiConfig?.setProperties(baseNode.guiConfig);
//     }

//     /* Signals
//      * ****************************************************************************************/
//     signal portAdded(var portId);

//     //! Emit when all node properties set to node.
//     //! This signal call afetr component.onCompleted signal.
//     signal nodeCompleted();

//     /* Functions
//      * ****************************************************************************************/

//     //! Adds a node the to nodes map
//     function addPort(port : Port) {
//         // Add to local administration
//         ports[port._qsUuid] = port;
//         portsChanged();

//         portAdded(port._qsUuid);
//     }

//     function deletePort(port) {
//     }


//     //! find port with portUuid
//     function findPort(portId: string): Port {
//         if (Object.keys(ports).includes(portId)) {
//             return ports[portId];
//         }
//             return null;
//     }

//     //! find port with specified port side.
//     function findPortByPortSide(portSide : int) : Port {
//                 let foundedPort = null;
//                 Object.values(ports).find(port => {
//                     if (port.portSide === portSide) {
//                         foundedPort = port;
//                     }
//                 });

//                 return foundedPort;
//     }
// }

import QtQuick
import QtQuickStream

import NodeLink

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
I_Node  {
    id: root
    Component.onDestruction: _qsRepo?.unregisterObject(this)
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

    //! Manages node images
    property ImagesModel    imagesModel: ImagesModel {}

    //! Auto size node based on content and port titles
    property bool autoSize: true

    //! Minimum node dimensions
    property int minWidth: 100
    property int minHeight: 70

    //! Padding for content
    property int contentPadding: 12

    /* Object Properties
    * ****************************************************************************************/
    objectType: NLSpec.ObjectType.Node

    /* Slots
     * ****************************************************************************************/

    //! adds functionionality for this layer
    //! Handle clone node operation
    onCloneFrom: function (baseNode)  {
        // Copy direct properties in root.
        title = baseNode.title;
        type  = baseNode.type;

        root.imagesModel?.setProperties(baseNode.imagesModel);
        root.guiConfig?.setProperties(baseNode.guiConfig);
    }

    /* Signals
     * ****************************************************************************************/
    signal portAdded(var portId);

    //! Emit when all node properties set to node.
    //! This signal call afetr component.onCompleted signal.
    signal nodeCompleted();

    /* Functions
     * ****************************************************************************************/

    //! Adds a port and triggers size recalculation if autoSize is enabled
    function addPort(port : Port) {
        // Add to local administration
        ports[port._qsUuid] = port;
        portsChanged();

        // Connect to port title changes for auto-sizing
        if (autoSize) {
            port.titleChanged.connect(calculateOptimalSize);
        }

        portAdded(port._qsUuid);

        // Recalculate size after adding port
        if (autoSize) {
            calculateOptimalSize();
        }
    }

    function deletePort(port : Port) {
        if (autoSize) {
            port.titleChanged.disconnect(calculateOptimalSize);
        }
        var portId = port._qsUuid
        var portObj = ports[portId]
        portObj.destroy()
        delete port[portId]
    }

    //! Calculate optimal node size based on content and port titles
    function calculateOptimalSize() {
        if (!autoSize) return;

        var requiredWidth = minWidth;
        var requiredHeight = minHeight;

        // Calculate width based on port titles
        var maxLeftTitleWidth = calculateMaxPortTitleWidth(NLSpec.PortPositionSide.Left);
        var maxRightTitleWidth = calculateMaxPortTitleWidth(NLSpec.PortPositionSide.Right);

        // Base node width + space for port titles on both sides
        requiredWidth = Math.max(requiredWidth, minWidth + maxLeftTitleWidth + maxRightTitleWidth);

        // Calculate height based on number of ports (adjust if needed)
        var leftPortCount = getPortCountBySide(NLSpec.PortPositionSide.Left);
        var rightPortCount = getPortCountBySide(NLSpec.PortPositionSide.Right);
        var maxPortCount = Math.max(leftPortCount, rightPortCount);

        // Adjust height based on number of ports
        if (maxPortCount > 2) {
            requiredHeight = Math.max(requiredHeight, minHeight + (maxPortCount - 2) * 25);
        }

        // Update GUI config
        if (guiConfig) {
            guiConfig.width = requiredWidth;
            guiConfig.height = requiredHeight;
        }
    }

    //! Calculate maximum title width for ports on a specific side
    function calculateMaxPortTitleWidth(side) {
        var maxWidth = 0;
        Object.values(ports).forEach(function(port) {
            if (port.portSide === side && port.title) {
                var estimatedWidth = estimateTextWidth(port.title);
                if (estimatedWidth > maxWidth) {
                    maxWidth = estimatedWidth;
                }
            }
        });
        return maxWidth;
    }

    //! Get port count by side
    function getPortCountBySide(side) {
        return Object.values(ports).filter(function(port) {
            return port.portSide === side;
        }).length;
    }

    //! Estimate text width (simplified calculation)
    function estimateTextWidth(text) {
        if (!text) return 0;
        // Rough estimation: ~8 pixels per character + some padding
        return text.length * 8 + 20;
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

    //! Handle title changes for auto-sizing
    onTitleChanged: {
        if (autoSize) {
            calculateOptimalSize();
        }
    }

    //! Initial size calculation
    Component.onCompleted: {
        if (autoSize) {
            calculateOptimalSize();
        }
        nodeCompleted();
    }
}
