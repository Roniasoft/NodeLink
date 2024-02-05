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

    property var selectedItems : Object.values(selectionModel?.selectedModel ?? ({}))

    property I_Node         node

    property bool selectedAlone : selectedItems.length === 1 && node === selectedItems[0]

    /* Object Properties
    * ****************************************************************************************/
    color: "#1e1e1e"
    radius: NLStyle.radiusAmount.itemButton
    border.width: 1
    border.color: "#363636"
    visible: node.imagesModel.imagesSources.length !== 0


    /*  Children
    * ****************************************************************************************/
    ListView {
        anchors.fill: parent
        anchors.margins: 4
        orientation: Qt.Horizontal
        model: node.imagesModel.imagesSources
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
                onEntered: {
                    iconRect.visible = true
                }
                onExited: {
                    iconRect.visible = false
                }

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        imageViewer.shownImage = nodeImage.image
                        imageViewer.visible = true
                    }
                }
            }

            //! delete button for image
            NLIconButtonRound {
                id: iconRect

                anchors.top: nodeImage.top
                anchors.right: nodeImage.right

                size: 20
                text: "\uf00d"
                radius: 2
                backColor: "transparent"
                textColor: "#fb464c"
                visible: false
                onClicked: {
                    if (nodeImage.image === node.imagesModel.imagesSources[node.imagesModel.coverImageIndex])
                        node.imagesModel.coverImageIndex = -1;
                    node.imagesModel.deleteImage(nodeImage.image)
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    hoverEnabled: true
                    onEntered: iconRect.visible = true
                }
            }

            NLIconButtonRound {
                id: starRect

                anchors.top: nodeImage.top
                anchors.left: nodeImage.left
                fontWeight: (node.imagesModel.imagesSources[node.imagesModel.coverImageIndex] === nodeImage.image) ? 900 : 400

                size: 20
                text: "\uf005"
                radius: 2
                backColor: "transparent"
                textColor: "yellow"
                onClicked: {
                    if (node.imagesModel.imagesSources[node.imagesModel.coverImageIndex] !== nodeImage.image)
                        node.imagesModel.coverImageIndex = node.imagesModel.imagesSources.indexOf(nodeImage.image);
                    else
                        node.imagesModel.coverImageIndex = -1;
                }

            }

            //! Image in its actual size
            ImageViewer {
                id: imageViewer
                images: node.imagesModel.imagesSources
                shownImage: nodeImage.image
            }

        }
    }
}
