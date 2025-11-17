import QtQuick
import QtQuick.Controls

import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * LogicCircuitNodeView - Shows only official gate symbols without rectangles
 * ************************************************************************************************/
NodeView {
    id: nodeView

    // Remove rectangle background from I_NodeView
    color: "transparent"
    border.width: 0
    radius: 0
    isResizable: false

    // Remove the header by making it invisible and setting height to 0
    contentItem: Item {
        // Make header invisible but keep structure for ports
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 0
            height: 0
            visible: false
        }

        // Content Area - Fill entire node with symbols
        Item {
            anchors.fill: parent
            anchors.margins: 0

            // INPUT NODE: Toggle switch
            Rectangle {
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.Input
                width: Math.min(44, parent.width * 0.8)
                height: Math.min(22, parent.height * 0.4)
                radius: height / 2
                color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
                border.color: Qt.darker(color, 1.2)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: node.nodeData.currentState ? "ON" : "OFF"
                    color: "#1E1E2E"
                    font.bold: true
                    font.pixelSize: Math.max(8, parent.height * 0.4)
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: node.toggleState && node.toggleState()
                }
            }

            // OUTPUT NODE: Lamp indicator
            Rectangle {
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.Output
                width: Math.min(34, parent.width * 0.6)
                height: Math.min(34, parent.height * 0.6)
                radius: width / 2
                color: node.nodeData.displayValue === "ON" ? "#4CAF50" :
                       node.nodeData.displayValue === "OFF" ? "#E53935" : "#757575"
                border.color: Qt.darker(color, 1.3)
                border.width: 2
            }

            // AND GATE: Official D-shaped symbol - SCALED
            Canvas {
                anchors.fill: parent
                visible: node.type === LSpecs.NodeType.AND

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05; // 5% margin
                    var leftX = margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var centerY = height / 2;
                    var radius = (height - 2 * margin) / 2;
                    var flatRightX = width - margin - radius;

                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.lineTo(flatRightX, topY);
                    ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
                    ctx.lineTo(leftX, bottomY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }

            // OR GATE: Perfect curved shape - SCALED
            Canvas {
                anchors.fill: parent
                visible: node.type === LSpecs.NodeType.OR

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var rightX = width - margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var midY = height / 2;

                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.quadraticCurveTo(rightX, topY, rightX, midY);
                    ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
                    ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }

            // NOT GATE: Triangle with bubble - SCALED
            Canvas {
                anchors.fill: parent
                visible: node.type === LSpecs.NodeType.NOT

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var midY = height / 2;
                    var triangleRight = width - margin - (width * 0.2); // Leave 20% for bubble
                    var bubbleRadius = Math.min(6, height * 0.1);

                    // Triangle
                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.lineTo(triangleRight, midY);
                    ctx.lineTo(leftX, bottomY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();

                    // Bubble
                    ctx.beginPath();
                    ctx.arc(triangleRight + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.stroke();
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }

            // NOR GATE: OR shape with bubble - SCALED
            Canvas {
                anchors.fill: parent
                visible: node.type === LSpecs.NodeType.NOR

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var rightX = width - margin - (width * 0.15); // Leave space for bubble
                    var topY = margin;
                    var bottomY = height - margin;
                    var midY = height / 2;
                    var bubbleRadius = Math.min(6, height * 0.1);

                    // OR shape
                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.quadraticCurveTo(rightX, topY, rightX, midY);
                    ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
                    ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();

                    // Bubble
                    ctx.beginPath();
                    ctx.arc(rightX + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.stroke();
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }

            // NAND GATE: AND shape with bubble - SCALED
            Canvas {
                anchors.fill: parent
                visible: node.type === LSpecs.NodeType.NAND

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var centerY = height / 2;
                    var radius = (height - 2 * margin) / 2;
                    var flatRightX = width - margin - radius - (width * 0.15); // Leave space for bubble
                    var bubbleRadius = Math.min(6, height * 0.1);

                    // AND shape
                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.lineTo(flatRightX, topY);
                    ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
                    ctx.lineTo(leftX, bottomY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();

                    // Bubble
                    ctx.beginPath();
                    ctx.arc(flatRightX + radius + bubbleRadius * 1.5, centerY, bubbleRadius, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.stroke();
                }

                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }
        }
    }
}

















