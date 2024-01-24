import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoSceneObserver keep connection between Scene Model properties and StackFlowCore
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    required property I_Scene       scene

    required property UndoStack     undoStack

    /* Childeren
     * ****************************************************************************************/
    Connections {
        target:  scene
        enabled: !NLSpec.undo.blockObservers

        function onTitleChanged() {
            undoStack.updateUndoStack();
        }

        function onNodesChanged() {
            undoStack.updateUndoStack();
        }

        function onLinksChanged() {
            undoStack.updateUndoStack();
        }
    }

    //! Node Loggers
    Repeater {
        model: Object.values(root.scene.nodes)

        delegate: UndoNodeObserver {
            node: modelData
            undoStack: root.undoStack
        }

    }

    //! Link Loggers
    Repeater {
        model: Object.values(root.scene.links)

        delegate: UndoLinkObserver {
            link: modelData
            undoStack: root.undoStack
        }

    }

    //! Containers Loggers
    Repeater {
        model: Object.values(root.scene.containers)

        delegate: UndoContainerObserver {
            container: modelData
            undoStack: root.undoStack
        }

    }
}
