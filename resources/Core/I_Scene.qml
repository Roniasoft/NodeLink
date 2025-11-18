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

    //! Each scene requires its own NodeRegistry.
    property NLNodeRegistry nodeRegistry: null

    //! Used defaultRepo as default or use scene repo if set.
    property var            sceneActiveRepo:  scene?._qsRepo ?? NLCore.defaultRepo
    
    //! Helper property to ensure proper type for Connections target
    //! This is needed because Connections.target requires QObject* and var type can't be inferred
    //! Using null initialization and setting in Component.onCompleted to avoid type errors
    property QtObject _sceneActiveRepoObject: null

    //! Scene GUI Config and Properties
    //! Defined after sceneActiveRepo to ensure proper type inference
    property SceneGuiConfig sceneGuiConfig: SceneGuiConfig {
        id: _sceneGuiConfig
        // _qsRepo will be set in Component.onCompleted to ensure proper type
    }

    /* Signals
     * ****************************************************************************************/

    //! Node added
    signal nodeAdded(Node node)

    //! Nodes added
    signal nodesAdded(var nodes)

    //! Node Removed
    signal nodeRemoved(Node node)

    //! Link added
    signal linkAdded(Link link)

    //! Links added
    signal linksAdded(var links)

    //! Link Removed
    signal linkRemoved(Link link)

    //! Nodes Removed
    signal nodesRemoved(var nodes)

    //! Container added
    signal containerAdded(Container container)

    //! Containers Removed
    signal containersRemoved(var containers)

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

    /* Component Lifecycle
     * ****************************************************************************************/
    Component.onCompleted: {
        // Initialize sceneActiveRepo - use scene's repo if available, otherwise keep defaultRepo
        // This ensures the repo is stored and won't be lost during undo/redo operations
        if (scene?._qsRepo) {
            sceneActiveRepo = scene._qsRepo;
        }
        // If scene._qsRepo is not available, sceneActiveRepo remains as NLCore.defaultRepo (set above)
        
        // Set _sceneActiveRepoObject for Connections target with proper type
        _sceneActiveRepoObject = sceneActiveRepo;
        
        // Set _qsRepo for sceneGuiConfig after initialization to ensure proper type
        if (_sceneGuiConfig) {
            _sceneGuiConfig._qsRepo = sceneActiveRepo;
        }
    }

    // Keep sceneActiveRepo in sync with scene._qsRepo when it becomes available
    // Using Connections to listen to repoChanged signal (NOTIFY signal for _qsRepo property)
    // Strategy: Update when scene._qsRepo becomes valid, but preserve sceneActiveRepo if scene._qsRepo becomes null
    // This prevents losing the repo value during undo/redo operations
    property Connections _repoSyncCon : Connections {
        target: scene
        function onRepoChanged() {
            if (scene?._qsRepo) {
                // If scene._qsRepo becomes valid, update sceneActiveRepo
                // This handles the case where scene._qsRepo is set after component completion
                sceneActiveRepo = scene._qsRepo;
                // Update _sceneActiveRepoObject for Connections target
                _sceneActiveRepoObject = sceneActiveRepo;
                // Also update sceneGuiConfig._qsRepo to keep it in sync
                if (_sceneGuiConfig) {
                    _sceneGuiConfig._qsRepo = sceneActiveRepo;
                }
            }
            // If scene._qsRepo becomes null, we don't update sceneActiveRepo to preserve it
            // This prevents losing the repo value during undo/redo operations
        }
    }

    // After undo/redo operations, sync sceneActiveRepo with scene._qsRepo
    // This is critical because loadRepo may reset qsRootObject and scene._qsRepo
    property Connections _undoRedoSyncCon : Connections {
        target: scene?._undoCore?.undoStack ?? null
        function onUndoRedoDone() {
            // After undo/redo, ensure sceneActiveRepo is synchronized with scene._qsRepo
            // This ensures sceneActiveRepo is always valid after loadRepo completes
            if (scene?._qsRepo) {
                sceneActiveRepo = scene._qsRepo;
                // Update _sceneActiveRepoObject for Connections target
                _sceneActiveRepoObject = sceneActiveRepo;
                // Also update sceneGuiConfig._qsRepo to keep it in sync
                if (_sceneGuiConfig) {
                    _sceneGuiConfig._qsRepo = sceneActiveRepo;
                }
            } else if (!sceneActiveRepo) {
                // Fallback: if both are null, use defaultRepo (shouldn't happen, but safety)
                sceneActiveRepo = NLCore.defaultRepo;
                _sceneActiveRepoObject = sceneActiveRepo;
                if (_sceneGuiConfig) {
                    _sceneGuiConfig._qsRepo = sceneActiveRepo;
                }
            }
            // If scene._qsRepo is null but sceneActiveRepo is valid, preserve sceneActiveRepo
        }
    }

    /* Functions
     * ****************************************************************************************/

    //! Check the repository if the model is loading the call the nodes add/remove
    //! related signals to sync the UI
    property Connections _initializeCon : Connections {
        target: _sceneActiveRepoObject
        function onIsLoadingChanged() {
            if (_sceneActiveRepoObject._isLoading) {
                Object.values(nodes).forEach(node => nodeRemoved(node));
                Object.values(links).forEach(link => linkRemoved(link));
                Object.values(containers).forEach(container => containerRemoved(container));
            } else {
                // After loading completes (e.g., after undo/redo), sync sceneActiveRepo with scene._qsRepo
                // This ensures sceneActiveRepo is always valid after loadRepo completes
                if (scene?._qsRepo) {
                    sceneActiveRepo = scene._qsRepo;
                    // Update _sceneActiveRepoObject for Connections target
                    _sceneActiveRepoObject = sceneActiveRepo;
                    // Also update sceneGuiConfig._qsRepo to keep it in sync
                    if (_sceneGuiConfig) {
                        _sceneGuiConfig._qsRepo = sceneActiveRepo;
                    }
                }
                
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

        // Push command (skip during replay)
        if (!scene._undoCore.undoStack.isReplaying) {
            var cmdAddContainer = Qt.createQmlObject('import QtQuick; import NodeLink; import "Undo/Commands"; AddContainerCommand { }', scene._undoCore.undoStack)
            cmdAddContainer.scene = scene
            cmdAddContainer.container = container
            scene._undoCore.undoStack.push(cmdAddContainer)
        }

        return container;
    }

    //! Deletes a container from scene
    function deleteContainer(containerUUId: string) {
        // Remove the deleted object from selected model
        selectionModel.remove(containerUUId);
        var containerRef = containers[containerUUId];
        containerRemoved(containerRef);
        delete containers[containerUUId];
        containersChanged();

        if (!scene._undoCore.undoStack.isReplaying && containerRef) {
            var cmdRemoveContainer = Qt.createQmlObject('import QtQuick; import NodeLink; import "Undo/Commands"; RemoveContainerCommand { }', scene._undoCore.undoStack)
            cmdRemoveContainer.scene = scene
            cmdRemoveContainer.container = containerRef
            scene._undoCore.undoStack.push(cmdRemoveContainer)
        }
    }
    //! Deletes containers from scene
    function deleteContainers(containerUUIds: string) {
        if (!containerUUIds || containerUUIds.length === 0) {
            return;
        }

        var removedContainers = [];

        for (var i = 0; i < containerUUIds.length; i++) {
            var containerUUId = containerUUIds[i];

            if (!containers[containerUUId]) {
                continue;
            }

            selectionModel.remove(containerUUId);

            removedContainers.push(containers[containerUUId]);
            delete containers[containerUUId];
        }
        if (removedContainers.length > 0) {
            containersRemoved(removedContainers);
            removedContainers.forEach(container => container.destroy());
            containersChanged();
        }

        //TODO: Add undo replaying scenario here
    }

    //! Checks if scene is empty or not
    function isSceneEmpty() : bool {
        if (Object.keys(nodes).length === 0 && Object.keys(links).length === 0 && Object.keys(containers).length === 0)
            return true;
        return false;
    }

    //! Adds a node the to nodes map
    function addNode(node: Node, autoSelect: bool) {
        //Sanity check
        if (nodes[node._qsUuid] === node) { return; }

        // Add to local administration
        nodes[node._qsUuid] = node;
        nodesChanged();
        nodeAdded(node);
        node.nodeCompleted()

        if (autoSelect) {
            scene.selectionModel.clear();
            scene.selectionModel.selectNode(node);
        }

        if (!scene._undoCore.undoStack.isReplaying) {
            var cmdAddNode = Qt.createQmlObject('import QtQuick; import NodeLink; import "Undo/Commands"; AddNodeCommand { }', scene._undoCore.undoStack)
            cmdAddNode.scene = scene
            cmdAddNode.node = node
            scene._undoCore.undoStack.push(cmdAddNode)
        }

        return node;
    }

    //! Adds multiple nodes at once
    function addNodes(nodeArray: list<Node>, autoSelect: bool) {
        if (!nodeArray || nodeArray.length === 0) {
            return;
        }

        var addedNodes = []

        for (var i = 0; i < nodeArray.length; i++) {
            var node = nodeArray[i]

            if (nodes[node._qsUuid] === node) {
                continue;
            }

            // Add to local administration
            nodes[node._qsUuid] = node;
            addedNodes.push(node);
            node.nodeCompleted()
        }

        if (addedNodes.length > 0) {
            nodesChanged();
            nodesAdded(addedNodes);

            if (autoSelect && addedNodes.length > 0) {
                scene.selectionModel.clear();
                scene.selectionModel.selectNode(addedNodes[addedNodes.length - 1]);
            }
        }

        return;
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

    //! Deletes multiple nodes from the scene
    function deleteNodes(nodeUUIds: list<string>) {
        if (!nodeUUIds || nodeUUIds.length === 0) {
            return;
        }

        var removedNodes = [];
        var affectedLinks = new Set();

        for (var i = 0; i < nodeUUIds.length; i++) {
            var nodeUUId = nodeUUIds[i];

            if (!nodes[nodeUUId]) {
                continue;
            }

            selectionModel.remove(nodeUUId);

            Object.keys(nodes[nodeUUId].ports).forEach(portId => {
               Object.entries(links).forEach(([key, value]) => {
                                                     if ((value.inputPort && value.inputPort._qsUuid === portId) ||
                                                         (value.outputPort && value.outputPort._qsUuid === portId)) {
                                                         affectedLinks.add(key);
                                                     }
                                             });
           });

            removedNodes.push(nodes[nodeUUId]);
            delete nodes[nodeUUId];
        }

        affectedLinks.forEach(linkKey => {
                                  linkRemoved(links[linkKey]);
                                  links[linkKey].destroy();
                                  delete links[linkKey];
                              });

        if (removedNodes.length > 0) {
            nodesRemoved(removedNodes);
            // Destroy removed nodes
            removedNodes.forEach(node => node.destroy());
            linksChanged();
            nodesChanged();
        }

        //TODO: Add undo replaying code here
    }

    //! Deletes a node from the scene
    function deleteNode(nodeUUId: string) {
        // Remove the deleted object from selected model
        selectionModel.remove(nodeUUId);

        var nodeRef = nodes[nodeUUId];
        if (!nodeRef) {
            return;
        }

        // Capture connected links (pairs of input/output port UUIDs) before deletion
        var connectedPairs = []
        Object.keys(nodeRef.ports).forEach(portId => {
            Object.entries(links).forEach(([key, value]) => {
                const inputPortUuid  = value.inputPort._qsUuid;
                const outputPortUuid = value.outputPort._qsUuid;
                if (inputPortUuid === portId || outputPortUuid === portId) {
                    connectedPairs.push({ inputPortUuid: inputPortUuid, outputPortUuid: outputPortUuid })
                }
            });
        });

        //! delete the node ports from the portsPosition map
        Object.keys(nodeRef.ports).forEach(portId => {

            // delete related links
            Object.entries(links).forEach(([key, value]) => {
                if (value.inputPort._qsUuid === portId ||
                        value.outputPort._qsUuid === portId) {
                    linkRemoved(value);
                    delete links[key];
                }
            });
        });
        nodeRemoved(nodeRef);

        delete nodes[nodeUUId];

        linksChanged();
        nodesChanged();

        if (!scene._undoCore.undoStack.isReplaying && nodeRef) {
            var cmdRemoveNode = Qt.createQmlObject('import QtQuick; import NodeLink; import "Undo/Commands"; RemoveNodeCommand { }', scene._undoCore.undoStack)
            cmdRemoveNode.scene = scene
            cmdRemoveNode.node = nodeRef
            cmdRemoveNode.links = connectedPairs
            scene._undoCore.undoStack.push(cmdRemoveNode)
        }
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

    //! Adds multiple links at once
    function createLinks(linkDataArray) {
        if (!linkDataArray || linkDataArray.length === 0) {
            return;
        }

        var addedLinks = [];

        for (var i = 0; i < linkDataArray.length; i++) {
            var linkData = linkDataArray[i];

            // Create the link object
            let obj = NLCore.createLink();
            obj.guiConfig.colorIndex = linkData.colorIndex !== undefined ? linkData.colorIndex : 0;
            obj.inputPort = findPort(linkData.portA);
            obj.outputPort = findPort(linkData.portB);
            obj._qsRepo = sceneActiveRepo;

            // Check if link already exists
            if (links[obj._qsUuid] === obj) {
                continue;
            }

            // Add to local administration
            links[obj._qsUuid] = obj;
            addedLinks.push(obj);
        }

        if (addedLinks.length > 0) {
            linksChanged();
            linksAdded(addedLinks);
        }

        return addedLinks;
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
            if (!scene._undoCore.undoStack.isReplaying) {
                var cmdCreateLink = Qt.createQmlObject('import QtQuick; import NodeLink; import "Undo/Commands"; CreateLinkCommand { }', scene._undoCore.undoStack)
                cmdCreateLink.scene = scene
                cmdCreateLink.inputPortUuid = portA
                cmdCreateLink.outputPortUuid = portB
                scene._undoCore.undoStack.push(cmdCreateLink)
            }
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

        if (!scene._undoCore.undoStack.isReplaying) {
            var cmdUnlink = Qt.createQmlObject('import QtQuick; import NodeLink; import "Undo/Commands"; UnlinkCommand { }', scene._undoCore.undoStack)
            cmdUnlink.scene = scene
            cmdUnlink.inputPortUuid = portA
            cmdUnlink.outputPortUuid = portB
            scene._undoCore.undoStack.push(cmdUnlink)
        }
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
        var nodesToBeDeleted = []
        var containersToBeDeleted = []
        for (var i = 0; i < Object.keys(scene.selectionModel.selectedModel).length; ++i) {
            var key = Object.keys(scene.selectionModel.selectedModel)[i]
            var item = Object.values(scene.selectionModel.selectedModel)[i]
            if (!item)
                continue
            if (item.objectType === NLSpec.ObjectType.Node ||
                    item.objectType === NLSpec.ObjectType.Link) //CHECKME: Can we select a link without a connected node? (the node will delete the link too)
                nodesToBeDeleted.push(key)
            else if (item.objectType === NLSpec.ObjectType.Container)
                containersToBeDeleted.push(key)
        }
        if (nodesToBeDeleted.length)
            deleteNodes(nodesToBeDeleted)
        if (containersToBeDeleted.length)
            deleteContainers(containersToBeDeleted)

        scene.selectionModel.notifySelectedObject = true;
		// Clear the selection
        scene.selectionModel.clear();
    }

    //! Find the nodes that are in the container item.
    function findNodesInContainerItem(containerItem) {
        var bandLeft   = containerItem.x;
        var bandTop    = containerItem.y;
        var bandRight  = bandLeft + containerItem.width;
        var bandBottom = bandTop + containerItem.height;

        var matches = [];

        function scan(map) {
            if (!map) return;
            for (var key in map) {
                if (!map.hasOwnProperty(key)) continue;
                var item = map[key];
                if (!item || !item.guiConfig) continue;

                var cfg = item.guiConfig;
                var pos = cfg.position;
                var nodeLeft   = pos.x;
                var nodeTop    = pos.y;
                var nodeRight  = nodeLeft + cfg.width;
                var nodeBottom = nodeTop  + cfg.height;

                // Axis-aligned rectangle overlap test
                if (nodeRight <= bandLeft ||
                    nodeLeft  >= bandRight ||
                    nodeBottom <= bandTop ||
                    nodeTop    >= bandBottom) {
                    continue;
                }

                matches.push(item);
            }
        }

        scan(nodes);
        scan(containers);

        return matches;
    }


    function copyNodes() {
        copyCalled();
    }

    function pasteNodes() {
        pasteCalled();
    }

    //! Snapped Position for when snap is enabled
    function snappedPosition (position) {
        return Qt.vector2d(Math.round(position.x / NLStyle.backgroundGrid.spacing) * NLStyle.backgroundGrid.spacing,
                           Math.round(position.y / NLStyle.backgroundGrid.spacing) * NLStyle.backgroundGrid.spacing);
    }

    //! Snap all nodes and containers to grid
   function snapAllNodesToGrid() {
       // Snap all nodes
       Object.values(nodes).forEach(node => {
           if (node && node.guiConfig) {
               node.guiConfig.position = snappedPosition(node.guiConfig.position);
               node.guiConfig.positionChanged();
           }
       });

       // Snap all containers
       Object.values(containers).forEach(container => {
           if (container && container.guiConfig) {
               container.guiConfig.position = snappedPosition(container.guiConfig.position);
               container.guiConfig.positionChanged();
           }
       });
   }

    //! Build connection graph based on links
    function buildConnectionGraph(nodes) {
        var connections = [];
        
        // Check all links to build the graph
        // Note: In Link, inputPort is actually the output port (source) and outputPort is the input port (target)
        Object.values(scene.links).forEach(function(link) {
            if (!link || !link.inputPort || !link.outputPort) {
                return;
            }
            
            var sourceNodeId = scene.findNodeId(link.inputPort._qsUuid);
            var targetNodeId = scene.findNodeId(link.outputPort._qsUuid);
            
            // Only consider selected nodes
            if (!nodes[sourceNodeId] || !nodes[targetNodeId]) {
                return;
            }
            
            connections.push({
                sourceNode: nodes[sourceNodeId],
                targetNode: nodes[targetNodeId],
                outputPort: link.inputPort,  // Output port (source)
                inputPort: link.outputPort   // Input port (target)
            });
        });
        
        return connections;
    }

    //! Calculate port position based on node position
    function getPortPosition(node, port) {
        var nodePos = node.guiConfig.position;
        var nodeWidth = node.guiConfig.width;
        var nodeHeight = node.guiConfig.height;
        var portSide = port.portSide;
        
        switch(portSide) {
            case NLSpec.PortPositionSide.Top:
                return Qt.vector2d(nodePos.x + nodeWidth / 2, nodePos.y);
            case NLSpec.PortPositionSide.Bottom:
                return Qt.vector2d(nodePos.x + nodeWidth / 2, nodePos.y + nodeHeight);
            case NLSpec.PortPositionSide.Left:
                return Qt.vector2d(nodePos.x, nodePos.y + nodeHeight / 2);
            case NLSpec.PortPositionSide.Right:
                return Qt.vector2d(nodePos.x + nodeWidth, nodePos.y + nodeHeight / 2);
            default:
                return Qt.vector2d(nodePos.x + nodeWidth / 2, nodePos.y + nodeHeight / 2);
        }
    }

    //! Determine if connection is left-to-right
    function isLeftToRightConnection(sourceNode, targetNode) {
        // If target node is to the right of source node, connection is left-to-right
        var sourceCenterX = sourceNode.guiConfig.position.x + sourceNode.guiConfig.width / 2;
        var targetCenterX = targetNode.guiConfig.position.x + targetNode.guiConfig.width / 2;
        return targetCenterX > sourceCenterX;
    }

    //! Find root node
    function findRootNode(nodes, rootId) {
        var rootNode = nodes[rootId];
        if (!rootNode) {
            rootNode = Object.values(nodes).reduce(function(minNode, currentNode) {
                return currentNode.guiConfig.position.x < minNode.guiConfig.position.x ? 
                       currentNode : minNode;
            });
        }
        return rootNode;
    }

    //! Build connected groups from nodes
    function buildConnectedGroups(nodes, connections, nodeIds) {
        var visited = {};
        var groups = [];
        
        function buildGroup(nodeId, group) {
            if (visited[nodeId] || !nodes[nodeId]) {
                return;
            }
            
            visited[nodeId] = true;
            group.push(nodeId);
            
            // Add connected nodes
            connections.forEach(function(conn) {
                if (conn.sourceNode._qsUuid === nodeId && !visited[conn.targetNode._qsUuid]) {
                    buildGroup(conn.targetNode._qsUuid, group);
                }
                if (conn.targetNode._qsUuid === nodeId && !visited[conn.sourceNode._qsUuid]) {
                    buildGroup(conn.sourceNode._qsUuid, group);
                }
            });
        }

        // Build groups
        nodeIds.forEach(function(nodeId) {
            if (!visited[nodeId]) {
                var group = [];
                buildGroup(nodeId, group);
                if (group.length > 0) {
                    groups.push(group);
                }
            }
        });
        
        return groups;
    }

    //! Calculate target position based on connection rules
    function calculatePositionByRules(currentNode, targetNode, outputPortSide, inputPortSide, leftToRight, NODE_SPACING) {
        var currentPos = currentNode.guiConfig.position;
        var currentWidth = currentNode.guiConfig.width;
        var currentHeight = currentNode.guiConfig.height;
        var targetWidth = targetNode.guiConfig.width;
        var targetHeight = targetNode.guiConfig.height;
        var targetPos = Qt.vector2d(0, 0);
        
        if (leftToRight) {
            // Left-to-right connection rules
            if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y);
            } else {
                // Default
                targetPos = Qt.vector2d(currentPos.x + currentWidth + NODE_SPACING, currentPos.y);
            }
        } else {
            // Right-to-left connection rules
            if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x + targetWidth + NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Top) {
                targetPos = Qt.vector2d(currentPos.x - currentWidth - NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x + targetWidth + NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x + targetWidth + NODE_SPACING, currentPos.y);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x + targetWidth + NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Left) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x + targetWidth + NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Bottom) {
                targetPos = Qt.vector2d(currentPos.x - currentWidth - NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Top && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x - currentWidth - NODE_SPACING, currentPos.y - targetHeight - NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Right && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Bottom && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x - currentWidth - NODE_SPACING, currentPos.y + currentHeight + NODE_SPACING);
            } else if (outputPortSide === NLSpec.PortPositionSide.Left && inputPortSide === NLSpec.PortPositionSide.Right) {
                targetPos = Qt.vector2d(currentPos.x - currentWidth - NODE_SPACING, currentPos.y);
            } else {
                // Default
                targetPos = Qt.vector2d(currentPos.x - targetWidth - NODE_SPACING, currentPos.y);
            }
        }
        
        return targetPos;
    }

    //! Check and resolve overlaps with other nodes
    function resolveOverlaps(pos, nodeWidth, nodeHeight, nodeId, leftToRight, MIN_SPACING) {
        var resolvedPos = Qt.vector2d(pos.x, pos.y);
        var maxIterations = 100;
        var iteration = 0;
        
        while (iteration < maxIterations) {
            var hasOverlap = false;
            var maxRightX = resolvedPos.x;
            var maxDownY = resolvedPos.y;
            var minLeftX = resolvedPos.x;
            var maxUpY = resolvedPos.y;
            
            // Check overlap with all nodes in the scene
            Object.keys(scene.nodes).forEach(function(otherNodeId) {
                // Skip if this is the target node itself
                if (otherNodeId === nodeId) return;
                
                var otherNode = scene.nodes[otherNodeId];
                if (!otherNode) return;
                
                var otherNodePos = otherNode.guiConfig.position;
                var otherNodeWidth = otherNode.guiConfig.width;
                var otherNodeHeight = otherNode.guiConfig.height;
                
                // Precise overlap check (using <= and >= to ensure no overlap)
                var noOverlapX = (resolvedPos.x + nodeWidth <= otherNodePos.x || 
                                 resolvedPos.x >= otherNodePos.x + otherNodeWidth);
                var noOverlapY = (resolvedPos.y + nodeHeight <= otherNodePos.y || 
                                 resolvedPos.y >= otherNodePos.y + otherNodeHeight);
                
                if (!noOverlapX && !noOverlapY) {
                    hasOverlap = true;
                    
                    // Calculate required positions for movement
                    var rightX = otherNodePos.x + otherNodeWidth + MIN_SPACING;
                    var leftX = otherNodePos.x - nodeWidth - MIN_SPACING;
                    var downY = otherNodePos.y + otherNodeHeight + MIN_SPACING;
                    var upY = otherNodePos.y - nodeHeight - MIN_SPACING;
                    
                    // Find maximum/minimum required position for movement
                    if (leftToRight) {
                        // Prefer movement to the right
                        if (rightX > maxRightX) {
                            maxRightX = rightX;
                        }
                    } else {
                        // Prefer movement to the left
                        if (leftX < minLeftX) {
                            minLeftX = leftX;
                        }
                    }
                    
                    // Always move down if necessary
                    if (downY > maxDownY) {
                        maxDownY = downY;
                    }
                    
                    // If movement up is better
                    if (upY < maxUpY) {
                        maxUpY = upY;
                    }
                }
            });
            
            if (!hasOverlap) {
                break;
            }
            
            // Apply movement - use maximum/minimum values to resolve all overlaps
            var newX = resolvedPos.x;
            var newY = resolvedPos.y;
            
            if (leftToRight) {
                newX = maxRightX;
            } else {
                newX = minLeftX;
            }
            
            // Choose between down and up (prefer down)
            if (maxDownY > resolvedPos.y) {
                newY = maxDownY;
            } else if (maxUpY < resolvedPos.y) {
                newY = maxUpY;
            }
            
            // Apply changes
            resolvedPos = Qt.vector2d(newX, newY);
            
            iteration++;
        }
        
        return resolvedPos;
    }

    //! Calculate position for node with multiple inputs
    function calculatePositionForMultiInputNode(targetNode, targetId, targetPos, connections, positioned, NODE_SPACING) {
        var inputConnections = [];
        connections.forEach(function(inputConn) {
            if (inputConn.targetNode._qsUuid === targetId && positioned[inputConn.sourceNode._qsUuid]) {
                inputConnections.push(inputConn);
            }
        });
        
        // If it has multiple inputs, calculate position based on average of all connections
        if (inputConnections.length > 1) {
            var positions = [targetPos];
            
            inputConnections.forEach(function(inputConn) {
                var sourceNode = inputConn.sourceNode;
                var sourcePos = sourceNode.guiConfig.position;
                var sourceWidth = sourceNode.guiConfig.width;
                var targetWidth = targetNode.guiConfig.width;
                
                var inputLeftToRight = isLeftToRightConnection(sourceNode, targetNode);
                var calculatedPos = Qt.vector2d(0, 0);
                
                // Calculate position based on this input connection (using the same rules)
                // Here we only do a simple calculation
                if (inputLeftToRight) {
                    calculatedPos = Qt.vector2d(sourcePos.x + sourceWidth + NODE_SPACING, sourcePos.y);
                } else {
                    calculatedPos = Qt.vector2d(sourcePos.x - targetWidth - NODE_SPACING, sourcePos.y);
                }
                
                positions.push(calculatedPos);
            });
            
            // Calculate average of positions
            var avgX = 0;
            var avgY = 0;
            positions.forEach(function(pos) {
                avgX += pos.x;
                avgY += pos.y;
            });
            avgX = avgX / positions.length;
            avgY = avgY / positions.length;
            
            // Use position calculated from current connection with higher weight
            targetPos = Qt.vector2d(targetPos.x * 0.6 + avgX * 0.4, targetPos.y * 0.6 + avgY * 0.4);
        }
        
        return targetPos;
    }

    //! Automatic node reordering based on connections
    function automaticNodeReorder(nodes, rootId, keepRootPosition) {
        if (!nodes || Object.keys(nodes).length === 0) {
            return;
        }

        var NODE_SPACING = 60;  // Spacing between nodes
        var MIN_SPACING = 40;   // Minimum spacing

        // Build connection graph
        var connections = buildConnectionGraph(nodes);
        var nodeIds = Object.keys(nodes);

        // Find root node
        var rootNode = findRootNode(nodes, rootId);
        var rootPosition = rootNode.guiConfig.position;

        // Build connected groups
        var groups = buildConnectedGroups(nodes, connections, nodeIds);

        // Position each group
        var currentX = rootPosition.x;
        var currentY = rootPosition.y;
        
        groups.forEach(function(group) {
            if (group.length === 0) return;
            
            // Find root node in this group
            var groupRootId = group[0];
            var hasRoot = group.indexOf(rootId) >= 0;
            if (hasRoot) {
                groupRootId = rootId;
            }
            
            var groupRoot = nodes[groupRootId];
            if (!groupRoot) return;
            
            // Position group root node
            if (hasRoot && keepRootPosition) {
                currentX = rootPosition.x;
                currentY = rootPosition.y;
            } else {
                groupRoot.guiConfig.position = Qt.vector2d(currentX, currentY);
            }
            
            // Position nodes in this group
            positionGroupNodes(group, groupRootId, rootId, hasRoot && keepRootPosition, rootPosition, nodes, connections, NODE_SPACING, MIN_SPACING);
            
            // Update position for next group
            var nextPos = updatePositionForNextGroup(group, nodes, currentX, currentY, NODE_SPACING);
            currentX = nextPos.x;
        });
    }

    //! Process outgoing connections and position target nodes
    //! Returns array of newly positioned node IDs
    function processOutgoingConnections(currentNode, currentNodeId, connections, positioned, inQueue, nodes, NODE_SPACING, MIN_SPACING) {
        var outgoingConnections = [];
        connections.forEach(function(conn) {
            if (conn.sourceNode._qsUuid === currentNodeId) {
                outgoingConnections.push(conn);
            }
        });
        
        var newlyPositioned = [];
        
        outgoingConnections.forEach(function(conn) {
            var targetNode = conn.targetNode;
            var targetId = targetNode._qsUuid;
            
            // Prevent cycles: if node is already positioned or in queue, skip it
            if (positioned[targetId] || inQueue[targetId]) {
                return;
            }
            
            var outputPort = conn.outputPort;
            var inputPort = conn.inputPort;
            var outputPortSide = outputPort.portSide;
            var inputPortSide = inputPort.portSide;
            
            // Determine if connection is left-to-right
            var leftToRight = isLeftToRightConnection(currentNode, targetNode);
            
            // If target node is not yet positioned, assume left-to-right connection
            if (!positioned[targetId] && targetNode.guiConfig.position.x === 0 && targetNode.guiConfig.position.y === 0) {
                leftToRight = true;
            }
            
            var targetWidth = targetNode.guiConfig.width;
            var targetHeight = targetNode.guiConfig.height;
            
            // Calculate position based on rules
            var targetPos = calculatePositionByRules(
                currentNode, targetNode, outputPortSide, inputPortSide, leftToRight, NODE_SPACING
            );
            
            // Check and resolve overlaps
            targetPos = resolveOverlaps(targetPos, targetWidth, targetHeight, targetId, leftToRight, MIN_SPACING);
            
            // If this node has multiple inputs, calculate position based on all connections
            targetPos = calculatePositionForMultiInputNode(
                targetNode, targetId, targetPos, connections, positioned, NODE_SPACING
            );
            
            // After calculating position for nodes with multiple inputs, check overlaps again
            targetPos = resolveOverlaps(targetPos, targetWidth, targetHeight, targetId, leftToRight, MIN_SPACING);
            
            targetNode.guiConfig.position = targetPos;
            positioned[targetId] = true;
            newlyPositioned.push(targetId);
        });
        
        return newlyPositioned;
    }

    //! Position nodes in a group using BFS
    function positionGroupNodes(group, groupRootId, rootId, keepRootPosition, rootPosition, nodes, connections, NODE_SPACING, MIN_SPACING) {
        var groupRoot = nodes[groupRootId];
        if (!groupRoot) return;
        
        // Position group root node
        if (group.indexOf(rootId) >= 0 && keepRootPosition) {
            groupRoot.guiConfig.position = rootPosition;
        }
        
        // Position remaining nodes based on connections
        var positioned = {};
        positioned[groupRootId] = true;
        var queue = [groupRootId];
        var inQueue = {};
        inQueue[groupRootId] = true;
        
        while (queue.length > 0) {
            var currentNodeId = queue.shift();
            inQueue[currentNodeId] = false;
            var currentNode = nodes[currentNodeId];
            if (!currentNode) continue;
            
            // Process outgoing connections and get newly positioned nodes
            var newlyPositioned = processOutgoingConnections(currentNode, currentNodeId, connections, positioned, inQueue, nodes, NODE_SPACING, MIN_SPACING);
            
            // Add newly positioned nodes to queue
            newlyPositioned.forEach(function(nodeId) {
                if (!inQueue[nodeId]) {
                    inQueue[nodeId] = true;
                    queue.push(nodeId);
                }
            });
        }
    }

    //! Update position for next group
    function updatePositionForNextGroup(group, nodes, currentX, currentY, NODE_SPACING) {
        var maxX = currentX;
        var maxY = currentY;
        group.forEach(function(nodeId) {
            var node = nodes[nodeId];
            if (node) {
                maxX = Math.max(maxX, node.guiConfig.position.x + node.guiConfig.width);
                maxY = Math.max(maxY, node.guiConfig.position.y + node.guiConfig.height);
            }
        });
        return { x: maxX + NODE_SPACING, y: maxY };
    }
}
