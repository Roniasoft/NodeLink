//1
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
                width: Math.min(30, parent.width * 0.6)
                height: Math.min(30, parent.height * 0.6)
                radius: width / 2
                color: "white"  // Always white background
                border.color: "#2A2A2A"  // Always dark gray border
                border.width: 2

                // Inner state indicator - this changes color based on status
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.6
                    height: parent.height * 0.6
                    radius: width / 2

                    // Use the statusColor from nodeData
                    color: node.nodeData ? node.nodeData.statusColor : "#9E9E9E"

                    // Smooth color transitions
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }
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





//2

// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Professional logic gate symbols for dark backgrounds
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     color: "transparent"
//     border.width: 0
//     radius: 0
//     isResizable: false

//     contentItem: Item {
//         Item {
//             id: titleItem
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.top: parent.top
//             anchors.margins: 0
//             height: 0
//             visible: false
//         }

//         // Content Area - Fill entire node with symbols
//         Item {
//             anchors.fill: parent
//             anchors.margins: 0

//             // INPUT NODE: Modern toggle switch
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Input
//                 width: Math.min(50, parent.width * 0.8)
//                 height: Math.min(26, parent.height * 0.4)
//                 radius: height / 2

//                 // Gradient for modern look
//                 gradient: Gradient {
//                     GradientStop {
//                         position: 0.0;
//                         color: node.nodeData.currentState ? "#7EE8A3" : "#5A5D70"
//                     }
//                     GradientStop {
//                         position: 1.0;
//                         color: node.nodeData.currentState ? "#4CAF50" : "#404354"
//                     }
//                 }

//                 border.color: node.nodeData.currentState ? "#4CAF50" : "#76787F"
//                 border.width: 2

//                 // Inner circle slider
//                 Rectangle {
//                     x: node.nodeData.currentState ? parent.width - width - 3 : 3
//                     anchors.verticalCenter: parent.verticalCenter
//                     width: parent.height - 6
//                     height: parent.height - 6
//                     radius: height / 2
//                     color: "#FFFFFF"
//                     border.color: "#E0E0E0"
//                     border.width: 1

//                     Behavior on x {
//                         NumberAnimation { duration: 200 }
//                     }
//                 }

//                 MouseArea {
//                     anchors.fill: parent
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: node.toggleState && node.toggleState()
//                 }
//             }

//             // OUTPUT NODE: Modern LED indicator
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Output
//                 width: Math.min(40, parent.width * 0.7)
//                 height: Math.min(40, parent.height * 0.7)
//                 radius: width / 2

//                 // LED gradient with glow effect
//                 gradient: Gradient {
//                     GradientStop {
//                         position: 0.0;
//                         color: {
//                             if (node.nodeData.displayValue === "ON") return "#8BC34A";
//                             if (node.nodeData.displayValue === "OFF") return "#F44336";
//                             return "#9E9E9E";
//                         }
//                     }
//                     GradientStop {
//                         position: 1.0;
//                         color: {
//                             if (node.nodeData.displayValue === "ON") return "#4CAF50";
//                             if (node.nodeData.displayValue === "OFF") return "#D32F2F";
//                             return "#757575";
//                         }
//                     }
//                 }

//                 border.color: "#FFFFFF"
//                 border.width: 2

//                 // LED highlight
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     width: parent.width * 0.4
//                     height: parent.height * 0.2
//                     radius: width / 2
//                     color: "#FFFFFF"
//                     opacity: 0.3
//                 }

//                 // Glow effect when ON
//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: parent.width * 1.8
//                     height: parent.height * 1.8
//                     radius: width / 2
//                     visible: node.nodeData.displayValue === "ON"
//                     color: "#4CAF50"
//                     opacity: 0.15
//                 }
//             }

//             // AND GATE: Professional design with glow
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.AND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     var margin = width * 0.05;
//                     var leftX = margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var centerY = height / 2;
//                     var radius = (height - 2 * margin) / 2;
//                     var flatRightX = width - margin - radius;

//                     // Glow effect
//                     ctx.shadowColor = "#4CAF50";
//                     ctx.shadowBlur = 8;
//                     ctx.shadowOffsetX = 0;
//                     ctx.shadowOffsetY = 0;

//                     // Gate body with gradient
//                     var gradient = ctx.createLinearGradient(0, 0, width, height);
//                     gradient.addColorStop(0, "#5D5D5D");
//                     gradient.addColorStop(1, "#3A3A3A");

//                     ctx.fillStyle = gradient;
//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 2;

