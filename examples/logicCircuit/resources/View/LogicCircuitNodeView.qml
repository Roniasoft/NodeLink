import QtQuick
import QtQuick.Controls

import NodeLink
import LogicCircuit

/*! ***********************************************************************************************
 * LogicCircuitNodeView custom view for logic gates nodes with proper graphics
 * ************************************************************************************************/
NodeView {
    id: nodeView

    contentItem: Item {
        //! Header Item
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            height: 20

            //! Icon
            Text {
                id: iconText
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
                font.weight: 400
            }

            //! Title Text
            Text {
                anchors.right: parent.right
                anchors.left: iconText.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                text: node.title
                color: NLStyle.primaryTextColor
                font.pointSize: 10
                font.bold: true
                elide: Text.ElideRight
            }
        }

        //! Content Area - Different for each node type
        Item {
            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5

            // INPUT NODE: Interactive Toggle Switch
            Rectangle {
                id: inputSwitch
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.Input
                width: 44
                height: 22
                radius: 11
                color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
                border.color: Qt.darker(color, 1.2)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: node.nodeData.currentState ? "ON" : "OFF"
                    color: "#1E1E2E"
                    font.bold: true
                    font.pixelSize: 10
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (node.toggleState) {
                            node.toggleState();
                        }
                    }
                }
            }

            // OUTPUT NODE: Fixed Display Switch
            Rectangle {
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.Output
                width: 44
                height: 22
                radius: 11
                color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
                       node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
                border.color: Qt.darker(color, 1.2)
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
                    color: "#1E1E2E"
                    font.bold: true
                    font.pixelSize: 10
                }
            }

            // AND GATE: Official AND Gate Symbol
            Canvas {
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.AND
                width: 80
                height: 60

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = node.guiConfig.color;
                    ctx.lineWidth = 2;
                    ctx.fillStyle = "transparent";

                    // Draw AND gate shape (D-shape)
                    ctx.beginPath();
                    ctx.moveTo(10, 10);
                    ctx.lineTo(50, 10);
                    ctx.arc(50, 30, 20, -Math.PI/2, Math.PI/2, false);
                    ctx.lineTo(10, 50);
                    ctx.closePath();
                    ctx.stroke();

                    // Draw AND symbol
                    ctx.fillStyle = node.guiConfig.color;
                    ctx.font = "bold 16px Arial";
                    ctx.fillText("&", 35, 35);
                }
            }

            // OR GATE: Official OR Gate Symbol
            Canvas {
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.OR
                width: 80
                height: 60

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = node.guiConfig.color;
                    ctx.lineWidth = 2;
                    ctx.fillStyle = "transparent";

                    // Draw OR gate shape (curved shape)
                    ctx.beginPath();
                    ctx.moveTo(15, 10);
                    ctx.quadraticCurveTo(40, 30, 15, 50);
                    ctx.quadraticCurveTo(65, 30, 15, 10);
                    ctx.closePath();
                    ctx.stroke();

                    // Draw OR symbol (≥1)
                    ctx.fillStyle = node.guiConfig.color;
                    ctx.font = "bold 14px Arial";
                    ctx.fillText("≥1", 35, 33);
                }
            }

            // NOT GATE: Official NOT Gate Symbol
            Canvas {
                anchors.centerIn: parent
                visible: node.type === LSpecs.NodeType.NOT
                width: 60
                height: 60

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.strokeStyle = node.guiConfig.color;
                    ctx.lineWidth = 2;
                    ctx.fillStyle = "transparent";

                    // Draw NOT gate triangle
                    ctx.beginPath();
                    ctx.moveTo(10, 10);
                    ctx.lineTo(40, 30);
                    ctx.lineTo(10, 50);
                    ctx.closePath();
                    ctx.stroke();

                    // Draw inversion circle at output
                    ctx.beginPath();
                    ctx.arc(45, 30, 5, 0, Math.PI * 2);
                    ctx.stroke();

                    // Draw NOT symbol (1 at input side)
                    ctx.fillStyle = node.guiConfig.color;
                    ctx.font = "bold 14px Arial";
                    ctx.fillText("1", 20, 35);
                }
            }
        }
    }
}

// import QtQuick
// import QtQuick.Controls

// import NodeLink
// import LogicCircuit

// /*! ***********************************************************************************************
//  * LogicCircuitNodeView - Shows only symbols without background rectangles
//  * ************************************************************************************************/
// NodeView {
//     id: nodeView

//     // Remove the default node background and header
//     background: null

//     contentItem: Item {
//         anchors.fill: parent

