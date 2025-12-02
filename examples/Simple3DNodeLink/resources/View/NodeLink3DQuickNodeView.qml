import QtQuick
import QtQuick.Controls

import NodeLink
import simple3DNodeLink

/*! ***********************************************************************************************
 * Simple3DNodeLinkNodeView is nodeView to show nodeView in 3D space.
 * This is similar to CalculatorNodeView but for 3D environment.
 * ************************************************************************************************/

NodeView {
    id: nodeView

    /* Object Properties
    * ****************************************************************************************/

    contentItem: Item {
        id: mainContentItem
        property bool iconOnly: nodeView.isNodeMinimal
        
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
                text: scene?.nodeRegistry?.nodeIcons?.[node.type] ?? ""
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
                    target: nodeView && nodeView.edit !== undefined ? nodeView : null

                    function onEditChanged() {
                        // Check if objects are still valid
                        if (!nodeView || !titleTextArea) return;
                        if(nodeView.edit)
                            titleTextArea.forceActiveFocus();
                    }
                }
            }
        }

        // Description Text - Show node data
        NLTextField {
            id: textArea

            property bool _internalUpdate: false

            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5

            focus: false
            visible: !mainContentItem.iconOnly
            placeholderText: qsTr("Value")
            color: NLStyle.primaryTextColor
            text: {
                if (_internalUpdate) {
                    // Return current text to avoid binding loop
                    var currentText = textArea.text;
                    return currentText !== undefined ? currentText : "";
                }
                // Check if node and nodeData are still valid
                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return "";
                try {
                    var data = node.nodeData.data;
                    return data !== null && data !== undefined ? String(data) : "";
                } catch (e) {
                    // Object destroyed, return empty
                    return "";
                }
            }
            readOnly: !nodeView.edit || (node.type === 1)  // ResultNode type is 1
            wrapMode: TextEdit.WrapAnywhere
            onTextChanged: {
                if (_internalUpdate) return;
                // Check if objects are still valid
                if (!node || !node.nodeData || typeof node.nodeData === 'undefined') return;
                try {
                    var currentData = node.nodeData.data;
                    var currentDataStr = (currentData !== null && currentData !== undefined) ? String(currentData) : "";
                    if (currentDataStr !== text) {
                        if (node.type === 0) {  // SourceNode type is 0
                            _internalUpdate = true;
                            node.nodeData.data = text;
                            _internalUpdate = false;
                            if (scene && scene.updateData) {
                                scene.updateData();
                            }
                        }
                    }
                } catch (e) {
                    // Object destroyed during operation, ignore
                    _internalUpdate = false;
                }
            }
            smooth: true
            antialiasing: true
            font.bold: true
            font.pointSize: 9

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

            color: mainContentItem.iconOnly ? "#282828" : "transparent"
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
                text: scene?.nodeRegistry?.nodeIcons?.[node.type] ?? ""
                color: node.guiConfig.color
                font.weight: 400
                visible: mainContentItem.iconOnly
            }
        }
    }
}
