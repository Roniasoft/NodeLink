import QtQuick
import NodeLink

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    property int                contentWidth

    property int                contentHeight

    /*  Object Properties
    * ****************************************************************************************/
    width: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.x + node.guiConfig.width)), 1024)
    height: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.y + node.guiConfig.height)), 768)
    color: "transparent"

    /*  Children
    * ****************************************************************************************/

    //! Nodes
    Repeater {
        model: Object.values(scene.nodes)
        delegate: NodeView {
            id: nodeView
            node: modelData
            scene: root.scene 
            sceneSession: root.sceneSession
            isSelected: modelData === scene.selectionModel.selectedNode
            onClicked: scene.selectionModel.select(modelData)
            contentWidth: root.contentWidth
            contentHeight: root.contentHeight
        }
    }

    //! Connections
    Repeater {
        id: keyRepeater

        model: Object.entries(scene.portsDownstream).filter(([key, value]) => value.length > 0)

        delegate: Item {
            id: repeaterItem
            property var inputPort: modelData[0]
            property var outputPort: modelData[1]

            anchors.fill: parent

            Repeater {
                model: outputPort
                delegate: ConnectionView {
                    scene: root.scene
                    linkMode: NLSpec.LinkMode.Connected
                    inputPort:  scene.findPort(repeaterItem.inputPort)
                    outputPort: scene.findPort(modelData)
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: sceneSession.connectingMode
        hoverEnabled: true
        propagateComposedEvents: true
        preventStealing: true

        property string inputPortId : ""
        property string outputPortId: ""

        onPressed: (mouse) => {
                       var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));
                       if(sceneSession.tempInputPort !== null) {
                           sceneSession.connectingMode = true;
                           sceneSession.tempConnectionEndPos = Qt.vector2d(gMouse.x, gMouse.y);

                           inputPortId = sceneSession.tempInputPort._qsUuid;
                           sceneSession.portsVisibility[inputPortId] = true;
                           sceneSession.portsVisibilityChanged();
                       }
                    }

        onPositionChanged: (mouse) => {
                    var gMouse = mapToItem(parent, Qt.point(mouse.x, mouse.y));

                    if(inputPortId.length > 0)
                        sceneSession.tempConnectionEndPos  = Qt.vector2d(gMouse.x, gMouse.y);

                    sceneSession.portsVisibility[outputPortId] = false;
                    sceneSession.portsVisibilityChanged();

                    outputPortId = findNearstPort(mouse, 20);
                    if(outputPortId.length > 0) {
                        sceneSession.portsVisibility[outputPortId] = true;
                        sceneSession.portsVisibilityChanged();
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

            onNodeAdded: (nodeUUid) => {
                parent.outputPortId = parent.findCorrespondingPortSide(sceneSession.tempInputPort, nodeUUid);

                if(parent.inputPortId.length > 0 && parent.outputPortId.length > 0)
                    scene.linkNodes(parent.inputPortId, parent.outputPortId);
                parent.clearTempConnection();
            }

            onClosed: parent.clearTempConnection();
        }


        //! clear temp connection.
        function clearTempConnection() {
            sceneSession.tempInputPort = null;
            sceneSession.connectingMode = false;
            sceneSession.portsVisibility[inputPortId]  = false;
            sceneSession.portsVisibility[outputPortId] = false;
            sceneSession.portsVisibilityChanged();

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
        function findNearstPort (mouse : point, searchMargin : int) : string {
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
