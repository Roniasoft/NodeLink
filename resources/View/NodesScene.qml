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
        id: hScrollBar

        property real preLastPosition

        width: 4
        opacity: 0.3
        background: Rectangle {
            color: "black"
            width: 4
            opacity: 0.8
        }

        NumberAnimation on position {
            id: animatedVPos
            from: hScrollBar.preLastPosition
            to: hScrollBar.position
            duration: 1000
        }
    }
    ScrollBar.horizontal: ScrollBar {
        id: vScrollBar

        property real preLastPosition

        height: 4
        opacity: 0.3
        background: Rectangle {
            color: "black"
            height: 4
            opacity: 0.8
        }

        NumberAnimation on position {
            id: animatedHPos
            from: vScrollBar.preLastPosition
            to: hScrollBar.position
            duration: 1000
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

                     if(flickable.visibleArea.heightRatio >= 1 ||
                        flickable.visibleArea.widthRatio  >= 1) {
                         flickable.contentWidth  = flickable.width;
                         flickable.contentHeight = flickable.height;
                         flickable.returnToBounds();
                     return;
                     }

                    if(scene.zoomFactor < 3 && wheel.angleDelta.y > 0)
                        scene.zoomFactor += 0.05

                     else if (scene.zoomFactor > 0.5)
                        scene.zoomFactor -= 0.05

                     scene.zoomPoint = Qt.point(wheel.x, wheel.y);

//                     flickable.resizeContent(flickable.contentWidth * scene.zoomFactor,
//                                             flickable.contentHeight * scene.zoomFactor,
//                                             scene.zoomPoint)
//                     flickable.returnToBounds();
                 }

        onClicked: mouse => {
            if(mouse.button === Qt.LeftButton){
                scene.selectionModel.select(null)
                flickable.forceActiveFocus()
            }
            else if (mouse.button === Qt.RightButton){
                contextMenu.popup(mouseX,mouseY)
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
            id: scaleTransform
            origin.x : scene.zoomPoint.x
            origin.y : scene.zoomPoint.y
            xScale   : scene.zoomFactor
            yScale   : scene.zoomFactor
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

    Connections {
        target: scene

        //! Auto zoom in flicable and fit nodes view to it.
        function onFittingTypeChanged() {
            if(scene.fittingType === NLSpec.FittingType.AutoFit) {

                // Move flicable to the nodesView position with animation on position
                hScrollBar.preLastPosition = hScrollBar.position;
                vScrollBar.preLastPosition = vScrollBar.position;

                hScrollBar.position = nodesView.x / flickable.contentWidth;
                vScrollBar.position = nodesView.y / flickable.contentHeight;

                animatedHPos.start();
                animatedVPos.start();

                scene.zoomPoint = Qt.point(nodesView.x, nodesView.y)

                var scaleX = flickable.width  / nodesView.width;
                var scaleY = flickable.height / nodesView.height;

                scene.zoomFactor = Math.min(scaleX, scaleY)

                scene.fittingType = NLSpec.FittingType.NoAutoFit
            }
        }
    }
}


