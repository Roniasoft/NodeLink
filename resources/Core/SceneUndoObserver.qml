import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The SceneUndoObserver keep connection between Scene Model properties and StackFlowCore
 * ************************************************************************************************/

Item {

    id: root
    property Scene         scene
    property UndoStack stackFlow : UndoStack {
        scene : root.scene
    }

    property Timer _timer : Timer {
        repeat: false
        interval: 50
        onTriggered: {
            stackFlow.updateStackFlow();
        }
    }

    Component.onCompleted: _timer.start();
    /* Childeren
     * ****************************************************************************************/

    Connections {
        target:  scene
        enabled: !NLSpec.undoProperty.blockUndoStackConnection

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

        delegate: NodeUndoObserver {
            node: modelData
            stackFlow: root.stackFlow
        }

    }
}
