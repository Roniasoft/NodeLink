import QtQuick
import QtQml

/*! ***********************************************************************************************
 * colot items or color cells.
 * ************************************************************************************************/

Item {
    id: colorItemContainer

    /* Property Declarations
     * ****************************************************************************************/
    property alias cellColor: innerRect.color
    //! Is color Item rainbow(custom) or not
    property bool  isCustom:  false
    //Is the color Item currently selected color item or not
    property bool  isCurrent: false

    /* Signals
     * ****************************************************************************************/
    signal clicked(color cellColor)

    /* Object Properties
     * ****************************************************************************************/
    width: 30;
    height: 30;

    //! outer rectangle, only visible when contains mouse (for effect)
    Rectangle{
        id:outerRect
        anchors.fill: parent
        radius: width /2
        visible: mouseArea.containsMouse || isCurrent ? true : false
        border.color: mouseArea.containsMouse || isCurrent ? cellColor : "#3f3f3f"

        Canvas {
            anchors.fill: parent
            enabled: isCustom && (isCurrent || mouseArea.containsMouse)
            visible: isCustom && (isCurrent || mouseArea.containsMouse)
            antialiasing: true
            smooth: true
            onPaint: {
                var ctx = getContext("2d");

                ctx.fillStyle = rainbowGradient(ctx, width, height);
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
                ctx.fill();
            }
        }

        Rectangle {
            width: parent.width - 2
            height: parent.height - 2
            radius: width / 2
            color: "black"
            anchors.centerIn: parent

        }
    }

    //! inner rectangle, containing the color
    Rectangle {
        id: innerRect
        width: colorItemContainer.width - 6;
        height: colorItemContainer.height - 6;
        radius: innerRect.width/2
        anchors.centerIn: outerRect

        Canvas {
            anchors.fill: parent
            enabled: isCustom && !isCurrent
            visible: isCustom && !isCurrent
            antialiasing: true
            smooth: true
            onPaint: {
                var ctx = getContext("2d");

                ctx.fillStyle = rainbowGradient(ctx, width, height);
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
                ctx.fill();
            }
        }
    }

    //mousearea for handling clicks (sends a signal containing chosen color)
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked:{
            colorItemContainer.clicked(colorItemContainer.cellColor);
        }
    }

    /* Functions
     * ****************************************************************************************/
    function rainbowGradient(ctx, width, height) {
        var gradient = ctx.createConicalGradient(width / 2, height / 2, 0);

        gradient.addColorStop(0.00, "rgba(255, 0, 0, 0.8)");
        gradient.addColorStop(0.17, "rgba(255, 165, 0, 0.8)");
        gradient.addColorStop(0.33, "rgba(255, 255, 0, 0.8)");
        gradient.addColorStop(0.50, "rgba(0, 255, 0, 0.8)");
        gradient.addColorStop(0.67, "rgba(0, 0, 255, 0.8)");
        gradient.addColorStop(0.83, "rgba(75, 0, 130, 0.8)");
        gradient.addColorStop(1.00, "rgba(148, 0, 211, 0.8)");

        return gradient;
    }
}
