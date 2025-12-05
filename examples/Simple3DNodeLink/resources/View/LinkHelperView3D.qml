import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick.Controls

import NodeLink
import Simple3DNodeLink

/*! ***********************************************************************************************
 * LinkHelperView3D - A view for user connection in 3D space (creating a new connection by user)
 * This extends LinkHelperView to support 3D positioning
 * ************************************************************************************************/
Item {
    id: item

    /* Property Declarations
     * ****************************************************************************************/
    property I_Scene        scene
    property SceneSession   sceneSession
    property View3D         view3d  // View3D instance for 3D coordinate conversion
    property real           cameraX: 0
    property real           cameraY: 0
    property real           cameraZ: 500
    property real           cameraRotationX: -20
    property real           cameraRotationY: 0

    /* Object Properties
     * ****************************************************************************************/

    /* Children
    * ****************************************************************************************/
    LinkView {
        id: linkview
        scene: item.scene
        sceneSession: item.sceneSession
    }

    MouseArea {
        id: mouseArea

        property alias link: linkview.link

        anchors.fill: parent
        enabled: sceneSession?.connectingMode ?? false
        hoverEnabled: true
        preventStealing: true

        property string inputPortId : ""
        property string outputPortId: ""

        //! Find if there is any port beneath the mouse pointer
        onPressed: (mouse) => {
            // Use smaller margin for more precise port selection
            var portId = findPortInRect(Qt.point(mouse.x, mouse.y), 8);
            linkview.inputPort = scene.findPort(portId);
            var gMouse = mapToItem(parent, mouse.x, mouse.y);
            if (linkview.inputPort) {
                linkview.opacity = 0 // The link will be shown on the first move
                linkview.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
                inputPortId = linkview.inputPort._qsUuid;
                link.inputPort.portSide = linkview.inputPort.portSide;
                sceneSession.setPortVisibility(inputPortId, true)
            }

        }

        //! While mouse pos is changing check for existing ports
        onPositionChanged: (mouse) => {

            // Sanity check
            if (inputPortId.length === 0)
                 return;

            // make it visible on first move
            linkview.opacity = 1.0

            // Hide input port
            if (sceneSession.portsVisibility[inputPortId])
                sceneSession.setPortVisibility(inputPortId, false);

            // Find the closest port based on specified margin
            // Use smaller margin for more precise port selection
            var closestPortId = findClosestPort(inputPortId, Qt.point(mouse.x, mouse.y), 8)

            if (outputPortId.length > 0 && closestPortId === outputPortId)
                 return;

            // Hide last detected port
            sceneSession.setPortVisibility(outputPortId, false);

            // Update outputPortId with new port found.
            outputPortId = closestPortId;

            // Update outputPos to paint line with new position.
            if (outputPortId.length > 0) {
                // find the detected port position to link it as a TEMP LINK
                linkview.outputPos = scene.findPort(outputPortId)._position;
                // Find port side based on the found output port
                linkview.outputPortSide = scene.findPort(outputPortId)?.portSide ??
                                   findPortSide(link.inputPort.portSide)
                sceneSession.setPortVisibility(outputPortId, true);
            } else {
                // Find the global mouse position and update outputPos
                var gMouse = mapToItem(parent, mouse.x, mouse.y);
                linkview.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
                // Find port side based on the input port
                linkview.outputPortSide = findPortSide(link.inputPort.portSide)
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
                    // Calculate 2D position for context menu
                    var gMouse = mapToItem(parent, mouse.x, mouse.y);
                    var nodePosition2D = calculateNodePosition(Qt.vector2d(gMouse.x, gMouse.y),
                                                                     link.inputPort.portSide);
                    
                    // Calculate 3D position from mouse position
                    var worldPos3D = calculate3DPosition(mouse.x, mouse.y);
                    
                    // Set positions in context menu
                    contextMenu.nodePosition = nodePosition2D;
                    contextMenu.nodePosition3D = worldPos3D;
                    contextMenu.popup(gMouse.x, gMouse.y);
                    sceneSession.connectingMode = false;
            }
        }

        ContextMenu3D {
            id: contextMenu
            scene: linkview.scene
            sceneSession: linkview.sceneSession

            onNodeAdded: function(nodeUuid) {
                var inputPortId = parent.inputPortId;
                var retryCount = 0;
                var maxRetries = 20;
                
                function tryLink() {
                    retryCount++;
                    
                    var outputPort = scene.findPort(inputPortId);
                    if (!outputPort) {
                        if (retryCount < maxRetries) {
                            Qt.callLater(tryLink);
                            return;
                        }
                        parent.clearTempConnection();
                        return;
                    }
                    
                    var outputType = scene.getOutputDataType(inputPortId);
                    var targetNode = scene.findNodeByItsId ? scene.findNodeByItsId(nodeUuid) : (scene.nodes[nodeUuid] || null);
                    if (!targetNode) {
                        if (retryCount < maxRetries) {
                            Qt.callLater(tryLink);
                            return;
                        }
                        parent.clearTempConnection();
                        return;
                    }
                    
                    if (!targetNode.ports || Object.keys(targetNode.ports).length === 0) {
                        if (retryCount < maxRetries) {
                            Qt.callLater(tryLink);
                            return;
                        }
                        parent.clearTempConnection();
                        return;
                    }
                    
                    if (outputType !== "Unknown") {
                        var matchingPortId = "";
                        
                        Object.entries(targetNode.ports).forEach(([portId, port]) => {
                            if (port && port.portType === NLSpec.PortType.Input) {
                                var inputType = scene.getInputDataType(port._qsUuid);
                                if (inputType === outputType && matchingPortId.length === 0) {
                                    matchingPortId = portId;
                                }
                            }
                        });
                        
                        if (matchingPortId.length > 0) {
                            parent.outputPortId = matchingPortId;
                        } else {
                            parent.outputPortId = parent.findCorrespondingPortSide(outputPort, nodeUuid);
                        }
                    } else {
                        parent.outputPortId = parent.findCorrespondingPortSide(outputPort, nodeUuid);
                    }

                    if(inputPortId.length > 0 && parent.outputPortId.length > 0) {
                        var canLink = scene.canLinkNodes(inputPortId, parent.outputPortId);
                        if (canLink) {
                            var linkResult = scene.linkNodes(inputPortId, parent.outputPortId);
                            if (!linkResult && retryCount < maxRetries) {
                                Qt.callLater(tryLink);
                                return;
                            }
                        } else if (retryCount < maxRetries) {
                            Qt.callLater(tryLink);
                            return;
                        }
                    } else if (retryCount < maxRetries) {
                        Qt.callLater(tryLink);
                        return;
                    }
                    parent.clearTempConnection();
                }
                
                Qt.callLater(tryLink);
            }

            onAboutToHide: parent.clearTempConnection();

            onClosed: parent.clearTempConnection();
        }

        //! Calculate 3D position from 2D mouse position
        function calculate3DPosition(mouseX: real, mouseY: real): vector3d {
            if (!view3d) return Qt.vector3d(0, 0, 0);
            
            // Try to pick 3D position from mouse position
            var result = view3d.pick(mouseX, mouseY);
            if (result.objectHit) {
                // Create node at hit position (e.g., ground plane)
                return result.scenePosition;
            }
            
            // Create node at exact mouse position in 3D space
            var depth = 200.0; // Distance from camera
            
            var rotX = cameraRotationX * Math.PI / 180;
            var rotY = cameraRotationY * Math.PI / 180;
            
            // Forward direction: camera looks toward -Z
            var forward = Qt.vector3d(
                -Math.sin(rotY) * Math.cos(rotX),
                Math.sin(rotX),
                -Math.cos(rotY) * Math.cos(rotX)
            ).normalized();
            
            // Right direction: perpendicular to forward, on horizontal plane
            var right = Qt.vector3d(
                Math.cos(rotY),
                0,
                Math.sin(rotY)
            ).normalized();
            
            // Up direction: perpendicular to forward and right
            var up = Qt.vector3d(
                Math.sin(rotY) * Math.sin(rotX),
                Math.cos(rotX),
                Math.cos(rotY) * Math.sin(rotX)
            ).normalized();
            
            // Calculate screen center
            var centerX = view3d.width / 2;
            var centerY = view3d.height / 2;
            
            // Calculate offset from center (normalized to -1 to 1)
            var offsetX = (mouseX - centerX) / view3d.width;
            var offsetY = (mouseY - centerY) / view3d.height;
            
            // Calculate FOV-based scaling
            var fov = 60.0 * Math.PI / 180; // Default FOV
            var aspectRatio = view3d.width / view3d.height;
            var scaleX = Math.tan(fov / 2) * depth * 2;
            var scaleY = scaleX / aspectRatio;
            
            // Calculate 3D position
            var cameraPos = Qt.vector3d(cameraX, cameraY, cameraZ);
            return cameraPos
                .plus(forward.times(depth))
                .plus(right.times(offsetX * scaleX))
                .plus(up.times(offsetY * scaleY));
        }

        //! clear temp connection.
        function clearTempConnection() {
            linkview.inputPort = null;
            sceneSession.connectingMode = false;
            sceneSession.setPortVisibility(inputPortId, false);
            sceneSession.setPortVisibility(outputPortId, false);

            inputPortId  = "";
            outputPortId = "";
        }

        //! find Corresponding port based on data type (not just port side)
        function findCorrespondingPortSide (inputPort : Port, outputNodeUuid : string) : string {
            if (!inputPort || !scene) return "";
            
            // Get the output data type from the input port's node
            // Note: inputPort is actually the output port we're dragging from
            var outputNode = scene.findNode(inputPort._qsUuid);
            if (!outputNode) return "";
            
            // Get the output data type
            var outputType = scene.getOutputDataType(inputPort._qsUuid);
            if (outputType === "Unknown") return "";
            
            // Find the target node
            var targetNode = scene.findNode(outputNodeUuid);
            if (!targetNode) return "";
            
            // Find input port in target node that matches the output type
            var matchingPortId = "";
            Object.entries(targetNode.ports).forEach(([portId, port]) => {
                if (port.portType === NLSpec.PortType.Input) {
                    var inputType = scene.getInputDataType(port._qsUuid);
                    if (inputType === outputType) {
                        // Found matching port type
                        matchingPortId = portId;
                    }
                }
            });
            
            // If we found a matching port, return it
            if (matchingPortId.length > 0) {
                return matchingPortId;
            }
            
            // Fallback: try to find port by port side (for backward compatibility)
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
        //! Uses Euclidean distance for more precise selection
        function findPortInRect (mousePoint : point, searchMargin : int) : string {
            var gMouse = mapToItem(parent, Qt.point(mousePoint.x, mousePoint.y));
            let foundKey = "";
            let minDistance = Number.MAX_VALUE;

            Object.values(scene.nodes).forEach (node => {
                Object.entries(node.ports).forEach(([key, value]) => {
                    var portPosition = value._position;
                    // Calculate Euclidean distance for more precise selection
                    var dx = portPosition.x - gMouse.x;
                    var dy = portPosition.y - gMouse.y;
                    var distance = Math.sqrt(dx * dx + dy * dy);
                    
                    // Check if within search margin and is the closest so far
                    if (distance <= searchMargin && distance < minDistance) {
                        minDistance = distance;
                        foundKey = key;
                    }
                });
            });

            return foundKey;
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
                var nodePosition = node.guiConfig.position;
                if (gMouse.x >= nodePosition.x - searchMargin &&
                gMouse.x <= nodePosition.x + node.guiConfig.width + searchMargin) {
                    if (gMouse.y >= nodePosition.y - searchMargin &&
                    gMouse.y <= nodePosition.y + node.guiConfig.height + searchMargin)
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
                    Object.values(scene.nodes[nodeId].ports).forEach(port => {
                        if (scene.canLinkNodes(inputPortId, port._qsUuid))
                            ports.push(port)
                    });

                });

            // Find closest port using Euclidean distance for more precision
            ports.forEach(port => {
                    var portPosition = port._position;
                    // Use Euclidean distance instead of Manhattan for more precise selection
                    var dx = portPosition.x - gMouse.x;
                    var dy = portPosition.y - gMouse.y;
                    var distance = Math.sqrt(dx * dx + dy * dy);

                    if (distance < minDistance) {
                        minDistance = distance;
                        closestPortId = port._qsUuid;
                    }
            });

            return closestPortId;
        }

        //! Calculates the Euclidean distance between two points (for more precise port selection)
        function calculateEuclideanDistance(point1 : vector2d, point2 : vector2d) {
            var dx = point1.x - point2.x;
            var dy = point1.y - point2.y;
            return Math.sqrt(dx * dx + dy * dy);
        }
        
        //! Calculates the Manhattan distance between two points (kept for backward compatibility)
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
        function calculateNodePosition(mousePoint: vector2d, inputPortSide: int) : vector2d {
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

                return mousePoint.minus(correctionFactor);
        }
    }
}


