// // // import QtQuick
// // // import QtQuick.Controls

// // // import NodeLink
// // // import LogicCircuit

// // // /*! ***********************************************************************************************
// // //  * LogicCircuitNodeView custom view for logic gates nodes with proper graphics
// // //  * ************************************************************************************************/
// // // NodeView {
// // //     id: nodeView

// // //     contentItem: Item {
// // //         //! Header Item
// // //         Item {
// // //             id: titleItem
// // //             anchors.left: parent.left
// // //             anchors.right: parent.right
// // //             anchors.top: parent.top
// // //             anchors.margins: 12
// // //             height: 20

// // //             //! Icon
// // //             Text {
// // //                 id: iconText
// // //                 font.family: NLStyle.fontType.font6Pro
// // //                 font.pixelSize: 20
// // //                 anchors.left: parent.left
// // //                 anchors.verticalCenter: parent.verticalCenter
// // //                 text: scene.nodeRegistry.nodeIcons[node.type]
// // //                 color: node.guiConfig.color
// // //                 font.weight: 400
// // //             }

// // //             //! Title Text
// // //             Text {
// // //                 anchors.right: parent.right
// // //                 anchors.left: iconText.right
// // //                 anchors.verticalCenter: parent.verticalCenter
// // //                 anchors.leftMargin: 5
// // //                 text: node.title
// // //                 color: NLStyle.primaryTextColor
// // //                 font.pointSize: 10
// // //                 font.bold: true
// // //                 elide: Text.ElideRight
// // //             }
// // //         }

// // //         //! Content Area - Different for each node type
// // //         Item {
// // //             anchors.top: titleItem.bottom
// // //             anchors.right: parent.right
// // //             anchors.bottom: parent.bottom
// // //             anchors.left: parent.left
// // //             anchors.margins: 12
// // //             anchors.topMargin: 5

// // //             // INPUT NODE: Interactive Toggle Switch
// // //             Rectangle {
// // //                 id: inputSwitch
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.Input
// // //                 width: 44
// // //                 height: 22
// // //                 radius: 11
// // //                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
// // //                 border.color: Qt.darker(color, 1.2)
// // //                 border.width: 1

// // //                 Text {
// // //                     anchors.centerIn: parent
// // //                     text: node.nodeData.currentState ? "ON" : "OFF"
// // //                     color: "#1E1E2E"
// // //                     font.bold: true
// // //                     font.pixelSize: 10
// // //                 }

// // //                 MouseArea {
// // //                     anchors.fill: parent
// // //                     cursorShape: Qt.PointingHandCursor
// // //                     onClicked: {
// // //                         if (node.toggleState) {
// // //                             node.toggleState();
// // //                         }
// // //                     }
// // //                 }
// // //             }

// // //             // OUTPUT NODE: Fixed Display Switch
// // //             Rectangle {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.Output
// // //                 width: 44
// // //                 height: 22
// // //                 radius: 11
// // //                 color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
// // //                        node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
// // //                 border.color: Qt.darker(color, 1.2)
// // //                 border.width: 1

// // //                 Text {
// // //                     anchors.centerIn: parent
// // //                     text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
// // //                     color: "#1E1E2E"
// // //                     font.bold: true
// // //                     font.pixelSize: 10
// // //                 }
// // //             }

// // //             // AND GATE: Official AND Gate Symbol
// // //             Canvas {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.AND
// // //                 width: 80
// // //                 height: 60

// // //                 onPaint: {
// // //                     var ctx = getContext("2d");
// // //                     ctx.reset();
// // //                     ctx.strokeStyle = node.guiConfig.color;
// // //                     ctx.lineWidth = 2;
// // //                     ctx.fillStyle = "transparent";

// // //                     // Draw AND gate shape (D-shape)
// // //                     ctx.beginPath();
// // //                     ctx.moveTo(10, 10);
// // //                     ctx.lineTo(50, 10);
// // //                     ctx.arc(50, 30, 20, -Math.PI/2, Math.PI/2, false);
// // //                     ctx.lineTo(10, 50);
// // //                     ctx.closePath();
// // //                     ctx.stroke();

// // //                     // Draw AND symbol
// // //                     ctx.fillStyle = node.guiConfig.color;
// // //                     ctx.font = "bold 16px Arial";
// // //                     ctx.fillText("&", 35, 35);
// // //                 }
// // //             }

// // //             // OR GATE: Official OR Gate Symbol
// // //             Canvas {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.OR
// // //                 width: 80
// // //                 height: 60

// // //                 onPaint: {
// // //                     var ctx = getContext("2d");
// // //                     ctx.reset();
// // //                     ctx.strokeStyle = node.guiConfig.color;
// // //                     ctx.lineWidth = 2;
// // //                     ctx.fillStyle = "transparent";

// // //                     // Draw OR gate shape (curved shape)
// // //                     ctx.beginPath();
// // //                     ctx.moveTo(15, 10);
// // //                     ctx.quadraticCurveTo(40, 30, 15, 50);
// // //                     ctx.quadraticCurveTo(65, 30, 15, 10);
// // //                     ctx.closePath();
// // //                     ctx.stroke();

// // //                     // Draw OR symbol (≥1)
// // //                     ctx.fillStyle = node.guiConfig.color;
// // //                     ctx.font = "bold 14px Arial";
// // //                     ctx.fillText("≥1", 35, 33);
// // //                 }
// // //             }

// // //             // NOT GATE: Official NOT Gate Symbol
// // //             Canvas {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.NOT
// // //                 width: 60
// // //                 height: 60

// // //                 onPaint: {
// // //                     var ctx = getContext("2d");
// // //                     ctx.reset();
// // //                     ctx.strokeStyle = node.guiConfig.color;
// // //                     ctx.lineWidth = 2;
// // //                     ctx.fillStyle = "transparent";

// // //                     // Draw NOT gate triangle
// // //                     ctx.beginPath();
// // //                     ctx.moveTo(10, 10);
// // //                     ctx.lineTo(40, 30);
// // //                     ctx.lineTo(10, 50);
// // //                     ctx.closePath();
// // //                     ctx.stroke();

// // //                     // Draw inversion circle at output
// // //                     ctx.beginPath();
// // //                     ctx.arc(45, 30, 5, 0, Math.PI * 2);
// // //                     ctx.stroke();

// // //                     // Draw NOT symbol (1 at input side)
// // //                     ctx.fillStyle = node.guiConfig.color;
// // //                     ctx.font = "bold 14px Arial";
// // //                     ctx.fillText("1", 20, 35);
// // //                 }
// // //             }
// // //         }
// // //     }
// // // }

// // // import QtQuick
// // // import QtQuick.Controls

// // // import NodeLink
// // // import LogicCircuit

// // // /*! ***********************************************************************************************
// // //  * LogicCircuitNodeView - Shows only official gate symbols without rectangles
// // //  * ************************************************************************************************/
// // // NodeView {
// // //     id: nodeView

// // //      // Remove rectangle background from I_NodeView
// // //     color: "transparent"
// // //     border.width: 0
// // //     radius: 0


