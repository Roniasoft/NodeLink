import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Tool bar buttons
 * ************************************************************************************************/
ToolButton {
    id: toolButton

    /* Object Properties
     * ****************************************************************************************/
    width: 30
    height: 30
    text: "\uf2ed"
    font.family: NLStyle.fontType.font6Pro
    font.pixelSize: 17
    font.weight: 400

    /* Children
     * ****************************************************************************************/
    contentItem: Text {
        text: toolButton.text
        font: toolButton.font
        textFormat: Text.MarkdownText
        opacity: enabled ? 1.0 : 0.3
        color: "#75FFFFFF"//control.down ? "#17a81a" : "#21be2b"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id:toolButtonController
        width: toolButton.width
        height: toolButton.height
        radius: NLStyle.radiusAmount.itemButton
        color: toolButton.hovered || toolButton.checked? "#2f2f2f" : "transparent"
        opacity: enabled ? 1 : 0.3
        Behavior on color{ColorAnimation{duration: 75}}
    }
}
