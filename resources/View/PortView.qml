import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Port view draw a port on the node based on Port model.
 * ************************************************************************************************/

Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Port port
    property SceneManager sceneManager

    property Port virtualPort: Port {}
    /* Object Properties
     * ****************************************************************************************/
    x: port.x
    y: port.y

    width: 10
    height: width
    radius: width
    color: port.color

    MouseArea {
        anchors.fill: parent

        propagateComposedEvents: true
        preventStealing: true

        property bool connectionCreated: false

        onPressAndHold: mouse => {
           if(port.portType === NLSpec.PortType.Output &&
              !connectionCreated) {
                                var gPoint = root.mapToGlobal(mouse.x, mouse.y)
                                root.port.gx = gPoint.x;
                                root.port.gy = gPoint.y;
                                sceneManager.createConnection(root.port, root.port);
                                connectionCreated = true;
                            }
                            if(connectionCreated) {

                                virtualPort.gx = mouse.x;
                                virtualPort.gy = mouse.y;
                                sceneManager.updateConnection(root.port, virtualPort)
                            }
                        }

        onPositionChanged: mouse => {
                               if(connectionCreated) {
                                   var gPoint = root.mapToGlobal(mouse.x, mouse.y)
                                   virtualPort.gx = gPoint.x;
                                   virtualPort.gy = gPoint.y;
                                   sceneManager.updateConnection(root.port, virtualPort)
                               }
                           }

        onReleased: mouse => {
                        connectionCreated = false
                    }
    }
}
