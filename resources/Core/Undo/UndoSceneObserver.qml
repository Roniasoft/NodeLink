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
    required property Scene       scene

    required property UndoStack undoStack

    property Timer _timer : Timer {
        repeat: false
        interval: 50
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
            root._timer.start();
        }

        function onNodesChanged() {
             root._timer.start();
        }

        function onPortsUpstreamChanged() {
            root._timer.start();
        }

        function onPortsDownstreamChanged() {
            root._timer.start();
        }

        function onPortsPositionsChanged() {
//            root._timer.start();
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
}
