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

    //! Scene Selection Model
    property SelectionModel selectionModel: null

    //! Scene GUI Config and Properties
    property SceneGuiConfig sceneGuiConfig: SceneGuiConfig {
        _qsRepo: scene._qsRepo
    }

    //! Each scene requires its own NodeRegistry.
    property NLNodeRegistry nodeRegistry: null

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

    //! This signals can be used to request changes in content x/y/width/height
    signal contentMoveRequested(diff: vector2d)
    signal contentResizeRequested(diff: vector2d)

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
        scene.selectionModel.selectNode(node);
        node.onPortAdded.connect(onPortAdded);
        return node;
    }


    //! Create a node with node type and its position
    //! \todo: this method should be removed
    function createSpecificNode(imports, nodeType : int,
                                nodeTypeName: string, nodeColor: string,
                                title: string,
                                xPos : real, yPos : real) : string {
        //! Create a Node with custom node type
        var node = QSSerializer.createQSObject(nodeTypeName, imports, NLCore.defaultRepo);
        node._qsRepo = NLCore.defaultRepo;
        node.type = nodeType;
        node.guiConfig.position.x = xPos;
        node.guiConfig.position.y = yPos;
        node.guiConfig.color = nodeColor;
        node.title = title;
        scene.addNode(node)

        return node._qsUuid;
    }

    //! Deletes a node from the scene
    function deleteNode(nodeUUId: string) {
        // Remove the deleted object from selected model
        selectionModel.remove(nodeUUId);

        //! delete the node ports from the portsPosition map
        Object.keys(nodes[nodeUUId].ports).forEach(portId => {

            // delete related links
            Object.entries(links).forEach(([key, value]) => {
                if (value.inputPort._qsUuid === portId ||
                        value.outputPort._qsUuid === portId) {
                    linkRemoved(value);
                    delete links[key];
                }
            });
        });
        nodeRemoved(nodes[nodeUUId]);

        delete nodes[nodeUUId];

        linksChanged();
        nodesChanged();
    }

    //! duplicator (third button)
    function cloneNode(nodeUuid: string) {
        var baseNode = nodes[nodeUuid];

        // Create node
        var node = QSSerializer.createQSObject(nodeRegistry.nodeTypes[baseNode.type],
                                               nodeRegistry.imports, NLCore.defaultRepo);
        node._qsRepo = NLCore.defaultRepo;

        // Clone node
        node.cloneFrom(baseNode);

        // Customize cloned node position.
        node.guiConfig.position.x += 50;
        node.guiConfig.position.y += 50;

        // Add node into nodes array to updata ui
        addNode(node);
    }

    //! On port added
    function onPortAdded(portUUId : string) {
    }

    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function createLink(portA : string, portB : string) {

            let obj = NLCore.createLink();
            obj.inputPort  = findPort(portA);
            obj.outputPort = findPort(portB);
            links[obj._qsUuid] = obj;
            linksChanged();

            // Add link into UI
            linkAdded(obj);
    }

    //! Unlink two ports
    function unlinkNodes(portA : string, portB : string) {
        // delete related links
        Object.entries(links).forEach(([key, value]) => {
            const inputPortUuid  = value.inputPort._qsUuid;
            const outputPortUuid = value.outputPort._qsUuid;
            if (inputPortUuid === portA && outputPortUuid === portB) {
                // Find the nodes to which portA and portB belong
                let nodeX = findNode(portA);
                let nodeY = findNode(portB);

                if (Object.keys(nodeX.children).includes(nodeY._qsUuid)) {
                    delete nodeX.children[nodeY._qsUuid];
                    nodeX.childrenChanged()
                }

                if (Object.keys(nodeX.parents).includes(nodeX._qsUuid)) {
                    delete nodeY.parents[nodeX._qsUuid];
                    nodeY.parentsChanged()
                }

                linkRemoved(value);
                selectionModel.remove(key);
                delete links[key];
            }
        });
        linksChanged();
    }

    //! Finds the node according given portId
    function findNodeId(portId: string) : string {
        let foundNodeId = "";
        Object.values(nodes).find(node => {
            if (node.findPort(portId) !== null) {
                foundNodeId = node._qsUuid;
            }
        });
        return foundNodeId;
    }

    //! Finds the exact node according to the given portId
    function findNode(portId: string) : Node {
        let foundNodeId = findNodeId(portId);
        if  (Object.keys(nodes).includes(foundNodeId))
            return nodes[foundNodeId];
        return null;
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
                if (!value.guiConfig.locked)
                    scene.deleteNode(value._qsUuid);
            }
            if(value.objectType === NLSpec.ObjectType.Link) {
                scene.unlinkNodes(value.inputPort._qsUuid, value.outputPort._qsUuid)
            }
        });
		// Clear the selection
        scene.selectionModel.clear();
    }

    //! Find the nodes that are in the container item.
    function findNodesInContainerItem(containerItem: rect) {

        // Key points of container to generate line equations and it's limits.
        var rBLeftX = containerItem.x;
        var rBTopY = containerItem.y;
        var rBRightX = rBLeftX + containerItem.width;
        var rBBottomY = rBTopY + containerItem.height;

        var foundObj = Object.values(nodes).filter(node => {
            // Key points of Node to generate line equations and it's limits.
            var position = node.guiConfig.position

            var nodeLeftX = position.x;
            var nodeTopY = position.y;
            var nodeRightX = nodeLeftX + node.guiConfig.width;
            var nodeBottomY = nodeTopY + node.guiConfig.height;
            // Checking the equations of the containerItem lines and nodes
            // and their intersection using the obtained limits
            var isSelected = (rBRightX > nodeLeftX && rBRightX < nodeRightX &&
                rBBottomY < nodeBottomY && rBBottomY > nodeTopY) ||
            (rBLeftX < nodeLeftX && rBRightX > nodeRightX &&
                rBBottomY > nodeTopY && rBBottomY < nodeBottomY) ||
            (rBLeftX >= nodeLeftX && rBRightX <= nodeRightX &&
                rBTopY <= nodeTopY && rBBottomY >= nodeBottomY) ||
            (rBLeftX > nodeLeftX && rBLeftX < nodeRightX &&
                (rBBottomY < nodeTopY && nodeBottomY < rBBottomY) ||
            (rBBottomY < nodeTopY && nodeBottomY > rBBottomY &&
                nodeTopY < rBBottomY)) ||
            (rBLeftX < nodeLeftX && rBRightX >= nodeRightX &&
                rBTopY < nodeTopY && nodeBottomY < rBBottomY) ||
            (rBLeftX > nodeLeftX && rBLeftX < nodeRightX &&
                rBTopY > nodeTopY && rBTopY < nodeBottomY) ||
            (nodeLeftX > rBLeftX && rBRightX > nodeLeftX &&
                rBTopY > nodeTopY && rBTopY < nodeBottomY) ||
            (rBLeftX < nodeRightX && rBLeftX >  nodeLeftX &&
                rBBottomY >  nodeTopY && rBBottomY <  nodeBottomY) ||
            (nodeRightX <= rBRightX && nodeRightX >= rBLeftX &&
                nodeTopY >= rBTopY && nodeBottomY <= rBBottomY) ||
            (nodeLeftX <= rBRightX && nodeLeftX >= rBLeftX &&
                nodeTopY >= rBTopY && nodeBottomY <= rBBottomY);

            // Return the found node that is inside the container.
            if(isSelected)
                return node;
        });

        return foundObj;
    }

}
