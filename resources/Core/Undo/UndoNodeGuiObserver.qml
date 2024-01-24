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

    property UndoStack      undoStack

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: guiConfig

        enabled: !NLSpec.undo.blockObservers

        function onLogoUrlChanged() {
            undoStack.updateUndoStack();
        }

        function onPositionChanged() {
            undoStack.updateUndoStack();
        }

        function onWidthChanged() {
             undoStack.updateUndoStack();
        }

        function onHeightChanged() {
           undoStack.updateUndoStack();
        }

        function onColorChanged() {
            undoStack.updateUndoStack();
        }
    }
}
