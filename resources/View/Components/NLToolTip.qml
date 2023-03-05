import QtQuick
import QtQuick.Controls

/*! ***********************************************************************************************
 * Custom NodeLink Tooltip
 * ************************************************************************************************/
ToolTip {
    id: nlToolTip

    /* Property Declarations
     * ****************************************************************************************/

    /* Object Properties
     * ****************************************************************************************/
    text: "This button does cool things"
    delay: 200


    /* Children
     * ****************************************************************************************/
    background: Rectangle{
        radius: 4
        color: "black"
    }
    contentItem: Text{
        text: nlToolTip.text
        color: "white"
        font.bold: true
    }
}
