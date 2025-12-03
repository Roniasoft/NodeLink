import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import Multiple3DEditors

/*! ***********************************************************************************************
 * MainWindow of Multiple 3D Editors example
 * ************************************************************************************************/

Window {
    id: window

    /* Property Declarations
     * ****************************************************************************************/

    property Multiple3DEditorsScene scene: Multiple3DEditorsScene { }

    /* Object Properties
     * ****************************************************************************************/

    width: 1600
    height: 1000
    visible: true
    title: qsTr("Multiple 3D Editors")
    color: "#1e1e1e"

    // Material theme is set in the QML engine

    Component.onCompleted: {
        // Scene initialized
    }

    /* Children
     * ****************************************************************************************/

    //! Load Font Awesome fonts for icons
    FontLoader {
        id: fontAwesomeRegular
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        id: fontAwesomeSolid
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }

    Multiple3DEditorsView {
        id: view3D
        scene: window.scene
        anchors.fill: parent
    }
}

