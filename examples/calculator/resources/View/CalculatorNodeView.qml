import QtQuick
import QtQuick.Controls

import NodeLink
import Calculator

/*! ***********************************************************************************************
 * CalculatorNodeView is nodeView to show nodeView calculator.
 * ************************************************************************************************/

NodeView {
    id: nodeView

    /* Object Properties
    * ****************************************************************************************/

    contentItem: Item {
        id: mainContentItem
        property bool iconOnly: ((node?.operationType ?? -1) > -1) ||
                                nodeView.isNodeMinimal
        //! Header Item
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12

            visible: !mainContentItem.iconOnly
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
            NLTextArea {
                id: titleTextArea

                anchors.right: parent.right
                anchors.left: iconText.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                height: 40

                rightPadding: 10

                readOnly: !nodeView.edit
                focus: false
                placeholderText: qsTr("Enter title")
                color: NLStyle.primaryTextColor
                selectByMouse: true
                text: node.title
                verticalAlignment: Text.AlignVCenter
                onTextChanged: {
                    if (node && node.title !== text)
                        node.title = text;
                }

                onPressed: (event) => {
                               if (event.button === Qt.RightButton) {
                                   nodeView.edit = false
                               }
                           }

                smooth: true
                antialiasing: true
                font.pointSize: 10
                font.bold: true

                //! Connections to forceActiveFocus when
                //! nodeView.edit is true
                Connections {
                    target: nodeView

                    function onEditChanged() {
                        if(nodeView.edit)
                            titleTextArea.forceActiveFocus();
                    }
                }
            }
        }

        // Description Text
        NLTextField {
            id: textArea

            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5

            focus: false
            visible: !mainContentItem.iconOnly
            placeholderText: qsTr("Number")
            color: NLStyle.primaryTextColor
            text: node?.nodeData?.data
            readOnly: !nodeView.edit || (node.type === CSpecs.NodeType.Result)
            wrapMode:TextEdit.WrapAnywhere
            onTextChanged: {
                if (node && (node.nodeData?.data ?? "") !== text) {
                    if (node.type === CSpecs.NodeType.Source) {
                        node.nodeData.data = text;
                        scene.updateData();
                    }
                }
            }
            smooth: true
            antialiasing: true
            font.bold: true
            font.pointSize: 9
            validator: DoubleValidator {}

            onPressed: (event) => {
                           if (event.button === Qt.RightButton) {
                               nodeView.edit = false;
                           }
                       }
            background: Rectangle {
                color: "transparent";
            }

        }

        //! Minimal nodeview in low zoomFactor: forgrond
        Rectangle {
            id: minimalRectangle
            anchors.fill: parent
            anchors.margins: 10

            color: mainContentItem.iconOnly ? "#282828" : "trasparent"
            radius: NLStyle.radiusAmount.nodeView

            //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0.7
            OpacityAnimator {
                target: minimalRectangle

                from: minimalRectangle.opacity
                to: 0.7
                duration: 200
                running: mainContentItem.iconOnly
            }

            //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0
            OpacityAnimator {
                target: minimalRectangle

                from: minimalRectangle.opacity
                to: 0
                duration: 200
                running: !mainContentItem.iconOnly
            }

            //! Text Icon
            Text {
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 60
                anchors.centerIn: parent
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
                font.weight: 400
                visible: mainContentItem.iconOnly
            }
        }
    }
}
