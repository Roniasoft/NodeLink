import QtQuick
import QtQuick.Layouts
import NodeLink
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * A color picker containing 6 colors
 * ************************************************************************************************/

Rectangle {  
    id: control

    width: colorPicker.width + 15
    height: 50
    color: "transparent"
    radius: 5
    border.width: 1
    border.color: "#363636"
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
            cellColor: rainbowColor.finalText

            onClicked: {
                rainbowColor.visible = !rainbowColor.visible
            }
        }
    }

    RainbowColorItem {
        id: rainbowColor
        visible: false
        finalText: "#363636"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.topMargin: -20
        onFinalTextChanged: control.colorChanged(finalText);
    }

}
