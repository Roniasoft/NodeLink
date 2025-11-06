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

    //! Base content width (space for operation/image in the middle)
    property int baseContentWidth: 100

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

    //! Calculate optimal node size based on content and port titles - SYMMETRIC VERSION
    function calculateOptimalSize() {
        if (!autoSize) return;

        var requiredWidth = minWidth;
        var requiredHeight = minHeight;

        // Find the longest port title from BOTH left and right sides
        var maxTitleWidth = 0;

        // Check all ports (both left and right)
        Object.values(ports).forEach(function(port) {
            if (port.title) {
                var estimatedWidth = estimateTextWidth(port.title);
                if (estimatedWidth > maxTitleWidth) {
                    maxTitleWidth = estimatedWidth;
                }
            }
        });

        // Symmetric formula: longest title + base content + longest title
        // This ensures both sides have equal space for titles
        requiredWidth = Math.max(minWidth, (maxTitleWidth * 2) + baseContentWidth);

        // Calculate height based on number of ports
        var leftPortCount = getPortCountBySide(NLSpec.PortPositionSide.Left);
        var rightPortCount = getPortCountBySide(NLSpec.PortPositionSide.Right);
        var maxPortCount = Math.max(leftPortCount, rightPortCount);

        // Adjust height based on number of ports - keep it symmetric
        var basePortHeight = 30; // Height per port
        var minPortAreaHeight = Math.max(2, maxPortCount) * basePortHeight;
        requiredHeight = Math.max(minHeight, minPortAreaHeight);

        // Update GUI config
        if (guiConfig) {
            guiConfig.width = requiredWidth;
            guiConfig.height = requiredHeight;
        }
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
        // Rough estimation: ~7 pixels per character for the font size used in ports
        // This accounts for the actual rendered width better
        return text.length * 7 + 15; // +15 for padding/margins
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
