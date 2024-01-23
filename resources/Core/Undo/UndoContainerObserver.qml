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

    property var        undoSceneObserver

    /* Childeren
     * ****************************************************************************************/
    Connections {
        target: container

        enabled: !NLSpec.undo.blockObservers


        function onTitleChanged() {
            startTimer()
        }

        function onNodesChanged() {
            startTimer()
        }

        function onContainersInsideChanged() {
            startTimer()
        }
    }

    UndoContainerGuiObserver {
        guiConfig: root.container?.guiConfig ?? null
        undoStack: root.undoStack
        undoSceneObserver: root.undoSceneObserver
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
