import QtQuick
import QtQuick.Controls

import NodeLink
import Simple3DNodeLink

/*! ***********************************************************************************************
 * Simple3DNodeLinkNodeView2D - 2D view component for nodes in 3D space
 * This is used as a texture source for 3D models
 * Uses the same structure as CalculatorNodeView
 * ************************************************************************************************/

Rectangle {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    property var node  // Use 'node' instead of 'nodeData' to match I_NodeView convention
    property var scene

    /* Object Properties
     * ****************************************************************************************/
    color: node?.guiConfig?.color ?? "#666666"
    border.color: node?.selected ? "#FFC107" : Qt.darker(node?.guiConfig?.color ?? "#666666", 1.2)
    border.width: 2
    radius: 8

    /* Children
     * ****************************************************************************************/
    
    // Title
    Text {
        id: titleText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        height: 20
        text: node?.title ?? "Node"
        color: "white"
        font.pixelSize: 12
        font.bold: true
        elide: Text.ElideRight
    }
    
    // Content area - Display different content based on node type
    Rectangle {
        id: contentArea
        anchors.top: titleText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        anchors.topMargin: 4
        color: Qt.darker(node?.guiConfig?.color ?? "#666666", 1.1)
        radius: 4
        
        // Main content - Icon and data
        Column {
            anchors.centerIn: parent
            spacing: 5
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    if (!node || !scene) return "?";
                    return scene.nodeRegistry?.nodeIcons?.[node.type] ?? "?";
                }
                color: "white"
                font.pixelSize: 24
                font.family: "Font Awesome 6 Pro"
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    if (!node || !node.nodeData) return "0";
                    var data = node.nodeData.data;
                    return data !== null && data !== undefined ? String(data) : "0";
                }
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
        }
        
        // Right Ports (Output ports - for SourceNode)
        Column {
            id: rightColumnPort
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: -6
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            spacing: 10
            visible: node && node.type === 0  // Only show for SourceNode
            
            Repeater {
                model: node ? Object.values(node.ports || {}).filter(port => port.portSide === NLSpec.PortPositionSide.Right) : []
                delegate: Rectangle {
                    width: 12
                    height: 12
                    radius: width / 2
                    color: modelData?.color ?? "#4CAF50"
                    border.color: "white"
                    border.width: 1
                }
            }
        }
        
        // Left Ports (Input ports - for ResultNode)
        Column {
            id: leftColumnPort
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: -6
            anchors.topMargin: 20
            anchors.bottomMargin: 20
            spacing: 10
            visible: node && node.type === 1  // Only show for ResultNode
            
            Repeater {
                model: node ? Object.values(node.ports || {}).filter(port => port.portSide === NLSpec.PortPositionSide.Left) : []
                delegate: Rectangle {
                    width: 12
                    height: 12
                    radius: width / 2
                    color: modelData?.color ?? "#2196F3"
                    border.color: "white"
                    border.width: 1
                }
            }
        }
    }
}

