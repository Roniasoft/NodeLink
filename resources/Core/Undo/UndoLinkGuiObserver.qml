import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The GuiConfigUndoObserver observe LinkGuiConfig properties changes.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property LinkGUIConfig  guiConfig

    property CommandStack      undoStack

    // cache last values to compute old/new
    property var _cache: ({})

    /* Object Properties
     * ****************************************************************************************/
    Component.onCompleted: {
        if (guiConfig) {
            _cache.description = guiConfig.description
            _cache.color = guiConfig.color
            _cache.colorIndex = guiConfig.colorIndex
            _cache.style = guiConfig.style
            _cache.type = guiConfig.type
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

        _cache.description = guiConfig.description
        _cache.colorIndex = guiConfig.colorIndex
        _cache.style = guiConfig.style
        _cache.color = guiConfig.color
        _cache.type = guiConfig.type
        _cache._init = true
    }

    function _positionsEqual(a, b) {
        if (!a || !b)
            return false

        return Math.abs(a.x - b.x) < 0.0001 && Math.abs(a.y - b.y) < 0.0001
    }

    function _copyPos(p) {
        return { x: p.x, y: p.y }
    }

    function pushProp(key, oldV, newV, apply) {
        if (!undoStack || undoStack.isReplaying)
            return

        if (oldV === undefined || newV === undefined)
            return

        const targetObj = guiConfig
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


        function onDescriptionChanged(){
            _ensureCache()
            let oldV = _cache.description
            let newV = guiConfig.description
            pushProp("description", oldV, newV)
            _cache.description = newV
        }

        function onColorChanged(){
            _ensureCache()
            let oldV = _cache.color
            let newV = guiConfig.color
            pushProp("color", oldV, newV)
            _cache.color = newV
        }

        function onColorIndexChanged(){
            _ensureCache()
            let oldV = _cache.colorIndex
            let newV = guiConfig.colorIndex
            pushProp("colorIndex", oldV, newV)
            _cache.colorIndex = newV
        }

        function onStyleChanged(){
            _ensureCache()
            let oldV =  _cache.style
            let newV = guiConfig.style
            pushProp("style", oldV, newV)
            _cache.style = newV
        }

        function onTypeChanged(){
            _ensureCache()
            let oldV =  _cache.type
            let newV = guiConfig.type
            pushProp("type", oldV, newV)
            _cache.type = newV
        }
    }
}
