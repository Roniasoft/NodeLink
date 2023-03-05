import QtQuick
import QtQuick.Controls

ToolTip {
    id: nlToolTip
    text: "This button does cool things"
    delay: 200
    background: Rectangle{
        radius: 4
        color: "black"
    }
    contentItem: Text{
        text: nlToolTip.text
        color: "white"
        font.bold: true
    }

}
