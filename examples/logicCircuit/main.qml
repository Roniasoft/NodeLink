import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls

import QtQuickStream
import NodeLink
import LogicCircuit

Window {
    id: window

    property LogicCircuitScene scene: null

    width: 1280
    height: 960
    visible: true
    title: qsTr("Logic Circuit Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "LogicCircuit"])
        NLCore.defaultRepo.initRootObject("LogicCircuitScene");
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
    }

    // Fonts
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }

    //! LogicCircuitView
    LogicCircuitView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