// // //     // Remove the header by making it invisible and setting height to 0
// // //     contentItem: Item {
// // //         // Make header invisible but keep structure for ports
// // //         Item {
// // //             id: titleItem
// // //             anchors.left: parent.left
// // //             anchors.right: parent.right
// // //             anchors.top: parent.top
// // //             anchors.margins: 0  // Remove margins
// // //             height: 0  // Make header height 0
// // //             visible: false  // Hide header completely

// // //             Text {
// // //                 id: iconText
// // //                 visible: false
// // //             }

// // //             Text {
// // //                 visible: false
// // //             }
// // //         }

// // //         // Content Area - Fill entire node with symbols
// // //         Item {
// // //             anchors.fill: parent  // Fill entire node space
// // //             anchors.margins: 0    // Remove all margins

// // //             // INPUT NODE: Only the toggle switch
// // //             Rectangle {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.Input
// // //                 width: 44
// // //                 height: 22
// // //                 radius: 11
// // //                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
// // //                 border.color: Qt.darker(color, 1.2)
// // //                 border.width: 1

// // //                 Text {
// // //                     anchors.centerIn: parent
// // //                     text: node.nodeData.currentState ? "ON" : "OFF"
// // //                     color: "#1E1E2E"
// // //                     font.bold: true
// // //                     font.pixelSize: 10
// // //                 }

// // //                 MouseArea {
// // //                     anchors.fill: parent
// // //                     cursorShape: Qt.PointingHandCursor
// // //                     onClicked: {
// // //                         if (node.toggleState) {
// // //                             node.toggleState();
// // //                         }
// // //                     }
// // //                 }
// // //             }

// // //             // OUTPUT NODE: Only the fixed switch
// // //             Rectangle {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.Output
// // //                 width: 44
// // //                 height: 22
// // //                 radius: 11
// // //                 color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
// // //                        node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
// // //                 border.color: Qt.darker(color, 1.2)
// // //                 border.width: 1

// // //                 Text {
// // //                     anchors.centerIn: parent
// // //                     text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
// // //                     color: "#1E1E2E"
// // //                     font.bold: true
// // //                     font.pixelSize: 10
// // //                 }
// // //             }

// // //             // AND GATE: Official AND symbol only
// // //             Canvas {
// // //                 id: canvas
// // //                 anchors.fill: parent  // fill the entire node area
// // //                 visible: node.type === LSpecs.NodeType.AND

// // //                 onPaint: {
// // //                     var ctx = getContext("2d");
// // //                     ctx.reset();
// // //                     ctx.clearRect(0, 0, canvas.width, canvas.height);

// // //                     var w = canvas.width;
// // //                     var h = canvas.height;

// // //                     // Minimum size for the gate to maintain its shape
// // //                     var minSize = 40;
// // //                     var scale = Math.max(Math.min(w, h), minSize) / 60; // 60 = reference size
// // //                     var centerX = w / 2;
// // //                     var centerY = h / 2;

// // //                     // Adjusted width & height for the drawing
// // //                     var drawW = 36 * scale;
// // //                     var drawH = 40 * scale;
// // //                     var leftX = centerX - drawW * 0.5;
// // //                     var rightX = centerX + drawW * 0.5;
// // //                     var topY = centerY - drawH * 0.5;
// // //                     var bottomY = centerY + drawH * 0.5;
// // //                     var arcRadius = drawH * 0.5;

// // //                     ctx.beginPath();
// // //                     ctx.moveTo(leftX, topY);
// // //                     ctx.lineTo(rightX - arcRadius, topY);
// // //                     ctx.arc(rightX - arcRadius, centerY, arcRadius, -Math.PI / 2, Math.PI / 2, false);
// // //                     ctx.lineTo(leftX, bottomY);
// // //                     ctx.closePath();
// // //                     ctx.strokeStyle = node.guiConfig.color;
// // //                     ctx.lineWidth = 2;
// // //                     ctx.stroke();
// // //                 }
// // //             }

// // //             // Canvas {
// // //             //     id: canvas
// // //             //     width: node.guiConfig.width
// // //             //     height: node.guiConfig.height
// // //             //     anchors.centerIn: parent

// // //             //     onPaint: {
// // //             //         var ctx = getContext("2d");
// // //             //         ctx.reset();
// // //             //         ctx.strokeStyle = node.guiConfig.color;
// // //             //         ctx.lineWidth = 2;

// // //             //         var w = canvas.width;
// // //             //         var h = canvas.height;
// // //             //         var s = Math.min(w, h);

// // //             //         ctx.beginPath();
// // //             //         ctx.moveTo(w*0.1, h*0.1);
// // //             //         ctx.lineTo(w*0.6, h*0.1);
// // //             //         ctx.arc(w*0.6, h*0.5, s*0.4, -Math.PI/2, Math.PI/2, false);
// // //             //         ctx.lineTo(w*0.1, h*0.9);
// // //             //         ctx.closePath();
// // //             //         ctx.stroke();
// // //             //     }
// // //             // }

// // //             // OR GATE: Official OR symbol only
// // //             Canvas {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.OR
// // //                 // width: 60
// // //                 // height: 40
// // //                 width: parent.width
// // //                 height: parent.height

// // //                 onPaint: {
// // //                     var ctx = getContext("2d");
// // //                     ctx.reset();
// // //                     ctx.strokeStyle = node.guiConfig.color;
// // //                     ctx.lineWidth = 2;

// // //                     // Draw OR gate shape (curved shape)
// // //                     ctx.beginPath();
// // //                     ctx.moveTo(10, 5);
// // //                     ctx.quadraticCurveTo(30, 20, 10, 35);
// // //                     ctx.quadraticCurveTo(50, 20, 10, 5);
// // //                     ctx.closePath();
// // //                     ctx.stroke();

// // //                     // Draw OR symbol (≥1)
// // //                     ctx.fillStyle = node.guiConfig.color;
// // //                     ctx.font = "bold 12px Arial";
// // //                     ctx.fillText("≥1", 25, 23);
// // //                 }
// // //             }

// // //             // NOT GATE: Official NOT symbol only
// // //             Canvas {
// // //                 anchors.centerIn: parent
// // //                 visible: node.type === LSpecs.NodeType.NOT
// // //                 width: 50
// // //                 height: 40

// // //                 onPaint: {
// // //                     var ctx = getContext("2d");
// // //                     ctx.reset();
// // //                     ctx.strokeStyle = node.guiConfig.color;
// // //                     ctx.lineWidth = 2;

// // //                     // Draw NOT gate triangle
// // //                     ctx.beginPath();
// // //                     ctx.moveTo(5, 5);
// // //                     ctx.lineTo(35, 20);
// // //                     ctx.lineTo(5, 35);
// // //                     ctx.closePath();
// // //                     ctx.stroke();

// // //                     // Draw inversion circle at output
// // //                     ctx.beginPath();
// // //                     ctx.arc(40, 20, 4, 0, Math.PI * 2);
// // //                     ctx.stroke();

// // //                     // Draw NOT symbol (1 at input side)
// // //                     ctx.fillStyle = node.guiConfig.color;
// // //                     ctx.font = "bold 12px Arial";
// // //                     ctx.fillText("1", 15, 25);
// // //                 }
// // //             }
// // //         }
// // //     }
// // // }


