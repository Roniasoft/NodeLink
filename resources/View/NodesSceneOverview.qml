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


    /* Object Properties
    * ****************************************************************************************/

    background: Rectangle {
        color: "#20262d"
    }

    contentItem: NodesRectOverview {
        scene: root.scene
        sceneSession: root.sceneSession
        overviewHeight: root.height
        overviewWidth: root.width
    }

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
        z: -10
    }

    //! Content Loader
    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: contentItem
    }

}
