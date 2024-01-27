import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoCore
 * ************************************************************************************************/
QtObject {
    id: root

    /* Property Properties
     * ****************************************************************************************/

    //! Scene, for some reasons if the type changes to Scene the app crashes
    required property var scene

    //! Undo/Redo Stacks
    property UndoStack undoStack : UndoStack {
        scene: root.scene
    }

    //! Observers
    property UndoSceneObserver undoSceneObserver: UndoSceneObserver {
        scene: root.scene
        undoStack: root.undoStack
    }
}