// // import QtQuick
// // import QtQuick.Controls

// // import NodeLink
// // import LogicCircuit

// // /*! ***********************************************************************************************
// //  * LogicCircuitNodeView - Shows only official gate symbols without rectangles
// //  * ************************************************************************************************/
// // NodeView {
// //     id: nodeView

// //      // Remove rectangle background from I_NodeView
// //     color: "transparent"
// //     border.width: 0
// //     radius: 0
// //     isResizable: false;


// //     // Remove the header by making it invisible and setting height to 0
// //     contentItem: Item {
// //         // Make header invisible but keep structure for ports
// //         Item {
// //             id: titleItem
// //             anchors.left: parent.left
// //             anchors.right: parent.right
// //             anchors.top: parent.top
// //             anchors.margins: 0  // Remove margins
// //             height: 0  // Make header height 0
// //             visible: false  // Hide header completely

// //             Text {
// //                 id: iconText
// //                 visible: false
// //             }

// //             Text {
// //                 visible: false
// //             }
// //         }

// //         // Content Area - Fill entire node with symbols
// //         Item {
// //             anchors.fill: parent  // Fill entire node space
// //             anchors.margins: 0    // Remove all margins

// //             // INPUT NODE: Only the toggle switch
// //             Rectangle {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.Input
// //                 width: 44
// //                 height: 22
// //                 radius: 11
// //                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
// //                 border.color: Qt.darker(color, 1.2)
// //                 border.width: 1

// //                 Text {
// //                     anchors.centerIn: parent
// //                     text: node.nodeData.currentState ? "ON" : "OFF"
// //                     color: "#1E1E2E"
// //                     font.bold: true
// //                     font.pixelSize: 10
// //                 }

// //                 MouseArea {
// //                     anchors.fill: parent
// //                     cursorShape: Qt.PointingHandCursor
// //                     onClicked: {
// //                         if (node.toggleState) {
// //                             node.toggleState();
// //                         }
// //                     }
// //                 }
// //             }

// //             // OUTPUT NODE: Only the fixed switch
// //             // Rectangle {
// //             //     anchors.centerIn: parent
// //             //     visible: node.type === LSpecs.NodeType.Output
// //             //     width: 44
// //             //     height: 22
// //             //     radius: 11
// //             //     color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
// //             //            node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
// //             //     border.color: Qt.darker(color, 1.2)
// //             //     border.width: 1

// //             //     Text {
// //             //         anchors.centerIn: parent
// //             //         text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
// //             //         color: "#1E1E2E"
// //             //         font.bold: true
// //             //         font.pixelSize: 10
// //             //     }
// //             // }

// //             // OUTPUT NODE: Lamp indicator (green/red/gray)
// //             Rectangle {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.Output

// //                 width: 34
// //                 height: 34
// //                 radius: 17

// //                 // Color logic for lamp state
// //                 color:
// //                     node.nodeData.displayValue === "ON"  ? "#4CAF50" :   // green
// //                     node.nodeData.displayValue === "OFF" ? "#E53935" :   // red
// //                                                            "#757575"     // undefined gray

// //                 border.color: Qt.darker(color, 1.3)
// //                 border.width: 2

// //                 // slight glow effect when ON
// //                 Rectangle {
// //                     anchors.centerIn: parent
// //                     width: parent.width
// //                     height: parent.height
// //                     radius: parent.radius
// //                     visible: node.nodeData.displayValue === "ON"
// //                     color: "#4CAF50"
// //                     opacity: 0.25
// //                     layer.enabled: true
// //                     layer.smooth: true
// //                     scale: 1.4
// //                 }
// //             }


// //             // AND GATE: Official AND symbol only
// //             // Canvas {
// //             //     id: canvas
// //             //     anchors.fill: parent  // fill the entire node area
// //             //     visible: node.type === LSpecs.NodeType.AND

// //             //     onPaint: {
// //             //         var ctx = getContext("2d");
// //             //         ctx.reset();
// //             //         ctx.clearRect(0, 0, canvas.width, canvas.height);

// //             //         var w = canvas.width;
// //             //         var h = canvas.height;

// //             //         // Minimum size for the gate to maintain its shape
// //             //         var minSize = 40;
// //             //         var scale = Math.max(Math.min(w, h), minSize) / 60; // 60 = reference size
// //             //         var centerX = w / 2;
// //             //         var centerY = h / 2;

// //             //         // Adjusted width & height for the drawing
// //             //         var drawW = 36 * scale;
// //             //         var drawH = 40 * scale;
// //             //         var leftX = centerX - drawW * 0.5;
// //             //         var rightX = centerX + drawW * 0.5;
// //             //         var topY = centerY - drawH * 0.5;
// //             //         var bottomY = centerY + drawH * 0.5;
// //             //         var arcRadius = drawH * 0.5;

// //             //         ctx.beginPath();
// //             //         ctx.moveTo(leftX, topY);
// //             //         ctx.lineTo(rightX - arcRadius, topY);
// //             //         ctx.arc(rightX - arcRadius, centerY, arcRadius, -Math.PI / 2, Math.PI / 2, false);
// //             //         ctx.lineTo(leftX, bottomY);
// //             //         ctx.closePath();
// //             //         ctx.strokeStyle = node.guiConfig.color;
// //             //         ctx.lineWidth = 2;
// //             //         ctx.stroke();
// //             //     }
// //             // }

// //             Canvas {
// //                 visible: node.type === LSpecs.NodeType.AND
// //                 width: 90
// //                 height: 60
// //                 anchors.centerIn: parent

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.clearRect(0, 0, width, height);
// //                     ctx.fillStyle = "white";
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;

// //                     var leftX = 10;
// //                     var rightX = 55;      // flat part before arc
// //                     var topY = 10;
// //                     var bottomY = 50;
// //                     var centerY = height / 2;
// //                     var radius = 20;

// //                     ctx.beginPath();
// //                     ctx.moveTo(leftX, topY);
// //                     ctx.lineTo(rightX, topY);
// //                     ctx.arc(rightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
// //                     ctx.lineTo(leftX, bottomY);
// //                     ctx.closePath();

// //                     ctx.fill();     // WHITE
// //                     ctx.stroke();   // BLACK BORDER


// //                 }
// //             }



// //             // OR GATE: Official OR symbol only
// //             // Canvas {
// //             //     anchors.centerIn: parent
// //             //     visible: node.type === LSpecs.NodeType.OR
// //             //     // width: 60
// //             //     // height: 40
// //             //     width: parent.width
// //             //     height: parent.height

// //             //     onPaint: {
// //             //         var ctx = getContext("2d");
// //             //         ctx.reset();
// //             //         ctx.strokeStyle = node.guiConfig.color;
// //             //         ctx.lineWidth = 2;

// //             //         // Draw OR gate shape (curved shape)
// //             //         ctx.beginPath();
// //             //         ctx.moveTo(10, 5);
// //             //         ctx.quadraticCurveTo(30, 20, 10, 35);
// //             //         ctx.quadraticCurveTo(50, 20, 10, 5);
// //             //         ctx.closePath();
// //             //         ctx.stroke();

