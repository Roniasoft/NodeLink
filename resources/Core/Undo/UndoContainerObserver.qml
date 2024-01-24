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

    property UndoStack  undoStack

    /* Childeren
     * ****************************************************************************************/
    Connections {
        target: container

        enabled: !NLSpec.undo.blockObservers


        function onTitleChanged() {
            undoStack.updateUndoStack();
        }

        function onNodesChanged() {
            undoStack.updateUndoStack();
        }

        function onContainersInsideChanged() {
            undoStack.updateUndoStack();
        }
    }

    UndoContainerGuiObserver {
        guiConfig: root.container?.guiConfig ?? null
        undoStack: root.undoStack
    }
}
