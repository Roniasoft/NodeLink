import QtQuick
import QtQuick.Controls
import QtQuick.NativeStyle as NativeStyle
import NodeLink

/*! ************************************************************************************************
 * The BaseButton class is used to add some additional functionality to all the buttons. To do this
 * all the buttons that are used in the UiCore project should inherit from this class.
 * ************************************************************************************************/
NativeStyle.DefaultButton {
    id: baseButton

    /* Property Declarations
     * ****************************************************************************************/
    property bool   rectHoverEnable:    false
    property string description:        ""             // Tooltip text
    property color  hoverBackColor:     Qt.lighter("#35393e", 1.2)
    property color  backColor:          "transparent"
    property color  textColor:          "black"
    property color  borderColor:        backColor
    property int    borderWidth:        1
    property int    radius:             0
    property alias  backgroundItem:     back         // Used to alter the background in other files


    /* Children
     * ****************************************************************************************/
    background: Rectangle {
        id: back

        anchors.fill: parent

        border.color: baseButton.enabled ? baseButton.borderColor : hoverBackColor
        border.width: baseButton.borderWidth

        radius: baseButton.radius
        color: baseButton.enabled ? baseButton.backColor : hoverBackColor
    }

    /* Animation Children
     * ****************************************************************************************/
    SequentialAnimation {
        id: clickAnimation

        NumberAnimation {
            target: contentItem
            properties: "opacity"

            duration: 250
            to: 0.8
            from: 1.0
        }
        NumberAnimation {
            target: contentItem
            properties: "opacity"

            duration: 250
            to: 1.0
            from: 0.8
        }
    }

    Behavior {
        NumberAnimation {
            target: contentItem
            properties: "scale"
            duration: 50
        }
    }

    /* Signal Handlers
     * ****************************************************************************************/
    onClicked: {
        clickAnimation.start();
    }

    onCheckedChanged: {
        if (checked) {
            clickAnimation.stop();
            opacity = 1.0;
        }
    }

    onHoveredChanged: {
        if (baseButton.rectHoverEnable) {
            back.color = (hovered && enabled) ? baseButton.hoverBackColor : baseButton.backColor
        }
        contentItem.scale = (hovered && enabled) ? 1.1 : 1.0
    }
}