// //             //         // Draw OR symbol (≥1)
// //             //         ctx.fillStyle = node.guiConfig.color;
// //             //         ctx.font = "bold 12px Arial";
// //             //         ctx.fillText("≥1", 25, 23);
// //             //     }
// //             // }


// //             Canvas {
// //                 visible: node.type === LSpecs.NodeType.OR
// //                 width: 100
// //                 height: 65
// //                 anchors.centerIn: parent

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.clearRect(0, 0, width, height);
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;

// //                     var leftX = 12;
// //                     var midX  = 35;
// //                     var rightX = 90;
// //                     var topY = 10;
// //                     var midY = height / 2;
// //                     var bottomY = 55;

// //                     ctx.beginPath();

// //                     // LEFT CURVE
// //                     ctx.moveTo(leftX, topY);
// //                     ctx.quadraticCurveTo(midX - 15, midY, leftX, bottomY);

// //                     // RIGHT OR CURVE (main shape)
// //                     ctx.quadraticCurveTo(rightX, midY, leftX, topY);

// //                     ctx.stroke();
// //                 }
// //             }


// //             // NOT GATE: Official NOT symbol only
// //             // Canvas {
// //             //     anchors.centerIn: parent
// //             //     visible: node.type === LSpecs.NodeType.NOT
// //             //     width: 50
// //             //     height: 40

// //             //     onPaint: {
// //             //         var ctx = getContext("2d");
// //             //         ctx.reset();
// //             //         ctx.strokeStyle = node.guiConfig.color;
// //             //         ctx.lineWidth = 2;

// //             //         // Draw NOT gate triangle
// //             //         ctx.beginPath();
// //             //         ctx.moveTo(5, 5);
// //             //         ctx.lineTo(35, 20);
// //             //         ctx.lineTo(5, 35);
// //             //         ctx.closePath();
// //             //         ctx.stroke();

// //             //         // Draw inversion circle at output
// //             //         ctx.beginPath();
// //             //         ctx.arc(40, 20, 4, 0, Math.PI * 2);
// //             //         ctx.stroke();

// //             //         // Draw NOT symbol (1 at input side)
// //             //         ctx.fillStyle = node.guiConfig.color;
// //             //         ctx.font = "bold 12px Arial";
// //             //         ctx.fillText("1", 15, 25);
// //             //     }
// //             // }

// //             Canvas {
// //                 visible: node.type === LSpecs.NodeType.NOT
// //                 width: 80
// //                 height: 60
// //                 anchors.centerIn: parent

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.clearRect(0, 0, width, height);
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;

// //                     // Triangle
// //                     ctx.beginPath();
// //                     ctx.moveTo(10, 10);
// //                     ctx.lineTo(60, 30);
// //                     ctx.lineTo(10, 50);
// //                     ctx.closePath();
// //                     ctx.stroke();

// //                     // Bubble
// //                     ctx.beginPath();
// //                     ctx.arc(65, 30, 5, 0, Math.PI * 2);
// //                     ctx.stroke();
// //                 }
// //             }

// //         }
// //     }
// // }





// // import QtQuick
// // import QtQuick.Controls

// // import NodeLink
// // import LogicCircuit

// // /*! ***********************************************************************************************
// //  * LogicCircuitNodeView custom view for logic gates nodes with proper graphics
// //  * ************************************************************************************************/
// // NodeView {
// //     id: nodeView

// //     contentItem: Item {
// //         //! Header Item
// //         Item {
// //             id: titleItem
// //             anchors.left: parent.left
// //             anchors.right: parent.right
// //             anchors.top: parent.top
// //             anchors.margins: 12
// //             height: 20

// //             //! Icon
// //             Text {
// //                 id: iconText
// //                 font.family: NLStyle.fontType.font6Pro
// //                 font.pixelSize: 20
// //                 anchors.left: parent.left
// //                 anchors.verticalCenter: parent.verticalCenter
// //                 text: scene.nodeRegistry.nodeIcons[node.type]
// //                 color: node.guiConfig.color
// //                 font.weight: 400
// //             }

// //             //! Title Text
// //             Text {
// //                 anchors.right: parent.right
// //                 anchors.left: iconText.right
// //                 anchors.verticalCenter: parent.verticalCenter
// //                 anchors.leftMargin: 5
// //                 text: node.title
// //                 color: NLStyle.primaryTextColor
// //                 font.pointSize: 10
// //                 font.bold: true
// //                 elide: Text.ElideRight
// //             }
// //         }

// //         //! Content Area - Different for each node type
// //         Item {
// //             anchors.top: titleItem.bottom
// //             anchors.right: parent.right
// //             anchors.bottom: parent.bottom
// //             anchors.left: parent.left
// //             anchors.margins: 12
// //             anchors.topMargin: 5

// //             // INPUT NODE: Interactive Toggle Switch
// //             Rectangle {
// //                 id: inputSwitch
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.Input
// //                 width: 44
// //                 height: 22
// //                 radius: 11
// //                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
// //                 border.color: Qt.darker(color, 1.2)
// //                 border.width: 1

// //                 Text {
// //                     anchors.centerIn: parent
// //                     text: node.nodeData.currentState ? "ON" : "OFF"
// //                     color: "#1E1E2E"
// //                     font.bold: true
// //                     font.pixelSize: 10
// //                 }

// //                 MouseArea {
// //                     anchors.fill: parent
// //                     cursorShape: Qt.PointingHandCursor
// //                     onClicked: {
// //                         if (node.toggleState) {
// //                             node.toggleState();
// //                         }
// //                     }
// //                 }
// //             }

// //             // OUTPUT NODE: Fixed Display Switch
// //             Rectangle {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.Output
// //                 width: 44
// //                 height: 22
// //                 radius: 11
// //                 color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
// //                        node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
// //                 border.color: Qt.darker(color, 1.2)
// //                 border.width: 1

// //                 Text {
// //                     anchors.centerIn: parent
// //                     text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
// //                     color: "#1E1E2E"
// //                     font.bold: true
// //                     font.pixelSize: 10
// //                 }
// //             }

// //             // AND GATE: Official AND Gate Symbol
// //             Canvas {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.AND
// //                 width: 80
// //                 height: 60

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;
// //                     ctx.fillStyle = "transparent";

// //                     // Draw AND gate shape (D-shape)
// //                     ctx.beginPath();
// //                     ctx.moveTo(10, 10);
// //                     ctx.lineTo(50, 10);
// //                     ctx.arc(50, 30, 20, -Math.PI/2, Math.PI/2, false);
// //                     ctx.lineTo(10, 50);
// //                     ctx.closePath();
// //                     ctx.stroke();

// //                     // Draw AND symbol
// //                     ctx.fillStyle = node.guiConfig.color;
// //                     ctx.font = "bold 16px Arial";
// //                     ctx.fillText("&", 35, 35);
// //                 }
// //             }

