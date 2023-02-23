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
        visible: mouseArea.containsMouse ? true : false
        border.color: cellColor
        border.width: 2
        color: "black"
    }

    //! inner rectangle, containing the color
    Rectangle {
        id: innerRect
        width: colorItemContainer.width - 6;
        height: colorItemContainer.height - 6;
        radius: innerRect.width/2
        anchors.centerIn: outerRect
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
}
