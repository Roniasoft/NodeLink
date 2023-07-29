import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * A view for user connection (creating a new connection by user)
 * Using a js canvas for drawing
 * ************************************************************************************************/
LinkView {
    id: root

    /* Object Properties
     * ****************************************************************************************/

    /* Property Declarations
    * ****************************************************************************************/


    /* Children
    * ****************************************************************************************/
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: sceneSession.connectingMode
        hoverEnabled: true
        preventStealing: true

        property string inputPortId : ""
        property string outputPortId: ""

        //! Find if there is any port beneath the mouse pointer
        onPressed: (mouse) => {
            var portId = findPortInRect(mouse, 5);
            root.inputPort = scene.findPort(portId);
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
            if(root.inputPort !== null) {
                root.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
                inputPortId = root.inputPort._qsUuid;
                link.inputPort.portSide = root.inputPort.portSide;
                sceneSession.setPortVisibility(inputPortId, true)
                root.opacity = 0
            }

        }

        //! While mouse pos is changing check for existing ports
        onPositionChanged: (mouse) => {
            var closestPortId = findClosestPort(mouse, 10)
            if (closestPortId !== outputPortId)
                scene.unlinkNodes(inputPortId, outputPortId);
            root.opacity = 1
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));

            if(inputPortId.length > 0) {
                root.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
            }
            sceneSession.setPortVisibility(outputPortId, false);
            outputPortId = closestPortId;
            if (outputPortId.length > 0 && scene.canLinkNodes(inputPortId, outputPortId)) {
                sceneSession.setPortVisibility(outputPortId, true);
                scene.linkNodes(inputPortId, outputPortId);
                root.opacity = 0
            }
        }

        onReleased: (mouse) => {
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
            if(inputPortId.length > 0 && outputPortId.length > 0 && scene.canLinkNodes(inputPortId, outputPortId)) {
                scene.linkNodes(inputPortId, outputPortId);
                clearTempConnection();
            } else if(inputPortId.length > 0) { // Open contex menu when the input port is selected
                if (root.opacity === 1) {
                    contextMenu.popup(gMouse.x, gMouse.y);
                    sceneSession.connectingMode = false
                }
                else { //If the port is just clicked and no connection is made, no menu opens
                    clearTempConnection();
                }
            } else {
                clearTempConnection();
            }
        }

        ContextMenu {
            id: contextMenu
            scene: root.scene
            sceneSession: root.sceneSession

            onNodeAdded: (nodeUuid) => {
                parent.outputPortId = parent.findCorrespondingPortSide(root.inputPort, nodeUuid);

                if(parent.inputPortId.length > 0 && parent.outputPortId.length > 0)
                    scene.linkNodes(parent.inputPortId, parent.outputPortId);
                parent.clearTempConnection();
            }

            onAboutToHide: parent.clearTempConnection();

            onClosed: parent.clearTempConnection();
        }

        //! clear temp connection.
        function clearTempConnection() {
            root.inputPort = null;
            sceneSession.connectingMode = false;
            sceneSession.setPortVisibility(inputPortId, false);
            sceneSession.setPortVisibility(outputPortId, false);

            inputPortId  = "";
            outputPortId = "";
        }

        //! find Corresponding port
        function findCorrespondingPortSide (inputPort : Port, outputNodeUuid : string) : string {

            switch (inputPort?.portSide ?? NLSpec.PortPositionSide.Top)  {
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
        //! Finds nodes in proximity of search margin, calls findClosestPortInNodes and returns the closest port Id
        function findClosestPort (mouse : point, searchMargin : int) : string {
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
            let foundNodeIds = [];
            var finalPortId = ""

            Object.entries(scene.nodesPositions).forEach(([key, value]) => {
                if (gMouse.x >= value.x - searchMargin && gMouse.x <= value.x + scene.nodesSizes[key].x + searchMargin) {
                    if (gMouse.y >= value.y - searchMargin && gMouse.y <= value.y + scene.nodesSizes[key].y + searchMargin)
                        foundNodeIds.push(key);
                }
            });

            if (foundNodeIds)
                finalPortId = findClosestPortInNodes(foundNodeIds, gMouse)
            return finalPortId;
        }

        //! Finds closes port Id amongst given node Ids
        function findClosestPortInNodes (foundNodesId, gMouse : point) : string {
            var ports = []
            var closestPortId = "";
            var minDistance = Number.MAX_VALUE;

            for (var i = 0 ; i < foundNodesId.length; i++) {
                Object.entries(scene.nodes[foundNodesId[i]].ports).forEach(([key, value]) => {
                        ports.push(key)
                });
            }

            for (i = 0; i < ports.length; i++) {
                var portId = ports[i];
                var portPosition = scene.portsPositions[portId];
                var distance = calculateManhattanDistance(gMouse, portPosition);

                if (distance < minDistance) {
                    minDistance = distance;
                    closestPortId = portId;
                }
            }
            return closestPortId;
        }

        //! Calculates the ManhattenDisance between two points
        function calculateManhattanDistance(point1, point2) {
            return Math.abs(point1.x - point2.x) + Math.abs(point1.y - point2.y);
        }

    }
}