//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();

//                     // Remove shadow for border
//                     ctx.shadowBlur = 0;
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // OR GATE: Professional curved design
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.OR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     var margin = width * 0.05;
//                     var leftX = margin;
//                     var rightX = width - margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var midY = height / 2;

//                     // Glow effect
//                     ctx.shadowColor = "#2196F3";
//                     ctx.shadowBlur = 8;

//                     // Gate body with gradient
//                     var gradient = ctx.createLinearGradient(0, 0, width, height);
//                     gradient.addColorStop(0, "#5D5D5D");
//                     gradient.addColorStop(1, "#3A3A3A");

//                     ctx.fillStyle = gradient;
//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 2;

//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.fill();

//                     // Remove shadow for border
//                     ctx.shadowBlur = 0;
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NOT GATE: Modern triangle design
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOT

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     var margin = width * 0.05;
//                     var leftX = margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var midY = height / 2;
//                     var triangleRight = width - margin - (width * 0.2);
//                     var bubbleRadius = Math.min(6, height * 0.1);

//                     // Glow effect
//                     ctx.shadowColor = "#FF9800";
//                     ctx.shadowBlur = 8;

//                     // Gate body with gradient
//                     var gradient = ctx.createLinearGradient(0, 0, width, height);
//                     gradient.addColorStop(0, "#5D5D5D");
//                     gradient.addColorStop(1, "#3A3A3A");

//                     ctx.fillStyle = gradient;
//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 2;

