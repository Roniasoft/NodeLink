import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import Qt5Compat.GraphicalEffects
import QtQuickStream

import "Logics/Calculation.js" as Calculation


/*! ***********************************************************************************************
 * NodesScene show the Nodes, Links, ports and etc.
 * ************************************************************************************************/
I_NodesScene {
    id: flickable

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent

    /* Children
    * ****************************************************************************************/
    SceneViewBackground {
        id: background
        anchors.fill: parent
    }

    //! MouseArea for selection of links
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !sceneSession.connectingMode

        //! We should toggle line selection with mouse press event
        onClicked: mouse => {
            scene.selectionModel.clear();
            if (mouse.button === Qt.LeftButton) {
                var gMouse = mapToItem(nodesView, Qt.point(mouse.x, mouse.y));
                var link = findLink(gMouse);
                scene.selectionModel.toggleLinkSelection(link);

            } else if (mouse.button === Qt.RightButton) {
                contextMenu.popup(mouse.x, mouse.y)
            }
        }
        onDoubleClicked: (mouse) => {
                             if (mouse.button === Qt.LeftButton) {
                                 scene.createCustomizeNode(NLSpec.NodeType.General, mouse.x, mouse.y);
                             }
                         }

        //! Context Menu for adding a new node (for now)
        ContextMenu {
            id: contextMenu
            scene: flickable.scene
        }

        //! find the link under or close to the mouse cursor
        function findLink(gMouse): Link {
            let foundLink = null;
            Object.values(scene.links).forEach(obj => {
                var inputPos  = scene?.portsPositions[obj.inputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                var outputPos = scene?.portsPositions[obj.outputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                var points = [inputPos, obj.controlPoint1, obj.controlPoint2, outputPos];

                if (Calculation.isPointOnCurve(gMouse.x, gMouse.y, 15, points)) {
                    foundLink = obj;
                }
            });
            return foundLink;
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
