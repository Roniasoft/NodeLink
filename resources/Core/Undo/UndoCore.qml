import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoCore
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/

    //! Scene, for some reasons if the type changes to Scene the app crashes
    required property Scene scene

    property UndoStack undoStack : UndoStack {
        scene: root.scene
    }

    property UndoSceneObserver undoSceneObserver: UndoSceneObserver {
        scene: root.scene
        undoStack: root.undoStack
    }
}
