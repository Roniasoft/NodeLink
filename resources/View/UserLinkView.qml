import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * A view for user connection (creating a new connection by user)
 * Using a js canvas for drawing
 * ************************************************************************************************/
LinkView {
    id: tempCurve

    /* Object Properties
     * ****************************************************************************************/


    /* Property Declarations
    * ****************************************************************************************/


    /* Children
    * ****************************************************************************************/
    MouseArea {
        anchors.fill: parent
        enabled: sceneSession.connectingMode
        hoverEnabled: true
        propagateComposedEvents: true
        preventStealing: true

        property string inputPortId : ""
        property string outputPortId: ""

        //! Find if there is any port beneath the mouse pointer
        onPressed: (mouse) => {
           var portId = findPortInRect(mouse, 5);
           tempCurve.inputPort = scene.findPort(portId);
           var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));

           if(tempCurve.inputPort !== null) {
               tempCurve.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
               inputPortId = tempCurve.inputPort._qsUuid;
               link.inputPort.portSide = tempCurve.inputPort.portSide;
               sceneSession.setPortVisibility(inputPortId, true)
           }
        }

        //! While mouse pos is changing check for existing ports
        onPositionChanged: (mouse) => {
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));

            if(inputPortId.length > 0) {
                tempCurve.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
            }

            sceneSession.setPortVisibility(outputPortId, false);
            outputPortId = findPortInRect(mouse, 20);
            if (outputPortId.length > 0) {
                sceneSession.setPortVisibility(outputPortId, true);
            }
        }


        onReleased: (mouse) => {
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
            if(inputPortId.length > 0 && outputPortId.length > 0) {
                    scene.linkNodes(inputPortId, outputPortId);
                    clearTempConnection();
            } else {
                    contextMenu.popup(gMouse.x, gMouse.y);
            }
        }

        ContextMenu {
            id: contextMenu
            scene: root.scene

            onNodeAdded: (nodeUuid) => {
                parent.outputPortId = parent.findCorrespondingPortSide(tempCurve.inputPort, nodeUuid);

                if(parent.inputPortId.length > 0 && parent.outputPortId.length > 0)
                    scene.linkNodes(parent.inputPortId, parent.outputPortId);
                parent.clearTempConnection();
            }

            onClosed: parent.clearTempConnection();
        }

        //! clear temp connection.
        function clearTempConnection() {
            tempCurve.inputPort = null;
            sceneSession.connectingMode = false;
            sceneSession.setPortVisibility(inputPortId, false);
            sceneSession.setPortVisibility(outputPortId, false);

            inputPortId  = "";
            outputPortId = "";
        }

        //! find Corresponding port
        function findCorrespondingPortSide (inputPort : Port, outputNodeUuid : string) : string {

            switch (inputPort.portSide)  {
                case (NLSpec.PortPositionSide.Top): {
                    return findPortByPortSide(outputNodeUuid, NLSpec.PortPositionSide.Bottom);
                }
                case (NLSpec.PortPositionSide.Bottom): {
                    return findPortByPortSide(outputNodeUuid, NLSpec.PortPositionSide.Top)
                }
                case (NLSpec.PortPositionSide.Left): {
                    return findPortByPortSide(outputNodeUuid, NLSpec.PortPositionSide.Right)
                }
                case (NLSpec.PortPositionSide.Right): {
                    return findPortByPortSide(outputNodeUuid, NLSpec.PortPositionSide.Left)
                }
            }

            return "";
        }

        //! find port with specified port side.
        function findPortByPortSide (nodeUuid : string, portSide : int) : string {
                let foundedPortId = "";

            Object.values(scene.nodes).find(node => {
                    if (node._qsUuid === nodeUuid) {
                        foundedPortId = node.findPortByPortSide(portSide)._qsUuid;
                    }
                });

                return foundedPortId;
        }

        //! Find nearest port with mouse position and port position
        function findPortInRect (mouse : point, searchMargin : int) : string {
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
            let findedKey = "";

            Object.entries(scene.portsPositions).forEach(([key, value]) => {
                if((value.x - searchMargin) <= gMouse.x &&  gMouse.x <= (value.x + searchMargin)) {
                    if((value.y - searchMargin) <= gMouse.y && gMouse.y <= (value.y + searchMargin))
                        findedKey = key;
                        }
                    });

                return findedKey;
        }
    }
}
