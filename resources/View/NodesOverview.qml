import QtQuick

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
I_NodesRect {

    /* Property Declarations
    * ****************************************************************************************/

    /* Object Properties
     * ****************************************************************************************/
    color: "#1e1e1e"
    border.width: 8
    border.color: "#55FFFFFF"
    radius: NLStyle.radiusAmount.nodeOverview
    scale: NLStyle.overview.scale
    transformOrigin: Item.TopLeft

    /* Children
    * ****************************************************************************************/
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        z: 3
    }
}
