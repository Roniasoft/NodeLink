import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NodeLink


/*! ***********************************************************************************************
 * Side Menu
 * ************************************************************************************************/
Item {
    id: sideMenu1

    property I_Scene scene
    property SceneSession sceneSession

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }

    /* Functions
     * ****************************************************************************************/

    //! Count parents of a node that exist in the given nodes set
    function countParentsInSet(node, nodesSet) {
        var parentCount = 0;
        if (node.parents) {
            Object.keys(node.parents).forEach(function(parentId) {
                if (nodesSet[parentId]) {
                    parentCount++;
                }
            });
        }
        return parentCount;
    }

    //! Find the earliest node (node with least parents) in a set of nodes
    function findEarliestNode(nodesSet) {
        var minParents = Infinity;
        var earliestNode = null;
        
        Object.values(nodesSet).forEach(function(node) {
            if (!node) return;
            
            var parentCount = countParentsInSet(node, nodesSet);
            
            if (parentCount < minParents) {
                minParents = parentCount;
                earliestNode = node;
            } else if (parentCount === minParents && !earliestNode) {
                earliestNode = node;
            }
        });
        
        return earliestNode;
    }

    //! Find all connected nodes using BFS starting from a node
    function findConnectedNodes(startNode) {
        var connectedNodes = {};
        var visited = {};
        var queue = [startNode._qsUuid];
        visited[startNode._qsUuid] = true;
        connectedNodes[startNode._qsUuid] = startNode;
        
        while (queue.length > 0) {
            var currentNodeId = queue.shift();
            var currentNode = scene.nodes[currentNodeId];
            if (!currentNode) continue;
            
            // Find connected nodes through links
            Object.values(scene.links).forEach(function(link) {
                if (!link || !link.inputPort || !link.outputPort) {
                    return;
                }
                
                var sourceNodeId = scene.findNodeId(link.inputPort._qsUuid);
                var targetNodeId = scene.findNodeId(link.outputPort._qsUuid);
                
                // If link is connected to current node
                if (sourceNodeId === currentNodeId && !visited[targetNodeId]) {
                    visited[targetNodeId] = true;
                    var targetNode = scene.nodes[targetNodeId];
                    if (targetNode) {
                        connectedNodes[targetNodeId] = targetNode;
                        queue.push(targetNodeId);
                    }
                } else if (targetNodeId === currentNodeId && !visited[sourceNodeId]) {
                    visited[sourceNodeId] = true;
                    var sourceNode = scene.nodes[sourceNodeId];
                    if (sourceNode) {
                        connectedNodes[sourceNodeId] = sourceNode;
                        queue.push(sourceNodeId);
                    }
                }
            });
        }
        
        return connectedNodes;
    }

    //! Find root node from selected nodes (node with no parents or first selected)
    function findRootFromSelected(selectedNodesArray) {
        var rootNode = null;
        
        // First find nodes that have no parents (source nodes)
        for (var i = 0; i < selectedNodesArray.length; i++) {
            var node = selectedNodesArray[i];
            if (!node.parents || Object.keys(node.parents).length === 0) {
                rootNode = node;
                break;
            }
        }
        
        // If root node is not found, use the first selected node
        if (!rootNode && selectedNodesArray.length > 0) {
            rootNode = selectedNodesArray[0];
        }
        
        return rootNode;
    }

    //! Check and fix overlap of a selected node with other nodes
    function fixNodeOverlap(selectedNode) {
        var MIN_SPACING = 60;
        var selectedWidth = selectedNode.guiConfig.width;
        var selectedHeight = selectedNode.guiConfig.height;
        var hasOverlap = false;
        var maxIterations = 10;
        var iteration = 0;
        
        while (iteration < maxIterations) {
            hasOverlap = false;
            var selectedPos = selectedNode.guiConfig.position;
            
            // Check overlap with all nodes in the scene
            Object.keys(scene.nodes).forEach(function(nodeId) {
                if (hasOverlap) return;
                
                // Skip if this is the selected node itself
                if (nodeId === selectedNode._qsUuid) return;
                
                var otherNode = scene.nodes[nodeId];
                if (!otherNode) return;
                
                var otherPos = otherNode.guiConfig.position;
                var otherWidth = otherNode.guiConfig.width;
                var otherHeight = otherNode.guiConfig.height;
                
                // Check overlap
                if (!(selectedPos.x + selectedWidth < otherPos.x ||
                      selectedPos.x > otherPos.x + otherWidth ||
                      selectedPos.y + selectedHeight < otherPos.y ||
                      selectedPos.y > otherPos.y + otherHeight)) {
                    hasOverlap = true;
                    
                    // Move to prevent overlap
                    // Prefer movement to the right and down
                    var newX = selectedPos.x;
                    var newY = selectedPos.y;
                    var moveRight = (otherPos.x + otherWidth + MIN_SPACING) - selectedPos.x;
                    var moveDown = (otherPos.y + otherHeight + MIN_SPACING) - selectedPos.y;
                    
                    if (moveRight > 0 && (moveRight <= moveDown || moveDown <= 0)) {
                        newX = otherPos.x + otherWidth + MIN_SPACING;
                    } else if (moveDown > 0) {
                        newY = otherPos.y + otherHeight + MIN_SPACING;
                    } else {
                        // If all paths are negative or zero, move to the right and down
                        newX = otherPos.x + otherWidth + MIN_SPACING;
                        newY = otherPos.y + otherHeight + MIN_SPACING;
                    }
                    
                    // Apply new position
                    selectedNode.guiConfig.position = Qt.vector2d(newX, newY);
                }
            });
            
            if (!hasOverlap) {
                break;
            }
            
            iteration++;
        }
    }

    //! Update GUI for reordered nodes
    function updateGUIForNodes(nodesToUpdate) {
        if (nodesToUpdate && Object.keys(nodesToUpdate).length > 0) {
            // Call positionChanged for all reordered nodes
            Object.values(nodesToUpdate).forEach(function(node) {
                if (node && node.guiConfig) {
                    node.guiConfig.positionChanged();
                }
            });
            
            // Update selectedModel in GUI
            if (scene.selectionModel) {
                scene.selectionModel.selectedModelChanged();
            }
        }
    }

    //! Handle autoformat when no nodes are selected
    function handleAutoformatNoSelection() {
        var nodesToReorder = scene.nodes;
        var rootNode = findEarliestNode(scene.nodes);
        
        if (rootNode) {
            scene.automaticNodeReorder(nodesToReorder, rootNode._qsUuid, false);
            updateGUIForNodes(scene.nodes);
        }
    }

    //! Handle autoformat when single node is selected
    function handleAutoformatSingleSelection(selectedNode) {
        // Find all connected nodes using BFS
        var connectedNodes = findConnectedNodes(selectedNode);
        var nodesToReorder = connectedNodes;
        
        // Find the earliest node in the chain (only consider parents in connected nodes)
        var rootNode = findEarliestNode(connectedNodes);
        
        return { nodesToReorder: nodesToReorder, rootNode: rootNode };
    }

    //! Handle autoformat when multiple nodes are selected
    function handleAutoformatMultipleSelection(selectedNodesArray, selectedNodes) {
        var nodesToReorder = selectedNodes;
        var rootNode = findRootFromSelected(selectedNodesArray);
        
        // Check and fix overlap of selected nodes with other nodes
        Object.values(selectedNodes).forEach(function(selectedNode) {
            if (selectedNode) {
                fixNodeOverlap(selectedNode);
            }
        });
        
        return { nodesToReorder: nodesToReorder, rootNode: rootNode };
    }


    /* Children
     * ****************************************************************************************/

    //! Zoom Buttons
    SideMenuButtonGroup {
        id: buttonGroup1
        //!Each button has a specific icon and position
        SideMenuButton {
            text: "\ue59e"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Zoom in"
            }

            onClicked: sceneSession.zoomManager.zoomInSignal()
        }
        SideMenuButton {
            text: "\uf2f9"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Reset zoom"
            }

            onClicked: sceneSession.zoomManager.resetZoomSignal(1.0)
        }

        SideMenuButton {
            text: "\uf00e"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Zoom to fit"
            }

            onClicked: sceneSession.zoomManager.zoomToFit()
        }

        SideMenuButton {
            text: "\ue404"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Zoom out"
            }

            onClicked: sceneSession.zoomManager.zoomOutSignal()
        }
    }

    //! Undo/Redo
    SideMenuButtonGroup {
        id: buttonGroup2
        anchors.top: buttonGroup1.bottom
        anchors.topMargin: 8
        SideMenuButton {
            id: undoButton
            text: "\ue455"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            // Base opacity based on whether undo is available
            opacity: (scene?._undoCore?.undoStack.isValidUndo ?? false) ? 1.0 : 0.4
            // enabled: scene?._undoCore?.undoStack.isValidUndo ?? false
            NLToolTip {
                visible: parent.hovered
                text: "Undo"
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }

            onClicked: {
                if(scene?._undoCore?.undoStack.isValidUndo){
                    lastAction = "undo"
                    scene._undoCore.undoStack.undo()
                }
            }
        }
        SideMenuButton {
            id: redoButton
            text: "\ue331"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            // Base opacity based on whether redo is available
            opacity: (scene?._undoCore?.undoStack.isValidRedo ?? false) ? 1.0 : 0.4
            // enabled: scene?._undoCore?.undoStack.isValidRedo ?? false
            NLToolTip {
                visible: parent.hovered
                text: "Redo"
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }

            onClicked: {
                if(scene?._undoCore?.undoStack.isValidRedo){
                    lastAction = "redo"
                    scene._undoCore.undoStack.redo()
                }
            }
        }
    }

    //! Track which action was last performed
    property string lastAction: ""

    //! Connection to handle undo/redo completion feedback
    Connections {
        target: scene?._undoCore?.undoStack ?? null
        function onUndoRedoDone() {
            // Fade out the button that was clicked to indicate completion
            if (lastAction === "undo") {
                undoButton.opacity = 0.4
            } else if (lastAction === "redo") {
                redoButton.opacity = 0.4
            }

            // Restore opacity after a short delay
            restoreOpacityTimer.restart()
        }
    }

    //! Timer to restore button opacity after undo/redo completion
    Timer {
        id: restoreOpacityTimer
        interval: 150 // 150ms delay before restoring opacity
        onTriggered: {
            // Restore opacity based on whether undo/redo is available
            undoButton.opacity = (scene?._undoCore?.undoStack.isValidUndo ?? false) ? 1.0 : 0.4
            redoButton.opacity = (scene?._undoCore?.undoStack.isValidRedo ?? false) ? 1.0 : 0.4
            lastAction = ""
        }
    }

    //! Snap/Grid/Overview Settings
    SideMenuButtonGroup {

        id: buttonGroup3
        anchors.top: buttonGroup2.bottom
        anchors.topMargin: 8
        SideMenuButton {
            id: snapGrid
            text: "\uf850"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            checkable: true
            onCheckedChanged: {
                NLStyle.snapEnabled = snapGrid.checked
                if (snapGrid.checked) {
                   scene?.snapAllNodesToGrid();
               }
            }
            NLToolTip {
                visible: parent.hovered
                text: "Snap to grid"
            }
        }
        SideMenuButton {
            text: "\uf773"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Auto Format"
            }
            onClicked: {
                var selectedNodes = scene.selectionModel.selectedModel;
                
                // If no node is selected, reorder all nodes in the scene
                if (!selectedNodes || Object.keys(selectedNodes).length === 0) {
                    handleAutoformatNoSelection();
                    return;
                }
                
                var selectedNodesArray = Object.values(selectedNodes);
                var nodesToReorder = {};
                var rootNode = null;
                
                // If only one node is selected, find all connected nodes
                if (selectedNodesArray.length === 1) {
                    var result = handleAutoformatSingleSelection(selectedNodesArray[0]);
                    nodesToReorder = result.nodesToReorder;
                    rootNode = result.rootNode;
                } else {
                    // If multiple nodes are selected
                    var result = handleAutoformatMultipleSelection(selectedNodesArray, selectedNodes);
                    nodesToReorder = result.nodesToReorder;
                    rootNode = result.rootNode;
                }
                
                if (rootNode) {
                    scene.automaticNodeReorder(nodesToReorder, rootNode._qsUuid, true);
                    
                    // Update GUI for reordered nodes
                    // If one node was selected and all connected nodes were reordered, we need to update all of them
                    var nodesToUpdate = selectedNodesArray.length === 1 ? nodesToReorder : selectedNodes;
                    updateGUIForNodes(nodesToUpdate);
                }
            }
        }

        //! Show/hide the overview
        SideMenuButton {
            text: "\uf065"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34

            checkable: true
            visible: sceneSession && sceneSession.enabledOverview
            enabled: sceneSession && sceneSession.enabledOverview
            checked: sceneSession && sceneSession.enabledOverview
                     && sceneSession.visibleOverview

            NLToolTip {
                text: (((sceneSession?.visibleOverview
                         ?? false) ? "Hide " : "Show ") + "the overview")
                visible: parent.hovered
            }

            onClicked: sceneSession.visibleOverview = !sceneSession.visibleOverview
        }
    }

    //! Lasso Selection
    SideMenuButtonGroup {
        id: buttonGroup4
        anchors.top: buttonGroup3.bottom
        anchors.topMargin: 8
        SideMenuButton {
            text: "\uf0c8"
            position: "only"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            checkable: true
            checked: true

            NLToolTip {
                visible: parent.hovered
                text: "Marquee Selection"
            }

            onClicked: {
                scene.toggleLassoSelectionMode()
            }

            onCheckedChanged: {
                if (checked)
                    sceneSession.selectionType = "rectangle"
                else
                    sceneSession.selectionType = "lasso"
            }

            Component.onCompleted: {
                if (checked)
                    sceneSession.selectionType = "rectangle"
                else
                    sceneSession.selectionType = "lasso"
            }
        }
    }

    //! Help
    SideMenuButtonGroup {
        id: buttonGroup5
        anchors.top: buttonGroup4.bottom
        anchors.topMargin: 8
        SideMenuButton {
            text: "\uf60b"
            position: "only"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Help"
            }
        }
    }
}
