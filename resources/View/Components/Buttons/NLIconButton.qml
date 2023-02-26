import QtQuick
import QtQuick.Controls
import SituationSimulator
/*! ***********************************************************************************************
 * The MslIconButton is button with a icon as contentItem. The reason that the textIcon is not used
 * in this class is because it would overwrite the contentItem and style from the Button.qml class.
 * ************************************************************************************************/
NLBaseButton {
    id: mslIconButton

    /* Property Declarations
     * ****************************************************************************************/
    property int iconPixelSize: height * 0.8

    /* Object Properties
     * ****************************************************************************************/
    textColor: "white"

    contentItem: TextIcon {
        id: textIcon

        fontSizeMode: Text.Fit
        minimumPixelSize: 10;
        font.pixelSize: iconPixelSize

        color: !mslIconButton.enabled ? "gray" : textColor

        text: mslIconButton.text
    }
}
