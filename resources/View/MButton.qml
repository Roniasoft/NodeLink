import QtQuick
import QtQuick.Controls

/*! ***********************************************************************************************
 * Tool bar buttons
 * ************************************************************************************************/

ToolButton {
    id: control
    width: 30
    height: 30
    text: "\uf2ed"
    font.family: "fa-regular"
//    color: "white"
    font.pixelSize: 17

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "#75FFFFFF"//control.down ? "#17a81a" : "#21be2b"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background:
    Rectangle {
        id:controller
        width: control.width
        height: control.height
        radius: 5
        color: control.hovered ? "#2f2f2f" : "transparent"
        opacity: enabled ? 1 : 0.3
//        visible: control.down || (control.enabled && (control.checked || control.highlighted))
        Behavior on color{ColorAnimation{duration: 75}}
    }
}
