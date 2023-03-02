import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import Qt5Compat.GraphicalEffects
import "./Components"

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
        property real zoomFactor: 1
        property point zoomPoint;
        property bool ctrlPressedAndHold: false
    }

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
        width: 4
        opacity: 0.3
        background: Rectangle {
            color: "black"
            width: 4
            opacity: 0.8
        }
    }
    ScrollBar.horizontal: ScrollBar {
        height: 4
        opacity: 0.3
        background: Rectangle {
            color: "black"
            height: 4
            opacity: 0.8
        }
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        z: -10
        onWheel: wheel => {
                    if(!flickable.privateProperty.ctrlPressedAndHold)
                    return;

                    if(flickable.privateProperty.zoomFactor < 3 && wheel.angleDelta.y > 0)
                        flickable.privateProperty.zoomFactor += 0.05

                     else if (flickable.privateProperty.zoomFactor > 0.5)
                        flickable.privateProperty.zoomFactor -= 0.05

                     flickable.privateProperty.zoomPoint = Qt.point(wheel.x, wheel.y);
                }
        onClicked: mouse => {
            if(mouse.button === Qt.LeftButton){
                scene.selectionModel.select(null)
                flickable.forceActiveFocus()
            }
            else if (mouse.button === Qt.RightButton){
                console.log("right clicked")
                contextMenu.popup(mouseX,mouseY)
                //scene.addNode(mouseX,mouseY)
            }

        }
        ContextMenu {
            id: contextMenu
            scene: flickable.scene
        }
    }


    //!Anything contained in this rectangle can be zoomed
    Rectangle{
        id: rect1
        anchors.centerIn: parent
        width: flickable.contentWidth
        height: flickable.contentHeight 
        color: "transparent"

        transform: Scale {
            origin.x : flickable.privateProperty.zoomPoint.x
            origin.y : flickable.privateProperty.zoomPoint.y
            xScale   : flickable.privateProperty.zoomFactor
            yScale   : flickable.privateProperty.zoomFactor
        }

        //! Background of scene view.
        SceneViewBackground {
            id: background

            anchors.fill: parent
            viewWidth: flickable.contentWidth
            viewHeigth: flickable.contentHeight
        }

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


