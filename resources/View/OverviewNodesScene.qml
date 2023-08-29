import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * I_NodesScene show the abstract the NodesScene properties.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Scene is the main model containing information about all nodes/links
    property Scene          scene:          null

    //! Scene session contains information about scene states (UI related)
    property SceneSession   sceneSession:   null

    //! Scene Background
    property Component      background:     null

    //! Scene Contents (Nodes/Links)
    property Component      contentItem:    null

    //! Scene Foreground
    property Component      foreground:     null

    /* Object Properties
    * ****************************************************************************************/
//    contentWidth: sceneSession.contentWidth
//    contentHeight: sceneSession.contentHeight
//    contentX: NLStyle.scene.defaultContentX
//    contentY: NLStyle.scene.defaultContentY
//    focus: true



    background: Rectangle {
        color: "#20262d"
//        scale: 0.15
    }
//    background: SceneViewBackground {}

    contentItem: OverviewNodesRect {
        scene: root.scene
        sceneSession: root.sceneSession

//        scale: 0.2
    }
    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
        z: -10
    }
//    transformOrigin: Item.BottomRight
    //! Content Loader
    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: contentItem
    }
//    Loader {
//        id: foregroundLoader
//        anchors.fill: parent
//        sourceComponent: foreground
//    }
}
