import QtQuick
import NodeLink

QtObject {
    id: stack

    /* Properties */
    property var undoStack: []
    property var redoStack: []

    readonly property bool isValidUndo: undoStack.length > 0
    readonly property bool isValidRedo: redoStack.length > 0

    // True while executing undo/redo to suppress observer-generated commands
    property bool isReplaying: false

    /* Signals */
    signal stacksUpdated()
    signal undoRedoDone()

    // batch aggregation for rapid sequences (e.g., multi-select moves)
    property var _pendingCommands: []
    property Timer _batchTimer: Timer {
        interval: 200
        repeat: false
        onTriggered: {
            stack._finalizePending()
        }
    }

    function clearRedo() {
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
            try { cmd.redo() } finally {
                NLSpec.undo.blockObservers = false
                isReplaying = false
            }
        }

        // aggregate into a batch, to group multiple simultaneous changes
        _pendingCommands.push(cmd)
        _batchTimer.restart()
    }

    function _finalizePending() {
        if (_pendingCommands.length === 0) return

        // build a macro command
        const cmds = _pendingCommands.slice()
        _pendingCommands = []

        var macro = {
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
        undoStackChanged()
        clearRedo()
        stacksUpdated()
    }

    function undo() {
        if (!isValidUndo) return
        const cmd = undoStack.shift()
        undoStackChanged()

        isReplaying = true
        NLSpec.undo.blockObservers = true
        try { cmd.undo() } finally {
            NLSpec.undo.blockObservers = false
            isReplaying = false
        }

        redoStack.unshift(cmd)
        redoStackChanged()
        undoRedoDone()
        stacksUpdated()
    }

    function redo() {
        if (!isValidRedo) return
        const cmd = redoStack.shift()
        redoStackChanged()

        isReplaying = true
        NLSpec.undo.blockObservers = true
        try { cmd.redo() } finally {
            NLSpec.undo.blockObservers = false
            isReplaying = false
        }

        undoStack.unshift(cmd)
        undoStackChanged()
        undoRedoDone()
        stacksUpdated()
    }

    function resetStacks() {
        undoStack = []
        redoStack = []
        undoStackChanged()
        redoStackChanged()
        stacksUpdated()
    }
}


