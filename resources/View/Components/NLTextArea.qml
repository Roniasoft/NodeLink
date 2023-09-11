import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T
import QtQuick.Controls.Universal 2.12

/*! ***********************************************************************************************
 * NLTextArea is a custome TextArea for NodeLink to be compatible with Qt 6.5
 * ************************************************************************************************/
T.TextArea {
    id: control

    /*  Object Properties
    * ****************************************************************************************/
    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 6
    leftPadding: padding + 4

    color: control.palette.text
    //! placeholderTextColor is the actual text color with a 0.5 opacity (alpha is set to 0.5)
    placeholderTextColor: Qt.hsla(control.color.hslHue, control.color.hslSaturation, control.color.hslLightness, 0.5)
    selectionColor: control.palette.highlight
    selectedTextColor: control.palette.highlightedText

    background: Rectangle {
        color: "transparent"
    }

    /*  Children
    * ****************************************************************************************/
    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
        renderType: control.renderType
    }
}