// //             // OR GATE: Official OR Gate Symbol
// //             Canvas {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.OR
// //                 width: 80
// //                 height: 60

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;
// //                     ctx.fillStyle = "transparent";

// //                     // Draw OR gate shape (curved shape)
// //                     ctx.beginPath();
// //                     ctx.moveTo(15, 10);
// //                     ctx.quadraticCurveTo(40, 30, 15, 50);
// //                     ctx.quadraticCurveTo(65, 30, 15, 10);
// //                     ctx.closePath();
// //                     ctx.stroke();

// //                     // Draw OR symbol (≥1)
// //                     ctx.fillStyle = node.guiConfig.color;
// //                     ctx.font = "bold 14px Arial";
// //                     ctx.fillText("≥1", 35, 33);
// //                 }
// //             }

// //             // NOT GATE: Official NOT Gate Symbol
// //             Canvas {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.NOT
// //                 width: 60
// //                 height: 60

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;
// //                     ctx.fillStyle = "transparent";

// //                     // Draw NOT gate triangle
// //                     ctx.beginPath();
// //                     ctx.moveTo(10, 10);
// //                     ctx.lineTo(40, 30);
// //                     ctx.lineTo(10, 50);
// //                     ctx.closePath();
// //                     ctx.stroke();

// //                     // Draw inversion circle at output
// //                     ctx.beginPath();
// //                     ctx.arc(45, 30, 5, 0, Math.PI * 2);
// //                     ctx.stroke();

// //                     // Draw NOT symbol (1 at input side)
// //                     ctx.fillStyle = node.guiConfig.color;
// //                     ctx.font = "bold 14px Arial";
// //                     ctx.fillText("1", 20, 35);
// //                 }
// //             }
// //         }
// //     }
// // }

// // import QtQuick
// // import QtQuick.Controls

// // import NodeLink
// // import LogicCircuit

// // /*! ***********************************************************************************************
// //  * LogicCircuitNodeView - Shows only official gate symbols without rectangles
// //  * ************************************************************************************************/
// // NodeView {
// //     id: nodeView

// //      // Remove rectangle background from I_NodeView
// //     color: "transparent"
// //     border.width: 0
// //     radius: 0


// //     // Remove the header by making it invisible and setting height to 0
// //     contentItem: Item {
// //         // Make header invisible but keep structure for ports
// //         Item {
// //             id: titleItem
// //             anchors.left: parent.left
// //             anchors.right: parent.right
// //             anchors.top: parent.top
// //             anchors.margins: 0  // Remove margins
// //             height: 0  // Make header height 0
// //             visible: false  // Hide header completely

// //             Text {
// //                 id: iconText
// //                 visible: false
// //             }

// //             Text {
// //                 visible: false
// //             }
// //         }

// //         // Content Area - Fill entire node with symbols
// //         Item {
// //             anchors.fill: parent  // Fill entire node space
// //             anchors.margins: 0    // Remove all margins

// //             // INPUT NODE: Only the toggle switch
// //             Rectangle {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.Input
// //                 width: 44
// //                 height: 22
// //                 radius: 11
// //                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
// //                 border.color: Qt.darker(color, 1.2)
// //                 border.width: 1

// //                 Text {
// //                     anchors.centerIn: parent
// //                     text: node.nodeData.currentState ? "ON" : "OFF"
// //                     color: "#1E1E2E"
// //                     font.bold: true
// //                     font.pixelSize: 10
// //                 }

// //                 MouseArea {
// //                     anchors.fill: parent
// //                     cursorShape: Qt.PointingHandCursor
// //                     onClicked: {
// //                         if (node.toggleState) {
// //                             node.toggleState();
// //                         }
// //                     }
// //                 }
// //             }

// //             // OUTPUT NODE: Only the fixed switch
// //             Rectangle {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.Output
// //                 width: 44
// //                 height: 22
// //                 radius: 11
// //                 color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
// //                        node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
// //                 border.color: Qt.darker(color, 1.2)
// //                 border.width: 1

// //                 Text {
// //                     anchors.centerIn: parent
// //                     text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
// //                     color: "#1E1E2E"
// //                     font.bold: true
// //                     font.pixelSize: 10
// //                 }
// //             }

// //             // AND GATE: Official AND symbol only
// //             Canvas {
// //                 id: canvas
// //                 anchors.fill: parent  // fill the entire node area
// //                 visible: node.type === LSpecs.NodeType.AND

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.clearRect(0, 0, canvas.width, canvas.height);

// //                     var w = canvas.width;
// //                     var h = canvas.height;

// //                     // Minimum size for the gate to maintain its shape
// //                     var minSize = 40;
// //                     var scale = Math.max(Math.min(w, h), minSize) / 60; // 60 = reference size
// //                     var centerX = w / 2;
// //                     var centerY = h / 2;

// //                     // Adjusted width & height for the drawing
// //                     var drawW = 36 * scale;
// //                     var drawH = 40 * scale;
// //                     var leftX = centerX - drawW * 0.5;
// //                     var rightX = centerX + drawW * 0.5;
// //                     var topY = centerY - drawH * 0.5;
// //                     var bottomY = centerY + drawH * 0.5;
// //                     var arcRadius = drawH * 0.5;

// //                     ctx.beginPath();
// //                     ctx.moveTo(leftX, topY);
// //                     ctx.lineTo(rightX - arcRadius, topY);
// //                     ctx.arc(rightX - arcRadius, centerY, arcRadius, -Math.PI / 2, Math.PI / 2, false);
// //                     ctx.lineTo(leftX, bottomY);
// //                     ctx.closePath();
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;
// //                     ctx.stroke();
// //                 }
// //             }

// //             // Canvas {
// //             //     id: canvas
// //             //     width: node.guiConfig.width
// //             //     height: node.guiConfig.height
// //             //     anchors.centerIn: parent

// //             //     onPaint: {
// //             //         var ctx = getContext("2d");
// //             //         ctx.reset();
// //             //         ctx.strokeStyle = node.guiConfig.color;
// //             //         ctx.lineWidth = 2;

// //             //         var w = canvas.width;
// //             //         var h = canvas.height;
// //             //         var s = Math.min(w, h);

// //             //         ctx.beginPath();
// //             //         ctx.moveTo(w*0.1, h*0.1);
// //             //         ctx.lineTo(w*0.6, h*0.1);
// //             //         ctx.arc(w*0.6, h*0.5, s*0.4, -Math.PI/2, Math.PI/2, false);
// //             //         ctx.lineTo(w*0.1, h*0.9);
// //             //         ctx.closePath();
// //             //         ctx.stroke();
// //             //     }
// //             // }

// //             // OR GATE: Official OR symbol only
// //             Canvas {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.OR
// //                 // width: 60
// //                 // height: 40
// //                 width: parent.width
// //                 height: parent.height

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;

// //                     // Draw OR gate shape (curved shape)
// //                     ctx.beginPath();
// //                     ctx.moveTo(10, 5);
// //                     ctx.quadraticCurveTo(30, 20, 10, 35);
// //                     ctx.quadraticCurveTo(50, 20, 10, 5);
// //                     ctx.closePath();
// //                     ctx.stroke();

