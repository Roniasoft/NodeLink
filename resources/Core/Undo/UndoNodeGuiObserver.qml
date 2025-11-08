import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The GuiConfigUndoObserver observe NodeGuiConfig properties changes.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property NodeGuiConfig  guiConfig

    property CommandStack      undoStack

    // cache last values to compute old/new
    property var _cache: ({})

    /* Object Properties
     * ****************************************************************************************/
    Component.onCompleted: {
        if (guiConfig) {
            _cache.position = guiConfig.position
            _cache.width = guiConfig.width
            _cache.height = guiConfig.height
            _cache.color = guiConfig.color
            _cache.logoUrl = guiConfig.logoUrl
            _cache.description = guiConfig.description
            _cache._init = true
        }
    }

    /* Functions
    * ****************************************************************************************/
    function _ensureCache() {
        if (!guiConfig)
            return

        if (_cache._init)
            return

        _cache.position = guiConfig.position
        _cache.width = guiConfig.width
        _cache.height = guiConfig.height
        _cache.color = guiConfig.color
        _cache.logoUrl = guiConfig.logoUrl
        _cache.description = guiConfig.description
        _cache._init = true
    }

    function _positionsEqual(a, b) {
        if (!a || !b)
            return false

        return Math.abs(a.x - b.x) < 0.0001 && Math.abs(a.y - b.y) < 0.0001
    }

    function _copyPos(p) {
        return { x: p.x, y: p.y } }


    function pushProp(key, oldV, newV, apply) {
        if (!undoStack || undoStack.isReplaying)
            return

        if (oldV === undefined || newV === undefined)
            return

        const targetObj = guiConfig
        // Special handling for position (value type vector2d)
        if (key === "position") {
            if (_positionsEqual(oldV, newV))
                return

            let oldCopy = _copyPos(oldV)
            let newCopy = _copyPos(newV)
            function setPos(val) {
                if (!targetObj)
                    return

                targetObj.position = Qt.vector2d(val.x, val.y)
            }
            var cmdPos = {
                undo: function() {
                    setPos(oldCopy)
                },
                redo: function() {
                    setPos(newCopy)
                }
            }

            undoStack.push(cmdPos)
            return
        }
        // Generic properties
        if (JSON.stringify(oldV) === JSON.stringify(newV))
            return

        function setProp(value) {
            if (!targetObj)
                return

            if (apply) {
                apply(targetObj, value)
            } else {
                targetObj[key] = value
            }
        }

        var cmd = {
            undo: function() {
                setProp(oldV)
            },
            redo: function() {
                setProp(newV)
            }
        }

        undoStack.push(cmd)
    }

    Connections {
        target: guiConfig
        enabled: !NLSpec.undo.blockObservers

        function onLogoUrlChanged() {
            _ensureCache()
            let oldV = _cache.logoUrl
            let newV = guiConfig.logoUrl
            pushProp("logoUrl", oldV, newV)
            _cache.logoUrl = newV
        }

        function onPositionChanged() {
            _ensureCache()
            let oldV = _cache.position
            let newV = guiConfig.position
            pushProp("position", oldV, newV)
            // store copy to avoid aliasing
            _cache.position = _copyPos(newV)
        }

        function onWidthChanged() {
            _ensureCache()
            let oldV = _cache.width
            let newV = guiConfig.width
            pushProp("width", oldV, newV)
            _cache.width = newV
        }

        function onHeightChanged() {
            _ensureCache()
            let oldV = _cache.height
            let newV = guiConfig.height
            pushProp("height", oldV, newV)
            _cache.height = newV
        }

        function onColorChanged() {
            _ensureCache()
            let oldV = _cache.color
            let newV = guiConfig.color
            pushProp("color", oldV, newV)
            _cache.color = newV
        }

        function onDescriptionChanged() {
            _ensureCache()
            let oldV = _cache.description
            let newV = guiConfig.description
            pushProp("description", oldV, newV)
            _cache.description = newV
        }
    }
}
