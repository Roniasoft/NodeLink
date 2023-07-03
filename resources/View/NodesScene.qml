import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import NodeLink
import QtQuickStream

import "Logics/Calculation.js" as Calculation


/*! ***********************************************************************************************
 * NodesScene show the Nodes, Links, ports and etc.
 * ************************************************************************************************/
I_NodesScene {
    id: flickable

    /* Property Declarations
     * ****************************************************************************************/

    //! flicable scale, use in scale transform
    property real flickableScale: 1.00

    property vector3d    zoomPoint:      Qt.vector3d(0, 0, 0)
    property vector2d    worldZoomPoint: Qt.vector2d(0, 0)

    /* Object Properties
    * ****************************************************************************************/

    anchors.fill: parent
    interactive: !sceneSession.isCtrlPressed

    /* Children
    * ****************************************************************************************/
    background: SceneViewBackground {}

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if(Object.keys(scene.selectionModel.selectedModel).length > 0) {
            deletePopup.open();
        }
    }

    //! Use Key to manage shift pressed to handle multiObject selection
    Keys.onPressed: (event)=> {
        if (event.key === Qt.Key_Shift)
            sceneSession.isShiftModifierPressed = true;
        if(event.key === Qt.Key_Control)
            sceneSession.isCtrlPressed = true;

    }

    Keys.onReleased: (event)=> {
        if (event.key === Qt.Key_Shift)
           sceneSession.isShiftModifierPressed = false;
        if(event.key === Qt.Key_Control)
             sceneSession.isCtrlPressed = false;
    }

    /* Children
    * ****************************************************************************************/

    //! Behavior on scaleX
    Behavior on flickableScale {
        id: scaleBehavior

        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad

            onRunningChanged: {
                if(!running) {
                    if(flickableScale > 1.0)
                        sceneSession.zoomManager.zoomIn(worldZoomPoint);
                    else if (flickableScale < 1.0)
                        sceneSession.zoomManager.zoomOut(worldZoomPoint);

                    updateFlickableDimention();
                    scaleBehavior.enabled = false;
                    zoomPoint = Qt.vector3d(0, 0, 0);
                    flickableScale = 1.00;
                    scaleBehavior.enabled = true;
                }
            }
        }
    }

    //! Scale transform
    transform: Scale {
        id: scaleTransform
          origin: zoomPoint
          xScale: flickableScale
          yScale: flickableScale

       }

    //! Delete selected objects
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: {
            scene.deleteSelectedObjects();
        }
    }

    //! Delete popup to confirm deletion process
    ConfirmPopUp {
        id: deletePopup
        confirmText: "Are you sure you want to delete " +
                     (Object.keys(scene.selectionModel.selectedModel).length > 1 ?
                         "these items?" : "this item?");
        sceneSession: flickable.sceneSession
        onAccepted: delTimer.start();
    }

    //! Nodes/Connections
    contentItem: NodesRect {
        scene: flickable.scene
        sceneSession: flickable.sceneSession
    }

    //! MouseArea for selection of links
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !sceneSession.connectingMode &&
                 !sceneSession.isRubberBandMoving

        propagateComposedEvents: true

        onWheel: (wheel) => {
                     if(!sceneSession.isCtrlPressed)
                        return;

                     zoomPoint      = Qt.vector3d(wheel.x - flickable.contentX, wheel.y - flickable.contentY, 0);
                     worldZoomPoint = Qt.vector2d(wheel.x, wheel.y);

                     if(wheel.angleDelta.y > 0 && sceneSession.zoomManager.canZoomIn())
                            flickableScale = 1 + 0.05;
                     else if (sceneSession.zoomManager.canZoomOut())
                            flickableScale = 1 - 0.05;
                 }

        //! We should toggle line selection with mouse press event
        onClicked: (mouse) => {

            if (!sceneSession.isShiftModifierPressed)
                 scene.selectionModel.clear();

            if (mouse.button === Qt.LeftButton) {
                var gMouse = mapToItem(contentLoader.item, Qt.point(mouse.x, mouse.y));
                var link = findLink(gMouse);
                if(link === null)
                     return;

                // Select current node
                if(scene.selectionModel.isSelected(link?._qsUuid) &&
                   sceneSession.isShiftModifierPressed)
                     scene.selectionModel.remove(link._qsUuid);
                else
                     scene.selectionModel.toggleLinkSelection(link);

            } else if (mouse.button === Qt.RightButton) {
                contextMenu.popup(mouse.x, mouse.y)
            }
        }
        onDoubleClicked: (mouse) => {
            //! Do nothing when user double clicks the on rubber band.
            if(sceneSession.isMouseInRubberBand)
                return;

            scene.selectionModel.clear();
            if (mouse.button === Qt.LeftButton) {
                var position = Qt.vector2d(mouse.x, mouse.y);

                // Correct position with zoom factor into real position.
                var positionCorrection = position?.times(1 / sceneSession.zoomManager.zoomFactor)

                scene.createCustomizeNode(NLSpec.NodeType.General, positionCorrection.x, positionCorrection.y);
            }
        }

        //! Context Menu for adding a new node (for now)
        ContextMenu {
            id: contextMenu
            scene: flickable.scene
            sceneSession: flickable.sceneSession
        }

        //! find the link under or close to the mouse cursor
        function findLink(gMouse): Link {
            let foundLink = null;
            Object.values(scene.links).forEach(obj => {
                var inputPos  = scene?.portsPositions[obj.inputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                var outputPos = scene?.portsPositions[obj.outputPort?._qsUuid] ?? Qt.vector2d(0, 0)
                if (Calculation.isPointOnLink(gMouse.x, gMouse.y, 15, obj.controlPoints, obj.guiConfig.type)) {
                    foundLink = obj;
                }
            });
            return foundLink;
        }
    }

    //! HelpersView
    HelpersView {
        scene: flickable.scene
        sceneSession: flickable.sceneSession
    }

    //! Foreground
    foreground: null

    //! Background Loader
    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
    }

    //! Content Loader
    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: contentItem
    }

    //! Foreground Loader
    Loader {
        id: foregroundLoader
        anchors.fill: parent
        sourceComponent: foreground
    }

    //! Update flicable dimention with zoomfactor
    function updateFlickableDimention() {

        //! Zoom implemented in two state: first : zoom Flicable
        //!                    second: scale Item objects

        //! Calculation parameters in flicable:
        //! zoomFactor, zoomPoint (in center now), contentX (horizontal scrollbar),
        //! contentY (vertical scrollbar)

        var xDiffrence = worldZoomPoint.x - contentX;
        var yDiffrence = worldZoomPoint.y - contentY;

        var zoomOriginX = worldZoomPoint.x * flickableScale;
        var zoomOriginY = worldZoomPoint.y * flickableScale;


        //! update content dimentions
        sceneSession.contentWidth  *= flickableScale;
        sceneSession.contentHeight *= flickableScale;

        // Adjust the content position to zoom to the mouse point
        flickable.contentX = zoomOriginX - xDiffrence;
        flickable.contentY = zoomOriginY - yDiffrence;
    }

    //! Manage zoom in flicable and zoomManager.
    Connections {
        target: sceneSession.zoomManager

        //! Emit from side menu, Do zoomIn process
        function onZoomToFitSignal () {
            var nodesLength = Object.values(scene.nodes).length;
            if(nodesLength < 1)
                return;

            //! Calculte Left, Right, Top, and Bottom of node container to fit into view.
            var firstNode = Object.values(scene.nodes)[0];
            var correctPosition = firstNode.guiConfig.position;
            var leftX = correctPosition.x;
            var rigthX = correctPosition.x + firstNode.guiConfig.width;
            var topY = correctPosition.y;
            var bottomY = correctPosition.y + firstNode.guiConfig.height;

            Object.values(scene.nodes).forEach(node => {
                                                   correctPosition = node.guiConfig.position;

                                                   var leftNodeX   = correctPosition.x;
                                                   var rightNodeX  = correctPosition.x + node.guiConfig.width;
                                                   var topNodeY    = correctPosition.y;
                                                   var bottomNodeY = correctPosition.y + node.guiConfig.height;

                                                   leftX   = Math.min(leftX,   leftNodeX);
                                                   rigthX  = Math.max(rigthX,  rightNodeX);
                                                   topY    = Math.min(topY,    topNodeY);
                                                   bottomY = Math.max(bottomY, bottomNodeY);
                                               });

            // Add margin to borders
            var margin = 5;
            leftX   -= margin;
            topY    -= margin;
            rigthX  += margin
            bottomY += margin

            //! Calculate width and height ratio, Use minimum value to fit in width and height
            var widthRatio  = flickable.width / (rigthX - leftX);
            var heightRatio = flickable.height / (bottomY - topY);
            var zoomFactor = nodesLength > 1 ? Math.min(widthRatio, heightRatio) : 1;

            worldZoomPoint = Qt.vector2d(flickable.contentX + flickable.width / 2,
                                      flickable.contentY + flickable.height / 2);


            //! update zoom factor
            sceneSession.zoomManager.customZoom(zoomFactor, worldZoomPoint)

            //! update content dimentions
            var fcontentWidth  = 4000 * zoomFactor
            var fcontentHeight = 4000 * zoomFactor

            //! Calculate contentX and contentY, when nodes has one node, the node must be in center
            var fcontentX = leftX * zoomFactor - (nodesLength === 1 ? (flickable.width - (rigthX - leftX)) / 2 : 0);
            var fcontentY = topY  * zoomFactor - (nodesLength === 1 ? (flickable.height - (bottomY - topY)) / 2 : 0);

            fcontentWidth = fcontentWidth < fcontentX ? fcontentX + flickable.width * 1.2 : fcontentWidth;
            //! Maximum contentWidth is 8000, greater than 8000, the app was slow.
            flickable.contentWidth = Math.min(fcontentWidth, 8000);

            fcontentHeight = fcontentHeight < fcontentY ? fcontentY + flickable.height  * 1.2 : fcontentHeight;
            flickable.contentHeight = Math.min(fcontentHeight, 8000);

            // Adjust the content position to zoom to the mouse point
            flickable.contentX = fcontentX;
            flickable.contentY = fcontentY;
        }

        //! Emit from side menu, Do zoomIn process
        function onZoomInSignal() {
            if(!sceneSession.zoomManager.canZoomIn())
                return;

            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(flickable.contentX + flickable.width / 2,
                                         flickable.contentY + flickable.height / 2);

            flickableScale = 1 + 0.05;
        }

        //! Emit from side menu, Do zoomOut process
        function onZoomOutSignal() {
            if (!sceneSession.zoomManager.canZoomOut())
                return;

            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(flickable.contentX + flickable.width / 2,
                                         flickable.contentY + flickable.height / 2);

            flickableScale = 1 - 0.05;
        }
    }

    //! Force active main scene view (flicable) when 3rdparty window closed.
    Connections {
        target: sceneSession

        function onSceneForceFocus() {
            flickable.forceActiveFocus();
        }
    }
}
