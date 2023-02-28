import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import Qt5Compat.GraphicalEffects

/*! ***********************************************************************************************
 * NodesScene show the Nodes, Connections, ports and etc.
 * ************************************************************************************************/

Flickable {
    id: flickable

    /* Property Declarations
    * ****************************************************************************************/
    property real scaler:1
    property Scene              scene
    property SceneSession       sceneSession
    property alias              tempConnection: tempConnection
    property QtObject           privateProperty: QtObject {
    property bool ctrlPressedAndHold: false}

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: 4000
    contentHeight: 4000
    focus: true

    /* Font Loader
    * ****************************************************************************************/
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }

    /* Children
    * ****************************************************************************************/

    //!Scroll Bars
    ScrollBar.vertical: ScrollBar {
        width: 5
        policy: ScrollBar.AsNeeded
    }
    ScrollBar.horizontal: ScrollBar {
        height: 5
        policy: ScrollBar.AsNeeded
    }

    //! Mousearea to handle zoom (ctrl + wheel)
    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Control) {
                            flickable.privateProperty.ctrlPressedAndHold = true
                        }
                    }
    Keys.onReleased: flickable.privateProperty.ctrlPressedAndHold = false
    MouseArea {
        anchors.fill: parent
        z: -10
        onWheel: wheel => {
                    if(!flickable.privateProperty.ctrlPressedAndHold)
                    return;
                    if(!(rect1.scale >= 3) && wheel.angleDelta.y > 0){
                        rect1.scale += 0.05
                    }
                     else if (!(rect1.scale <= 0.5)){
                        rect1.scale -= 0.05
                    }
                }
        onClicked: {
            scene.selectionModel.select(null)
            flickable.forceActiveFocus()
        }
    }

    //!Anything contained in this rectangle can be zoomed
    Rectangle{
        id: rect1
        anchors.centerIn: parent
        width: flickable.contentWidth/rect1.scale
        height: flickable.contentHeight/rect1.scale
        color: "transparent"
        transformOrigin: Item.Center

        //! Nodes/Connections (pay attention to contentWidth and contentHeight)
        NodesRect {
            id: nodesView
            scene: flickable.scene
            sceneSession: flickable.sceneSession
            contentWidth: rect1.width
            contentHeight: rect1.height
        }

        //! Temp Connection
        ConnectionView {
            id: tempConnection
            anchors.fill: parent
            startPos: sceneSession.tempConnectionStartPos
            endPos: sceneSession.tempConnectionEndPos
            visible: sceneSession.creatingConnection
        }
    }
}
//        SceneViewBackground {
//            id: background
//            anchors.fill: parent
//            viewWidth: flickable.contentWidth
//            viewHeigth: flickable.contentHeight
//        }


