import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

/*! ***********************************************************************************************
 * RainbowColorItem, for the user to chose the color themselves using the hex code
 * ************************************************************************************************/

Rectangle{
    id: rainbowColorPicker

    property string finalText

    width: 200
    height: 120
    color: "#363636"
    radius: 5
    border.width: 1
    border.color: "#959595"



//    RowLayout {
//        id: firstRow
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 10
//        spacing: 15

//        Rectangle{
//            id: colorRrect
//            width: 120
//            height: 30
//            border.width: 1
//            radius: 5
//            border.color: "#959595"
//            color: "#363636"
//            TextInput{
//                id: colorRtext
//                width: parent.width
//                height: parent.height
//                horizontalAlignment: TextInput.AlignHCenter
//                verticalAlignment: TextInput.AlignVCenter
//                color: "#959595"
//            }
//        }

//        Rectangle{
//            id: colorGrect
//            width: 40
//            height: 30
//            border.width: 1
//            radius: 5
//            border.color: "#959595"
//            color: "#363636"
//            TextInput{
//                id:colorGtext
//                width: parent.width
//                height: parent.height
//                horizontalAlignment: TextInput.AlignHCenter
//                verticalAlignment: TextInput.AlignVCenter
//                color: "#959595"
//            }

//        }
//        Rectangle{
//            id: colorBrect
//            width: 40
//            height: 30
//            border.width: 1
//            radius: 5
//            border.color: "#959595"
//            color: "#363636"
//            TextInput{
//                id:colorBtext
//                width: parent.width
//                height: parent.height
//                horizontalAlignment: TextInput.AlignHCenter
//                verticalAlignment: TextInput.AlignVCenter
//                color: "#959595"
//            }
//        }
//    }

//    RowLayout {
//        id: secondRow
//        anchors.horizontalCenter: parent.horizontalCenter
//        height: parent.height / 2
//        anchors.top: firstRow.bottom
//        anchors.topMargin: -5

//        spacing: 48
//        Text{
//            text: "Hex"
//            color: colorRtext.color

//        }
//        Text{
//            text: "G"
//            color: colorGtext.color
//        }
//        Text{
//            text: "B"
//            color: colorBtext.color
//        }
//    }

//    Button{
//        width:50
//        height:35
//        anchors.top: secondRow.bottom
//        anchors.topMargin: -15
//        anchors.horizontalCenter: parent.horizontalCenter
//        //            anchors.verticalCenter: parent.verticalCenter
//        MouseArea{
//            anchors.fill: parent
//            onClicked: {
//                finalText = "#" + colorRtext.text
//                //                    rainbowColorPicker.clicked1(finalText)
//                console.log("here" + finalText)
//            }
//        }
//    }
}
