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

    //! Nodes Scene (flickable)
    property Component      nodesScene: NodesScene {
        scene: view.scene
        sceneSession: view.sceneSession
    }

    /* Children
    * ****************************************************************************************/

    //! Loader Nodes Scene (flickable)
    Loader {
        id: nodesSceneLoader
        anchors.fill: parent
        sourceComponent: nodesScene
    }

    //! Overview Rect
    NodesOverview {
        id: overView

        scene: view.scene
        sceneSession: view.sceneSession
        overviewWidth: NLStyle.overview.width
        overviewHeight: NLStyle.overview.height

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

    //! Connection to set zoom after undo
    Connections {
        target: scene?.sceneGuiConfig ?? null

        function onZoomFactorChanged () {
            if (sceneSession.zoomManager.zoomFactor !== scene.sceneGuiConfig.zoomFactor)
                sceneSession.zoomManager.customZoom(scene.sceneGuiConfig.zoomFactor)
        }
    }

    //! Connection to set sceneGuiConfig to the user requested zoomFactor
    Connections {
        target: sceneSession?.zoomManager ?? null

        function onZoomFactorChanged () {
            scene.sceneGuiConfig.zoomFactor = sceneSession.zoomManager.zoomFactor

        }
    }

    //! Zoom needs to be set the first time scene is loaded
    Component.onCompleted: {
        if (scene && scene._qsRepo._isLoading)
            sceneSession.zoomManager.customZoom(scene.sceneGuiConfig.zoomFactor)
        else if (scene && sceneSession)
            scene.sceneGuiConfig.zoomFactor = sceneSession.zoomManager.zoomFactor
    }


}
