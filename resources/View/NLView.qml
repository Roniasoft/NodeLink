import QtQuick
import QtQuick.Controls
import NodeLink

Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property Scene scene

    property SceneSession   sceneSession:   SceneSession {}

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
}
