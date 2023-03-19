import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The LoggerStackFlow keep connection between Scene Model properties and StackFlowCore
 * ************************************************************************************************/

Item {

    id: root
    property Scene         scene
    property StackFlowCore stackFlow : StackFlowCore {
        scene : root.scene
    }

    /* Childeren
     * ****************************************************************************************/

    Connections {
        id: sceneConnection
        target:  scene
        enabled: !NLCore.blockStackFlowConnection

        function onUpdateStackFlowModel() {
             console.log("onUpdateStackFlowModel")
            stackFlow.updateStackFlow();
        }

        function onTitleChanged() {
             console.log("onTitleChanged")
            stackFlow.updateStackFlow();
        }

        function onNodesChanged() {
             console.log("onNodesChanged")
            stackFlow.updateStackFlow();
        }

        function onPortsUpstreamChanged() {
            stackFlow.updateStackFlow();
        }

        function onPortsDownstreamChanged() {
            stackFlow.updateStackFlow();
        }

        function onPortsPositionsChanged() {
//            stackFlow.updateStackFlow();
        }

    }

    //! Node Loggers
    NodeDataLogger {
        nodes: scene.nodes
        stackFlow: root.stackFlow
    }
}
