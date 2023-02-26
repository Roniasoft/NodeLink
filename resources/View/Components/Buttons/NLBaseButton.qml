import QtQuick 2.0
import QtQuick.Controls

/*! ************************************************************************************************
 * The BaseButton class is used to add some additional functionality to all the buttons. To do this
 * all the buttons that are used in the UiCore project should inherit from this class.
 * ************************************************************************************************/
Button {
    id: baseButton

    /* Property Declarations
     * ****************************************************************************************/
    property string description: ""             // Tooltip text
    property color backColor: "transparent"
    property color textColor: "black"
    property color borderColor: backColor
    property int borderWidth: 0
    property int radius: 0
    property alias backgroundItem: back         // Used to alter the background in other files


    /* Children
     * ****************************************************************************************/
    background: Rectangle {
        id: back

        anchors.fill: parent

        border.color: baseButton.borderColor
        border.width: baseButton.borderWidth

        radius: baseButton.radius
        color: baseButton.backColor
    }

    ToolTip {
        visible: baseButton.hovered && (description !== "")
        text: baseButton.description
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
        contentItem.scale = (hovered && enabled) ? 1.05 : 1.0
    }
}
