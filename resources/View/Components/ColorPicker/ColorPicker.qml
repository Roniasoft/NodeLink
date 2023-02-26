import QtQuick
import QtQuick.Layouts
import NodeLink
import QtQuick.Controls
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * A color picker containing 5 colors and one custome color picker (first cell from right)
 * ************************************************************************************************/

Rectangle {  
    id: colorPickerRect

    /* Property Declarations
     * ****************************************************************************************/
    property string customeColor: colorDialog.selectedColor

    /* Object Properties
     * ****************************************************************************************/
    width: colorPicker.width + 15
    height: 50
    color: "transparent"
    radius: 5
    border.width: 1
    border.color: "#363636"

    /* Signals
     * ****************************************************************************************/
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
                colorPickerRect.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "green";
            onClicked: {
                colorPickerRect.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "purple";
            onClicked: {
                colorPickerRect.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "yellow";
            onClicked: {
                colorPickerRect.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: "steelblue";
            onClicked: {
                colorPickerRect.colorChanged(cellColor);
            }
        }
        ColorItem {
            cellColor: customeColor
            onClicked: {
                colorDialog.open()
            }
        }
    }

    //!qml color dialouge, for user to choose the color themeselves
    ColorDialog {
        id: colorDialog
        title: "Please Choose a Color"
        onSelectedColorChanged: {
            colorPickerRect.colorChanged(colorDialog.selectedColor);
        }
        onAccepted: {
            colorPickerRect.colorChanged(customeColor);
        }
        onRejected: {
            colorDialog.close()
        }
    }
}
