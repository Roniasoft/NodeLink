import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The UndoSceneObserver keep connection between Scene Model properties and StackFlowCore
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    required property I_Scene       scene

    required property UndoStack undoStack

    // Why even this exists?
    property Timer _timer : Timer {
        repeat: false
        interval: 300
        onTriggered: {
            undoStack.updateStacks();
        }
    }

    Component.onCompleted: _timer.start();

    /* Childeren
     * ****************************************************************************************/
    Connections {
        target:  scene
        enabled: !NLSpec.undo.blockObservers

        function onTitleChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
        }

        function onNodesChanged() {
            if (_timer.running) {
                _timer.stop()
            }
             root._timer.start();
        }

        function onLinksChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            root._timer.start();
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
}
