import QtQuick
import QtQuick.Controls
import NodeLink
/*! ***********************************************************************************************
 * The iconButton is button with a icon as contentItem. The reason that the textIcon is not used
 * in this class is because it would overwrite the contentItem and style from the Button.qml class.
 * ************************************************************************************************/
NLBaseButton {
    id: iconButton

    /* Property Declarations
     * ****************************************************************************************/
    property int iconPixelSize: height * 0.8
    property int fontWeight: 900

    /* Object Properties
     * ****************************************************************************************/
    textColor: "white"

    contentItem: Text {
        id: textIcon

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
//        fontSizeMode: Text.Fit
        minimumPixelSize: 10;
        font.pixelSize: iconPixelSize
        font.family: "Font Awesome 6 Pro"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        color: (!iconButton.enabled ? Qt.darker(textColor, 1.2) : textColor)
        font.weight: fontWeight
        text: iconButton.text
    }
}
