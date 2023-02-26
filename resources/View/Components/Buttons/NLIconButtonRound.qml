import QtQuick 2.0
import QtQuick.Controls 2.15

/*! ***********************************************************************************************
 * The MslIconButtonRound is round button with a icon as contentItem. Because the button is round
 * the size property has been introduced so only one property has to be set to determine the size.
 * ************************************************************************************************/
NLIconButton {
    id: mslIconButtonRound

    /* Property Declarations
     * ****************************************************************************************/
    property int size: 100

    /* Object Properties
     * ****************************************************************************************/
    height: size
    width: size

    backColor: "blue"
    textColor: "white"

    radius: width / 2
    iconPixelSize: height * 0.55
}
