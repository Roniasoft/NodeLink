import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NodeLink
import QtQuickStream

Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property Scene          scene

    property SceneSession   sceneSession:   SceneSession {}

    property alias          nodesScene:     nodesScene

    /* Children
    * ****************************************************************************************/

    //! Nodes Scene (flickable)
    NodesScene {
        id: nodesScene
        scene: view.scene
        sceneSession: view.sceneSession
    }

    //! Overview Rect
    NodesOverview {
        id: overView

        visible: sceneSession.visibleOverview

        scene: view.scene
        sceneSession: view.sceneSession
        overviewWidth: 300
        overviewHeight: 300

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        clip: true
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