//         // INPUT NODE: Only the toggle switch (no background)
//         Rectangle {
//             anchors.centerIn: parent
//             visible: node.type === LSpecs.NodeType.Input
//             width: 44
//             height: 22
//             radius: 11
//             color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
//             border.color: Qt.darker(color, 1.2)
//             border.width: 1

//             Text {
//                 anchors.centerIn: parent
//                 text: node.nodeData.currentState ? "ON" : "OFF"
//                 color: "#1E1E2E"
//                 font.bold: true
//                 font.pixelSize: 10
//             }

//             MouseArea {
//                 anchors.fill: parent
//                 cursorShape: Qt.PointingHandCursor
//                 onClicked: {
//                     if (node.toggleState) {
//                         node.toggleState();
//                     }
//                 }
//             }
//         }

//         // OUTPUT NODE: Only the fixed switch (no background)
//         Rectangle {
//             anchors.centerIn: parent
//             visible: node.type === LSpecs.NodeType.Output
//             width: 44
//             height: 22
//             radius: 11
//             color: node.nodeData.displayValue === "ON" ? "#A6E3A1" :
//                    node.nodeData.displayValue === "OFF" ? "#585B70" : "#757575"
//             border.color: Qt.darker(color, 1.2)
//             border.width: 1

//             Text {
//                 anchors.centerIn: parent
//                 text: node.nodeData.displayValue === "UNDEFINED" ? "?" : node.nodeData.displayValue
//                 color: "#1E1E2E"
//                 font.bold: true
//                 font.pixelSize: 10
//             }
//         }

//         // AND GATE: Only the official AND symbol
//         Canvas {
//             anchors.centerIn: parent
//             visible: node.type === LSpecs.NodeType.AND
//             width: 60
//             height: 40

//             onPaint: {
//                 var ctx = getContext("2d");
//                 ctx.reset();
//                 ctx.strokeStyle = node.guiConfig.color;
//                 ctx.lineWidth = 2;

//                 // Draw AND gate shape (D-shape)
//                 ctx.beginPath();
//                 ctx.moveTo(5, 5);
//                 ctx.lineTo(35, 5);
//                 ctx.arc(35, 20, 15, -Math.PI/2, Math.PI/2, false);
//                 ctx.lineTo(5, 35);
//                 ctx.closePath();
//                 ctx.stroke();

//                 // Draw AND symbol
//                 ctx.fillStyle = node.guiConfig.color;
//                 ctx.font = "bold 14px Arial";
//                 ctx.fillText("&", 25, 25);
//             }
//         }

//         // OR GATE: Only the official OR symbol
//         Canvas {
//             anchors.centerIn: parent
//             visible: node.type === LSpecs.NodeType.OR
//             width: 60
//             height: 40

//             onPaint: {
//                 var ctx = getContext("2d");
//                 ctx.reset();
//                 ctx.strokeStyle = node.guiConfig.color;
//                 ctx.lineWidth = 2;

//                 // Draw OR gate shape (curved shape)
//                 ctx.beginPath();
//                 ctx.moveTo(10, 5);
//                 ctx.quadraticCurveTo(30, 20, 10, 35);
//                 ctx.quadraticCurveTo(50, 20, 10, 5);
//                 ctx.closePath();
//                 ctx.stroke();

//                 // Draw OR symbol (≥1)
//                 ctx.fillStyle = node.guiConfig.color;
//                 ctx.font = "bold 12px Arial";
//                 ctx.fillText("≥1", 25, 23);
//             }
//         }

//         // NOT GATE: Only the official NOT symbol
//         Canvas {
//             anchors.centerIn: parent
//             visible: node.type === LSpecs.NodeType.NOT
//             width: 50
//             height: 40

//             onPaint: {
//                 var ctx = getContext("2d");
//                 ctx.reset();
//                 ctx.strokeStyle = node.guiConfig.color;
//                 ctx.lineWidth = 2;

//                 // Draw NOT gate triangle
//                 ctx.beginPath();
//                 ctx.moveTo(5, 5);
//                 ctx.lineTo(35, 20);
//                 ctx.lineTo(5, 35);
//                 ctx.closePath();
//                 ctx.stroke();

//                 // Draw inversion circle at output
//                 ctx.beginPath();
//                 ctx.arc(40, 20, 4, 0, Math.PI * 2);
//                 ctx.stroke();

//                 // Draw NOT symbol (1 at input side)
//                 ctx.fillStyle = node.guiConfig.color;
//                 ctx.font = "bold 12px Arial";
//                 ctx.fillText("1", 15, 25);
//             }
//         }
//     }
// }
