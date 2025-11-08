import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoLinkObserver update UndoStack when Link properties changed.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property Link       link

    property CommandStack  undoStack

    property var _cache: ({})

    /* Object Properties
     * ****************************************************************************************/
    Component.onCompleted: {
        if (link) {
            _cache.title = link.title
            _cache.type = link.type
            _cache._init = true
        }
    }

    /* Functions
    * ****************************************************************************************/
    function _ensureCache() {
        if (!link)
            return

        if (_cache._init)
            return

        _cache.title = link.title
        _cache.type = link.type
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
        target: link

        enabled: !NLSpec.undo.blockObservers

        function onInputPortChanged() {
            _ensureCache()
            let oldV = _cache.title
            let newV = link.title
            pushProp(link, "inputPort", oldV, newV)
            _cache.title = newV
        }

        function onOutputPortChanged() {
            _ensureCache()
            let oldV = _cache.type
            let newV = link.type
            pushProp(link, "outputPort", oldV, newV)
            _cache.type = newV
        }
        // Note: ports changes are structural; handled by link/scene commands
    }

    UndoLinkGuiObserver {
      guiConfig: root.link?.guiConfig ?? null
      undoStack: root.undoStack
    }
}
