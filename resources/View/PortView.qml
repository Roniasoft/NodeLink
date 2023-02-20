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

    property Flickable  flickable

    property Scene      scene

    property Port       virtualPort:    Port {}

    property int        globalX:        nodeView.x + mapToItem(nodeView, Qt.point(x, y)).x

    property int        globalY:        nodeView.y + mapToItem(nodeView, Qt.point(x, y)).y

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

    Behavior on opacity {NumberAnimation{duration: 100}}

    MouseArea {
        anchors.fill: parent

        propagateComposedEvents: true
        preventStealing: true

        property bool connectionCreated: false

        onPressAndHold: mouse => {
           if(port.portType === NLSpec.PortType.Output &&
              !connectionCreated) {
                                var gPoint = mapToItem(flickable, Qt.point(mouse.x, mouse.y));
;
                                root.port.gx = gPoint.x;
                                root.port.gy = gPoint.y;
                                scene.createConnection(root.port, root.port);
                                connectionCreated = true;
                            }
                            if(connectionCreated) {
                                var gPoint2 =  mapToItem(flickable, Qt.point(mouse.x, mouse.y));
                                virtualPort.gx = gPoint2.x;
                                virtualPort.gy = gPoint2.y;
                                scene.updateConnection(root.port, virtualPort)
                            }
                        }

        onPositionChanged: mouse => {
                               console.log("pos changed!!!!" + mouseX)
                               if(connectionCreated) {
                                   var gPoint =  mapToItem(flickable, Qt.point(mouse.x, mouse.y));
                                   virtualPort.gx = gPoint.x;
                                   virtualPort.gy = gPoint.y;
                                   scene.updateConnection(root.port, virtualPort)
                               }
                           }

        onReleased: mouse => {
                        connectionCreated = false
                    }
    }
}
