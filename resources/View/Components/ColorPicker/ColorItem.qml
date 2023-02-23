import QtQuick
import QtQml

/*! ***********************************************************************************************
 * colot items
 * ************************************************************************************************/

Item {
    id: colorItemContainer
    property alias cellColor: innerRect.color

    //once the user choses a color, a signal containing that color is sent
    signal clicked(color cellColor)

    width: 30;
    height: 30;


    Rectangle{
        id:outerRect
        anchors.fill: parent
        radius: width /2
        visible: mouseArea.containsMouse ? true : false
        border.color: cellColor
        border.width: 2
        color: "black"
    }

    Rectangle {
        id: innerRect
        width: colorItemContainer.width - 6;
        height: colorItemContainer.height - 6;
        radius: innerRect.width/2
        anchors.centerIn: outerRect
    }

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
