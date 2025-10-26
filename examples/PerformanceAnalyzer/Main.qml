import QtQuick
import QtQuickStream
import QtQuick.Controls
import NodeLink
import PerformanceAnalyzer

Window {
    id: window

    visible: true
    width: 1280
    height: 960
    title: qsTr("Performance Test Example")
    color: "#1e1e1e"

    property PerformanceScene scene: null
    property int nodeCount: 100

    Component.onCompleted: {
        NLCore.defaultRepo = NLCore.createDefaultRepo([ "QtQuickStream", "PerformanceAnalyzer"])
        NLCore.defaultRepo.initRootObject("PerformanceScene")
        window.scene = Qt.binding(function() {
            return NLCore.defaultRepo.qsRootObject
        })
    }

    PerformanceAnalyzerView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }

    property var startTime
    Button {
        anchors.right: view.right
        anchors.top: view.top
        anchors.topMargin: 50
        anchors.rightMargin: 50
        text: "Start"
        onClicked: {
            nodeCount = 100
            timer.running = true
            startTime = Date.now()
        }
    }
    Timer {
        id: timer
        interval: 1
        running: false
        onTriggered: {
            scene.createPairNode(Math.random() * scene.sceneGuiConfig.contentWidth, Math.random() * scene.sceneGuiConfig.contentHeight, "test_" + nodeCount)
            if (--nodeCount < 0) {
                running = false
                var elapsedTime = Date.now() - startTime
                console.log("Elapsed time: " + elapsedTime + "ms")
            }
        }
        repeat: true
    }

    /* Fonts
     * ****************************************************************************************/
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }


}
