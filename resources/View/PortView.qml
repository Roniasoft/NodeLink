import QtQuick
import QtQuick.Controls
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

    property vector2d      globalPos:      Qt.vector2d(globalX, globalY)


    onGlobalPosChanged: {
        scene.portsPositions[port._qsUuid] = globalPos;
        scene.portsPositionsChanged();

        sceneSession.portsVisibility[port._qsUuid] = false;
        sceneSession.portsVisibilityChanged();
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


    // Behavior on opacity {NumberAnimation{duration: 100}}
    Behavior on scale {NumberAnimation{}}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !sceneSession.connectingMode
        propagateComposedEvents: true

        onPressed: mouse => {
                       //Start point of connection.
                       sceneSession.tempInputPort = root.port;
                       var gMouse = mapToItem(parent.parent.parent.parent, Qt.point(mouse.x, mouse.y));
                       sceneSession.tempConnectionEndPos  = Qt.vector2d(gMouse.x, gMouse.y)
                       sceneSession.connectingMode = true;

                       //Set mouse.accepeted to false to pass mouse events to last active parent
                       mouse.accepted = false
                   }
    }
}
