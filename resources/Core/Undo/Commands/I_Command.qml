import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * I_Command - Base interface/class for all undo/redo commands
 * 
 * All commands must implement:
 * - redo(): Apply the command
 * - undo(): Reverse the command
 * 
 * Commands should set the 'scene' property to the I_Scene instance they operate on.
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    //! The scene this command operates on
    property var scene: null

    /* Functions
     * ****************************************************************************************/
    
    //! Apply the command (called on redo or initial execution)
    //! Must be implemented by derived commands
    function redo() {
        console.warn("[I_Command] redo() not implemented in", root)
    }

    //! Reverse the command (called on undo)
    //! Must be implemented by derived commands
    function undo() {
        console.warn("[I_Command] undo() not implemented in", root)
    }

    //! Helper function to check if scene is valid
    function isValidScene() : bool {
        return scene !== null && scene !== undefined
    }

    //! Helper function to check if an object is valid (not null and has _qsUuid)
    function isValidObject(obj) : bool {
        return obj !== null && obj !== undefined && obj._qsUuid !== undefined
    }

    //! Helper function to check if a node is valid
    function isValidNode(node) : bool {
        return isValidObject(node) && node._qsUuid !== null && node._qsUuid !== ""
    }

    //! Helper function to check if a link is valid
    function isValidLink(link) : bool {
        return isValidObject(link) && 
               link.inputPort !== null && link.inputPort !== undefined &&
               link.outputPort !== null && link.outputPort !== undefined
    }

    //! Helper function to check if a container is valid
    function isValidContainer(container) : bool {
        return isValidObject(container)
    }

    //! Helper function to check if a UUID string is valid
    function isValidUuid(uuid) : bool {
        return uuid !== null && uuid !== undefined && uuid !== ""
    }
}

