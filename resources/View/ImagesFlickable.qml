import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * Images Flickable appearing on top of each node that has images
 * ************************************************************************************************/
Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property I_Scene        scene

    property SceneSession   sceneSession

    property SelectionModel selectionModel: scene?.selectionModel ?? null

    property I_Node         node

    /* Object Properties
    * ****************************************************************************************/
    color: "#1e1e1e"
    radius: NLStyle.radiusAmount.itemButton
    border.width: 1
    border.color: "#363636"
    visible: node.imagesManager.imagesSources.length !== 0


    /*  Children
    * ****************************************************************************************/
    ListView {
        anchors.fill: parent
        anchors.margins: 4
        orientation: Qt.Horizontal
        model: node.imagesManager.imagesSources
        clip: true
        spacing: 4

        delegate: Rectangle {
            id: imageItem
            width: parent.height * nodeImage.aspectRatio
            height: parent.height
            color: "transparent"
            property int   radius: 5
            property color bgColor: "#1e1e1e"
            property int   drawRadius: radius > 0 ? radius : width / 2

            Image {
                id: nodeImage
                property double aspectRatio: sourceSize.width / sourceSize.height
                anchors.fill: parent
                fillMode: Image.Stretch
                property var image: modelData
                // Set the source to the local file path
                source: modelData
                asynchronous: true
            }

            Canvas {
                anchors.fill: parent
                antialiasing: true
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.fillStyle = imageItem.bgColor
                    ctx.beginPath()
                    ctx.rect(0, 0, width, height)
                    ctx.fill()
                    ctx.beginPath()
                    ctx.globalCompositeOperation = 'source-out'
                    ctx.roundedRect(0, 0, width, height, imageItem.drawRadius, imageItem.drawRadius)
                    ctx.fill()
                }
            }
            //! MouseArea for showing image popup
            MouseArea {
                id: imageMouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        imageViewer.visible = true
                    }



//                    if (isNodeEditable && mouse.button === Qt.RightButton) {
//                        scene.selectionModel.clearAllExcept(node._qsUuid);
//                        scene.selectionModel.selectNode(node);
//                        root.nodeContextMenu.popup(mouse.x, mouse.y);
//                    }
                }
            }

            //! delete button for image
            NLIconButtonRound {
                id: iconRect

                anchors.top: nodeImage.top
                anchors.right: nodeImage.right

                size: 25
                text: "\uf00d"
                radius: 2
                backColor: "transparent"
                textColor: "#fb464c"
                onClicked: node.imagesManager.deleteImage(nodeImage.image)

            }

            //! Image in its actual size
            NLPopUp {
                id: imageViewer
                parent: Overlay.overlay
                x: Math.round((parent.width - width) / 2)
                y: Math.round((parent.height - height) / 2)
                width: Math.min(popupImage.sourceSize.width, 850)
                height: Math.min(popupImage.sourceSize.height, 650)

                Image {
                    id: popupImage

                    anchors.fill: parent
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    source: nodeImage.image
                }
            }

        }
    }
}
