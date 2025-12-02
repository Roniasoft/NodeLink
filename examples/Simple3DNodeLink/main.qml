import QtQuick
import QtQuickStream
import QtQuick.Controls
import QtQuick.Controls.Material

import NodeLink
import Simple3DNodeLink

/*! ***********************************************************************************************
 * MainWindow of NodeLink 3D Quick Scene example
 * ************************************************************************************************/

Window {
    id: window

    /* Property Declarations
     * ****************************************************************************************/

    property Simple3DNodeLinkScene scene: Simple3DNodeLinkScene { }

    //! nodeRegistry: Use nodeRegistry in the main scene (we need one object)
    property NLNodeRegistry nodeRegistry: NLNodeRegistry {
        _qsRepo: NLCore.defaultRepo

        imports: ["Simple3DNodeLink","NodeLink"];
        defaultNode: 0
    }

    /* Object Properties
     * ****************************************************************************************/

    width: 1400
    height: 1000
    visible: true
    title: qsTr("NodeLink 3D Quick Scene Example")
    color: "#1e1e1e"

    // Material theme is set in the QML engine

    Component.onCompleted: {
        // Prepare nodeRegistry
        var nodeType = 0;
        nodeRegistry.nodeTypes[nodeType] = "SourceNode";
        nodeRegistry.nodeNames[nodeType] = "Source Node";
        nodeRegistry.nodeIcons[nodeType] = "\uf1c0";
        nodeRegistry.nodeColors[nodeType] = "#4CAF50";

        nodeRegistry.nodeTypes[nodeType + 1] = "ResultNode";
        nodeRegistry.nodeNames[nodeType + 1] = "Result Node";
        nodeRegistry.nodeIcons[nodeType + 1] = "\uf06e";
        nodeRegistry.nodeColors[nodeType + 1] = "#2196F3";

        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "Simple3DNodeLink"])
        NLCore.defaultRepo.initRootObject("Simple3DNodeLinkScene");

        //Set registry to scene
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
        window.scene.nodeRegistry = Qt.binding(function() { return window.nodeRegistry});
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

    Simple3DNodeLinkView {
        id: view3D
        scene: window.scene
        anchors.fill: parent
    }

    //! Help Panel - Instructions for keyboard and mouse controls
    Rectangle {
        id: helpPanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20
        width: 300
        height: helpContent.height + 40
        color: "#2a2a2a"
        radius: 8
        border.color: "#555"
        border.width: 1
        visible: false
        z: 1000

        Column {
            id: helpContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 15
            spacing: 10

            Text {
                text: "Controls"
                color: "white"
                font.pixelSize: 16
                font.bold: true
            }

            Text {
                text: "Camera Movement:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "W / S - Move forward/backward\nQ / E - Move left/right\nShift / Space - Move up/down\nR / T - Rotate camera up/down"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Mouse:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "Right Click - Context menu\nCtrl + Right Click + Drag - Rotate camera\nDouble Click - Create node"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    //! Simple Side Menu (Undo/Redo and Help only)
    Item {
        id: simpleSideMenu
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        width: 40
        height: undoRedoGroup.height + helpButtonGroup.height + 8
        z: 1000

        //! Undo/Redo Button Group
        SideMenuButtonGroup {
            id: undoRedoGroup
            anchors.top: parent.top
            width: 40
            SideMenuButton {
                id: undoButton
                text: "\ue455"
                position: "top"
                width: 40
                height: 40
                opacity: (window.scene?._undoCore?.undoStack.isValidUndo ?? false) ? 1.0 : 0.4
                NLToolTip {
                    visible: parent.hovered
                    text: "Undo"
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutQuad
                    }
                }
                onClicked: {
                    if(window.scene?._undoCore?.undoStack.isValidUndo){
                        window.scene._undoCore.undoStack.undo()
                    }
                }
            }
            SideMenuButton {
                id: redoButton
                text: "\ue331"
                position: "bottom"
                width: 40
                height: 40
                opacity: (window.scene?._undoCore?.undoStack.isValidRedo ?? false) ? 1.0 : 0.4
                NLToolTip {
                    visible: parent.hovered
                    text: "Redo"
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutQuad
                    }
                }
                onClicked: {
                    if(window.scene?._undoCore?.undoStack.isValidRedo){
                        window.scene._undoCore.undoStack.redo()
                    }
                }
            }
        }

        //! Help Button
        SideMenuButtonGroup {
            id: helpButtonGroup
            anchors.top: undoRedoGroup.bottom
            anchors.topMargin: 8
            width: 40
            SideMenuButton {
                id: helpButton
                text: "\uf60b"
                position: "only"
                width: 40
                height: 40
                checkable: true
                checked: helpPanel.visible
                NLToolTip {
                    visible: parent.hovered
                    text: helpPanel.visible ? "Hide Help" : "Show Help"
                }
                onClicked: {
                    helpPanel.visible = !helpPanel.visible
                }
            }
        }

        //! Connection to update undo/redo button states
        Connections {
            target: window.scene?._undoCore?.undoStack ?? null
            function onUndoRedoDone() {
                undoButton.opacity = (window.scene?._undoCore?.undoStack.isValidUndo ?? false) ? 1.0 : 0.4
                redoButton.opacity = (window.scene?._undoCore?.undoStack.isValidRedo ?? false) ? 1.0 : 0.4
            }
        }
    }
}

