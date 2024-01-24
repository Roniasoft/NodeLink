import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import NodeLink

/*! ***********************************************************************************************
 * This class show node ui.
 * ************************************************************************************************/
InteractiveNodeView {
    id: nodeView

    /* Property Declarations
     * ****************************************************************************************/
    property bool         edit

    //! Node is in minimal state or not (based in zoom factor)
    property bool         isNodeMinimal:  sceneSession.zoomManager.zoomFactor < sceneSession.zoomManager.minimalZoomNode

    //! nodeMouseArea
    //! Simply capture mouse area properties and avoid overwriting anything carelessly.
    //! such as onPositionChanged, onPressed and etc.
    property alias        mainMouseArea:  nodeMouseArea

    //! Node Context menu, required in image MouseArea
    property alias        nodeContextMenu: nodeContextMenu

    /* Object Properties
     * ****************************************************************************************/
    opacity: isSelected ? 1 : isNodeMinimal ? 0.6 : 0.8

    /* Slots
     * ****************************************************************************************/
    signal mainMouseAreaClicked(event: var);

    /* Slots
     * ****************************************************************************************/

    onMainMouseAreaClicked: event => {
                                // Sanity check
                                if (event.button === Qt.RightButton) {
                                    edit = false;
                                    nodeMouseArea.clicked(event);
                                }
                            }


    onEditChanged: {

        // When Node is editting and zoomFactor is less than minimalZoomNode,
        // and need a node to be edit
        // The zoom will change to the minimum editable value
        if(nodeView.edit && nodeView.isNodeMinimal)
            sceneSession.zoomManager.zoomToNodeSignal(node, sceneSession.zoomManager.nodeEditZoom);

        if (!nodeView.edit) 
             nodeView.forceActiveFocus();
    }

    onIsSelectedChanged: {
        //! Current nodeView keep the focus, current focus handle in the upper layers.
        nodeView.forceActiveFocus();
        if (!nodeView.isSelected)
            nodeView.edit = false;

    }

    /* Children
    * ****************************************************************************************/

    //! contentItem, All things that are shown in a nodeView.
    contentItem: Item {
        //! Header Item
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12

            visible: !nodeView.isNodeMinimal
            height: 20

            //! Icon
            Text {
                id: iconText
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
                font.weight: 400
            }

            //! Title Text
            NLTextArea {
                id: titleTextArea

                anchors.right: parent.right
                anchors.left: iconText.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                height: 40

                rightPadding: 10

                readOnly: !nodeView.edit
                focus: false
                placeholderText: qsTr("Enter title")
                color: NLStyle.primaryTextColor
                selectByMouse: true
                text: node.title
                verticalAlignment: Text.AlignVCenter
                onTextChanged: {
                    if (node && node.title !== text)
                        node.title = text;
                }

                onPressed: (event) => {
                               if (event.button === Qt.RightButton) {
                                   nodeView.edit = false
                                   nodeMouseArea.clicked(event)
                               }
                           }

                smooth: true
                antialiasing: true
                font.pointSize: NLStyle.node.fontSizeTitle
                font.bold: true

                //! Connections to forceActiveFocus when
                //! nodeView.edit is true
                Connections {
                    target: nodeView

                    function onEditChanged() {
                        if(nodeView.edit)
                            titleTextArea.forceActiveFocus();
                    }
                }
            }
        }

        //! ScrollView to manage scroll view in Text Area
        ScrollView {
            id: view

            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5

            hoverEnabled: true
            clip: true
            focus: true
            visible: !nodeView.isNodeMinimal

            ScrollBar.vertical: ScrollBar {
                id: scrollerV
                parent: view.parent
                anchors.top: view.top
                anchors.right: view.right
                anchors.bottom: view.bottom
                width: 5
                anchors.rightMargin: 1
            }

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            // Description Text
            NLTextArea {
                id: textArea

                focus: false
                placeholderText: qsTr("Enter description")
                color: NLStyle.primaryTextColor
                text: node.guiConfig.description
                readOnly: !nodeView.edit
                wrapMode:TextEdit.WrapAnywhere
                onTextChanged: {
                    if (node && node.guiConfig.description !== text)
                        node.guiConfig.description = text;
                }
                smooth: true
                antialiasing: true
                font.bold: true
                font.pointSize: NLStyle.node.fontSize

                onPressed: (event) => {
                               if (event.button === Qt.RightButton) {
                                   nodeView.edit = false;
                                   nodeMouseArea.clicked(event);
                               }
                           }
                background: Rectangle {
                    color: "transparent";
                }
            }
        }

        //! Minimal nodeview in low zoomFactor: forgrond
        Rectangle {
            id: minimalRectangle
            anchors.fill: parent
            anchors.margins: 10

            color: nodeView.isNodeMinimal ? "#282828" : "trasparent"
            radius: NLStyle.radiusAmount.nodeView

            //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0.7
            OpacityAnimator {
                target: minimalRectangle

                from: minimalRectangle.opacity
                to: 0.7
                duration: 200
                running: nodeView.isNodeMinimal
            }

            //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0
            OpacityAnimator {
                target: minimalRectangle

                from: minimalRectangle.opacity
                to: 0
                duration: 200
                running: !nodeView.isNodeMinimal
            }

            //! Node Image, if exists
            Image {
                id: nodeImageMinimal
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: (node.imagesModel.coverImageIndex !== -1) ? node.imagesModel.imagesSources[node.imagesModel.coverImageIndex] : ""
                visible: node.imagesModel.coverImageIndex !== -1
            }

            //! Text Icon for when node has an image
            Text {
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 30
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 3
                text: scene?.nodeRegistry?.nodeIcons[node.type] ?? ""
                color: node.guiConfig.color
                font.weight: 400
                visible: nodeView.isNodeMinimal && node.imagesModel.coverImageIndex !== -1
            }

            //! Text Icon for when node does not have an image
            Text {
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 60
                anchors.centerIn: parent
                text: scene?.nodeRegistry?.nodeIcons[node.type] ?? ""
                color: node.guiConfig.color
                font.weight: 400
                visible: nodeView.isNodeMinimal && node.imagesModel.coverImageIndex === -1
            }
        }

    }

    //! Manage node selection and position change.
    MouseArea {
        id: nodeMouseArea

        property real    prevX:      node.guiConfig.position.x
        property real    prevY:      node.guiConfig.position.y
        property bool   isDraging:  false

        anchors.fill: parent
        anchors.margins: 10
        hoverEnabled: true
        preventStealing: true
        enabled: !nodeView.edit && !sceneSession.connectingMode &&
                 !node.guiConfig.locked && !sceneSession.isCtrlPressed &&
                 isNodeEditable

        // To hide cursor when is disable
        visible: enabled

        //! Manage zoom in nodeview and pass it to zoomManager
        onWheel: (wheel) => {
                     //! active zoom with no modifier.
                     if(wheel.modifiers === sceneSession.zoomModifier) {
                         sceneSession.zoomManager.zoomNodeSignal(
                             Qt.point(wheel.x, wheel.y),
                             this,
                             wheel.angleDelta.y);
                     }
                 }

        onDoubleClicked: (mouse) => {
            // Clear all selected nodes
            scene.selectionModel.clearAllExcept(node._qsUuid);

            // Select current node
            scene.selectionModel.selectNode(node);

            // Enable edit mode
            nodeView.edit = true;
            isDraging = false;
        }

        cursorShape: (nodeMouseArea.containsMouse && !nodeView.edit)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor


        //! Manage right and left click to select and
        //! show node contex menue.
        onClicked: (mouse) => {
            if (isNodeEditable && mouse.button === Qt.RightButton) {
                // Ensure the isDraging is false.
                isDraging = false;

                // Clear all selected nodes
                scene.selectionModel.clearAllExcept(node._qsUuid);

                // Select current node
                scene.selectionModel.selectNode(node);

                nodeContextMenu.popup(mouse.x, mouse.y);
            }
        }

        onPressed: (mouse) => {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
            _selectionTimer.start();
        }

        onReleased: (mouse) => {
            isDraging = false;
        }

        onPositionChanged: (mouse) => {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                node.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;
                var deltaY = mouse.y - prevY;
                node.guiConfig.position.y += deltaY;
                if(NLStyle.snapEnabled)
                    node.guiConfig.position = scene.snappedPosition(node.guiConfig.position)
                node.guiConfig.positionChanged();
                prevY = mouse.y - deltaY;

                if((node.guiConfig.position.x < 0  && deltaX < 0) ||
                   (node.guiConfig.position.y < 0 && deltaY < 0))
                                 isDraging = false;

                 if (node.guiConfig.position.x + node.guiConfig.width > scene.sceneGuiConfig.contentWidth && deltaX > 0)
                                 scene.sceneGuiConfig.contentWidth += deltaX;

                 if(node.guiConfig.position.y + node.guiConfig.height > scene.sceneGuiConfig.contentHeight && deltaY > 0)
                                 scene.sceneGuiConfig.contentHeight += deltaY;
            }
        }

        NodeContextMenu {
            id: nodeContextMenu
            scene: nodeView.scene
            sceneSession: nodeView.sceneSession
            node: nodeView.node
            onEditNode: nodeView.edit = true;
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
                     scene.selectionModel.clearAllExcept(node._qsUuid);

                const isAlreadySel = scene.selectionModel.isSelected(node._qsUuid);
                // Select current node
                if(isAlreadySel && isModifiedOn)
                    scene.selectionModel.remove(node._qsUuid);
                else
                    scene.selectionModel.selectNode(node);
            }
        }
    }

    //! Locks the node
    MouseArea {
        anchors.fill: parent
        anchors.margins: -10
        enabled: node.guiConfig.locked || !isNodeEditable
        onClicked: _selectionTimer.start();
        visible: node.guiConfig.locked || !isNodeEditable

        //! Manage zoom in nodeview and pass it to zoomManager in lock mode.
        onWheel: (wheel) => {
                     //! active zoom with no modifier.
                     if(wheel.modifiers === Qt.NoModifier) {
                         sceneSession.zoomManager.zoomNodeSignal(
                             Qt.point(wheel.x, wheel.y),
                             this,
                             wheel.angleDelta.y);
                     }
                 }

    }

    //! Reset some properties when selection model changed.
    Connections {
        target: scene.selectionModel

        function onSelectedModelChanged() {
            if(!scene.selectionModel.isSelected(node._qsUuid))
                nodeView.edit = false;
        }
    }

    //! When node is selected, width, height, x, and y
    //! changed must be sent into rubber bandd.
    Connections {
        target: node.guiConfig

        function onPositionChanged() {
            dimensionChanged(true);
        }

        function onWidthChanged() {
            dimensionChanged(true);
        }

        function onHeightChanged() {
            dimensionChanged(true);
        }
    }

}
