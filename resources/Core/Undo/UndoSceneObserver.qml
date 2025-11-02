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

    required property CommandStack     undoStack

    /* Childeren
     * ****************************************************************************************/
    // Scene-level updates are handled via specific commands in I_Scene and observers.
    // No snapshot updates here.

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
        model: Object.values(root.scene.links).filter(link => link !== null && link !== undefined)

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
