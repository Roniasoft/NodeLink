import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import Qt5Compat.GraphicalEffects
import QtQuickStream

import "Logics/Calculation.js" as Calculation


/*! ***********************************************************************************************
 * NodesScene show the Nodes, Connections, ports and etc.
 * ************************************************************************************************/
Flickable {
    id: flickable

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession


    /* Object Properties
 * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: 4000
    contentHeight: 4000
    focus: true
    ScrollBar.horizontal: HorizontalScrollBar{}
    ScrollBar.vertical: VerticalScrollBar{}

    /* Children
* ****************************************************************************************/
    SceneViewBackground {
        id: background
        anchors.fill: parent
        viewWidth: flickable.contentWidth
        viewHeigth: flickable.contentHeight
    }


    MouseArea {
        anchors.fill: parent
//        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        property string selectedConnection: ""

//        onPositionChanged: (mouse) => {
//                               //! select link with mouse detection link
//                               var gMouse = mapToItem(nodesView, Qt.point(mouse.x, mouse.y));

//                               if(!sceneSession.connectingMode) {
//                                   unselectConnections();
//                                   findSelectedConnection(gMouse)
//                                   selectConnection(selectedConnection);
//                               }
//                           }


        onClicked: mouse => {
            if(mouse.button === Qt.LeftButton) {
                var gMouse = mapToItem(nodesView, Qt.point(mouse.x, mouse.y));

                scene.selectionModel.select(null)
                flickable.forceActiveFocus();

                //! select line or deselect it
                if(!sceneSession.connectingMode) {
                    unselectConnections();
                    var foundToSelect = findSelectedConnection(gMouse);
                    if(foundToSelect === selectedConnection) {
                        deselectConnection(selectedConnection);
                    } else {
                        selectedConnection = foundToSelect;
                    }
                }
            }
            else if (mouse.button === Qt.RightButton) {
                contextMenu.popup(mouse.x, mouse.y)
            }
        }

        ContextMenu {
            id: contextMenu
            scene: flickable.scene
        }

        //! Unselect all connections
        function unselectConnections() {
            let foundedLink = scene.connections.find(conObj => conObj.isSelected);
            if(foundedLink !== undefined) {
                foundedLink.isSelected = false;
                unselectConnections();
            }
        }

        //! find connection to select with mouse position
        function findSelectedConnection(gMouse) {
                        let foundedConnection = "";
                        scene.connections.forEach(conObj => {
                                                    var inputPos  = scene?.portsPositions[conObj.inputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                                                    var outputPos = scene?.portsPositions[conObj.outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

                                                    if(Calculation.isPositionOnCurve(Qt.vector2d(gMouse.x, gMouse.y),
                                                                                         inputPos,
                                                                                        conObj.controlPoint1,
                                                                                        conObj.controlPoint2,
                                                                                        outputPos)) {
                                                          conObj.isSelected = true;
                                                          foundedConnection = conObj._qsUuid;

                                                      }

                            });

                            return foundedConnection;
        }

        //! Select a connection with Uuid
        function selectConnection(linkUuid : string) {
            let foundedObj = scene.connections.find(obj => obj._qsUuid === linkUuid);
            if (foundedObj !== undefined) {
                foundedObj.isSelected = true;
            }
        }

        //! Deselect a connection with Uuid
        function deselectConnection(linkUuid : string) {
            let foundedObj = scene.connections.find(obj => obj._qsUuid === linkUuid);
            if (foundedObj !== undefined) {
                foundedObj.isSelected = false;
            }
        }
    }

    //! Nodes/Connections
    NodesRect {
        id: nodesView
        scene: flickable.scene
        sceneSession: flickable.sceneSession
        contentWidth: flickable.contentWidth
        contentHeight: flickable.contentHeight
    }
}