// //                     // Draw OR symbol (≥1)
// //                     ctx.fillStyle = node.guiConfig.color;
// //                     ctx.font = "bold 12px Arial";
// //                     ctx.fillText("≥1", 25, 23);
// //                 }
// //             }

// //             // NOT GATE: Official NOT symbol only
// //             Canvas {
// //                 anchors.centerIn: parent
// //                 visible: node.type === LSpecs.NodeType.NOT
// //                 width: 50
// //                 height: 40

// //                 onPaint: {
// //                     var ctx = getContext("2d");
// //                     ctx.reset();
// //                     ctx.strokeStyle = node.guiConfig.color;
// //                     ctx.lineWidth = 2;

// //                     // Draw NOT gate triangle
// //                     ctx.beginPath();
// //                     ctx.moveTo(5, 5);
// //                     ctx.lineTo(35, 20);
// //                     ctx.lineTo(5, 35);
// //                     ctx.closePath();
// //                     ctx.stroke();

// //                     // Draw inversion circle at output
// //                     ctx.beginPath();
// //                     ctx.arc(40, 20, 4, 0, Math.PI * 2);
// //                     ctx.stroke();

// //                     // Draw NOT symbol (1 at input side)
// //                     ctx.fillStyle = node.guiConfig.color;
// //                     ctx.font = "bold 12px Arial";
// //                     ctx.fillText("1", 15, 25);
// //                 }
// //             }
// //         }
// //     }
// // }


// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Shows only official gate symbols without rectangles
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     property real portRadius: 6


//      // Remove rectangle background from I_NodeView
//     color: "transparent"
//     border.width: 0
//     radius: 0
//     isResizable: false;


//     // Remove the header by making it invisible and setting height to 0
//     contentItem: Item {
//         // Make header invisible but keep structure for ports
//         Item {
//             id: titleItem
//             anchors.left: parent.left
//             anchors.right: parent.right
//             anchors.top: parent.top
//             anchors.margins: 0  // Remove margins
//             height: 0  // Make header height 0
//             visible: false  // Hide header completely

//             Text {
//                 id: iconText
//                 visible: false
//             }

//             Text {
//                 visible: false
//             }
//         }

//         // Content Area - Fill entire node with symbols
//         Item {
//             anchors.fill: parent  // Fill entire node space
//             anchors.margins: 0    // Remove all margins

//             // INPUT NODE: Only the toggle switch
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Input
//                 width: 44
//                 height: 22
//                 radius: 11
//                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
//                 border.color: Qt.darker(color, 1.2)
//                 border.width: 1

//                 Text {
//                     anchors.centerIn: parent
//                     text: node.nodeData.currentState ? "ON" : "OFF"
//                     color: "#1E1E2E"
//                     font.bold: true
//                     font.pixelSize: 10
//                 }

