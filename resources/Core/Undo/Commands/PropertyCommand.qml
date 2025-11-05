import QtQuick

QtObject {
    id: root

    // target object and property
    property var target
    property string key
    property var oldValue
    property var newValue

    // Optional custom applier: function(t, value)
    property var apply

    function setProp(value) {
        if (!target) return
        if (apply) {
            apply(target, value)
        } else {
            target[key] = value
        }
    }

    function undo() { setProp(oldValue) }
    function redo() { setProp(newValue) }
}



