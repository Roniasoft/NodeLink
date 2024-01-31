import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * Image Viewer, with ability to navigate between pictures
 * ************************************************************************************************/
NLPopUp {
    id: imageViewer

    /* Property Declarations
    * ****************************************************************************************/
    //! All the images in nodes
    property var images: []

    //! Shown image appearing in popup
    property var shownImage;

    /* Object Properties
    * ****************************************************************************************/
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: Math.min(popupImage.sourceSize.width > popupImage.sourceSize.height - 50 ?
                        popupImage.sourceSize.width + 80 : popupImage.sourceSize.width, 1050)
    height: Math.min(popupImage.sourceSize.height, 650)

    /* Children
    * ****************************************************************************************/
    //! Image shown in popup
    Image {
        id: popupImage

        anchors.fill: parent
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: shownImage
    }

    //! Left arrow icon
    NLIconButton {
        id: leftArrow
        text: "\uf104"
        textColor: NLStyle.primaryTextColor
        iconPixelSize: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        onClicked: {
            if (images.indexOf(shownImage) - 1 >= 0)
                shownImage = images[images.indexOf(shownImage) - 1];
        }
    }

    //! Right arrow icon
    NLIconButton {
        id: rightArrow
        text: "\uf105"
        textColor: NLStyle.primaryTextColor
        iconPixelSize: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        onClicked: {
            if (images.indexOf(shownImage) + 1 < images.length)
                shownImage = images[images.indexOf(shownImage) + 1];
        }
    }

    //! Item is a placeholder for keys item to work
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: (event)=> {
            if (event.key === Qt.Key_Left)
                leftArrow.clicked()
            if (event.key === Qt.Key_Right)
                rightArrow.clicked()
        }
    }
}
