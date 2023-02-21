import QtQuick

/*! ***********************************************************************************************
 * A color picker containing 6 colors
 * ************************************************************************************************/

Item {
    id: container
    property alias cellColor: rectangle1.color

    //once the user choses a color, a signal containing that color is sent
    signal clicked(color cellColor)

    width: 25;
    height: 25

    Rectangle {
        id: rectangle1
        radius: container.width /2
        border.color: "white"
        anchors.fill: parent
        border.width : mouseArea.containsMouse ? 5 : 1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked:{
            container.clicked(container.cellColor);
        }
    }
}
