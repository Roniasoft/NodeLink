import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import NodeLink
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * Button groups for the side menu
 * ************************************************************************************************/
Rectangle {
    id: sideMenuGroup

    /* Property Declarations
     * ****************************************************************************************/
    default property alias  contents:   layout.data

    property alias          layout:     layout

    /* Object Properties
     * ****************************************************************************************/
    radius: NLStyle.radiusAmount.itemButton
    height: layout.implicitHeight
    width: 34
    border.color: "#3f3f3f"
    color: "#3f3f3f"

    /* Children
     * ****************************************************************************************/
    //A column of different buttons
    ColumnLayout {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3     
    }
}

