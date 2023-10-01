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
        NLNodeRegistry.imports = ["NodeLink"]
        NLNodeRegistry.defaultNode = SNLSpecs.NodeType.General
        NLNodeRegistry.nodeTypes = [
                                      SNLSpecs.NodeType.General    = "GeneralNode",
                                      SNLSpecs.NodeType.Root       = "RootNode",
                                      SNLSpecs.NodeType.Step       = "StepNode",
                                      SNLSpecs.NodeType.Transition = "TransitionNode",
                                      SNLSpecs.NodeType.Macro      = "MacroNode"
                                      ];

        NLNodeRegistry.nodeNames = [
                                      SNLSpecs.NodeType.General      = "General",
                                      SNLSpecs.NodeType.Root         = "Root",
                                      SNLSpecs.NodeType.Step         = "Step",
                                      SNLSpecs.NodeType.Transition   = "Transition",
                                      SNLSpecs.NodeType.Macro        = "Macro"
                                      ];

        NLNodeRegistry.nodeIcons = [
                                      SNLSpecs.NodeType.General    = "\ue4e2",
                                      SNLSpecs.NodeType.Root       = "\uf04b",
                                      SNLSpecs.NodeType.Step       = "\uf54b",
                                      SNLSpecs.NodeType.Transition = "\ue57f",
                                      SNLSpecs.NodeType.Macro      = "\uf2db"
                                      ];

        NLNodeRegistry.nodeColors = [
                                      SNLSpecs.NodeType.General      = "#444",
                                      SNLSpecs.NodeType.Root         = "#333",
                                      SNLSpecs.NodeType.Step         = "#3D9798",
                                      SNLSpecs.NodeType.Transition   = "#625192",
                                      SNLSpecs.NodeType.Macro        = "#9D9E57"
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
