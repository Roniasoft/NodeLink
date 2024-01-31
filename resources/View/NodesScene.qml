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
    property real flickableScale: sceneSession.zoomManager.zoomFactor

    property vector3d    zoomPoint:      Qt.vector3d(0, 0, 0)
    property vector2d    worldZoomPoint: Qt.vector2d(0, 0)

    //! This is to control what button selections MouseArea handle. This is a temporary solution
    //! for making NodesScene behavior customizable
    property int         selectionMouseAreaButtons: Qt.LeftButton | Qt.RightButton

    /* Object Properties
    * ****************************************************************************************/
    interactive: false // Pannding and flicking is controlled manually by NodesScene

    /* Children
    * ****************************************************************************************/
    background: SceneViewBackground {}

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        var hasObjectsSelected = Object.keys(scene.selectionModel.selectedModel).length > 0;

        if (!hasObjectsSelected)
            return;

        if (!sceneSession.isSceneEditable) {
            infoPopup.open();
            return;
        }

        if (sceneSession.isDeletePromptEnable)
            deletePopup.open();
        else
            delTimer.start();
    }

    //! Use Key to manage shift pressed to handle multiObject selection
    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Shift)
                        sceneSession.isShiftModifierPressed = true;
                        if(event.key === Qt.Key_Control)
                        sceneSession.isCtrlPressed = true;
                        // beware of Alt selection as it may be used by user for removing connections
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
    }

    ScrollBar.vertical: VerticalScrollBar {
        //! Hide scrollbar when zoom process is running ...
    }

    /* Children
    * ****************************************************************************************/

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

    //! Information of a process
    ConfirmPopUp {
        id: infoPopup

        confirmText: "Can not be deleted! either the scene or the node is not editable"
        sceneSession: flickable.sceneSession
        keyButtons: [MessageDialog.Ok]
    }

    //! Nodes/Connections
    contentItem: NodesRect {
        scene: flickable.scene
        sceneSession: flickable.sceneSession
    }

    //! Shortcut for going to center
    Shortcut {
        sequence: "F"
        onActivated: goToCenter();
    }

    //! Context Menu for adding a new node (for now)
    ContextMenu {
        id: contextMenu
        scene: flickable.scene
        sceneSession: flickable.sceneSession
        nodePosition: Qt.vector2d(x + contentX, y + contentY).times(1 / flickableScale)
    }

    //! Pan and flick MouseArea. This is added to override Flickable handling pan/flick to be able
    //! to tweak it easily from outside
    //! Note: This MouseArea should be child of flickable itself and not its content item.
    MouseArea {
        property bool       wasDragged: false
        property vector2d   lastSpeed:  Qt.vector2d(0, 0)
        property point      lastPoint:  Qt.point(-1, -1)
        property real       elapsedTime: 0

        parent: flickable //! Redundant, just for clarification
        anchors.fill: parent
        propagateComposedEvents: true
        acceptedButtons: sceneSession.panButton
        z: -1 //! This is neccessary so this MouseArea is below flickableContents

        onPressed: function(event){
            if (flickable.moving) {
                flickable.cancelFlick();
                wasDragged = true;
            }

            //! Set elapsedTime
            if (sceneSession.flickEnabled) {
                elapsedTime = new Date().getMilliseconds();
            }
            lastPoint = Qt.point(event.x, event.y);
        }

        onReleased: function(mouse){
            lastPoint = Qt.point(-1, -1);

            if (sceneSession.flickEnabled && (new Date()).getMilliseconds() - elapsedTime < 5) {
                lastSpeed = Qt.vector2d(Math.max(-1, Math.min(1, lastSpeed.x)),
                                        Math.max(-1, Math.min(1, lastSpeed.y)));
                flickable.flick(lastSpeed.x * Screen.width, lastSpeed.y * Screen.height);
                elapsedTime = 0;
            } else if (flickable.moving) {
                flickable.cancelFlick();
            }

            if (!wasDragged) {
                //! Any left-button click outside rubber bound will clear selections
                //! Any right-button click should show contextMenu if possible
                if (mouse.button === Qt.LeftButton) {
                    if (!sceneSession.isMouseInRubberBand) {
                        scene.selectionModel.clear();
                    }

                    //! Search for links under click point too
                    selectLinkAt(Qt.point(mouse.x, mouse.y), mouse.modifiers);
                } else if (sceneSession.isSceneEditable && mouse.button === Qt.RightButton) {
                    contextMenu.popup(mouse.x, mouse.y);
                }
            }

            wasDragged = false;
        }

        onPositionChanged: function(event){
            wasDragged = true;

            contentX = Math.max(0, Math.min(contentX + (lastPoint.x - event.x), flickable.contentWidth - flickable.width));
            contentY = Math.max(0, Math.min(contentY + (lastPoint.y - event.y), flickable.contentHeight - flickable.height));

            //! Get miliseconds since last drag
            var elapsed = new Date().getMilliseconds() - elapsedTime;
            lastSpeed = Qt.vector2d((event.x - lastPoint.x) / elapsed,
                                    (event.y - lastPoint.y) / elapsed);

            lastPoint = Qt.point(event.x, event.y);

            //! Restart elapsedTime
            if (sceneSession.flickEnabled) {
                elapsedTime = new Date().getMilliseconds();
            }
        }
    }

    //! MouseArea for selection of links: This should be child of Flickable content item
    //! (flickableContents) and not Flickable itself
    MouseArea {
        property bool wasDragged: false

        parent: flickableContents
        anchors.fill: parent
        enabled: sceneSession && !sceneSession.connectingMode &&
                 !sceneSession.isRubberBandMoving &&
                 !sceneSession.isCtrlPressed
        z: -1 //! Below contents and above background
        hoverEnabled: sceneSession.marqueeSelectionMode
        acceptedButtons: sceneSession.marqueeSelectionButton

        //! Shortcut, alt+left click for deleting selected link
        onClicked:(mouse)=> {
            if (mouse.button === Qt.LeftButton && mouse.modifiers & Qt.AltModifier) {
                if (scene.selectionModel.lastSelectedObject(NLSpec.ObjectType.Link))
                    delTimer.start();
            }
        }

        onPositionChanged: (mouse) => {
                               // Update marquee selection
                               wasDragged = true;
                               sceneSession.updateMarqueeSelection(mouse)
                           }


        onReleased: (mouse) => {
                        if (!wasDragged) {
                            //! Any left-button click outside rubber bound will clear selections
                            //! Any right-button click should show contextMenu if possible
                            if (mouse.button === Qt.LeftButton) {
                                if (!sceneSession.isMouseInRubberBand) {
                                    scene.selectionModel.clear();
                                }

                                //! Search for links under click point too
                                selectLinkAt(Qt.point(mouse.x, mouse.y), mouse.modifiers);
                            } else if (sceneSession.isSceneEditable && mouse.button === Qt.RightButton) {
                                contextMenu.popup(flickableContents.mapToItem(flickable, mouse.x, mouse.y))
                            }
                        }

                        wasDragged = false;
                        sceneSession.marqueeSelectionMode = false;
                    }

        //! We should toggle line selection with mouse press event
        onPressed: (mouse) => {
                       sceneSession.marqueeSelectionMode = true;
                       sceneSession.marqueeSelectionStart(mouse);
                   }

        onDoubleClicked: (mouse) => {
                             //! Do nothing when user double clicks the on rubber band.
                             if(sceneSession.isMouseInRubberBand) {
                                 return;
                             }

                             scene.selectionModel.clear();
                             if (sceneSession.isSceneEditable) {
                                 var position = Qt.vector2d(mouse.x, mouse.y);

                                 // Correct position with zoom factor into real position.
                                 var positionMapped = position

                                 scene.createCustomizeNode(scene.nodeRegistry.defaultNode, positionMapped.x, positionMapped.y);
                             }
                         }
    }

    //! MouseArea to update the current mouse position in scene model
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true

        onPositionChanged: (mouse) => {
            scene.sceneGuiConfig._mousePosition = Qt.vector2d(mouse.x, mouse.y)
        }

        onExited: scene.sceneGuiConfig._mousePosition = Qt.vector2d(-1, -1)
    }

    //! HelpersView
    HelpersView {
        parent: contentLoader.item ?? flickable
        scene: flickable.scene
        sceneSession: flickable.sceneSession
    }

    //! Foreground
    foreground: null

    Item {
        id: flickableContents
        width: scene?.sceneGuiConfig?.contentWidth ?? 0
        height: scene?.sceneGuiConfig?.contentHeight ?? 0
        transformOrigin: Item.TopLeft
        scale: flickableScale

        //! Background Loader
        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: background
            z: -10
        }

        WheelHandler {
            acceptedModifiers: sceneSession.zoomModifier
            onWheel: function(wheel) {
                zoomPoint      = Qt.vector3d(wheel.x - scene.sceneGuiConfig.contentX, wheel.y - scene.sceneGuiConfig.contentY, 0);
                worldZoomPoint = flickableContents.mapToItem(flickableContents.parent, wheel.x, wheel.y);

                if(wheel.angleDelta.y > 0) {
                    sceneSession.zoomManager.zoomIn();
                } else if (wheel.angleDelta.y < 0) {
                    sceneSession.zoomManager.zoomOut();
                }
            }
        }

        //! Content Loader
        Loader {
            id: contentLoader
            anchors.fill: parent
            sourceComponent: contentItem

            // The value needs to be greater than 1 to
            // avoid interference with the upper MouseAreas.
            z: 1
        }

        //! Foreground Loader
        Loader {
            id: foregroundLoader
            anchors.fill: parent
            sourceComponent: foreground
            z: 10
        }
    }

    //! Manage zoom in flickable and zoomManager.
    Connections {
        target: sceneSession?.zoomManager ?? null

        function onZoomFactorChanged()
        {
            updateContentSize();

            //! Update zoomFactor in SceneGuiConfig
            if (Math.abs(scene.sceneGuiConfig.zoomFactor - sceneSession.zoomManager.zoomFactor) > 0.0001) {
                scene.sceneGuiConfig.zoomFactor = sceneSession.zoomManager.zoomFactor;
            }
        }

        //! Emit from side menu, Do zoomIn process
        function onZoomToFitSignal () {
            var nodesLength = Object.values(scene.nodes).length;
            if(nodesLength < 1)
                return;

            //! Calculte Left, Right, Top, and Bottom of node container to fit into view.
            var firstNode = Object.values(scene.nodes)[0];
            var correctPosition = firstNode.guiConfig.position;
            var leftX = correctPosition.x;
            var rightX = correctPosition.x + firstNode.guiConfig.width;
            var topY = correctPosition.y;
            var bottomY = correctPosition.y + firstNode.guiConfig.height;

            Object.values(scene.nodes).forEach(node => {
                                                   correctPosition = node.guiConfig.position;

                                                   var leftNodeX   = correctPosition.x;
                                                   var rightNodeX  = correctPosition.x + node.guiConfig.width;
                                                   var topNodeY    = correctPosition.y;
                                                   var bottomNodeY = correctPosition.y + node.guiConfig.height;

                                                   leftX   = Math.min(leftX,   leftNodeX);
                                                   rightX  = Math.max(rightX,  rightNodeX);
                                                   topY    = Math.min(topY,    topNodeY);
                                                   bottomY = Math.max(bottomY, bottomNodeY);
                                               });


            //! Calculate width and height ratio, Use minimum value to fit in width and height
            var widthRatio  = flickable.width / (rightX - leftX) / 1.15;
            var heightRatio = flickable.height / (bottomY - topY) / 1.15;

            //! Maximum zoomFactor is 1.5, greater than 1.5 is not necessary.
            var zoomFactor = nodesLength > 1 ? Math.max(sceneSession.zoomManager.minimumZoom,
                                                        Math.min(sceneSession.zoomManager.maximumZoom,
                                                                 widthRatio, heightRatio))
                                             : 1;

            worldZoomPoint = Qt.vector2d((rightX + leftX) / 2, (topY + bottomY) / 2).times(
                        sceneSession.zoomManager.zoomFactor);

            contentX = Math.max(0, worldZoomPoint.x - flickable.width / 2);
            contentY = Math.max(0, worldZoomPoint.y - flickable.height / 2);

            //! update zoom factor
            sceneSession.zoomManager.customZoom(zoomFactor)
        }

        //! Emit from side menu, Do zoomIn process
        function onZoomInSignal() {
            if(!sceneSession.zoomManager.canZoomIn())
                return;

            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(scene.sceneGuiConfig.contentX + flickable.width / 2,
                                         scene.sceneGuiConfig.contentY + flickable.height / 2);

            sceneSession.zoomManager.zoomIn();
        }

        //! Emit from side menu, Do zoomOut process
        function onZoomOutSignal() {
            if (!sceneSession.zoomManager.canZoomOut())
                return;

            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(scene.sceneGuiConfig.contentX + flickable.width / 2,
                                         scene.sceneGuiConfig.contentY + flickable.height / 2);

            sceneSession.zoomManager.zoomOut();
        }

        //! Manage zoom from nodeView.
        function onZoomNodeSignal(localZoomPoint: point, nodeView: Item, wheelAngle: int) {
            if (!nodeView) return;

            flickable.zoomPoint = Qt.vector3d(localZoomPoint.x - scene.sceneGuiConfig.contentX, localZoomPoint.y - scene.sceneGuiConfig.contentY, 0);
            flickable.worldZoomPoint = nodeView.mapToItem(flickableContents.parent, localZoomPoint);

            if(wheelAngle > 0)
                sceneSession.zoomManager.zoomIn();
            else if (wheelAngle < 0)
                sceneSession.zoomManager.zoomOut();
        }

        //! Set focus on NodesScene after zoom In/Out
        function onFocusToScene() {
            flickable.forceActiveFocus();
        }

        //! Reset zoom and related parameters
        function onResetZoomSignal(zoomFactor: real) {
            zoomPoint      = Qt.vector3d(flickable.width / 2, flickable.height / 2, 0);
            worldZoomPoint = Qt.vector2d(NLStyle.scene.defaultContentX + flickable.width / 2,
                                         NLStyle.scene.defaultContentY + flickable.height / 2);

            sceneSession.zoomManager.customZoom(zoomFactor);

            contentX = NLStyle.scene.defaultContentX;
            contentY = NLStyle.scene.defaultContentY;
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

    Connections {
        target: scene.sceneGuiConfig

        function onContentWidthChanged()
        {
            worldZoomPoint = Qt.point(0, 0);
            updateContentSize();
        }

        function onContentHeightChanged()
        {
            worldZoomPoint = Qt.point(0, 0);
            updateContentSize();
        }
    }

    Connections {
        target: scene

        function onContentMoveRequested(diff)
        {
            contentX = Math.max(0, Math.min(contentWidth - width, contentX + diff.x));
            contentY = Math.max(0, Math.min(contentHeight - height, contentY + diff.y));
        }

        function onContentResizeRequested(diff: vector2d)
        {
            scene.sceneGuiConfig.contentWidth = Math.max(NLStyle.scene.defaultContentWidth,
                                                         Math.min(NLStyle.scene.maximumContentWidth,
                                                                  scene.sceneGuiConfig.contentWidth + diff.x));
            scene.sceneGuiConfig.contentHeight = Math.max(NLStyle.scene.defaultContentHeight,
                                                         Math.min(NLStyle.scene.maximumContentHeight,
                                                                  scene.sceneGuiConfig.contentHeight + diff.y));

            updateContentSize();
        }
    }

    Connections {
        target: scene?._undoCore.undoStack ?? null

        //! We use this connection to update content x, y, width, and height when and undo/redo is
        //! happened, scene properties of Scene.sceneGuiConfig is not binded to that of this
        //! Flickable
        function onUndoRedoDone()
        {
            //! Restore zoom
            sceneSession.zoomManager.customZoom(scene.sceneGuiConfig.zoomFactor);

            //! Update contentX and contentY
            if (Math.abs(scene.sceneGuiConfig.contentX - contentX) > 0.001) {
                contentX = scene.sceneGuiConfig.contentX;
            }
            if (Math.abs(scene.sceneGuiConfig.contentY - contentY) > 0.001) {
                contentY = scene.sceneGuiConfig.contentY;
            }
        }
    }

    /*! Methods
     * *******************************************************************************************/
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

    function selectLinkAt(pos, modifier)
    {
        var link = findLink(pos);

        if (link === null) return;

        // Select current node
        if (scene.selectionModel.isSelected(link?._qsUuid) && modifier === Qt.ShiftModifier) {
            scene.selectionModel.remove(link._qsUuid);
        } else {
            // TODO: bug with shift selection! beware of Alt
            scene.selectionModel.selectLink(link);
        }
    }

    function updateContentSize()
    {
        //! \note: This might not be always desired so its better to add a boolean to control if
        //! users of NodesScene want's to enable this behavior
        //!
        //! This method will be called mostly due to zooming, so lets check if content width/height
        //! is less than the view (flickable's width/height), we'll resize them so there are no
        //! non-functional areas
        var newContentWidth = scene.sceneGuiConfig.contentWidth * sceneSession.zoomManager.zoomFactor;
        var newContentHeight = scene.sceneGuiConfig.contentHeight * sceneSession.zoomManager.zoomFactor;
        if (newContentWidth < flickable.width) {
            //! Increase content width
            scene.sceneGuiConfig.contentWidth += (flickable.width - newContentWidth) / sceneSession.zoomManager.zoomFactor;
            scene.sceneGuiConfig.contentHeight = scene.sceneGuiConfig.contentWidth;

            newContentWidth = scene.sceneGuiConfig.contentWidth * sceneSession.zoomManager.zoomFactor;
            newContentHeight = scene.sceneGuiConfig.contentHeight * sceneSession.zoomManager.zoomFactor;
        }

        if (newContentHeight < flickable.height) {
            //! Increase content height
            scene.sceneGuiConfig.contentHeight += (flickable.height - newContentHeight) / sceneSession.zoomManager.zoomFactor;
            scene.sceneGuiConfig.contentWidth = scene.sceneGuiConfig.contentHeight;

            newContentWidth = scene.sceneGuiConfig.contentWidth * sceneSession.zoomManager.zoomFactor;
            newContentHeight = scene.sceneGuiConfig.contentHeight * sceneSession.zoomManager.zoomFactor;
        }

        resizeContent(newContentWidth, newContentHeight, worldZoomPoint);

        contentX = Math.max(0, Math.min(contentWidth - width, contentX));
        contentY = Math.max(0, Math.min(contentHeight - height, contentY));
    }

    //! Function to update ui to the center of the selected Rect
    function goToCenter() {
        var minX = Number.POSITIVE_INFINITY;
        var minY = Number.POSITIVE_INFINITY;
        var maxX = Number.NEGATIVE_INFINITY;
        var maxY = Number.NEGATIVE_INFINITY;

        if (Object.values(scene.selectionModel.selectedModel).length === 0)
            return;

        // Iterate through selected components
        Object.values(scene.selectionModel.selectedModel).forEach(comp =>{
            // Update min and max values
            if(comp.objectType === NLSpec.ObjectType.Node || comp.objectType === NLSpec.ObjectType.Container ) {
                minX = Math.min(minX, comp.guiConfig.position.x);
                minY = Math.min(minY, comp.guiConfig.position.y);
                maxX = Math.max(maxX, comp.guiConfig.position.x + comp.guiConfig.width);
                maxY = Math.max(maxY, comp.guiConfig.position.y + comp.guiConfig.height);
            }
        })

        var topLeftX = contentX * (1 / flickableScale) +
            (scene.sceneGuiConfig.sceneViewWidth * (1 / flickableScale))  / 2 - (maxX - minX) / 2
        var topLeftY = contentY * (1 / flickableScale) +
            (scene.sceneGuiConfig.sceneViewHeight * (1 / flickableScale)) / 2 - (maxY - minY) / 2

        var diffX = topLeftX - minX;
        var diffY = topLeftY - minY;

        flickable.contentX -= diffX * flickableScale;
        flickable.contentY -= diffY * flickableScale;
    }
}
