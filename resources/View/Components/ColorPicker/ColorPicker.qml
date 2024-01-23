import QtQuick
import QtQuick.Layouts
import NodeLink
import QtQuick.Controls
import QtQuick.Dialogs

import ColorTools

/*! ***********************************************************************************************
 * A color picker containing 5 colors and one custome color picker (first cell from right)
 * ************************************************************************************************/

Rectangle {  
    id: colorPickerRect

    /* Property Declarations
     * ****************************************************************************************/
    property string customeColor: colorDialog.color
    property string currentColor: colorDialog.color
    property int currentIndex: -1

    property var    colorItems:   []

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
    signal colorChanged(var colorName, var index)

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
            onClicked: updateColor(redColorItem.cellColor, redColorItem);
            Component.onCompleted: {
                colorItems.push(redColorItem)
                colorItemsChanged();
            }
        }

        ColorItem {
            id: greenItem
            cellColor: "green";
            onClicked: updateColor(greenItem.cellColor, greenItem);
            Component.onCompleted: {
                colorItems.push(greenItem)
                colorItemsChanged();
            }
        }

        ColorItem {
            id: purpleItem
            cellColor: "purple";
            onClicked: updateColor(purpleItem.cellColor, purpleItem);
            Component.onCompleted: {
                colorItems.push(purpleItem)
                colorItemsChanged();
            }
        }

        ColorItem {
            id: yellowItem
            cellColor: "yellow";
            onClicked: updateColor(yellowItem.cellColor, yellowItem);
            Component.onCompleted: {
                colorItems.push(yellowItem)
                colorItemsChanged();
            }
        }

        ColorItem {
            id: steelBlueItem
            cellColor: "steelblue";
            onClicked: updateColor(steelBlueItem.cellColor, steelBlueItem);
            Component.onCompleted: {
                colorItems.push(steelBlueItem)
                colorItemsChanged();
            }
        }

        ColorItem {
            id: rainbowColorItem
            isCustom: true
            cellColor: customeColor
            onClicked: colorDialog.open()
            Component.onCompleted: {
                colorItems.push(rainbowColorItem)
                colorItemsChanged();
            }
        }
    }

    //!qml color dialouge, for user to choose the color themeselves
    ColorPickerDialog {
        id: colorDialog
        color: colorPickerRect.currentColor
        width: 250
        height: 520

        background: Rectangle {
            anchors.fill: parent
            color: NLStyle.primaryBackgroundColor
            border.color: NLStyle.primaryColor
            border.width: 2
            radius: 5

        }
        onColorChanged: {
            if (colorDialog.visible)
                colorPickerRect.colorChanged(colorDialog.color, colorPickerRect.currentIndex);
        }
        onAccepted: {
            colorPickerRect.colorChanged(customeColor, 0);
            updateColor(customeColor, rainbowColorItem)
        }
        onRejected: {
            //! cancel button removed so we have no reject and accept always
            colorPickerRect.colorChanged(customeColor, 0);
            updateColor(customeColor, rainbowColorItem)
            /* code for rejection
            colorPickerRect.currentColorChanged();
            // not working good on multiple selection with different color Index
            colorPickerRect.colorChanged(colorPickerRect.currentColor, colorPickerRect.currentIndex);
            colorDialog.close()*/
        }
    }

    /* Functions
     * ****************************************************************************************/
    function updateColor(cellColor, colorItem) {
        colorPickerRect.currentColor = cellColor;
        colorPickerRect.currentIndex = colorItems.indexOf(colorItem);
        colorPickerRect.colorChanged(colorPickerRect.currentColor, colorPickerRect.currentIndex);
        colorPickerRect.visible = false;

        colorItems.forEach(colorItemInstance => {
            if (colorItemInstance !== colorItem)
                colorItemInstance.isCurrent = false;
            else
                colorItemInstance.isCurrent = true;
        });
    }

    function setColor(cellColor, colorIndex) {
        colorItems.forEach(colorItemInstance => {
                colorItemInstance.isCurrent = false;
        });
        if (colorIndex === 0) {
            rainbowColorItem.isCurrent = true;
        } else if (colorIndex > 0 && colorIndex <= colorItems.length) {
            colorItems[colorIndex].isCurrent = true;
        } else {
            // make default color current
            return;
        }
        colorPickerRect.currentIndex = colorIndex;
        colorPickerRect.currentColor = cellColor;
    }
}
