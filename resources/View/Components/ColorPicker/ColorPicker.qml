import QtQuick
import QtQuick.Layouts
import NodeLink

/*! ***********************************************************************************************
 * A color picker containing 6 colors
 * ************************************************************************************************/

Rectangle {  
    id: control

    width: colorPicker.width + 4
    height: 50
    color: "transparent"

    signal colorChanged(var colorName)

    //A row with 6 colors
    RowLayout {
        id: colorPicker
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2
        //Each color is one color item
        ColorItem {
            cellColor: "red";
            onClicked: {
                control.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "green";
            onClicked: {
                control.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "purple";
            onClicked: {
                control.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "yellow";
            onClicked: {
                control.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "steelblue";
            onClicked: {
                control.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "black";
            onClicked: {
                control.colorChanged(cellColor);
            }
        }
    }
}
