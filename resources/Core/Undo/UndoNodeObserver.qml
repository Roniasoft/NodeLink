import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The NodeUndoObserver update UndoStack when Nodes properties changed.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property Node       node

    property UndoStack  undoStack

    property Timer _timer : Timer {
        repeat: false
        interval: 50
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
            root._timer.start();
        }

        function onTypeChanged() {
            root._timer.start();
        }

        function onPortsChanged() {
            root._timer.start();
        }
    }

    UndoNodeGuiObserver {
      guiConfig: root.node.guiConfig
      undoStack: root.undoStack
    }
}