//                     // Triangle
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(triangleRight, midY);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(triangleRight + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();

//                     // Remove shadow for borders
//                     ctx.shadowBlur = 0;

//                     // Stroke both shapes
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(triangleRight, midY);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.stroke();

//                     ctx.beginPath();
//                     ctx.arc(triangleRight + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NOR GATE: OR with inverted output
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     var margin = width * 0.05;
//                     var leftX = margin;
//                     var rightX = width - margin - (width * 0.15);
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var midY = height / 2;
//                     var bubbleRadius = Math.min(6, height * 0.1);

//                     // Glow effect
//                     ctx.shadowColor = "#9C27B0";
//                     ctx.shadowBlur = 8;

//                     // Gate body with gradient
//                     var gradient = ctx.createLinearGradient(0, 0, width, height);
//                     gradient.addColorStop(0, "#5D5D5D");
//                     gradient.addColorStop(1, "#3A3A3A");

//                     ctx.fillStyle = gradient;
//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 2;

//                     // OR shape
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.fill();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(rightX + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();

//                     // Remove shadow for borders
//                     ctx.shadowBlur = 0;

//                     // Stroke both shapes
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.stroke();

//                     ctx.beginPath();
//                     ctx.arc(rightX + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NAND GATE: AND with inverted output
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NAND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     var margin = width * 0.05;
//                     var leftX = margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var centerY = height / 2;
//                     var radius = (height - 2 * margin) / 2;
//                     var flatRightX = width - margin - radius - (width * 0.15);
//                     var bubbleRadius = Math.min(6, height * 0.1);

//                     // Glow effect
//                     ctx.shadowColor = "#FF5722";
//                     ctx.shadowBlur = 8;

//                     // Gate body with gradient
//                     var gradient = ctx.createLinearGradient(0, 0, width, height);
//                     gradient.addColorStop(0, "#5D5D5D");
//                     gradient.addColorStop(1, "#3A3A3A");

//                     ctx.fillStyle = gradient;
//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 2;

//                     // AND shape
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(flatRightX + radius + bubbleRadius * 1.5, centerY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();

//                     // Remove shadow for borders
//                     ctx.shadowBlur = 0;

//                     // Stroke both shapes
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.stroke();

//                     ctx.beginPath();
//                     ctx.arc(flatRightX + radius + bubbleRadius * 1.5, centerY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }
//         }
//     }
// }


//3

// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Realistic physical logic gate components
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     color: "transparent"
//     border.width: 0
//     radius: 0
//     isResizable: false

//     contentItem: Item {
//         Item {
//             id: titleItem
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.top: parent.top
//             anchors.margins: 0
//             height: 0
//             visible: false
//         }

//         // Content Area - Fill entire node with symbols
//         Item {
//             anchors.fill: parent
//             anchors.margins: 0

//             // INPUT NODE: Realistic toggle switch
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Input
//                 width: Math.min(24, parent.width * 0.6)
//                 height: Math.min(44, parent.height * 0.8)
//                 radius: 3

//                 // Switch body - black plastic
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 0.5; color: "#1A1A1A" }
//                     GradientStop { position: 1.0; color: "#2A2A2A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 1

//                 // Switch lever
//                 Rectangle {
//                     id: switchLever
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     y: node.nodeData.currentState ? 6 : parent.height - height - 6
//                     width: parent.width - 8
//                     height: 12
//                     radius: 2
//                     color: node.nodeData.currentState ? "#4CAF50" : "#757575"
//                     border.color: "#E0E0E0"
//                     border.width: 1

//                     Behavior on y {
//                         NumberAnimation { duration: 150 }
//                     }
//                 }

//                 // Switch contacts
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     width: 4
//                     height: 8
//                     color: "#CCCCCC"
//                 }

//                 Rectangle {
//                     anchors.bottom: parent.bottom
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     width: 4
//                     height: 8
//                     color: "#CCCCCC"
//                 }

//                 MouseArea {
//                     anchors.fill: parent
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: node.toggleState && node.toggleState()
//                 }
//             }

//             // OUTPUT NODE: Realistic LED component
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Output
//                 width: Math.min(32, parent.width * 0.6)
//                 height: Math.min(20, parent.height * 0.5)
//                 radius: 2

//                 // LED body - black plastic
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 1.0; color: "#1A1A1A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 1

//                 // LED lens
//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: parent.width - 8
//                     height: parent.height - 6
//                     radius: 3

//                     // LED color with realistic gradient
//                     gradient: Gradient {
//                         GradientStop {
//                             position: 0.0;
//                             color: {
//                                 if (node.nodeData.displayValue === "ON") return "#8BC34A";
//                                 if (node.nodeData.displayValue === "OFF") return "#D32F2F";
//                                 return "#9E9E9E";
//                             }
//                         }
//                         GradientStop {
//                             position: 0.7;
//                             color: {
//                                 if (node.nodeData.displayValue === "ON") return "#4CAF50";
//                                 if (node.nodeData.displayValue === "OFF") return "#B71C1C";
//                                 return "#757575";
//                             }
//                         }
//                     }
//                     border.color: "#202020"
//                     border.width: 1

//                     // LED highlight
//                     Rectangle {
//                         anchors.top: parent.top
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         width: parent.width * 0.6
//                         height: parent.height * 0.3
//                         radius: width / 2
//                         color: "#FFFFFF"
//                         opacity: 0.4
//                     }
//                 }

//                 // LED pins
//                 Rectangle {
//                     anchors.top: parent.bottom
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     width: 2
//                     height: 8
//                     color: "#CCCCCC"
//                 }
//             }

//             // AND GATE: Realistic DIP (Dual In-line Package) IC
//             Rectangle {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.AND
//                 radius: 4

//                 // IC body - black plastic
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 0.3; color: "#1A1A1A" }
//                     GradientStop { position: 1.0; color: "#2A2A2A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 2

//                 // IC notch
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.left: parent.left
//                     width: 12
//                     height: 4
//                     color: "#404040"
//                     radius: 2
//                 }

//                 // AND symbol inside IC
//                 Canvas {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.7
//                     height: parent.height * 0.7

//                     onPaint: {
//                         var ctx = getContext("2d");
//                         ctx.reset();
//                         ctx.clearRect(0, 0, width, height);

//                         ctx.strokeStyle = "#E0E0E0";
//                         ctx.lineWidth = 2;
//                         ctx.fillStyle = "transparent";

//                         var leftX = 5;
//                         var topY = 5;
//                         var bottomY = height - 5;
//                         var centerY = height / 2;
//                         var radius = (height - 10) / 2;
//                         var flatRightX = width - 5 - radius;

//                         ctx.beginPath();
//                         ctx.moveTo(leftX, topY);
//                         ctx.lineTo(flatRightX, topY);
//                         ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                         ctx.lineTo(leftX, bottomY);
//                         ctx.stroke();
//                     }
//                 }

//                 // IC pins (left side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: -3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }

//                 // IC pins (right side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: parent.width - 3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }
//             }

//             // OR GATE: Realistic DIP IC
//             Rectangle {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.OR
//                 radius: 4

//                 // IC body
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 0.3; color: "#1A1A1A" }
//                     GradientStop { position: 1.0; color: "#2A2A2A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 2

//                 // IC notch
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.left: parent.left
//                     width: 12
//                     height: 4
//                     color: "#404040"
//                     radius: 2
//                 }

//                 // OR symbol inside IC
//                 Canvas {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.7
//                     height: parent.height * 0.7

