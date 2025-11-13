import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls

import QtQuickStream
import NodeLink
import VisionLink

/*! ***********************************************************************************************
 * MainWindow of visionLink example
 * ************************************************************************************************/
Window {
    id: window

    /* Property Declarations
     * ****************************************************************************************/
    //! Scene
    property VisionLinkScene scene: null

    /* Object Properties
     * ****************************************************************************************/
    width: 1280
    height: 960
    visible: true
    title: qsTr("VisionLink Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {

        // Create root object
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "VisionLink"])
        NLCore.defaultRepo.initRootObject("VisionLinkScene");
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
    }

    /* Fonts
     * ****************************************************************************************/
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }


    /* Children
     * ****************************************************************************************/
    //! VisionLinkView
    VisionLinkView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