//                 MouseArea {
//                     anchors.fill: parent
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: {
//                         if (node.toggleState) {
//                             node.toggleState();
//                         }
//                     }
//                 }
//             }

//             // OUTPUT NODE: Only the fixed switch
//             // Rectangle {
//             //     anchors.centerIn: parent
//             //     visible: node.type === LSpecs.NodeType.Output
//             //     width: 44
//             //     height: 22
//             //     radius: 11
//             //     color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
//             //            node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
//             //     border.color: Qt.darker(color, 1.2)
//             //     border.width: 1

//             //     Text {
//             //         anchors.centerIn: parent
//             //         text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
//             //         color: "#1E1E2E"
//             //         font.bold: true
//             //         font.pixelSize: 10
//             //     }
//             // }

//             // OUTPUT NODE: Lamp indicator (green/red/gray)
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Output

//                 width: 34
//                 height: 34
//                 radius: 17

//                 // Color logic for lamp state
//                 color:
//                     node.nodeData.displayValue === "ON"  ? "#4CAF50" :   // green
//                     node.nodeData.displayValue === "OFF" ? "#E53935" :   // red
//                                                            "#757575"     // undefined gray

//                 border.color: Qt.darker(color, 1.3)
//                 border.width: 2

//                 // slight glow effect when ON
//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: parent.width
//                     height: parent.height
//                     radius: parent.radius
//                     visible: node.nodeData.displayValue === "ON"
//                     color: "#4CAF50"
//                     opacity: 0.25
//                     layer.enabled: true
//                     layer.smooth: true
//                     scale: 1.4
//                 }
//             }


//             // Canvas {
//             //     id: andCanvas
//             //     visible: node.type === LSpecs.NodeType.AND
//             //     anchors.fill: parent

//             //     property real portRadius: 6
//             //     property real leftMargin: portRadius * 2
//             //     property real rightMargin: portRadius * 2

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.clearRect(0, 0, width, height);

//             //         ctx.fillStyle = "white";
//             //         ctx.strokeStyle = "black";
//             //         ctx.lineWidth = 2;

//             //         // Gate boundary (tight against ports)
//             //         var leftX  = leftMargin;
//             //         var rightX = width - rightMargin;

//             //         // Vertical proportions
//             //         var topY = height * 0.18;
//             //         var bottomY = height * 0.82;
//             //         var centerY = height / 2;
//             //         var radius = (bottomY - topY) / 2;

//             //         //
//             //         // === INPUT LINES ===
//             //         //
//             //         ctx.beginPath();
//             //         ctx.moveTo(0, topY + radius * 0.40);
//             //         ctx.lineTo(leftX, topY + radius * 0.40);

//             //         ctx.moveTo(0, bottomY - radius * 0.40);
//             //         ctx.lineTo(leftX, bottomY - radius * 0.40);
//             //         ctx.stroke();

//             //         //
//             //         // === AND GATE BODY ===
//             //         //
//             //         ctx.beginPath();
//             //         ctx.moveTo(leftX, topY);
//             //         ctx.lineTo(rightX - radius, topY);
//             //         ctx.arc(rightX - radius, centerY, radius,
//             //                 -Math.PI/2, Math.PI/2, false);
//             //         ctx.lineTo(leftX, bottomY);
//             //         ctx.closePath();
//             //         ctx.fill();
//             //         ctx.stroke();

//             //         //
//             //         // === OUTPUT LINE ===
//             //         //
//             //         ctx.beginPath();
//             //         ctx.moveTo(rightX, centerY);
//             //         ctx.lineTo(width, centerY);
//             //         ctx.stroke();
//             //     }
//             // }


//             Canvas {
//                 id: andCanvas
//                 visible: node.type === LSpecs.NodeType.AND
//                 anchors.fill: parent

//                 property real portRadius: 6
//                 property real margin: portRadius * 2  // spacing between gate and port circles

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

//                     // --- Gate boundaries (fill width & height, stick to ports) ---
//                     var leftX  = margin;
//                     var rightX = width - margin;
//                     var topY   = height * 0.2;
//                     var bottomY = height * 0.8;
//                     var centerY = height / 2;
//                     var radius = (bottomY - topY) / 2;

//                     // --- INPUT lines ---
//                     ctx.beginPath();
//                     ctx.moveTo(0, topY + radius * 0.4);
//                     ctx.lineTo(leftX, topY + radius * 0.4);
//                     ctx.moveTo(0, bottomY - radius * 0.4);
//                     ctx.lineTo(leftX, bottomY - radius * 0.4);
//                     ctx.stroke();

//                     // --- AND gate body ---
//                     ctx.beginPath();
//                     ctx.moveTo(leftX, topY);
//                     ctx.lineTo(rightX - radius, topY);
//                     ctx.arc(rightX - radius, centerY, radius, -Math.PI/2, Math.PI/2, false);
//                     ctx.lineTo(leftX, bottomY);
//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // --- OUTPUT line ---
//                     ctx.beginPath();
//                     ctx.moveTo(rightX, centerY);
//                     ctx.lineTo(width, centerY);
//                     ctx.stroke();
//                 }
//             }





//             // Canvas {
//             //     visible: node.type === LSpecs.NodeType.AND
//             //     width: node.guiConfig.width
//             //     height: node.guiConfig.height
//             //     anchors.centerIn: parent

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.clearRect(0, 0, width, height);

//             //         // Colors
//             //         ctx.fillStyle = "white";
//             //         ctx.strokeStyle = "black";
//             //         ctx.lineWidth = 2;

//             //         // --- Gate boundaries ---
//             //         var leftX = 0;           // left edge of gate = sticks to left ports
//             //         var rightX = width;      // right edge = sticks to output port
//             //         var topY = height * 0.2;
//             //         var bottomY = height * 0.8;
//             //         var centerY = height / 2;
//             //         var radius = (bottomY - topY) / 2;

//             //         // AND gate shape
//             //         ctx.beginPath();
//             //         ctx.moveTo(leftX, topY);
//             //         ctx.lineTo(rightX - radius, topY);
//             //         ctx.arc(rightX - radius, centerY, radius, -Math.PI/2, Math.PI/2, false);
//             //         ctx.lineTo(leftX, bottomY);
//             //         ctx.closePath();
//             //         ctx.fill();
//             //         ctx.stroke();
//             //     }
//             // }







//             // OR GATE: Official OR symbol only
//             // Canvas {
//             //     anchors.centerIn: parent
//             //     visible: node.type === LSpecs.NodeType.OR
//             //     // width: 60
//             //     // height: 40
//             //     width: parent.width
//             //     height: parent.height

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.strokeStyle = node.guiConfig.color;
//             //         ctx.lineWidth = 2;

//             //         // Draw OR gate shape (curved shape)
//             //         ctx.beginPath();
//             //         ctx.moveTo(10, 5);
//             //         ctx.quadraticCurveTo(30, 20, 10, 35);
//             //         ctx.quadraticCurveTo(50, 20, 10, 5);
//             //         ctx.closePath();
//             //         ctx.stroke();

//             //         // Draw OR symbol (≥1)
//             //         ctx.fillStyle = node.guiConfig.color;
//             //         ctx.font = "bold 12px Arial";
//             //         ctx.fillText("≥1", 25, 23);
//             //     }
//             // }

//             //**************************************OR
//             Canvas {
//                 id: orCanvas
//                 visible: node.type === LSpecs.NodeType.OR
//                 anchors.fill: parent

//                 property real portRadius: 6
//                 property real margin: portRadius * 2

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

//                     // --- Geometry ---
//                     var leftX  = margin;
//                     var rightX = width - margin;
//                     var topY   = height * 0.2;
//                     var bottomY = height * 0.8;
//                     var centerY = height / 2;

//                     var h = bottomY - topY;
//                     var w = rightX - leftX;

//                     // How strong the OR curvature should be
//                     var ctrl = w * 0.55;   // Increased so the curve reaches rightX

//                     // --- INPUT lines ---
//                     ctx.beginPath();
//                     ctx.moveTo(0, topY + h * 0.25);
//                     ctx.lineTo(leftX, topY + h * 0.25);
//                     ctx.moveTo(0, bottomY - h * 0.25);
//                     ctx.lineTo(leftX, bottomY - h * 0.25);
//                     ctx.stroke();

//                     // --- OR gate body (full width) ---
//                     ctx.beginPath();

//                     // Back curve
//                     ctx.moveTo(leftX, topY);
//                     ctx.bezierCurveTo(
//                         leftX + ctrl * 0.2, topY + h * 0.10,
//                         leftX + ctrl * 0.2, bottomY - h * 0.10,
//                         leftX, bottomY
//                     );

//                     // Front curve (reaching full width)
//                     ctx.bezierCurveTo(
//                         rightX, bottomY,     // bottom control → touches right edge
//                         rightX, topY,        // top control → touches right edge
//                         leftX, topY
//                     );

//                     ctx.closePath();
//                     ctx.fill();
//                     ctx.stroke();

//                     // --- OUTPUT line ---
//                     ctx.beginPath();
//                     ctx.moveTo(rightX, centerY);
//                     ctx.lineTo(width, centerY);
//                     ctx.stroke();
//                 }
//             }




//             // Canvas {
//             //     id: orCanvas
//             //     visible: node.type === LSpecs.NodeType.OR
//             //     anchors.fill: parent

//             //     property real portRadius: 6
//             //     property real margin: portRadius * 2  // space from port circles

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.clearRect(0, 0, width, height);

//             //         ctx.fillStyle = "white";
//             //         ctx.strokeStyle = "black";
//             //         ctx.lineWidth = 2;

//             //         // Scaled positions
//             //         var leftX   = margin;           // left curve start (input side)
//             //         var rightX  = width - margin;   // tip of OR (output side)
//             //         var midX    = width * 0.45;     // control point for back curve
//             //         var topY    = height * 0.12;
//             //         var bottomY = height * 0.88;
//             //         var centerY = height * 0.5;

//             //         // --- OR gate body ---
//             //         ctx.beginPath();

//             //         // Left back curve (concave)
//             //         ctx.moveTo(leftX, topY);
//             //         ctx.quadraticCurveTo(midX * 0.55, centerY, leftX, bottomY);

//             //         // Right front curve (convex tip)
//             //         ctx.quadraticCurveTo(rightX, centerY, leftX, topY);

//             //         ctx.fill();
//             //         ctx.stroke();

//             //         // --- OUTPUT line ---
//             //         ctx.beginPath();
//             //         ctx.moveTo(rightX, centerY);
//             //         ctx.lineTo(width, centerY);
//             //         ctx.stroke();

//             //         // --- INPUT lines (2 ports) ---
//             //         ctx.beginPath();
//             //         ctx.moveTo(0, topY + (centerY - topY) * 0.6);
//             //         ctx.lineTo(leftX, topY + (centerY - topY) * 0.6);

//             //         ctx.moveTo(0, bottomY - (bottomY - centerY) * 0.6);
//             //         ctx.lineTo(leftX, bottomY - (bottomY - centerY) * 0.6);
//             //         ctx.stroke();
//             //     }
//             // }



//             // Canvas {
//             //     id: orCanvas
//             //     visible: node.type === LSpecs.NodeType.OR
//             //     anchors.fill: parent

//             //     property real portRadius: 6
//             //     property real leftMargin: portRadius * 2
//             //     property real rightMargin: portRadius * 2

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.clearRect(0, 0, width, height);

//             //         ctx.fillStyle = "white";
//             //         ctx.strokeStyle = "black";
//             //         ctx.lineWidth = 2;

//             //         // -----------------
//             //         // Gate boundaries
//             //         // -----------------
//             //         var leftX   = leftMargin;           // start of OR gate body
//             //         var rightX  = width - rightMargin;  // tip of OR gate body
//             //         var topY    = height * 0.18;
//             //         var bottomY = height * 0.82;
//             //         var centerY = height / 2;

//             //         // Control points for curves
//             //         var leftCtrlX = leftX + (rightX - leftX) * 0.35;  // inward curve
//             //         var rightCtrlX = rightX;                           // front curve

//             //         // -----------------
//             //         // OR gate shape
//             //         // -----------------
//             //         ctx.beginPath();
//             //         ctx.moveTo(leftX, topY);                            // top-left
//             //         ctx.quadraticCurveTo(leftCtrlX, centerY, leftX, bottomY); // left/back curve
//             //         ctx.quadraticCurveTo(rightCtrlX, centerY, leftX, topY);   // right/front curve
//             //         ctx.fill();
//             //         ctx.stroke();

//             //         // -----------------
//             //         // Output line
//             //         // -----------------
//             //         ctx.beginPath();
//             //         ctx.moveTo(rightX, centerY);
//             //         ctx.lineTo(width, centerY);
//             //         ctx.stroke();

//             //         // -----------------
//             //         // Input lines (two ports)
//             //         // -----------------
//             //         ctx.beginPath();
//             //         ctx.moveTo(0, topY + (centerY - topY) * 0.6);
//             //         ctx.lineTo(leftX, topY + (centerY - topY) * 0.6);

//             //         ctx.moveTo(0, bottomY - (bottomY - centerY) * 0.6);
//             //         ctx.lineTo(leftX, bottomY - (bottomY - centerY) * 0.6);
//             //         ctx.stroke();
//             //     }
//             // }




//             // Canvas {
//             //     visible: node.type === LSpecs.NodeType.OR
//             //     width: 100
//             //     height: 65
//             //     anchors.centerIn: parent

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.clearRect(0, 0, width, height);
//             //         ctx.strokeStyle = node.guiConfig.color;
//             //         ctx.lineWidth = 2;

//             //         var leftX = 12;
//             //         var midX  = 35;
//             //         var rightX = 90;
//             //         var topY = 10;
//             //         var midY = height / 2;
//             //         var bottomY = 55;

//             //         ctx.beginPath();

//             //         // LEFT CURVE
//             //         ctx.moveTo(leftX, topY);
//             //         ctx.quadraticCurveTo(midX - 15, midY, leftX, bottomY);

//             //         // RIGHT OR CURVE (main shape)
//             //         ctx.quadraticCurveTo(rightX, midY, leftX, topY);

//             //         ctx.stroke();
//             //     }
//             // }


//             // NOT GATE: Official NOT symbol only
//             // Canvas {
//             //     anchors.centerIn: parent
//             //     visible: node.type === LSpecs.NodeType.NOT
//             //     width: 50
//             //     height: 40

//             //     onPaint: {
//             //         var ctx = getContext("2d");
//             //         ctx.reset();
//             //         ctx.strokeStyle = node.guiConfig.color;
//             //         ctx.lineWidth = 2;

//             //         // Draw NOT gate triangle
//             //         ctx.beginPath();
//             //         ctx.moveTo(5, 5);
//             //         ctx.lineTo(35, 20);
//             //         ctx.lineTo(5, 35);
//             //         ctx.closePath();
//             //         ctx.stroke();

//             //         // Draw inversion circle at output
//             //         ctx.beginPath();
//             //         ctx.arc(40, 20, 4, 0, Math.PI * 2);
//             //         ctx.stroke();

//             //         // Draw NOT symbol (1 at input side)
//             //         ctx.fillStyle = node.guiConfig.color;
//             //         ctx.font = "bold 12px Arial";
//             //         ctx.fillText("1", 15, 25);
//             //     }
//             // }

//             Canvas {
//                 visible: node.type === LSpecs.NodeType.NOT
//                 width: nodeView.node.guiConfig.width
//                 height: nodeView.node.guiConfig.height
//                 anchors.centerIn: parent

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);
//                     ctx.strokeStyle = node.guiConfig.color;
//                     ctx.lineWidth = 2;

