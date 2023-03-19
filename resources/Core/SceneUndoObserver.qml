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
        interval: 250
        onTriggered: {
            stackFlow.updateStackFlow();
        }
    }

    Component.onCompleted: _timer.start();
    /* Childeren
     * ****************************************************************************************/

    Connections {
        id: sceneConnection
        target:  scene
        enabled: !NLSpec.undoProperty.blockUndoStackConnection

        function onTitleChanged() {
            _timer.start();
        }

        function onNodesChanged() {
             _timer.start();
        }

        function onPortsUpstreamChanged() {
            _timer.start();
        }

        function onPortsDownstreamChanged() {
            _timer.start();
        }

        function onPortsPositionsChanged() {
            _timer.start();
        }

    }
    //! Node Loggers
    Repeater {
        model: scene.nodes

        delegate: NodeUndoObserver{
            node: modelData
            stackFlow: root.stackFlow
        }

    }
}