//                     onPaint: {
//                         var ctx = getContext("2d");
//                         ctx.reset();
//                         ctx.clearRect(0, 0, width, height);

//                         ctx.strokeStyle = "#E0E0E0";
//                         ctx.lineWidth = 2;
//                         ctx.fillStyle = "transparent";

//                         var leftX = 5;
//                         var rightX = width - 5;
//                         var topY = 5;
//                         var bottomY = height - 5;
//                         var midY = height / 2;

//                         ctx.beginPath();
//                         ctx.moveTo(leftX, topY);
//                         ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                         ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                         ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                         ctx.stroke();
//                     }
//                 }

//                 // IC pins (left side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: -3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }

//                 // IC pins (right side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: parent.width - 3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }
//             }

//             // NOT GATE: Realistic DIP IC
//             Rectangle {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOT
//                 radius: 4

//                 // IC body
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 0.3; color: "#1A1A1A" }
//                     GradientStop { position: 1.0; color: "#2A2A2A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 2

//                 // IC notch
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.left: parent.left
//                     width: 12
//                     height: 4
//                     color: "#404040"
//                     radius: 2
//                 }

//                 // NOT symbol inside IC
//                 Canvas {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.7
//                     height: parent.height * 0.7

//                     onPaint: {
//                         var ctx = getContext("2d");
//                         ctx.reset();
//                         ctx.clearRect(0, 0, width, height);

//                         ctx.strokeStyle = "#E0E0E0";
//                         ctx.lineWidth = 2;
//                         ctx.fillStyle = "transparent";

//                         var leftX = 5;
//                         var topY = 5;
//                         var bottomY = height - 5;
//                         var midY = height / 2;
//                         var triangleRight = width - 15;
//                         var bubbleRadius = 4;

//                         // Triangle
//                         ctx.beginPath();
//                         ctx.moveTo(leftX, topY);
//                         ctx.lineTo(triangleRight, midY);
//                         ctx.lineTo(leftX, bottomY);
//                         ctx.stroke();

//                         // Bubble
//                         ctx.beginPath();
//                         ctx.arc(triangleRight + 6, midY, bubbleRadius, 0, Math.PI * 2);
//                         ctx.stroke();
//                     }
//                 }

//                 // IC pins (left side)
//                 Repeater {
//                     model: 2
//                     Rectangle {
//                         x: -3
//                         y: (parent.height / 3) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }

//                 // IC pins (right side)
//                 Repeater {
//                     model: 2
//                     Rectangle {
//                         x: parent.width - 3
//                         y: (parent.height / 3) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }
//             }

//             // NOR GATE: Realistic DIP IC
//             Rectangle {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOR
//                 radius: 4

//                 // IC body
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 0.3; color: "#1A1A1A" }
//                     GradientStop { position: 1.0; color: "#2A2A2A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 2

//                 // IC notch
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.left: parent.left
//                     width: 12
//                     height: 4
//                     color: "#404040"
//                     radius: 2
//                 }

//                 // NOR symbol inside IC
//                 Canvas {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.7
//                     height: parent.height * 0.7

//                     onPaint: {
//                         var ctx = getContext("2d");
//                         ctx.reset();
//                         ctx.clearRect(0, 0, width, height);

//                         ctx.strokeStyle = "#E0E0E0";
//                         ctx.lineWidth = 2;
//                         ctx.fillStyle = "transparent";

//                         var leftX = 5;
//                         var rightX = width - 15;
//                         var topY = 5;
//                         var bottomY = height - 5;
//                         var midY = height / 2;
//                         var bubbleRadius = 4;

//                         // OR shape
//                         ctx.beginPath();
//                         ctx.moveTo(leftX, topY);
//                         ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                         ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                         ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                         ctx.stroke();

//                         // Bubble
//                         ctx.beginPath();
//                         ctx.arc(rightX + 6, midY, bubbleRadius, 0, Math.PI * 2);
//                         ctx.stroke();
//                     }
//                 }

//                 // IC pins (left side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: -3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }

//                 // IC pins (right side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: parent.width - 3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }
//             }

//             // NAND GATE: Realistic DIP IC
//             Rectangle {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NAND
//                 radius: 4

//                 // IC body
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: "#2A2A2A" }
//                     GradientStop { position: 0.3; color: "#1A1A1A" }
//                     GradientStop { position: 1.0; color: "#2A2A2A" }
//                 }
//                 border.color: "#404040"
//                 border.width: 2