//                     // Triangle
//                     ctx.beginPath();
//                     ctx.moveTo(10, 10);
//                     ctx.lineTo(60, 30);
//                     ctx.lineTo(10, 50);
//                     ctx.closePath();
//                     ctx.stroke();

//                     // Bubble
//                     ctx.beginPath();
//                     ctx.arc(65, 30, 5, 0, Math.PI * 2);
//                     ctx.stroke();
//                 }
//             }

//         }
//     }
// }



















// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Shows only official gate symbols without rectangles
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     // Remove rectangle background from I_NodeView
//     color: "transparent"
//     border.width: 0
//     radius: 0
//     isResizable: false

//     // Remove the header by making it invisible and setting height to 0
//     contentItem: Item {
//         // Make header invisible but keep structure for ports
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

//             // INPUT NODE: Toggle switch
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Input
//                 width: 44
//                 height: 22
//                 radius: 11
//                 color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
//                 border.color: Qt.darker(color, 1.2)
//                 border.width: 1

//                 Text {
//                     anchors.centerIn: parent
//                     text: node.nodeData.currentState ? "ON" : "OFF"
//                     color: "#1E1E2E"
//                     font.bold: true
//                     font.pixelSize: 10
//                 }

//                 MouseArea {
//                     anchors.fill: parent
//                     cursorShape: Qt.PointingHandCursor
//                     onClicked: node.toggleState && node.toggleState()
//                 }
//             }

//             // OUTPUT NODE: Lamp indicator
//             Rectangle {
//                 anchors.centerIn: parent
//                 visible: node.type === LSpecs.NodeType.Output
//                 width: 34
//                 height: 34
//                 radius: 17
//                 color: node.nodeData.displayValue === "ON" ? "#4CAF50" :
//                        node.nodeData.displayValue === "OFF" ? "#E53935" : "#757575"
//                 border.color: Qt.darker(color, 1.3)
//                 border.width: 2
//             }

//             // AND GATE: Official D-shaped symbol
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.AND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

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
//             }

//             // OR GATE: Perfect curved shape
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.OR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

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
//             }

//             // NOT GATE: Triangle with bubble
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOT

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

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
//             }

//             // NOR GATE: OR shape with bubble
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NOR

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

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
//             }

//             // NAND GATE: AND shape with bubble
//             Canvas {
//                 anchors.fill: parent
//                 visible: node.type === LSpecs.NodeType.NAND

//                 onPaint: {
//                     var ctx = getContext("2d");
//                     ctx.reset();
//                     ctx.clearRect(0, 0, width, height);

//                     ctx.fillStyle = "white";
//                     ctx.strokeStyle = "black";
//                     ctx.lineWidth = 2;

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
//             }
//         }
//     }
// }




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

















