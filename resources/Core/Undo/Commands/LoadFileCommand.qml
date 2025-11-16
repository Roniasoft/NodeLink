import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * LoadFileCommand
 * Handles file loading with undo/redo support
 * Loads only nodes, links, and containers without changing the scene
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var scene // I_Scene
    property var repo  // QSRepository - the repository to load from
    property url filePath // Path to the file to load
    
    // Store current state (nodes, links, containers) before loading
    property var previousNodes: []
    property var previousLinks: []
    property var previousContainers: []
    
    // Store loaded state (nodes, links, containers) from file
    property var loadedNodes: []
    property var loadedLinks: []
    property var loadedContainers: []
    
    // Temporary repo for loading file
    property var tempRepo: null
    
    // FileIO instance for reading files (avoids QSFileIO singleton crash in Qt 6.5.3)
    property FileIO fileIO: FileIO { }

    /* Functions
     * ****************************************************************************************/
    
    // Save current state
    function saveCurrentState() {
        if (!scene) return
        
        previousNodes = Object.values(scene.nodes)
        previousLinks = Object.values(scene.links)
        previousContainers = Object.values(scene.containers)
    }
    
    // Clear all current objects from scene
    function clearAllSceneObjects() {
        if (!scene) return
        
        // Get all current objects
        var currentNodes = Object.values(scene.nodes)
        var currentLinks = Object.values(scene.links)
        var currentContainers = Object.values(scene.containers)
        
        // Remove all containers first
        for (var i = 0; i < currentContainers.length; i++) {
            scene.deleteContainer(currentContainers[i]._qsUuid)
        }
        
        // Remove all nodes (this will also remove connected links)
        if (currentNodes.length > 0) {
            var nodeUuids = currentNodes.map(function(node) { return node._qsUuid })
            scene.deleteNodes(nodeUuids)
        }
        
        // Remove any remaining links that weren't removed by node deletion
        for (var j = 0; j < currentLinks.length; j++) {
            var link = currentLinks[j]
            if (link && link.inputPort && link.outputPort) {
                scene.unlinkNodes(link.inputPort._qsUuid, link.outputPort._qsUuid)
            }
        }
    }
    
    // Load objects from file into scene
    function loadObjectsFromFile() {
        if (!scene || !repo || !filePath) return false
        
        // First, clear all current objects from scene
        clearAllSceneObjects()
        
        // Convert filePath to string for FileIO
        var filePathString = filePath
        if (filePath && typeof filePath === "object") {
            if (typeof filePath.toLocalFile === "function") {
                filePathString = filePath.toLocalFile()
            } else if (filePath.toString) {
                filePathString = filePath.toString().replace("file:///", "")
            } else {
                filePathString = String(filePath)
            }
        } else if (typeof filePath !== "string") {
            filePathString = String(filePath)
        }
        
        // Read file using FileIO instance (avoids QSFileIO singleton crash in Qt 6.5.3)
        var jsonString = fileIO.read(filePathString)
        if (!jsonString || jsonString.length === 0) {
            console.error("Failed to read file:", filePathString)
            return false
        }
        
        // Parse JSON
        var fileObjects
        try {
            fileObjects = JSON.parse(jsonString)
        } catch (e) {
            console.error("Failed to parse file JSON:", e)
            return false
        }
        
        // Create temporary repo to load the file
        tempRepo = QSSerializer.createQSObject("QSRepository", ["QtQuickStream"], repo)
        tempRepo.imports = repo.imports
        tempRepo._localImports = repo._localImports
        
        // Load into temp repo
        if (!tempRepo.loadRepo(fileObjects)) {
            console.error("Failed to load file into temp repo")
            return false
        }
        
        // Wait for loading to complete
        if (tempRepo._isLoading) {
            console.warn("Temp repo is still loading, this should not happen")
            return false
        }
        
        // Extract scene from temp repo
        var tempScene = tempRepo.qsRootObject
        if (!tempScene) {
            console.error("Failed to get scene from temp repo")
            return false
        }
        
        // Extract nodes, links, and containers
        var tempNodes = tempScene.nodes ? Object.values(tempScene.nodes) : []
        var tempLinks = tempScene.links ? Object.values(tempScene.links) : []
        var tempContainers = tempScene.containers ? Object.values(tempScene.containers) : []
        
        // Clone and add nodes to current scene
        var portMap = {} // Map old ports to new ports for link creation
        for (var i = 0; i < tempNodes.length; i++) {
            var tempNode = tempNodes[i]
            var newNode = QSSerializer.createQSObject(
                scene.nodeRegistry.nodeTypes[tempNode.type],
                scene.nodeRegistry.imports,
                scene.sceneActiveRepo
            )
            newNode._qsRepo = scene.sceneActiveRepo
            newNode.cloneFrom(tempNode)
            
            // Map ports
            var oldPortKeys = Object.keys(tempNode.ports)
            var newPortKeys = Object.keys(newNode.ports)
            for (var j = 0; j < oldPortKeys.length && j < newPortKeys.length; j++) {
                portMap[tempNode.ports[oldPortKeys[j]]._qsUuid] = newNode.ports[newPortKeys[j]]
            }
            
            loadedNodes.push(newNode)
            scene.addNode(newNode, false)
        }
        
        // Clone and add containers
        for (var k = 0; k < tempContainers.length; k++) {
            var tempContainer = tempContainers[k]
            var newContainer = QSSerializer.createQSObject(
                "Container",
                scene.nodeRegistry.imports,
                scene.sceneActiveRepo
            )
            newContainer._qsRepo = scene.sceneActiveRepo
            newContainer.cloneFrom(tempContainer)
            
            loadedContainers.push(newContainer)
            scene.addContainer(newContainer)
        }
        
        // Clone and add links
        for (var l = 0; l < tempLinks.length; l++) {
            var tempLink = tempLinks[l]
            var inputPortUuid = tempLink.inputPort ? tempLink.inputPort._qsUuid : null
            var outputPortUuid = tempLink.outputPort ? tempLink.outputPort._qsUuid : null
            
            if (inputPortUuid && outputPortUuid && portMap[inputPortUuid] && portMap[outputPortUuid]) {
                var newLink = scene.createLink(
                    portMap[inputPortUuid]._qsUuid,
                    portMap[outputPortUuid]._qsUuid
                )
                if (newLink) {
                    newLink.cloneFrom(tempLink)
                    loadedLinks.push(newLink)
                }
            }
        }
        
        return true
    }
    
    // Remove objects from scene
    function removeObjects(nodesToRemove, linksToRemove, containersToRemove) {
        if (!scene) return
        
        // Remove nodes (this will also remove connected links)
        if (nodesToRemove && nodesToRemove.length > 0) {
            var nodeUuids = nodesToRemove.map(function(node) { return node._qsUuid })
            scene.deleteNodes(nodeUuids)
        }
        
        // Remove containers
        if (containersToRemove && containersToRemove.length > 0) {
            for (var i = 0; i < containersToRemove.length; i++) {
                scene.deleteContainer(containersToRemove[i]._qsUuid)
            }
        }
    }
    
    // Restore objects to scene
    function restoreObjects(nodesToRestore, linksToRestore, containersToRestore) {
        if (!scene) return
        
        // Add nodes
        if (nodesToRestore && nodesToRestore.length > 0) {
            scene.addNodes(nodesToRestore, false)
        }
        
        // Add containers
        if (containersToRestore && containersToRestore.length > 0) {
            for (var i = 0; i < containersToRestore.length; i++) {
                scene.addContainer(containersToRestore[i])
            }
        }
        
        // Add links
        if (linksToRestore && linksToRestore.length > 0) {
            scene.restoreLinks(linksToRestore)
        }
    }
    
    function redo() {
        if (!scene || !filePath) return
        
        // If we already loaded, clear current objects and restore the loaded objects
        if (loadedNodes.length > 0 || loadedLinks.length > 0 || loadedContainers.length > 0) {
            // Clear all current objects first
            clearAllSceneObjects()
            // Then restore the loaded objects
            restoreObjects(loadedNodes, loadedLinks, loadedContainers)
        } else {
            // First time: save current state and load from file
            saveCurrentState()
            loadObjectsFromFile()
        }
    }

    function undo() {
        if (!scene) return
        
        // Remove loaded objects
        removeObjects(loadedNodes, loadedLinks, loadedContainers)
        
        // Restore previous objects
        restoreObjects(previousNodes, previousLinks, previousContainers)
    }
}
