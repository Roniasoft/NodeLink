import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * NodesScene show the Nodes, Connections, ports and etc.
 * ************************************************************************************************/
Flickable {
    id: flickable
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    property alias          tempConnection: tempConnection

    property QtObject       privateProperty: QtObject {
        property bool ctrlPressedAndHold: false
    }


    /* Object Properties
 * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: 4000
    contentHeight: 4000
    focus: true

    ScrollBar.vertical: ScrollBar {
        width: 5
        policy: ScrollBar.AsNeeded
    }

    ScrollBar.horizontal: ScrollBar {
        height: 5
        policy: ScrollBar.AsNeeded
    }

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
        z: -10
        onWheel: wheel => {
                     if(!flickable.privateProperty.ctrlPressedAndHold)
                     return;
                     if(wheel.angleDelta.y > 0)
                     flickable.scale += 0.1;
                     else if (flickable.scale > 0.5) {
                         flickable.scale -= 0.1;
                     }

                     console.log(flickable.scale)
                 }

        onClicked: {
            scene.selectionModel.select(null)
            flickable.forceActiveFocus()
        }
    }

    //! Nodes/Connections
    NodesRect {
        id: nodesView
        scene: flickable.scene
        sceneSession: flickable.sceneSession
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
