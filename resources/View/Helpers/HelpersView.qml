import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * HelpersView manages Helper classes.
 * ************************************************************************************************/

Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Scene is the main model containing information about all nodes/links
    property I_Scene        scene

    //! Scene session contains information about scene states (UI related)
    property SceneSession   sceneSession

    /* Object Properties
    * ****************************************************************************************/

    anchors.fill: parent

    // upper layer in app
    z: (sceneSession?.connectingMode ?? false) ? -1 : 0

    /* Children
    * ****************************************************************************************/

    //! Selection Helper view and Rubber band
    SelectionHelperView {
        anchors.fill: parent

        scene: root.scene
        sceneSession: root.sceneSession
    }

    //! User Connection Curve
    LinkHelperView {
        scene: root.scene
        sceneSession: root.sceneSession
        anchors.fill: parent
    }
}
