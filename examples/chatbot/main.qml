import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts

import QtQuickStream
import NodeLink
import Chatbot

/*! ***********************************************************************************************
 * MainWindow of Chatbot example
 * ************************************************************************************************/
Window {
    id: window

    /* Property Declarations
     * ****************************************************************************************/

    //! Scene
    property ChatbotScene scene: null

    /* Object Properties
     * ****************************************************************************************/

    width: 1280
    height: 960
    visible: true
    title: qsTr("Chatbot Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        // Create root object
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "Chatbot"])
        NLCore.defaultRepo.initRootObject("ChatbotScene");
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});

        Qt.callLater(() => {
            if (window.scene) {
                window.scene.botResponse.connect(function(msg) {
                    chatBox.addMessage(msg, false)
                })
            }
        })

    }

    /* Fonts
     * ****************************************************************************************/
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }

    /* Children
     * ****************************************************************************************/

    //! ChatbotView
    RowLayout {
        anchors.fill: parent
        spacing: 4
        anchors.margins: 4

        //! Node-based view (left)
        ChatbotView {
            id: view
            scene: window.scene
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        //! Chat box (right)
        Chatbox {
            id: chatBox
            Layout.preferredWidth: 400
            Layout.fillHeight: true
            onUserMessageSent: {
                console.log("User message:", message)

                let sourceNode = Object.values(window.scene.nodes).find(n => n.type === 0)
                if (sourceNode) {
                    sourceNode.nodeData.data = message
                    window.scene.updateData()
                }
            }
        }
    }
}
