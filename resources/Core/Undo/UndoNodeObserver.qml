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

    property UndoStack  undoStack

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
        target: node

        enabled: !NLSpec.undo.blockObservers


        function onTitleChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            _timer.start();
        }

        function onTypeChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }

        function onPortsChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }
    }

    UndoNodeGuiObserver {
      guiConfig: root.node?.guiConfig ?? null
      undoStack: root.undoStack
    }
}
