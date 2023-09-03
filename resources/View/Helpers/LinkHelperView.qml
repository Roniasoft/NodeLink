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
            var portId = findPortInRect(Qt.point(mouse.x, mouse.y), 5);
            root.inputPort = scene.findPort(portId);
            var gMouse = mapToItem(parent, mouse.x, mouse.y);
            if (root.inputPort) {
                root.opacity = 0 // The link will be shown on the first move
                root.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
                inputPortId = root.inputPort._qsUuid;
                link.inputPort.portSide = root.inputPort.portSide;
                sceneSession.setPortVisibility(inputPortId, true)
            }

        }

        //! While mouse pos is changing check for existing ports
        onPositionChanged: (mouse) => {

            // Sanity check
            if (inputPortId.length === 0)
                 return;

            // make it visible on first move
            root.opacity = 1.0

            // Hide input port
            if (sceneSession.portsVisibility[inputPortId])
                sceneSession.setPortVisibility(inputPortId, false);

            // Find the closest port based on specified margin
            var closestPortId = findClosestPort(inputPortId, Qt.point(mouse.x, mouse.y), 10)

            if (outputPortId.length > 0 && closestPortId === outputPortId)
                 return;

            // Hide last detected port
            sceneSession.setPortVisibility(outputPortId, false);

            // Update outputPortId with new port found.
            outputPortId = closestPortId;

            // Update outputPos to paint line with new position.
            if (outputPortId.length > 0) {
                // find the detected port position to link it as a TEMP LINK
                root.outputPos = scene.portsPositions[outputPortId];
                // Find port side based on the found output port
                root.outputPortSide = scene.findPort(outputPortId)?.portSide ??
                                   findPortSide(link.inputPort.portSide)
                sceneSession.setPortVisibility(outputPortId, true);
            } else {
                // Find the global mouse position and update outputPos
                var gMouse = mapToItem(parent, mouse.x, mouse.y);
                root.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
                // Find port side based on the input port
                root.outputPortSide = findPortSide(link.inputPort.portSide)
            }
        }

        onReleased: (mouse) => {
            // Sanity check
            if (inputPortId.length === 0) {
                clearTempConnection();
                return;
            }

            if (outputPortId.length > 0) {
                    scene.linkNodes(inputPortId, outputPortId);
                    clearTempConnection();

            } else {  // Open context menu when the outport not selected
                    // Update node position
                    var gMouse = mapToItem(parent, mouse.x, mouse.y);
                    contextMenu.nodePosition = calculateNodePosition(Qt.vector2d(gMouse.x, gMouse.y),
                                                                     link.inputPort.portSide,
                                                                     sceneSession.zoomManager.zoomFactor);
                    contextMenu.popup(gMouse.x, gMouse.y);
                    sceneSession.connectingMode = false;
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
                        foundedPortId = node.findPortByPortSide(portSide)?._qsUuid ?? "";
                    }
                });

                return foundedPortId;
        }

        //! Find nearest port with mouse position and port position
        function findPortInRect (mousePoint : point, searchMargin : int) : string {
            var gMouse = mapToItem(parent, Qt.point(mousePoint.x, mousePoint.y));
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
        //!     inputPortId: input node id to check the ability to establish a link in findClosestPortInNodes
        //!     mousePoint: To calculate distance.
        //!     searchMargin: A margin to search nodes
        function findClosestPort (inputPortId: string, mousePoint: point, searchMargin: int) : string {
            var gMouse = mapToItem(parent, mousePoint.x, mousePoint.y);
            let foundNodeIds = [];
            var finalPortId = ""

            Object.values(scene.nodes).forEach(node => {
                var zoomFactor = sceneSession.zoomManager.zoomFactor;
                var nodePosition = node.guiConfig.position.times(zoomFactor);
                if (gMouse.x >= nodePosition.x - searchMargin &&
                gMouse.x <= nodePosition.x + node.guiConfig.width * zoomFactor + searchMargin) {
                    if (gMouse.y >= nodePosition.y - searchMargin &&
                    gMouse.y <= nodePosition.y + node.guiConfig.height * zoomFactor + searchMargin)
                            foundNodeIds.push(node._qsUuid);
                }
            });

            if (foundNodeIds)
                finalPortId = findClosestPortInNodes(inputPortId, foundNodeIds, gMouse)
            return finalPortId;
        }

        //! Finds closes port Id amongst given node Ids,
        //!     inputPortId: input node id to check the ability to establish a link
        //!     foundNodesId: Nodes id as an array
        //!     gMouse: To calculate distance.
        function findClosestPortInNodes (inputPortId: string, foundNodesId: array, gMouse: point) : string {

            // Port Uuid array
            var ports = []
            var closestPortId = "";
            var minDistance = Number.MAX_VALUE;

            // Find ports that can be linked in Nodes
            foundNodesId.forEach(nodeId => {
                    Object.keys(scene.nodes[nodeId].ports).forEach(portUuid => {
                        if (scene.canLinkNodes(inputPortId, portUuid))
                            ports.push(portUuid)
                    });

                });

            // Find closest port
            ports.forEach(portUuid => {
                    var portPosition = scene.portsPositions[portUuid];
                    var distance = calculateManhattanDistance(gMouse, portPosition);

                    if (distance < minDistance) {
                        minDistance = distance;
                        closestPortId = portUuid;
                    }
            });

            return closestPortId;
        }

        //! Calculates the ManhattenDisance between two points
        function calculateManhattanDistance(point1 : vector2d, point2 : vector2d) {
            return Math.abs(point1.x - point2.x) + Math.abs(point1.y - point2.y);
        }

        //! Find outputport side based on inputPortSide to draw correct arrow
        function findPortSide(inputPortSide: int) : int {
            switch (inputPortSide)  {
                case (NLSpec.PortPositionSide.Top): {
                    return NLSpec.PortPositionSide.Bottom;
                }
                case (NLSpec.PortPositionSide.Bottom): {
                    return  NLSpec.PortPositionSide.Top;
                }
                case (NLSpec.PortPositionSide.Left): {
                    return  NLSpec.PortPositionSide.Right;
                }
                case (NLSpec.PortPositionSide.Right): {
                    return NLSpec.PortPositionSide.Left;
                }

                default: {
                return NLSpec.PortPositionSide.Top
                }
            }
        }

        //! Calculate node position based on contextmenu position,
        //! inputPortSide and defualt node width and height
        function calculateNodePosition(mousePoint: vector2d, inputPortSide: int, zoomFactor: real) : vector2d {
                var correctionFactor = Qt.vector2d(0, 0);
                switch (inputPortSide)  {
                    case (NLSpec.PortPositionSide.Top): {
                        correctionFactor = Qt.vector2d(NLStyle.node.width / 2, NLStyle.node.height);
                    } break;

                    case (NLSpec.PortPositionSide.Bottom): {
                        correctionFactor = Qt.vector2d(NLStyle.node.width / 2, 0);
                    } break;

                    case (NLSpec.PortPositionSide.Left): {
                       correctionFactor = Qt.vector2d(NLStyle.node.width, NLStyle.node.height / 2);
                    } break;

                    case (NLSpec.PortPositionSide.Right): {
                        correctionFactor = Qt.vector2d(0, NLStyle.node.height / 2);
                    } break;
                }

                return mousePoint.minus(correctionFactor.times(zoomFactor));
        }
    }
}
