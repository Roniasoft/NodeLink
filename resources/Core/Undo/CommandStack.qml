import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * CommandStack
 * ************************************************************************************************/

QtObject {
    id: stack

    /* Property Declarations
    * ****************************************************************************************/
    property var undoStack: []
    property var redoStack: []

    readonly property bool isValidUndo: undoStack.length > 0
    readonly property bool isValidRedo: redoStack.length > 0

    // True while executing undo/redo to suppress observer-generated commands
    property bool isReplaying: false

    // Maximum number of undo/redo commands to keep in memory
    // Set to 0 for unlimited (not recommended for performance)
    property int maxStackSize: 50

    // batch aggregation for rapid sequences (e.g., multi-select moves)
    property var _pendingCommands: []
    property Timer _batchTimer: Timer {
        interval: 200
        repeat: false
        onTriggered: {
            stack._finalizePending()
        }
    }

    /* Signals
    * ****************************************************************************************/
    signal stacksUpdated()
    signal undoRedoDone()

    /* Functions
    * ****************************************************************************************/
    function clearRedo() {
        // Cleanup commands before clearing
        for (var i = 0; i < redoStack.length; i++) {
            _cleanupCommand(redoStack[i])
        }
        
        redoStack = []
        redoStackChanged()
    }

    // appliedAlready: when true (default), the change is already applied by the caller
    function push(cmd, appliedAlready = true) {
        if (!cmd || typeof cmd.redo !== "function" || typeof cmd.undo !== "function")
            return

        if (!appliedAlready) {
            isReplaying = true
            NLSpec.undo.blockObservers = true
            try {
                cmd.redo()
            } finally {
                NLSpec.undo.blockObservers = false
                isReplaying = false
            }
        }

        // aggregate into a batch, to group multiple simultaneous changes
        _pendingCommands.push(cmd)
        _batchTimer.restart()
    }

    function _finalizePending() {
        if (_pendingCommands.length === 0)
            return

        // build a macro command
        const cmds = _pendingCommands.slice()
        _pendingCommands = []

        var macro = {
            subCommands: cmds,  // Store sub-commands for cleanup
            undo: function() {
                // undo in reverse order to respect dependencies
                for (var i = cmds.length - 1; i >= 0; --i) {
                    cmds[i].undo()
                }
            },
            redo: function() {
                for (var i = 0; i < cmds.length; ++i) {
                    cmds[i].redo()
                }
            }
        }

        undoStack.unshift(macro)
        
        // Limit stack size to prevent memory issues
        _enforceStackLimit()
        
        undoStackChanged()
        clearRedo()
        stacksUpdated()
    }

    //! Enforces maximum stack size by removing oldest commands
    function _enforceStackLimit() {
        if (maxStackSize <= 0)
            return // Unlimited

        // Remove oldest commands if stack exceeds limit
        while (undoStack.length > maxStackSize) {
            var oldCmd = undoStack.pop()
            _cleanupCommand(oldCmd)
        }
    }

    //! Cleans up resources held by a command
    function _cleanupCommand(cmd) {
        if (!cmd)
            return
        
        // If it's a macro command (JavaScript object with subCommands array)
        if (cmd.subCommands && Array.isArray(cmd.subCommands)) {
            // Cleanup all sub-commands
            for (var i = 0; i < cmd.subCommands.length; i++) {
                var subCmd = cmd.subCommands[i]
                if (subCmd && subCmd.destroy && typeof subCmd.destroy === "function") {
                    try {
                        subCmd.destroy()
                    } catch (e) {
                        // Ignore errors during cleanup
                    }
                }
            }
            // Clear the array to release references
            cmd.subCommands = []
        }
        // If it's a QML command object
        else if (cmd.destroy && typeof cmd.destroy === "function") {
            try {
                cmd.destroy()
            } catch (e) {
                // Ignore errors during cleanup
            }
        } else {
            // For plain JS objects, just clear any references
            if (cmd.node) cmd.node = null
            if (cmd.nodes) cmd.nodes = null
            if (cmd.links) cmd.links = null
            if (cmd.createdLink) cmd.createdLink = null
            if (cmd.removedLink) cmd.removedLink = null
        }
    }

    function undo() {
        if (!isValidUndo)
            return

        const cmd = undoStack.shift()
        undoStackChanged()

        isReplaying = true
        NLSpec.undo.blockObservers = true
        try {
            cmd.undo()
        } finally {
            NLSpec.undo.blockObservers = false
            isReplaying = false
        }

        redoStack.unshift(cmd)
        redoStackChanged()
        undoRedoDone()
        stacksUpdated()
    }

    function redo() {
        if (!isValidRedo)
            return

        const cmd = redoStack.shift()
        redoStackChanged()

        isReplaying = true
        NLSpec.undo.blockObservers = true
        try {
            cmd.redo()
        } finally {
            NLSpec.undo.blockObservers = false
            isReplaying = false
        }

        undoStack.unshift(cmd)
        undoStackChanged()
        undoRedoDone()
        stacksUpdated()
    }

    function resetStacks() {
        // Cleanup all commands before resetting
        for (var i = 0; i < undoStack.length; i++) {
            _cleanupCommand(undoStack[i])
        }
        for (var j = 0; j < redoStack.length; j++) {
            _cleanupCommand(redoStack[j])
        }
        
        undoStack = []
        redoStack = []
        undoStackChanged()
        redoStackChanged()
        stacksUpdated()
    }

    //! Returns memory statistics for debugging
    function getMemoryStats() {
        return {
            undoStackSize: undoStack.length,
            redoStackSize: redoStack.length,
            maxStackSize: maxStackSize,
            totalCommands: undoStack.length + redoStack.length
        }
    }
}


