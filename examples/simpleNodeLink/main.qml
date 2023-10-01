import QtQuick
import QtQuickStream
import QtQuick.Dialogs
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * MainWindow of NodeLink example
 * ************************************************************************************************/

Window {
    id: window

    /* Property Declarations
     * ****************************************************************************************/

    property Scene scene: null



    /* Object Properties
     * ****************************************************************************************/

    width: 1280
    height: 960
    visible: true
    title: qsTr("Simple NodeLink Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {

        //! Registr node types and related properties.
        NLNodeRegistry.imports = ["SimpleNodeLink"];
        var nodeID = 0;
        NLNodeRegistry.defaultNode = nodeID;
        NLNodeRegistry.nodeTypes = [
                                      nodeID = "NodeExample"
                                      ];

        NLNodeRegistry.nodeNames = [
                                      nodeID = "NodeExample"
                                      ];

        NLNodeRegistry.nodeIcons = [
                                      nodeID = "\ue4e2"
                                      ];

        NLNodeRegistry.nodeColors = [
                                      nodeID = "#444"
                                      ];

        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink"])
        NLCore.defaultRepo.initRootObject("Scene");
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
    }

    /* Children
     * ****************************************************************************************/

    NLView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }

    //! 2. Save and load handlers
    Rectangle {
        anchors.left:  parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10

        width: 400
        height: 40

        color: "#b0aeab"

        Button {
            text: "Save"

            width: 150
            anchors.left: parent.left
            anchors.margins: 20
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                radius: 5
                color: "#6899e3"
            }

            onClicked: {
                saveDialog.visible = true
            }
        }

        Button {
            text: "Load"
            anchors.right: parent.right
            anchors.margins: 20
            anchors.verticalCenter: parent.verticalCenter

            width: 150
            background: Rectangle {
                radius: 5
                color: "#eb5e65"
            }
            onClicked: loadDialog.visible = true
        }

    }

    //Save
    FileDialog {
        id: saveDialog
        currentFile: "QtQuickStream.QQS.json"
        fileMode: FileDialog.SaveFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            NLCore.defaultRepo.saveToFile(saveDialog.currentFile);
        }
    }

    //! Load
    FileDialog {
        id: loadDialog
        currentFile: "QtQuickStream.QQS.json"
        fileMode: FileDialog.OpenFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            NLCore.defaultRepo.clearObjects();
            NLCore.defaultRepo.loadFromFile(loadDialog.currentFile);
//            window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
        }
    }
}
