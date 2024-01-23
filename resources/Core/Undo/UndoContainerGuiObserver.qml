import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The GuiConfigUndoObserver observe ContainerGuiConfig properties changes.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property ContainerGuiConfig  guiConfig

    property UndoStack           undoStack

    property var                 undoSceneObserver


    /* Childeren
     * ****************************************************************************************/
    Connections {
        target: guiConfig

        enabled: !NLSpec.undo.blockObservers

        function onPositionChanged() {
            startTimer()
        }

        function onWidthChanged() {
            startTimer()
        }

        function onHeightChanged() {
            startTimer()
        }

        function onColorChanged() {
            startTimer()
        }
    }

    /* Functions
     * ****************************************************************************************/
    function startTimer() {
        if (undoSceneObserver._timer.running) {
            undoSceneObserver._timer.stop()
        }
        undoSceneObserver._timer.start();
    }
}