//                 // IC notch
//                 Rectangle {
//                     anchors.top: parent.top
//                     anchors.left: parent.left
//                     width: 12
//                     height: 4
//                     color: "#404040"
//                     radius: 2
//                 }

//                 // NAND symbol inside IC
//                 Canvas {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.7
//                     height: parent.height * 0.7

//                     onPaint: {
//                         var ctx = getContext("2d");
//                         ctx.reset();
//                         ctx.clearRect(0, 0, width, height);

//                         ctx.strokeStyle = "#E0E0E0";
//                         ctx.lineWidth = 2;
//                         ctx.fillStyle = "transparent";

//                         var leftX = 5;
//                         var topY = 5;
//                         var bottomY = height - 5;
//                         var centerY = height / 2;
//                         var radius = (height - 10) / 2;
//                         var flatRightX = width - 15 - radius;
//                         var bubbleRadius = 4;

//                         // AND shape
//                         ctx.beginPath();
//                         ctx.moveTo(leftX, topY);
//                         ctx.lineTo(flatRightX, topY);
//                         ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                         ctx.lineTo(leftX, bottomY);
//                         ctx.stroke();

//                         // Bubble
//                         ctx.beginPath();
//                         ctx.arc(flatRightX + radius + 6, centerY, bubbleRadius, 0, Math.PI * 2);
//                         ctx.stroke();
//                     }
//                 }

//                 // IC pins (left side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: -3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }

//                 // IC pins (right side)
//                 Repeater {
//                     model: 4
//                     Rectangle {
//                         x: parent.width - 3
//                         y: (parent.height / 5) * (index + 1) - 2
//                         width: 6
//                         height: 4
//                         radius: 1
//                         color: "#CCCCCC"
//                         border.color: "#999999"
//                         border.width: 1
//                     }
//                 }
//             }
//         }
//     }
// }




//4
// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Pure logic gate symbols without containers
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     color: "transparent"
//     border.width: 0
//     radius: 0
//     isResizable: false

//     contentItem: Item {
//         Item {
//             id: titleItem
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.top: parent.top
//             anchors.margins: 0
//             height: 0
//             visible: false
//         }

//         // Content Area - Fill entire node with symbols
//         Item {
//             anchors.fill: parent
//             anchors.margins: 0

//             // INPUT NODE: Simple toggle indicator
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Input
//                 width: Math.min(30, parent.width * 0.6)
//                 height: Math.min(30, parent.height * 0.6)
//                 radius: width / 2
//                 color: node.nodeData.currentState ? "#4CAF50" : "#757575"
//                 border.color: "#E0E0E0"
//                 border.width: 2

//                 MouseArea {
//                     anchors.fill: parent
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: node.toggleState && node.toggleState()
//                 }
//             }

//             // OUTPUT NODE: Simple LED indicator
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Output
//                 width: Math.min(30, parent.width * 0.6)
//                 height: Math.min(30, parent.height * 0.6)
//                 radius: width / 2
//                 color: node.nodeData.displayValue === "ON" ? "#4CAF50" :
//                        node.nodeData.displayValue === "OFF" ? "#F44336" : "#757575"
//                 border.color: "#E0E0E0"
//                 border.width: 2
//             }

//             // AND GATE: Pure D-shape symbol
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.AND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 3;
//                     ctx.fillStyle = "#2A2A2A";

//                     var leftX = 5;
//                     var topY = 5;
//                     var bottomY = height - 5;
//                     var centerY = height / 2;
//                     var radius = (height - 10) / 2;
//                     var flatRightX = width - 5 - radius;

//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // OR GATE: Pure curved shape
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.OR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 3;
//                     ctx.fillStyle = "#2A2A2A";

//                     var leftX = 5;
//                     var rightX = width - 5;
//                     var topY = 5;
//                     var bottomY = height - 5;
//                     var midY = height / 2;

//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NOT GATE: Pure triangle with bubble
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOT

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 3;
//                     ctx.fillStyle = "#2A2A2A";

//                     var leftX = 5;
//                     var topY = 5;
//                     var bottomY = height - 5;
//                     var midY = height / 2;
//                     var triangleRight = width - 15;
//                     var bubbleRadius = 5;

