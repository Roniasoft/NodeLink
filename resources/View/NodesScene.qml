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
    interactive: sceneSession && !sceneSession.isCtrlPressed

    /* Children
    * ****************************************************************************************/
    background: SceneViewBackground {}

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if(sceneSession.isSceneEditable && Object.keys(scene.selectionModel.selectedModel).length > 0) {
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

    //! Change ScrollBars
    ScrollBar.horizontal: HorizontalScrollBar {
        //! Hide scrollbar when zoom process is running ...
        visible: flickableScale === 1.0
    }

    ScrollBar.vertical: VerticalScrollBar {
        //! Hide scrollbar when zoom process is running ...
        visible: flickableScale === 1.0
    }

    /* Children
    * ****************************************************************************************/

    //! Behavior on scaleX
    Behavior on flickableScale {
        id: scaleBehavior

        NumberAnimation {
            duration: 200
            easing.type: Easing.Linear

            onRunningChanged: {
                if(!running) {
                    if(flickableScale > 1.0)
                        sceneSession.zoomManager.zoomIn();
                    else if (flickableScale < 1.0)
                        sceneSession.zoomManager.zoomOut();

                    updateFlickableDimension();
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
                     (Object.keys(scene?.selectionModel?.selectedModel ?? ({})).length > 1 ?
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
        enabled: sceneSession && !sceneSession.connectingMode &&
                 !sceneSession.isRubberBandMoving &&
                 !sceneSession.isCtrlPressed

        propagateComposedEvents: true

        onWheel: (wheel) => {
                     if(!sceneSession.isShiftModifierPressed)
                        return;

                     zoomPoint      = Qt.vector3d(wheel.x - scene.sceneGuiConfig.contentX, wheel.y - scene.sceneGuiConfig.contentY, 0);
                     worldZoomPoint = Qt.vector2d(wheel.x, wheel.y);

                     if(wheel.angleDelta.y > 0)
                            prepareScale(1 + sceneSession.zoomManager.zoomInStep());
                     else if (wheel.angleDelta.y < 0)
                            prepareScale(1 / (1 + sceneSession.zoomManager.zoomOutStep()));
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
                     scene.selectionModel.selectLink(link);

            } else if (sceneSession.isSceneEditable && mouse.button === Qt.RightButton) {
                contextMenu.popup(mouse.x, mouse.y)
            }
        }
        onDoubleClicked: (mouse) => {
            //! Do nothing when user double clicks the on rubber band.
            if(sceneSession.isMouseInRubberBand)
                return;

            scene.selectionModel.clear();
            if (sceneSession.isSceneEditable && mouse.button === Qt.LeftButton) {
                var position = Qt.vector2d(mouse.x, mouse.y);

                // Correct position with zoom factor into real position.
                var positionMapped = position?.times(1 / sceneSession.zoomManager.zoomFactor)

                scene.createCustomizeNode(NLNodeRegistry.defaultNode, positionMapped.x, positionMapped.y);
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
                var inputPos  = obj.inputPort?._position ?? Qt.vector2d(0, 0)
                var outputPos = obj.outputPort?._position ?? Qt.vector2d(0, 0)
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
        z: -10
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
        z: 10
    }

    //! Manage zoom in flickable and zoomManager.
    Connections {
        target: sceneSession?.zoomManager ?? null

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


            //! Calculate width and height ratio, Use minimum value to fit in width and height
            var widthRatio  = flickable.width / (rigthX - leftX) / 1.15;
            var heightRatio = flickable.height / (bottomY - topY) / 1.15;

            //! Maximum zoomFactor is 1.5, greater than 1.5 is not necessary.
            var zoomFactor = nodesLength > 1 ? Math.min(widthRatio, heightRatio, sceneSession.zoomManager.maximumZoom) : 1;

            worldZoomPoint = Qt.vector2d(scene.sceneGuiConfig.contentX + flickable.width / 2,
                                      scene.sceneGuiConfig.contentY + flickable.height / 2);

            //! update zoom factor
            sceneSession.zoomManager.customZoom(zoomFactor)

            //! update content dimentions
            var fcontentWidth  = NLStyle.scene.defaultContentWidth  * zoomFactor
            var fcontentHeight = NLStyle.scene.defaultContentHeight * zoomFactor

            //! Calculate contentX and contentY, when nodes has one node, the node must be in center
            //! Contents margin
            var cantentMargin = nodesLength === 1 ? 1 : 0.95;

            var fcontentX = leftX * zoomFactor * cantentMargin - (nodesLength === 1 ? (flickable.width - (rigthX - leftX)) / 2 : 0);
            var fcontentY = topY  * zoomFactor * cantentMargin - (nodesLength === 1 ? (flickable.height - (bottomY - topY)) / 2 : 0);

            fcontentWidth = Math.max(...Object.values(scene?.nodes ?? ({})).
                                     map(node => ((node.guiConfig.position.x + node.guiConfig.width) *
                                                  sceneSession.zoomManager.zoomFactor)), fcontentWidth);

            //! Maximum contentWidth is 8000, greater than 8000, the app was slow.
            scene.sceneGuiConfig.contentWidth = Math.max(fcontentWidth, scene.sceneGuiConfig.contentWidth);

            fcontentHeight = Math.max(...Object.values(scene?.nodes ?? ({})).
                                      map(node => ((node.guiConfig.position.y + node.guiConfig.height) *
                                                   sceneSession.zoomManager.zoomFactor)), fcontentHeight);

            scene.sceneGuiConfig.contentHeight = Math.max(fcontentHeight, scene.sceneGuiConfig.contentHeight);

            // Adjust the content position to zoom to the mouse point
            scene.sceneGuiConfig.contentX = Math.max(0, fcontentX);
            scene.sceneGuiConfig.contentY = Math.max(0, fcontentY);
        }

        //! Emit from side menu, Do zoomIn process
        function onZoomInSignal() {
            if(!sceneSession.zoomManager.canZoomIn())
                return;

            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(scene.sceneGuiConfig.contentX + flickable.width / 2,
                                         scene.sceneGuiConfig.contentY + flickable.height / 2);

            prepareScale(1 + sceneSession.zoomManager.zoomInStep());
        }

        //! Emit from side menu, Do zoomOut process
        function onZoomOutSignal() {
            if (!sceneSession.zoomManager.canZoomOut())
                return;

            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(scene.sceneGuiConfig.contentX + flickable.width / 2,
                                         scene.sceneGuiConfig.contentY + flickable.height / 2);

            prepareScale(1 / (1 + sceneSession.zoomManager.zoomOutStep()));
        }

        //! Manage zoom from nodeView.
        function onZoomNodeSignal(zoomPointScaled: vector2d, wheelAngle: int) {

            flickable.zoomPoint      = Qt.vector3d(zoomPointScaled.x - scene.sceneGuiConfig.contentX, zoomPointScaled.y - scene.sceneGuiConfig.contentY, 0);
            flickable.worldZoomPoint = Qt.vector2d(zoomPointScaled.x, zoomPointScaled.y);
            if(wheelAngle > 0)
                   prepareScale(1 + sceneSession.zoomManager.zoomInStep());
            else if (wheelAngle < 0)
                   prepareScale(1 / (1 + sceneSession.zoomManager.zoomOutStep()))
        }

        //! Set focus on NodesScene after zoom In/Out
        function onFocusToScene() {
            flickable.forceActiveFocus();
        }

        //! Reset zoom and related parameters
        function onResetZoomSignal(zoomFactor: real) {
            //! Reset zoom to defualt values
            scene.sceneGuiConfig.contentWidth  = NLStyle.scene.defaultContentWidth;
            scene.sceneGuiConfig.contentHeight = NLStyle.scene.defaultContentHeight;

            //! Change contents to initial value
            scene.sceneGuiConfig.contentX = 1500;
            scene.sceneGuiConfig.contentY = 1500;


            sceneSession.zoomManager.customZoom(zoomFactor);
        }

        //! Manage zoom to node signal
        function onZoomToNodeSignal(node: Node, targetZoomFactor: real) {
            if (!node)
                return;

            var origin  = Qt.vector2d(node.guiConfig.position.x + node.guiConfig.width / 2,
                                         node.guiConfig.position.y + node.guiConfig.height / 2);

            //! Prepare positions with targetZoomFactor.
            origin =  origin.times(targetZoomFactor)

            //! update zoom factor
            sceneSession.zoomManager.customZoom(targetZoomFactor)

            //! update content dimentions
            scene.sceneGuiConfig.contentWidth  = NLStyle.scene.defaultContentWidth  * targetZoomFactor;
            scene.sceneGuiConfig.contentHeight = NLStyle.scene.defaultContentHeight * targetZoomFactor;

            //! Calculate contentX and contentY, when nodes has one node, the node must be in center
            var fcontentX = origin.x - (flickable.width / 2);
            var fcontentY = origin.y - (flickable.height / 2 ) ;

            // Adjust the content position to zoom to the mouse point
            scene.sceneGuiConfig.contentX = Math.max(0, fcontentX);
            scene.sceneGuiConfig.contentY = Math.max(0, fcontentY);
        }
    }

    //! Force active main scene view (flicable) when 3rdparty window closed.
    Connections {
        target: sceneSession

        function onSceneForceFocus() {
            flickable.forceActiveFocus();
        }
    }

    /* Functions
    * ****************************************************************************************/

    //! Update flicable dimension with zoomfactor
    function updateFlickableDimension() {

        //! Zoom implemented in two state: first : zoom Flicable
        //!                    second: scale Item objects

        //! Calculation parameters in flicable:
        //! zoomFactor, zoomPoint (in center now), contentX (horizontal scrollbar),
        //! contentY (vertical scrollbar)

        var xDiffrence = worldZoomPoint.x - scene.sceneGuiConfig.contentX;
        var yDiffrence = worldZoomPoint.y - scene.sceneGuiConfig.contentY;

        var zoomOriginX = worldZoomPoint.x * flickableScale;
        var zoomOriginY = worldZoomPoint.y * flickableScale;


        //! update content dimentions
        var canWidthChange = scene.sceneGuiConfig.contentWidth * flickableScale >= flickable.width;
        var isNotRight =  (scene.sceneGuiConfig.contentWidth * flickableScale - scene.sceneGuiConfig.contentX - flickable.width) > 0
        scene.sceneGuiConfig.contentWidth  *= (canWidthChange && isNotRight )? flickableScale : 1;

        var canHeightChange = scene.sceneGuiConfig.contentHeight * flickableScale >= flickable.height;
        var isNotBottom = (scene.sceneGuiConfig.contentHeight * flickableScale - scene.sceneGuiConfig.contentY - flickable.height) > 0

        scene.sceneGuiConfig.contentHeight *= (canHeightChange && isNotBottom) ? flickableScale : 1;

        // Adjust the content position to zoom to the mouse point
        if (canWidthChange)
            scene.sceneGuiConfig.contentX =  Math.max(0, zoomOriginX - xDiffrence);

        if (canHeightChange)
            scene.sceneGuiConfig.contentY =  Math.max(0, zoomOriginY - yDiffrence);
    }

    //! Prepare scale to set on the scene scale
    function prepareScale(scale: real) {
        flickableScale = scale;
    }
}
