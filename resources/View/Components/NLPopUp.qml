import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts

import NodeLink


/*! ***********************************************************************************************
 * The NL Popup is the interface/base class that should be extended by notification popups.
 * ************************************************************************************************/
Popup {
    id: popup


    /* Property Declarations
     * ****************************************************************************************/
    property bool titleBar: false

    //! Title of popup
    property string title: "Title"

    //! icon of popup
    property string icon: ""


    /* Object Properties
     * ****************************************************************************************/
    // Material.roundedScale: Material.SmallScale
    visible: false

    //    Material.elevation: 10
    width: 467
    height: 427

    leftPadding: 12
    rightPadding: 12
    topPadding: 12
    bottomPadding: 12
    modal: true
    focus: visible
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside


    /* Children
     * ****************************************************************************************/
    Row {
        id: titlebarRow

        visible: titleBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
        anchors.topMargin: 15
        spacing: 10

        //! Text icon
        Text {
            text: icon
            font.family: "Font Awesome 6 Pro"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            font.weight: 800
            font.pixelSize: 20
            color: "#4890e2"
            anchors.verticalCenter: titleText.verticalCenter
        }

        //! Title text
        Text {
            id: titleText
            text: title
            font.weight: 500
            font.pixelSize: 18
            font.family: NLStyle.fontType.roboto
            color: "#4890e2"
        }
    }

    //! Customize dim background (for modal popups)
    Overlay.modal: Rectangle {
        color: "#44444444"
        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    //! overriden to add border and the background color to match the other widgets as the popup.Material.dialogColor is readonly
    background: Rectangle {
        // FullScale doesn't make sense for Popup.
        radius: 15
        color: "#161314"
        border.color: "#4890e2"
        border.width: 2

        layer.enabled: popup.Material.elevation > 0
        // layer.effect: RoundedElevationEffect {
        //     elevation: popup.Material.elevation
        //     roundedScale: popup.background.radius
        // }
    }
}
