import QtQuick
import NodeLink
import QtQuick.Controls

import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 * LinkView use I_LinkView (BezierCurve) to manages link children.
 * ************************************************************************************************/
I_LinkView {
    id: linkView

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Delete) {
                            shortcutManager.deleteSelectedObject();
                        }
                    }

    /* Children
    * ****************************************************************************************/
    //! Shortcut manager
    ShortcutManager {
        id: shortcutManager
        scene: root.scene
    }

    //! Link tools
    LinkToolsRect {
        id: linkToolRect

        x: linkMidPoint.x
        y: linkMidPoint.y - height * 2

        visible: isSelected
        scene: linkView.scene
        link: linkView.link

        onEditDescription: (isEditable) => {
                               descriptionText.focus = isEditable
                           }
    }

    // Description view
    TextArea {
        id: descriptionText
        x: linkMidPoint.x
        y: linkMidPoint.y

        text: link.guiConfig.description
        visible: link.guiConfig.description.length > 0 || activeFocus

        color: "white"
        font.family: "Roboto"
        font.pointSize: 14

        onTextChanged: {
            if (link && link.description !== text)
                link.guiConfig.description = text;
        }

        background: Rectangle {
            radius: 5
            border.width: 3
            border.color: isSelected ? link.guiConfig.color : "transparent"
            color: "#1e1e1e"
        }

        onFocusChanged: {
            if(focus && !isSelected) {
                scene.selectionModel.toggleLinkSelection(link);
            }
        }
    }

    Connections {
        target: scene

        // Send paint requset when PortsPositionsChanged
        function onPortsPositionsChanged () {
            linkView.requestPaint();
        }
    }

    Connections {
        target: link.guiConfig

        // Send paint requset when ColorChanged
        function onColorChanged () {
            linkView.requestPaint();
        }
    }

    //! To hide color picker if selected node is changed and
    //! remove focus on description TextArea
    Connections {
        target: linkView
        function onIsSelectedChanged() {
            linkToolRect.colorPicker.visible = false;
            descriptionText.focus = false;
        }
    }

//    MouseArea {
//       anchors.fill: parent

//       enabled: isSelected && !descriptionText.activeFocus
//       onDoubleClicked: descriptionText.forceActiveFocus();
//    }
}
