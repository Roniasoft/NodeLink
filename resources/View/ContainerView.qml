import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * Container View
 * ************************************************************************************************/

InteractiveNodeView {
    id: containerView

    /* Property Declarations
    * ****************************************************************************************/
    //! Container
    property Container container;

    property bool      isNodeMinimal:  sceneSession.zoomManager.zoomFactor < sceneSession.zoomManager.minimalZoomNode

    /* Object properties
    * ****************************************************************************************/
    width: container.guiConfig.width
    height: container.guiConfig.height
    x: container.guiConfig.position.x
    y: container.guiConfig.position.y
    node: container
    z: 0
    isContainer: true
    isResizable: !container.guiConfig.locked

    /* Children
    * ****************************************************************************************/
    //! When node is selected, width, height, x, and y
    //! changed must be sent into rubber bandd.
    Connections {
        target: node.guiConfig

        function onPositionChanged() {
            dimensionChanged(false);
        }

        function onWidthChanged() {
            dimensionChanged(false);
        }

        function onHeightChanged() {
            dimensionChanged(false);
        }
    }

    //! container title
    Rectangle {
        id: containerRect
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: 5
        border.color: containerTitle.activeFocus ? container.guiConfig.color : NLStyle.primaryBorderColor
        color: Qt.darker(container?.guiConfig?.color ?? "transparent", 10)
        height: container.guiConfig.containerTextHeight
        width: Math.min(containerTitle.width, parent.width)
        visible: !containerView.isNodeMinimal
        border.width: 2
        radius: 5
        clip: true

        NLTextArea {
            id: containerTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: container.title
            onTextChanged: container.title = text
            color: NLStyle.primaryTextColor
            font.family: NLStyle.fontType.roboto
            height: parent.height
            font.pixelSize: 15
            readOnly: container.guiConfig.locked
            enabled: isSelected
        }
    }

    //! Mousearea to manage dragging and selection
    MouseArea {
        id: containerMouseArea

        property real    prevX:      container.guiConfig.position.x
        property real    prevY:      container.guiConfig.position.y
        property bool    isDraging:  false

        anchors.fill: parent
        anchors.margins: 10
        hoverEnabled: true
        preventStealing: true
        enabled: !sceneSession.connectingMode &&
                 !sceneSession.isCtrlPressed
        // To hide cursor when is disable
        visible: enabled

        //! Manage zoom in containerView and pass it to zoomManager
        onWheel: (wheel) => {
            //! active zoom with no modifier.
            if(wheel.modifiers === sceneSession.zoomModifier) {
                sceneSession.zoomManager.zoomcontainerSignal(
                    Qt.point(wheel.x, wheel.y),
                    this,
                    wheel.angleDelta.y);
            }
        }

        cursorShape: (containerMouseArea.containsMouse)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor

        onPressed: (mouse) => {
            updateInnerItems()
            if (!container.guiConfig.locked) {
                isDraging = true;
                prevX = mouse.x; // should be fixed during movement as this is relative to parent
                prevY = mouse.y;
                _selectionTimer.start();
            }
        }

        onReleased: (mouse) => {
            if (!container.guiConfig.locked)
                isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (isDraging && !container.guiConfig.locked) {
                var deltaX = mouse.x - prevX;
                var deltaY = mouse.y - prevY;
                //! Updating container position
                container.guiConfig.position.x += deltaX;
                container.guiConfig.position.y += deltaY;

                if (NLStyle.snapEnabled) {
                    var x_old = container.guiConfig.position.x;
                    var y_old = container.guiConfig.position.y;
                    container.guiConfig.position = scene.snappedPosition(container.guiConfig.position);
                    deltaX +=  container.guiConfig.position.x - x_old
                    deltaY +=  container.guiConfig.position.y - y_old
                }
                container.guiConfig.positionChanged();

                var allObjects = [...Object.values(container.nodes), ...Object.values(container.containersInside)];
                //! Updating inner nodes and containers position
                allObjects.forEach(obj => {
                    obj.guiConfig.position.x += deltaX;
                    obj.guiConfig.position.y += deltaY;
                    if (false && NLStyle.snapEnabled) // disabled for now, might be changed before activating to make sure remain inside
                        obj.guiConfig.position = scene.snappedPosition(obj.guiConfig.position);
                    obj.guiConfig.positionChanged();
                })

                if((container.guiConfig.position.x < 0  && deltaX < 0) ||
                   (container.guiConfig.position.y < 0 && deltaY < 0))
                                 isDraging = false;

                 if (container.guiConfig.position.x + container.guiConfig.width > scene.sceneGuiConfig.contentWidth && deltaX > 0)
                                 scene.sceneGuiConfig.contentWidth += deltaX;

                 if(container.guiConfig.position.y + container.guiConfig.height > scene.sceneGuiConfig.contentHeight && deltaY > 0)
                                 scene.sceneGuiConfig.contentHeight += deltaY;
            }
        }
        //! Timer to manage pressed and clicked  events.
        //! They should be avoided at the same time
        Timer {
            id: _selectionTimer

            interval: 100
            repeat: false
            running: false

            onTriggered: {
                // Clear selection model when Shift key not pressed.
                const isModifiedOn = sceneSession.isShiftModifierPressed;

                if(!isModifiedOn)
                     scene.selectionModel.clearAllExcept(container._qsUuid);

                const isAlreadySel = scene.selectionModel.isSelected(container._qsUuid);
                // Select current container
                if(isAlreadySel && isModifiedOn)
                    scene.selectionModel.remove(container._qsUuid);
                else
                    scene.selectionModel.selectContainer(container);
            }
        }
    }

    /* Functions
    * ****************************************************************************************/
    //! Updating inner added or removed items
    function updateInnerItems() {
        //! removing nodes that are no longer in bounds
        Object.values(container.nodes).forEach(node => {
            if (!isInsideBound(node))
                container.removeNode(node)
        })
        //! adding nodes that are now in bounds
        Object.values(scene.nodes).forEach(node => {
           if (isInsideBound(node))
                container.addNode(node);
        })

        Object.values(container.containersInside).forEach(containerInside => {
            if (!isInsideBound(containerInside))
                container.removeContainerInside(containerInside)
        })

        Object.values(scene.containers).forEach(containerInside => {
            if (container !== containerInside && isInsideBound(containerInside))
                container.addContainerInside(containerInside)
        })
    }

    //! If given item is inside container or not
    function isInsideBound(node) {
        return node.guiConfig.position.x >= container.guiConfig.position.x &&
                node.guiConfig.position.y >= container.guiConfig.position.y &&
                node.guiConfig.position.x + node.guiConfig.width <= container.guiConfig.position.x + container.guiConfig.width &&
                node.guiConfig.position.y + node.guiConfig.height <= container.guiConfig.position.y + container.guiConfig.height;
    }
}
