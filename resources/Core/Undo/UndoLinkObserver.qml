import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * The UndoLinkObserver update UndoStack when Link properties changed.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property Link       link

    property UndoStack  undoStack

    //! Timer to damp excessive property change calls
    property Timer _timer : Timer {
        repeat: false
        interval: 300
        onTriggered: {
            undoStack.updateStacks();
        }
    }

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: link

        function onDirectionChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }
    }

    Connections {
        target: link?.guiConfig ?? null

        function onDescriptionChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }

        function onColorChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }

        function onStyleChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }

        function onTypeChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }
    }
}