//                     // Triangle
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(triangleRight, midY);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(triangleRight + 8, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NOR GATE: Pure OR shape with bubble
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 3;
//                     ctx.fillStyle = "#2A2A2A";

//                     var leftX = 5;
//                     var rightX = width - 15;
//                     var topY = 5;
//                     var bottomY = height - 5;
//                     var midY = height / 2;
//                     var bubbleRadius = 5;

//                     // OR shape
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(rightX + 8, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NAND GATE: Pure AND shape with bubble
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NAND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "#E0E0E0";
//                     ctx.lineWidth = 3;
//                     ctx.fillStyle = "#2A2A2A";

//                     var leftX = 5;
//                     var topY = 5;
//                     var bottomY = height - 5;
//                     var centerY = height / 2;
//                     var radius = (height - 10) / 2;
//                     var flatRightX = width - 15 - radius;
//                     var bubbleRadius = 5;

//                     // AND shape
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(flatRightX + radius + 8, centerY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }
//         }
//     }
// }




//5
// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Classic white-filled logic gate symbols with black borders
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     color: "transparent"
//     border.width: 0
//     radius: 0
//     isResizable: false

//     contentItem: Item {
//         Item {
//             id: titleItem
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.top: parent.top
//             anchors.margins: 0
//             height: 0
//             visible: false
//         }

//         // Content Area - Fill entire node with symbols
//         Item {
//             anchors.fill: parent
//             anchors.margins: 0

//             // INPUT NODE: Clean circle with state indication
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Input
//                 width: Math.min(24, parent.width * 0.5)
//                 height: Math.min(24, parent.height * 0.5)
//                 radius: width / 2
//                 color: "white"
//                 border.color: "black"
//                 border.width: 2

//                 // Inner state indicator
//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.6
//                     height: parent.height * 0.6
//                     radius: width / 2
//                     color: node.nodeData.currentState ? "#4CAF50" : "#F44336"
//                 }

//                 MouseArea {
//                     anchors.fill: parent
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: node.toggleState && node.toggleState()
//                 }
//             }

//             // OUTPUT NODE: Clean circle with state indication
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Output
//                 width: Math.min(24, parent.width * 0.5)
//                 height: Math.min(24, parent.height * 0.5)
//                 radius: width / 2
//                 color: "white"
//                 border.color: "black"
//                 border.width: 2

//                 // Inner state indicator
//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: parent.width * 0.6
//                     height: parent.height * 0.6
//                     radius: width / 2
//                     color: node.nodeData.displayValue === "ON" ? "#4CAF50" :
//                            node.nodeData.displayValue === "OFF" ? "#F44336" : "#9E9E9E"
//                 }
//             }

//             // AND GATE: Classic D-shape with white fill and black border
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.AND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;
//                     ctx.fillStyle = "white";

//                     var margin = 4;
//                     var leftX = margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var centerY = height / 2;
//                     var radius = (height - 2 * margin) / 2;
//                     var flatRightX = width - margin - radius;

//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // OR GATE: Classic curved shape with white fill and black border
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.OR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;
//                     ctx.fillStyle = "white";

//                     var margin = 4;
//                     var leftX = margin;
//                     var rightX = width - margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var midY = height / 2;

//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NOT GATE: Classic triangle with bubble, white fill and black border
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOT

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;
//                     ctx.fillStyle = "white";

//                     var margin = 4;
//                     var leftX = margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var midY = height / 2;
//                     var triangleRight = width - 20;
//                     var bubbleRadius = 4;

//                     // Triangle
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(triangleRight, midY);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // Bubble (filled white with black border)
//                     ctx.beginPath();
//                     ctx.arc(triangleRight + 10, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NOR GATE: OR shape with output bubble, white fill and black border
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;
//                     ctx.fillStyle = "white";

//                     var margin = 4;
//                     var leftX = margin;
//                     var rightX = width - 20;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var midY = height / 2;
//                     var bubbleRadius = 4;

//                     // OR shape
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.quadraticCurveTo(rightX, topY, rightX, midY);
//                     ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
//                     ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(rightX + 10, midY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }

//             // NAND GATE: AND shape with output bubble, white fill and black border
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NAND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;
//                     ctx.fillStyle = "white";

//                     var margin = 4;
//                     var leftX = margin;
//                     var topY = margin;
//                     var bottomY = height - margin;
//                     var centerY = height / 2;
//                     var radius = (height - 2 * margin) / 2;
//                     var flatRightX = width - 20 - radius;
//                     var bubbleRadius = 4;

//                     // AND shape
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(flatRightX, topY);
//                     ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(flatRightX + radius + 10, centerY, bubbleRadius, 0, Math.PI * 2);
//                     ctx.fill();
//                     ctx.stroke();
//                 }

//                 onWidthChanged: requestPaint()
//                 onHeightChanged: requestPaint()
//             }
//         }
//     }
// }
