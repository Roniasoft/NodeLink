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

    property point      globalPos:      Qt.point(globalX, globalY)


    onGlobalPosChanged: {
        scene.portsPositions[port._qsUuid] = globalPos;
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


    // Behavior on opacity {NumberAnimation{duration: 100}}
    Behavior on scale {NumberAnimation{}}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
//                hoverEnabled: true
        propagateComposedEvents: true
        preventStealing: true

        property bool isDragging: false
        property string inputPortId : ""
        property string outputPortId: ""

        onPressed: mouse => {
                            inputPortId = root.port._qsUuid;
                            sceneSession.tempInputPort = root.port;
                            var gMouse = mapToItem(parent.parent.parent.parent, Qt.point(mouse.x, mouse.y));
                            sceneSession.tempConnectionEndPos  = Qt.point(gMouse.x, gMouse.y)
                        }


        onPositionChanged: mouse => {
                               if(inputPortId.length > 0) {
                                   var gMouse = mapToItem(parent.parent.parent.parent, Qt.point(mouse.x, mouse.y));
                                   sceneSession.tempConnectionEndPos  = Qt.point(gMouse.x, gMouse.y)
                               }
                           }

        onReleased: mouse => {
                        if(inputPortId.length > 0) {
                            outputPortId = findNearstPort(mouse);
                            if(outputPortId.length > 0) {
                                sceneSession.tempInputPort = null;
                                scene.linkNodes(inputPortId, outputPortId);
                                console.log("link created = ", inputPortId, outputPortId);
                            }
                        }
                        console.log("Realeased. ");
                        inputPortId = "";
                        outputPortId = "";
                    }

        //! Find nearest port with mouse position and port position
        function findNearstPort(mouse : point) : string {
            var gMouse = mapToItem(parent.parent.parent.parent, Qt.point(mouse.x, mouse.y));
            let findedKey = -1;

            Object.entries(scene.portsPositions).forEach(([key, value]) => {
                if((value.x - 5) <= gMouse.x &&  gMouse.x <= (value.x + 5)) {
                    if((value.y - 5) <= gMouse.y && gMouse.y <= (value.y + 5))
                        findedKey = key;
                        }
                    });

                    return findedKey;
        }
    }
}
