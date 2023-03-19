import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Port view draw a port on the node based on Port model.
 * ************************************************************************************************/

Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Port       port

    property Scene      scene

    property SceneSession sceneSession

    property int        globalX

    property int        globalY

    property point      globalPos:      Qt.point(globalX, globalY)

    onGlobalPosChanged: {
        scene.portsPositions[port.id] = globalPos;
        scene.portsPositionsChanged();
    }

    /* Object Properties
     * ****************************************************************************************/
    width: NLStyle.portView.size
    border.width: NLStyle.portView.borderSize
    height: width
    radius: width
    color: "#8b6cef"
    border.color: "#363636"
    scale: mouseArea.containsMouse ? 1.1 : 1

//    Behavior on opacity {NumberAnimation{duration: 100}}
    Behavior on scale {NumberAnimation{}}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
//        hoverEnabled: true
//        propagateComposedEvents: true
//        preventStealing: true

        property bool isDragging: false

        onPressed: (mouse) => {
                       isDragging = true;
                       sceneSession.creatingConnection = true
                       sceneSession.tempConnectionStartPos = globalPos;
                       console.log("port view pressed")
                       mouse.accepted = false
                   }

        onPositionChanged: (mouse)=> {
                               console.log("pos changed!")
                               if (isDragging) {
                                   sceneSession.creatingConnection = true
                                    sceneSession.tempConnectionEndPos = Qt.point(globalPos.x + mouseX, globalPos.y + mouseY);

//                                   mouse.accepted = false
                               }
        }

        onReleased: mouse => {
                        console.log("port view released!")
                        sceneSession.creatingConnection = false
                        isDragging = false;
//                        mouse.accepted = false
                    }
    }
}
