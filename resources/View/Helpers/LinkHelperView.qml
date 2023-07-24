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
        property string inputPortNodeId
        property Node   inputPortNode

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
            scene.unlinkNodes(inputPortId, outputPortId);
            root.opacity = 1
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));

            if(inputPortId.length > 0) {
                root.outputPos = Qt.vector2d(gMouse.x, gMouse.y);
            }

            sceneSession.setPortVisibility(outputPortId, false);
            outputPortId = findPortInRect(mouse, 40);
            if (outputPortId.length > 0) {
                sceneSession.setPortVisibility(outputPortId, true);
                if(scene.canLinkNodes(inputPortId, outputPortId))
                    scene.linkNodes(inputPortId, outputPortId);
                root.opacity = 0
            }

        }

        onReleased: (mouse) => {
            var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
            if(inputPortId.length > 0 && outputPortId.length > 0) {
                scene.linkNodes(inputPortId, outputPortId);
                clearTempConnection();
            } else if(inputPortId.length > 0) { // Open contex menu when the input port is selected
                if (root.opacity === 1) {
                    contextMenu.popup(gMouse.x, gMouse.y);
                    sceneSession.connectingMode = false
                }
                else {
                    mouseArea.inputPortNodeId = scene.findNodeId(inputPortId)
                    mouseArea.inputPortNode = scene.nodes[mouseArea.inputPortNodeId]
                    clearTempConnection();
                    _selectionTimer.start()
                }
            } else {
                clearTempConnection();
            }
        }

        Timer {
            id: _selectionTimer

            interval: 100
            repeat: false
            running: false

            onTriggered: {
                // Clear selection model when Shift key not pressed.
                const isModifiedOn = sceneSession.isShiftModifierPressed;

                if(!isModifiedOn)
                    scene.selectionModel.clearAllExcept(mouseArea.inputPortNodeId);

                const isAlreadySel = scene.selectionModel.isSelected(mouseArea.inputPortNodeId);
                // Select current node
                if(isAlreadySel && isModifiedOn)
                    scene.selectionModel.remove(mouseArea.inputPortNodeId);
                else
                    scene.selectionModel.select(mouseArea.inputPortNode);
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
    }
}
