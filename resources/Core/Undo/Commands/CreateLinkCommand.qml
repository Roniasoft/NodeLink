import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * CreateLinkCommand
 * ************************************************************************************************/

I_Command {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property string inputPortUuid
    property string outputPortUuid
    property var createdLink // Link, set after redo

    /* Functions
     * ****************************************************************************************/
    function redo() {
        if (!isValidScene() || !isValidUuid(inputPortUuid) || !isValidUuid(outputPortUuid))
            return

        if (createdLink) {
            // Restore the existing link object (preserves all properties)
            scene.restoreLinks([createdLink])
        } else {
            // First time: create new link
            createdLink = scene.createLink(inputPortUuid, outputPortUuid)
        }
    }

    function undo() {
        if (!isValidScene() || !isValidLink(createdLink))
            return

        // Remove link from scene but DON'T destroy it (we need it for redo)
        if (scene.links[createdLink._qsUuid]) {
            // Remove parent/children relationships before removing link
            if (createdLink.inputPort && createdLink.outputPort) {
                let nodeX = scene.findNode(createdLink.inputPort._qsUuid);
                let nodeY = scene.findNode(createdLink.outputPort._qsUuid);
                
                if (nodeX && nodeY) {
                    // Remove children relationship
                    if (Object.keys(nodeX.children).includes(nodeY._qsUuid)) {
                        delete nodeX.children[nodeY._qsUuid];
                        nodeX.childrenChanged();
                    }
                    
                    // Remove parents relationship
                    if (Object.keys(nodeY.parents).includes(nodeX._qsUuid)) {
                        delete nodeY.parents[nodeX._qsUuid];
                        nodeY.parentsChanged();
                    }
                }
            }
            
            scene.linkRemoved(createdLink)
            scene.selectionModel.remove(createdLink._qsUuid)
            delete scene.links[createdLink._qsUuid]
            scene.linksChanged()
        }
    }
}
