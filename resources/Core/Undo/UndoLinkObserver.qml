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

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: link

        function onDirectionChanged() {
            undoStack.updateUndoStack();
        }
    }

    Connections {
        target: link?.guiConfig ?? null

        function onDescriptionChanged() {
          undoStack.updateUndoStack();
        }

        function onColorChanged() {
           undoStack.updateUndoStack();
        }

        function onStyleChanged() {
            undoStack.updateUndoStack();
        }

        function onTypeChanged() {
            undoStack.updateUndoStack();
        }
    }
}
