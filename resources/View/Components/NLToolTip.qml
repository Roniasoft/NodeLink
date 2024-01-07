import QtQuick
import QtQuick.Controls
import NodeLink

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
        radius: NLStyle.radiusAmount.toolTip
        color: "black"
    }
    contentItem: Text{
        text: nlToolTip.text
        color: "white"
        font.bold: true
    }

    //! To fix the fade effect on tooltip
    exit: Transition {}
}
