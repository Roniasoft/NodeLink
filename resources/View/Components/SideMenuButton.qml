import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Buttons designed for the side menu
 * ************************************************************************************************/
ToolButton {
    id: sideMenuToolButtons

    /* Property Declarations
     * ****************************************************************************************/
    property string position

    /* Object Properties
     * ****************************************************************************************/
    width: 30
    height: 30
    text: "\uf2ed"
    font.family: NLStyle.fontType.font6Pro
    font.pixelSize: 15
    font.weight: 400

    /* Children
     * ****************************************************************************************/
    contentItem: Text {
        text: sideMenuToolButtons.text
        font: sideMenuToolButtons.font
        color: !enabled ? "#7a7676" : (checked) ? "dodgerblue" : "#a6a6a6"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    //!Background specifically defined to handle opacity and round corners
    background: Rectangle {
        id: sideMenuToolButtonController
        width: sideMenuToolButtons.width
        height: sideMenuToolButtons.height
        radius: NLStyle.radiusAmount.itemButton
        color: sideMenuToolButtons.hovered ? "#494949" : "transparent"
        Rectangle {
            color: sideMenuToolButtons.hovered ? "#494949" : "transparent"
            height: sideMenuToolButtonController.radius
            anchors.bottom : (position==="middle" || position==="top") ?  sideMenuToolButtonController.bottom : undefined
            anchors.left : (position!=="only") ? sideMenuToolButtonController.left : undefined
            anchors.right : (position!=="only") ?  sideMenuToolButtonController.right : undefined
            anchors.top: (position==="middle" || position==="bottom") ? sideMenuToolButtonController.top : undefined
        }
    }

}
