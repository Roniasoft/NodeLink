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
        defaultNode: Specs.NodeType.Number
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
        // Number node
        nodeRegistry.nodeTypes[Specs.NodeType.Number] = "NumberNode";
        nodeRegistry.nodeNames[Specs.NodeType.Number] = "Number";
        nodeRegistry.nodeIcons[Specs.NodeType.Number] = "\uf1ec";
        nodeRegistry.nodeColors[Specs.NodeType.Number] = "#FF9800";
        
        // Color node
        nodeRegistry.nodeTypes[Specs.NodeType.Color] = "ColorNode";
        nodeRegistry.nodeNames[Specs.NodeType.Color] = "Color";
        nodeRegistry.nodeIcons[Specs.NodeType.Color] = "\uf53f";
        nodeRegistry.nodeColors[Specs.NodeType.Color] = "#E91E63";
        
        // Position node
        nodeRegistry.nodeTypes[Specs.NodeType.Position] = "PositionNode";
        nodeRegistry.nodeNames[Specs.NodeType.Position] = "Position";
        nodeRegistry.nodeIcons[Specs.NodeType.Position] = "\uf041";
        nodeRegistry.nodeColors[Specs.NodeType.Position] = "#9C27B0";
        
        // Rotation node
        nodeRegistry.nodeTypes[Specs.NodeType.Rotation] = "RotationNode";
        nodeRegistry.nodeNames[Specs.NodeType.Rotation] = "Rotation";
        nodeRegistry.nodeIcons[Specs.NodeType.Rotation] = "\uf01e";
        nodeRegistry.nodeColors[Specs.NodeType.Rotation] = "#9C27B0";
        
        // Scale node
        nodeRegistry.nodeTypes[Specs.NodeType.Scale] = "ScaleNode";
        nodeRegistry.nodeNames[Specs.NodeType.Scale] = "Scale";
        nodeRegistry.nodeIcons[Specs.NodeType.Scale] = "\uf31e";
        nodeRegistry.nodeColors[Specs.NodeType.Scale] = "#9C27B0";
        
        // Dimensions node
        nodeRegistry.nodeTypes[Specs.NodeType.Dimensions] = "DimensionsNode";
        nodeRegistry.nodeNames[Specs.NodeType.Dimensions] = "Dimensions";
        nodeRegistry.nodeIcons[Specs.NodeType.Dimensions] = "\uf1b2";
        nodeRegistry.nodeColors[Specs.NodeType.Dimensions] = "#9C27B0";
        
        // Material nodes
        nodeRegistry.nodeTypes[Specs.NodeType.Metal] = "MetalMaterialNode";
        nodeRegistry.nodeNames[Specs.NodeType.Metal] = "Metal";
        nodeRegistry.nodeIcons[Specs.NodeType.Metal] = "\uf0e7";
        nodeRegistry.nodeColors[Specs.NodeType.Metal] = "#607D8B";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Plastic] = "PlasticMaterialNode";
        nodeRegistry.nodeNames[Specs.NodeType.Plastic] = "Plastic";
        nodeRegistry.nodeIcons[Specs.NodeType.Plastic] = "\uf0e7";
        nodeRegistry.nodeColors[Specs.NodeType.Plastic] = "#607D8B";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Glass] = "GlassMaterialNode";
        nodeRegistry.nodeNames[Specs.NodeType.Glass] = "Glass";
        nodeRegistry.nodeIcons[Specs.NodeType.Glass] = "\uf0e7";
        nodeRegistry.nodeColors[Specs.NodeType.Glass] = "#607D8B";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Rubber] = "RubberMaterialNode";
        nodeRegistry.nodeNames[Specs.NodeType.Rubber] = "Rubber";
        nodeRegistry.nodeIcons[Specs.NodeType.Rubber] = "\uf0e7";
        nodeRegistry.nodeColors[Specs.NodeType.Rubber] = "#607D8B";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Wood] = "WoodMaterialNode";
        nodeRegistry.nodeNames[Specs.NodeType.Wood] = "Wood";
        nodeRegistry.nodeIcons[Specs.NodeType.Wood] = "\uf0e7";
        nodeRegistry.nodeColors[Specs.NodeType.Wood] = "#607D8B";
        
        // Shape nodes
        nodeRegistry.nodeTypes[Specs.NodeType.Cube] = "CubeNode";
        nodeRegistry.nodeNames[Specs.NodeType.Cube] = "Cube";
        nodeRegistry.nodeIcons[Specs.NodeType.Cube] = "\uf1b2";
        nodeRegistry.nodeColors[Specs.NodeType.Cube] = "#F44336";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Sphere] = "SphereNode";
        nodeRegistry.nodeNames[Specs.NodeType.Sphere] = "Sphere";
        nodeRegistry.nodeIcons[Specs.NodeType.Sphere] = "\uf111";
        nodeRegistry.nodeColors[Specs.NodeType.Sphere] = "#F44336";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Cylinder] = "CylinderNode";
        nodeRegistry.nodeNames[Specs.NodeType.Cylinder] = "Cylinder";
        nodeRegistry.nodeIcons[Specs.NodeType.Cylinder] = "\uf1b2";
        nodeRegistry.nodeColors[Specs.NodeType.Cylinder] = "#F44336";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Cone] = "ConeNode";
        nodeRegistry.nodeNames[Specs.NodeType.Cone] = "Cone";
        nodeRegistry.nodeIcons[Specs.NodeType.Cone] = "\uf1b2";
        nodeRegistry.nodeColors[Specs.NodeType.Cone] = "#F44336";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Plane] = "PlaneNode";
        nodeRegistry.nodeNames[Specs.NodeType.Plane] = "Plane";
        nodeRegistry.nodeIcons[Specs.NodeType.Plane] = "\uf0c8";
        nodeRegistry.nodeColors[Specs.NodeType.Plane] = "#F44336";
        
        nodeRegistry.nodeTypes[Specs.NodeType.Rectangle] = "RectangleNode";
        nodeRegistry.nodeNames[Specs.NodeType.Rectangle] = "Rectangle";
        nodeRegistry.nodeIcons[Specs.NodeType.Rectangle] = "\uf0c8";
        nodeRegistry.nodeColors[Specs.NodeType.Rectangle] = "#F44336";

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
        anchors.topMargin: 400  // Below node menu
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
                text: "W / S - Move forward/backward\nQ / E - Move left/right\nShift / Space - Move up/down"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Camera Rotation:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "A / D - Rotate left/right\nR / T - Rotate up/down\nCtrl + Right Click + Drag - Rotate camera"
                color: "#ccc"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                text: "Node Creation:"
                color: "#aaa"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: "Double Click - Create node at click position\nRight Click - Context menu"
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

