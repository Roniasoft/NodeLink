import QtQuick
import QtQuick.Controls
import NodeLink
import QtQml


/*! ***********************************************************************************************
 * The UndoCore
 * ************************************************************************************************/
QtObject {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    //! Scene, for some reasons if the type changes to Scene the app crashes
    required property I_Scene scene

    //! Undo/Redo Stacks (command-based)
    property CommandStack undoStack: CommandStack { }

    //! Observers
    property UndoSceneObserver undoSceneObserver: UndoSceneObserver {
        scene: root.scene
        undoStack: root.undoStack
    }
}
