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
    color: NLStyle.primaryBackgroundColor
    radius: NLStyle.radiusAmount.itemButton
    border.width: 1
    border.color: NLStyle.primaryBorderColor

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
            id: redColorItem
            cellColor: "red";
            onClicked: updateColor(redColorItem.cellColor);
        }

        ColorItem {
            id: greenItem
            cellColor: "green";
            onClicked: updateColor(greenItem.cellColor);
        }

        ColorItem {
            id: purpleItem
            cellColor: "purple";
            onClicked: updateColor(purpleItem.cellColor);
        }

        ColorItem {
            id: yellowItem
            cellColor: "yellow";
            onClicked: updateColor(yellowItem.cellColor);
        }

        ColorItem {
            id: steelBlueItem
            cellColor: "steelblue";
            onClicked: updateColor(steelBlueItem.cellColor);
        }

        ColorItem {
            id: rainbowColorItem
            isCustom: true
            cellColor: customeColor
            onClicked: colorDialog.open()
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
            rainbowColorItem.isCustom = false
        }
        onRejected: {
            colorDialog.close()
        }
    }

    /* Functions
     * ****************************************************************************************/
    function updateColor(cellColor) {
        colorPickerRect.colorChanged(cellColor);
        colorPickerRect.visible = false;
        rainbowColorItem.isCustom = true;
    }
}
