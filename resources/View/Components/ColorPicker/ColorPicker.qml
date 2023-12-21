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
    property var    colorItems:   []

    /* Object Properties
     * ****************************************************************************************/
    width: colorPicker.width + 15
    height: 50
    color: NLStyle.primaryBackgroundColor
    radius: NLStyle.radiusAmount.itemButton
    border.width: 1
    border.color: NLStyle.primaryBorderColor
    onColorItemsChanged:  {
        console.log("hey, ", colorItems)
    }

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
    ColorDialog {
        id: colorDialog
        title: "Please Choose a Color"
        onSelectedColorChanged: {
            colorPickerRect.colorChanged(colorDialog.selectedColor);
        }
        onAccepted: {
            colorPickerRect.colorChanged(customeColor);
            updateColor(customeColor, rainbowColorItem)
//            rainbowColorItem.isCustom = false
        }
        onRejected: {
            colorDialog.close()
        }
    }

    /* Functions
     * ****************************************************************************************/
    function updateColor(cellColor, colorItem) {
        colorPickerRect.colorChanged(cellColor);
        colorPickerRect.visible = false;
//        rainbowColorItem.isCustom = true;
        colorItems.forEach(colorItemInstance => {
            if (colorItemInstance !== colorItem)
                colorItemInstance.isCurrent = false;
            else
                colorItemInstance.isCurrent = true;
        });
    }
}
