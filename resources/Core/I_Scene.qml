import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and links between them.
 *
 * ************************************************************************************************/
QSObject {
    id: scene

    /* Property Properties
     * ****************************************************************************************/
    //! Scene Title
    property string         title:          "<Untitled>"

    //! Nodes
    //! map <UUID, Node>
    property var            nodes:          ({})

    //! Keep Connection models
    //! map <UUID, Link>
    property var            links:          ({})

    //! Port positions (global)
    //! map <port uuid: string, global pos: vector2d>
    property var            portsPositions: ({})

    //! Scene Selection Model
    property SelectionModel selectionModel: null

    /* Signals
     * ****************************************************************************************/

    //! Node added
    signal nodeAdded(Node node)

    //! Node Removed
    signal nodeRemoved(Node node)

    //! Link added
    signal linkAdded(Link link)

    //! Link Removed
    signal linkRemoved(Link link)

    /* Functions
     * ****************************************************************************************/

    //! Check the repository if the model is loading the call the nodes add/remove
    //! related signals to sync the UI
    property Connections _initializeCon : Connections {
        target: scene._qsRepo
        function onIsLoadingChanged() {
            if (scene._qsRepo._isLoading) {
                Object.values(nodes).forEach(node => nodeRemoved(node));
                Object.values(links).forEach(link => linkRemoved(link));
            } else {
                Object.values(nodes).forEach(node => nodeAdded(node));
                Object.values(links).forEach(link => linkAdded(link));
            }
        }
    }

    //! Adds a node the to nodes map
    function addNode(node: Node) {
        //Sanity check
        if (nodes[node._qsUuid] === node) { return; }

        // Add to local administration
        nodes[node._qsUuid] = node;
        nodesChanged();
        nodeAdded(node);

        scene.selectionModel.clear();
        scene.selectionModel.select(node);

        node.onPortAdded.connect(onPortAdded);
        return node;
    }

    //! Create a node with node type and its position
    //! \todo: this method should be removed
    function createCustomizeNode(nodeType : int, xPos : real, yPos : real) : string {
        var node = NLCore.createNode();
        node.type = nodeType;
        node.guiConfig.position.x = xPos;
        node.guiConfig.position.y = yPos;
        node.guiConfig.color = NLStyle.nodeColors[nodeType]//Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
        node.title = NLStyle.objectTypesString[nodeType] + "_" + (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1)
        scene.addNode(node)
        node.addPortByHardCode();

        return node._qsUuid;
    }

    //! Deletes a node from the scene
    function deleteNode(nodeUUId: string) {
        //! delete the node ports from the portsPosition map
        Object.keys(nodes[nodeUUId].ports).forEach(portId => {
            // delete from portsPositions
            delete portsPositions[portId];

            // delete related links
            Object.entries(links).forEach(([key, value]) => {
                if (value.inputPort._qsUuid === portId ||
                        value.outputPort._qsUuid === portId) {
                    linkRemoved(value);
                    delete links[key];
                }
            });
        });

        // Remove the deleted object from selected model
        selectionModel.remove(nodeUUId);

        nodeRemoved(nodes[nodeUUId]);
        delete nodes[nodeUUId];

        portsPositionsChanged();
        linksChanged();
        nodesChanged();
    }

    //! duplicator (third button)
    function cloneNode(nodeUUId: string) {
        var node = NLCore.createNode();
        addNode(node);

        node.guiConfig.position.x = nodes[nodeUUId].guiConfig.position.x + 50
        node.guiConfig.position.y = nodes[nodeUUId].guiConfig.position.y + 50
        node.guiConfig.color = nodes[nodeUUId].guiConfig.color
        node.guiConfig.height = nodes[nodeUUId].guiConfig.height
        node.guiConfig.width = nodes[nodeUUId].guiConfig.width
        node.title = nodes[nodeUUId].title
        node.addPortByHardCode();
        selectionModel.select(node);
    }

    //! On port added
    function onPortAdded(portUUId : string) {

        // Add an empty position index
        portsPositions[portUUId] = Qt.vector2d(0, 0);;
        portsPositionsChanged();
    }

    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function linkNodes(portA : string, portB : string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes ");
            return;
        }

        let link = Object.values(links).find(conObj =>
                                     conObj.inputPort._qsUuid === portA &&
                                     conObj.outputPort._qsUuid === portB);

        if (link === undefined) {
            let obj = NLCore.createLink();
            obj.inputPort  = findPort(portA);
            obj.outputPort = findPort(portB);
            links[obj._qsUuid] = obj;
            linksChanged();

            // Add link into UI
            linkAdded(obj);
        }
    }

    //! Unlink two ports
    function unlinkNodes(portA : string, portB : string) {
        // delete related links
        Object.entries(links).forEach(([key, value]) => {
            const inputPortUuid  = value.inputPort._qsUuid;
            const outputPortUuid = value.outputPort._qsUuid;
            if (inputPortUuid === portA && outputPortUuid === portB) {
                linkRemoved(value);
                selectionModel.remove(key);
                delete links[key];
                }
        });
        linksChanged();
    }

    //! Checks if two ports can be linked or not
    function canLinkNodes(portA : string, portB : string): bool {
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);
        if (HashCompareString.compareStringModels(nodeA, nodeB)
                    || nodeA.length === 0 || nodeB.length === 0) {
            return false;
        }
        return true;
    }

    //! Finds the node according given portId
    function findNodeId(portId: string) : string {
        let foundNode = "";
        Object.values(nodes).find(node => {
            if (node.findPort(portId) !== null) {
                foundNode = node._qsUuid;
            }
        });
        return foundNode;
    }

    //! Finds port object from port id
    function findPort(portId: string) : Port {
        var portObj = null;
        Object.values(nodes).find(node => {
            let foundPort = node.findPort(portId);
            if (foundPort !== null) {
                portObj = foundPort;
            }});
        return portObj;
    }

    //! Delete all selected objects (Node + Link)
    function  deleteSelectedObjects() {
        // Delete objects
        Object.entries(scene.selectionModel.selectedModel).forEach(([key, value]) => {
            if(value.objectType === NLSpec.ObjectType.Node) {
                scene.deleteNode(value._qsUuid);
            }
            if(value.objectType === NLSpec.ObjectType.Link) {
                scene.unlinkNodes(value.inputPort._qsUuid, value.outputPort._qsUuid)
            }
        });
		// Clear the selection
        scene.selectionModel.clear();
    }
}
