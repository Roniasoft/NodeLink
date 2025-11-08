import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoNodeObserver update UndoStack when Node properties changed.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property Node       node

    property CommandStack  undoStack

    property var _cache: ({})

    /* Object Properties
     * ****************************************************************************************/
    Component.onCompleted: {
        if (node) {
            _cache.title = node.title
            _cache.type = node.type
            _cache._init = true
        }
    }

    /* Functions
    * ****************************************************************************************/
    function _ensureCache() {
        if (!node)
            return

        if (_cache._init)
            return

        _cache.title = node.title
        _cache.type = node.type
        _cache._init = true
    }

    function pushProp(targetObj, key, oldV, newV) {
        if (!undoStack || undoStack.isReplaying)
            return

        if (oldV === undefined || newV === undefined)
            return

        if (JSON.stringify(oldV) === JSON.stringify(newV))
            return

        function setProp(obj, value) {
            if (obj)
                obj[key] = value
        }

        var cmd = {
            undo: function() {
                setProp(targetObj, oldV)
            },
            redo: function() {
                setProp(targetObj, newV)
            }
        }

        undoStack.push(cmd)
    }

    Connections {
        target: node

        enabled: !NLSpec.undo.blockObservers

        function onTitleChanged() {
            _ensureCache()
            let oldV = _cache.title
            let newV = node.title
            pushProp(node, "title", oldV, newV)
            _cache.title = newV
        }

        function onTypeChanged() {
            _ensureCache()
            let oldV = _cache.type
            let newV = node.type
            pushProp(node, "type", oldV, newV)
            _cache.type = newV
        }
        // Note: ports changes are structural; handled by link/scene commands
    }

    UndoNodeGuiObserver {
      guiConfig: root.node?.guiConfig ?? null
      undoStack: root.undoStack
    }
}
