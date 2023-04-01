import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import Qt5Compat.GraphicalEffects
import QtQuickStream


/*! ***********************************************************************************************
 * NodesScene show the Nodes, Connections, ports and etc.
 * ************************************************************************************************/
Flickable {
    id: flickable

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    property QtObject           privateProperty: QtObject {
     property bool ctrlPressedAndHold: false
    }


    /* Object Properties
 * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: 4000
    contentHeight: 4000
    focus: true
    ScrollBar.horizontal: HorizontalScrollBar{}
    ScrollBar.vertical: VerticalScrollBar{}

    /* Children
* ****************************************************************************************/
    SceneViewBackground {
        id: background
        anchors.fill: parent
        viewWidth: flickable.contentWidth
        viewHeigth: flickable.contentHeight
    }


    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Control) {
                            privateProperty.ctrlPressedAndHold = true
                        }
                    }
    Keys.onReleased: privateProperty.ctrlPressedAndHold = false

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        z: -10
        onWheel: wheel => {
                     if(!flickable.privateProperty.ctrlPressedAndHold)
                     return;
                     if(wheel.angleDelta.y > 0)
                     flickable.scale += 0.1;
                     else if (flickable.scale > 0.5) {
                         flickable.scale -= 0.1;
                     }
                 }

        onClicked: mouse => {
            if(mouse.button === Qt.LeftButton){
                scene.selectionModel.select(null)
                flickable.forceActiveFocus()
            }
            else if (mouse.button === Qt.RightButton){
                console.log("right clicked")
                contextMenu.popup(mouse.x, mouse.y)
            }
        }
        ContextMenu {
            id: contextMenu
            scene: flickable.scene
        }
    }

    //! Nodes/Connections
    NodesRect {
        id: nodesView
        scene: flickable.scene
        sceneSession: flickable.sceneSession
        contentWidth: flickable.contentWidth
        contentHeight: flickable.contentHeight
    }
}
