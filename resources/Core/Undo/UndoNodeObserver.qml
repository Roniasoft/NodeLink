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

    /* Childeren
     * ****************************************************************************************/
    Connections {
        target: node

        enabled: !NLSpec.undo.blockObservers


        function onTitleChanged() {
            undoStack.updateUndoStack();
        }

        function onTypeChanged() {
            undoStack.updateUndoStack();
        }

        function onPortsChanged() {
            undoStack.updateUndoStack();
        }
    }

    UndoNodeGuiObserver {
      guiConfig: root.node?.guiConfig ?? null
      undoStack: root.undoStack
    }
}
