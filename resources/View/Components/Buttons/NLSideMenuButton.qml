import QtQuick 2.0

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
NLIconButton {
    id: button

    /* Property Declarations
     * ****************************************************************************************/


    /* Object Properties
     * ****************************************************************************************/
    textColor: (button.hovered || button.checked) ? "white" : "#808080"
    iconPixelSize: 19
    checkable: true
}