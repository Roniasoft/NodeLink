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

    /* Property Declarations
     * ****************************************************************************************/
    //! Scene Title
    property string         title:          "<Untitled>"

    //! Nodes
    //! map <UUID, Node>
    property var            nodes:          ({})

    //! Keep Connection models
    //! map <UUID, Link>
    property var            links:          ({})

    //! map <UUID, Container>
    property var            containers:     ({})

    //! Scene Selection Model
    property SelectionModel selectionModel: null

    //! Scene GUI Config and Properties
    property SceneGuiConfig sceneGuiConfig: SceneGuiConfig {
        _qsRepo: sceneActiveRepo
    }

    //! Each scene requires its own NodeRegistry.
    property NLNodeRegistry nodeRegistry: null

    //! Used defaultRepo as default or use scene repo if set.
    property var            sceneActiveRepo:  scene?._qsRepo ?? NLCore.defaultRepo

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

    //! Container added
    signal containerAdded(Container container)

    //! Container Removed
    signal containerRemoved(Container container)

    //! Copy Nodes 
    signal copyCalled();

    //! Paste Node
    signal pasteCalled();

    //! This signals can be and should be used to request changes in content x/y/width/height, since
    //! direct changes of SceneGuiConfig.content* won't effect Flickable contents.
    //! contentMoveRequested() is mainly used by NodesOverview
    signal contentMoveRequested(diff: vector2d)
    signal contentResizeRequested(diff: vector2d)

    /* Functions
     * ****************************************************************************************/

    //! Check the repository if the model is loading the call the nodes add/remove
    //! related signals to sync the UI
    property Connections _initializeCon : Connections {
        target: sceneActiveRepo
        function onIsLoadingChanged() {
            if (sceneActiveRepo._isLoading) {
                Object.values(nodes).forEach(node => nodeRemoved(node));
                Object.values(links).forEach(link => linkRemoved(link));
                Object.values(containers).forEach(container => containerRemoved(container));
            } else {
                Object.values(nodes).forEach(node => nodeAdded(node));
                Object.values(links).forEach(link => linkAdded(link));
                Object.values(containers).forEach(container => containerAdded(container));
            }
        }
    }

    //! Creates a new container
    function createContainer() {
        let obj = QSSerializer.createQSObject("Container", ["NodeLink"], sceneActiveRepo);
        obj._qsRepo = sceneActiveRepo;
        return obj;
    }

    //! Adds a container to container map
    function addContainer(container: Container) {
        if (containers[container._qsUuid] === container) { return; }

        // Add to local administration
        containers[container._qsUuid] = container;
        containersChanged();
        containerAdded(container);

        scene.selectionModel.clear();
        scene.selectionModel.selectContainer(container);

        return container;
    }

    //! Deletes a container from scene
    function deleteContainer(containerUUId: string) {
        // Remove the deleted object from selected model
        selectionModel.remove(containerUUId);
        containerRemoved(containers[containerUUId]);
        delete containers[containerUUId];
        containersChanged();
    }

    //! Checks if scene is empty or not
    function isSceneEmpty() : bool {
        if (Object.keys(nodes).length === 0 && Object.keys(links).length === 0 && Object.keys(containers).length === 0)
            return true;
        return false;
    }

    //! Adds a node the to nodes map
    function addNode(node: Node) {
        //Sanity check
        if (nodes[node._qsUuid] === node) { return; }

        // Add to local administration
        nodes[node._qsUuid] = node;
        nodesChanged();
        nodeAdded(node);
        node.nodeCompleted()

        scene.selectionModel.clear();
        scene.selectionModel.selectNode(node);

        return node;
    }


    //! Create a node with node type and its position
    //! \todo: this method should be removed
    function createSpecificNode(imports, nodeType : int,
                                nodeTypeName: string, nodeColor: string,
                                title: string,
                                xPos : real, yPos : real) : string {
        //! Create a Node with custom node type
        var node = QSSerializer.createQSObject(nodeTypeName, imports, sceneActiveRepo);
        node._qsRepo = sceneActiveRepo;
        node.type = nodeType;
        node.guiConfig.position.x = xPos;
        node.guiConfig.position.y = yPos;
        node.guiConfig.color = nodeColor;
        node.guiConfig.colorIndex = 0;
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
    //! returns cloned Container
    function cloneContainer(nodeUuid: string) {
        var baseContainer = containers[nodeUuid];

        // Create container
        var container = createContainer();
        container._qsRepo = sceneActiveRepo;

        // Clone container
        container.cloneFrom(baseContainer);

        // Customize cloned container position.
        container.guiConfig.position.x += 50;
        container.guiConfig.position.y += 50;

        // Add container into containers array to update ui
        return addContainer(container);
    }

    //! duplicator (third button)
    //! returns cloned node
    function cloneNode(nodeUuid: string) {
        var baseNode = nodes[nodeUuid];

        // Create node
        var node = QSSerializer.createQSObject(nodeRegistry.nodeTypes[baseNode.type],
                                               nodeRegistry.imports, sceneActiveRepo);
        node._qsRepo = sceneActiveRepo;

        // Clone node
        node.cloneFrom(baseNode);

        // Customize cloned node position.
        node.guiConfig.position.x += 50;
        node.guiConfig.position.y += 50;

        // Add node into nodes array to update ui
        return addNode(node);
    }

    //! Copies the inside properties of the current scene and returns a new scene
    function copyScene () {
        var scene = QSSerializer.createQSObject("Scene",
                    ["NodeLink"], sceneActiveRepo);
        scene.nodeRegistry = nodeRegistry

        var allPorts =  ({});
        var keys1;
        var keys2;

        //! Copying nodes
        Object.values(nodes).forEach(node => {
            var newNode = QSSerializer.createQSObject(scene.nodeRegistry.nodeTypes[node.type],
                                                   scene.nodeRegistry.imports, sceneActiveRepo);
            newNode._qsRepo = sceneActiveRepo;
            newNode.cloneFrom(node);
            scene.addNode(newNode)

            //! Creating a map of ports, used for creating links later
            keys1 = Object.keys(node.ports);
            keys2 = Object.keys(newNode.ports);
            for (var i = 0; i < keys1.length; ++i) {
                var id1 = keys1[i];
                var id2 = keys2[i]
                var port1Value = node.ports[id1];
                var port2Value = newNode.ports[id2];

                allPorts[port1Value] = port2Value;
            }
        })

        //! Copying containers
        Object.values(containers).forEach(container => {
            var newContainer = QSSerializer.createQSObject("Container", scene.nodeRegistry.imports, sceneActiveRepo);
            newContainer._qsRepo = sceneActiveRepo;
            newContainer.cloneFrom(container);
            scene.addContainer(newContainer);
        })

        //! Copying links
        Object.values(links).forEach( link => {
            var matchedInputPort;
            var matchedOutputPort;
            Object.keys(allPorts).forEach(port => {
                if(String(link.inputPort) === String(port))
                    matchedInputPort = allPorts[port];

                if(String(link.outputPort) === String(port))
                    matchedOutputPort = allPorts[port];
            })
            var copiedLink = scene.createLink(matchedInputPort._qsUuid, matchedOutputPort._qsUuid)
            copiedLink._qsRepo = sceneActiveRepo;
            copiedLink.cloneFrom(link);
        })

        return scene;
    }

    //! Link two nodes (via their ports) - portA is the upstream and portB the downstream one
    function createLink(portA : string, portB : string) {

            let obj = NLCore.createLink();
            obj.guiConfig.colorIndex = 0;
            obj.inputPort  = findPort(portA);
            obj.outputPort = findPort(portB);
            obj._qsRepo = sceneActiveRepo;
            links[obj._qsUuid] = obj;
            linksChanged();

            // Add link into UI
            linkAdded(obj);
            return obj;
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
        return Object.values(nodes).find( node => node.findPort(portId) !== null )?._qsUuid ?? "";
    }

    //! Finds Node using its ID
    function findNodeByItsId(nodeId: string) : Node {
        return Object.values(nodes).find(node => node._qsUuid === nodeId);
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
        scene.selectionModel.notifySelectedObject = false;
        // Delete objects
        Object.entries(scene.selectionModel.selectedModel).forEach(([key, value]) => {
            if (value.objectType === NLSpec.ObjectType.Node) {
                if (!value.guiConfig.locked)
                    scene.deleteNode(value._qsUuid);
            }
            if (value.objectType === NLSpec.ObjectType.Container) {
                scene.deleteContainer(value._qsUuid);
            }
            if (value.objectType === NLSpec.ObjectType.Link) {
                scene.unlinkNodes(value.inputPort._qsUuid, value.outputPort._qsUuid)
            }
        });

        scene.selectionModel.notifySelectedObject = true;
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

        var allObjects = [...Object.values(nodes), ...Object.values(containers)];

        var foundObj = allObjects.filter(node => {
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

    function copyNodes() {
        copyCalled();
    }

    function pasteNodes() {
        pasteCalled();
    }
}
