import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream
import Calculator

/*! ***********************************************************************************************
 * CalculatorView manage and show all objects in calcultor.
 * ************************************************************************************************/

Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property CalculatorScene scene

    property SceneSession    sceneSession:   SceneSession {
        enabledOverview: false;
        doNodesNeedImage: false
    }

    /* Children
    * ****************************************************************************************/

    //! Nodes Scene (flickable)
    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        contentItem: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("CalculatorNodeView.qml")
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
