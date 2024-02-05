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

    //! will be overriden by load
    property Scene scene: Scene { }

    //! nodeRegistry: Use nodeRegistry in the main scene (we need one object)
    property NLNodeRegistry nodeRegistry:      NLNodeRegistry {
        _qsRepo: NLCore.defaultRepo

        imports: ["SimpleNodeLink","NodeLink"];
        defaultNode: 0
    }

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
        // Prepare nodeRegistry
        var nodeType = 0;
        nodeRegistry.nodeTypes[nodeType]  = "NodeExample";
        nodeRegistry.nodeNames[nodeType]  = "NodeExample";
        nodeRegistry.nodeIcons[nodeType]  = "\ue4e2";
        nodeRegistry.nodeColors[nodeType] = "#444";

        nodeRegistry.nodeTypes[nodeType + 1]  = "Container";
        nodeRegistry.nodeNames[nodeType + 1]  = "Container";
        nodeRegistry.nodeIcons[nodeType + 1]  = "\uf247";
        nodeRegistry.nodeColors[nodeType + 1] = NLStyle.primaryColor;

        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "SimpleNodeLink"])
        NLCore.defaultRepo.initRootObject("Scene");

        //Set registry to scene
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
        window.scene.nodeRegistry = Qt.binding(function() { return window.nodeRegistry});
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

    //! Copy nodes shortcut
    Shortcut {
        sequence: "Ctrl+C"
        onActivated: {
            view.copyNodes();
        }
    }

    //! Paste nodes shortcut
    Shortcut {
        sequence: "Ctrl+V"
        onActivated: {
            view.pasteNodes()
        }
    }

    //! Select all nodes and links
    Shortcut {
        sequence: "Ctrl+A"
        onActivated: scene?.selectionModel.selectAll(scene.nodes, scene.links, scene.containers);
    }

    //! Clones all selected nodes
    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            var copiedNodes = ({});
            var copiedContainers = ({});
            Object.keys(scene?.selectionModel.selectedModel ?? []).forEach(key => {
                if (Object.keys(scene.nodes).includes(key)){

                    var copiedNode = scene?.cloneNode(key);
                    copiedNodes[copiedNode._qsUuid] = copiedNode;
                }

                if (Object.keys(scene?.containers).includes(key)){
                    var copiedContainer = scene?.cloneContainer(key);
                    copiedContainers[copiedContainer._qsUuid] = copiedContainer;
                }
            });

            scene?.selectionModel.selectAll(copiedNodes, ({}), copiedContainers);
        }
    }
}
