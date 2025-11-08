import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoContainerObserver update UndoStack when Container properties changed.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property Container  container

    property CommandStack  undoStack

    property var _cache: ({})

    /* Object Properties
     * ****************************************************************************************/
    Component.onCompleted: {
        if (container) {
            _cache.title = container.title
            _cache._init = true
        }
    }

    /* Functions
    * ****************************************************************************************/
    function _ensureCache() {
        if (!container)
            return

        if (_cache._init)
            return

        _cache.title = container.title
        _cache._init = true
    }

    function pushProp(targetObj, key, oldV, newV) {
        if (!undoStack || undoStack.isReplaying)
            return

        if (oldV === undefined || newV === undefined)
            return

        if (JSON.stringify(oldV) === JSON.stringify(newV))
            return

        var cmd = Qt.createQmlObject('import QtQuick; import NodeLink; import "Commands"; PropertyCommand {}', undoStack)
        cmd.target = targetObj
        cmd.key = key
        cmd.oldValue = oldV
        cmd.newValue = newV
        undoStack.push(cmd)
    }

    Connections {
        target: container

        enabled: !NLSpec.undo.blockObservers

        function onTitleChanged() {
            _ensureCache()
            let oldV = _cache.title
            let newV = container.title
            pushProp(container, "title", oldV, newV)
            _cache.title = newV
        }
        // Structural changes (nodes/containersInside) are handled by scene commands
    }

    UndoContainerGuiObserver {
        guiConfig: root.container?.guiConfig ?? null
        undoStack: root.undoStack
    }
}
