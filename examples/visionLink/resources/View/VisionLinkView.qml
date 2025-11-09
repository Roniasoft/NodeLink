import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream
import VisionLink

/*! ***********************************************************************************************
 * VisionLinkView manage and show all objects in calcultor.
 * ************************************************************************************************/
Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property VisionLinkScene scene

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
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("VisionLinkNodeView.qml")
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
