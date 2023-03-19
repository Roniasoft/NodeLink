import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NodeLink
import QtQuickStream

Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property Scene scene

    property SceneSession   sceneSession:   SceneSession {}

    //! Logger stack flow
    property LoggerStackFlow loggerStackFlow: LoggerStackFlow {

        scene: view.scene
    }

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
        visible: NLStyle.overview.visible
        scene: view.scene
        sceneSession: view.sceneSession
        x: view.width - overView.width * scale - 20
        y: view.height - overView.height * scale - 20
    }

    //! Side Menu
    SideMenu {
        loggerSF: view.loggerStackFlow

        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }


}
