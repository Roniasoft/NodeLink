import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream
import LogicCircuit

/*! ***********************************************************************************************
 * LogicCircuitView manages and shows all objects in logic gates example
 * ************************************************************************************************/
Item {
    id: view

    property LogicCircuitScene scene
    property SceneSession sceneSession: SceneSession {
        enabledOverview: false
        doNodesNeedImage: false
    }

    //! Nodes Scene
    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("LogicCircuitNodeView.qml")
        }
    }

    //! Side Menu
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }
}
