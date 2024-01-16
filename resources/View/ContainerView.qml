import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * Container View
 * ************************************************************************************************/

Item {
    id: containerView

    /* Property Declarations
    * ****************************************************************************************/
    property Container container;

    property I_Scene        scene

    property SceneSession   sceneSession

    property bool isResizable: true

    property bool isSelected: scene?.selectionModel?.isSelected(container?._qsUuid ?? "") ?? false
    //! viewProperties encompasses all view properties that are not included
    //! in either the scene or the scene session.
    property QtObject   viewProperties: null

    property bool edit

    width: container.guiConfig.width
    height: container.guiConfig.height
    x: container.guiConfig.position.x
    y: container.guiConfig.position.y

    onEditChanged: {

        // When Node is editting and zoomFactor is less than minimalZoomNode,
        // and need a node to be edit
        // The zoom will change to the minimum editable value
        if(containerView.edit)
            sceneSession.zoomManager.zoomToNodeSignal(container, sceneSession.zoomManager.nodeEditZoom);

        if (!containerView.edit)
             containerView.forceActiveFocus();
    }

    Keys.onDeletePressed: {
        if (!isSelected)
            return;


        if (sceneSession.isDeletePromptEnable)
            deletePopup.open();
         else
            delTimer.start();
    }

    //! Use Key to manage shift pressed to handle multiObject selection
    Keys.onPressed: (event)=> {
        if (event.key === Qt.Key_Shift)
            sceneSession.isShiftModifierPressed = true;
    }

    Keys.onReleased: (event)=> {
        if (event.key === Qt.Key_Shift)
            sceneSession.isShiftModifierPressed = false;
    }
    ConfirmPopUp {
        id: deletePopup
        confirmText: "Are you sure you want to delete " +
                                     (Object.keys(scene.selectionModel.selectedModel).length > 1 ?
                                         "these items?" : "this item?");
        sceneSession: containerView.sceneSession
        onAccepted: delTimer.start();
    }

    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: {
            scene.deleteSelectedObjects();
        }
    }

    Rectangle {
        id: backgroundRect
        width: parent.width
        height: parent.height - containerTitle.height - 5
        anchors.bottom: parent.bottom
        color: "transparent"
        border.color: container.guiConfig.color
        border.width: 2
        opacity: isSelected ? 1 : 0.8
        radius: 5
    }

    NLTextField {
        id: containerTitle
        height: 35
        width: Math.max(parent.width * 0.3, 100)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: backgroundRect.top
        anchors.bottomMargin: 5
        text: container.title
        onTextChanged: container.title = text
        color: NLStyle.primaryTextColor
        font.family: NLStyle.fontType.roboto

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: containerTitle.activeFocus ? container.guiConfig.color : NLStyle.primaryBorderColor
            opacity: 0.9
            border.width: 1
            radius: 5
        }

    }

    MouseArea {
        id: containerMouseArea

        property real    prevX:      container.guiConfig.position.x
        property real    prevY:      container.guiConfig.position.y
        property bool   isDraging:  false

        anchors.fill: backgroundRect
        anchors.margins: 10
        hoverEnabled: true
        preventStealing: true
        enabled: !sceneSession.connectingMode &&
                 !sceneSession.isCtrlPressed
        // To hide cursor when is disable
        visible: enabled

//        onEntered:
//        onExited:

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

        onDoubleClicked: (mouse) => {
            checkBounds()
            // Clear all selected containers
            scene.selectionModel.clearAllExcept(container._qsUuid);

            // Select current container
            scene.selectionModel.selectContainer(container);

            // Enable edit mode
            containerView.edit = true;
            isDraging = false;
        }

        cursorShape: (containerMouseArea.containsMouse/* && !containerView.edit*/)
                     ? (isDraging ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
                     : Qt.ArrowCursor


        //! Manage right and left click to select and
        //! show container contex menue.
        onClicked: (mouse) => {
//            isDraging = false;
//                       scene.selectionModel.clearAllExcept(container._qsUuid);
//            scene.selectionModel.selectContainer(container);
//            if (isContainerEditable && mouse.button === Qt.RightButton) {
//                // Ensure the isDraging is false.
//                isDraging = false;

//                // Clear all selected containers
//                scene.selectionModel.clearAllExcept(container._qsUuid);

//                // Select current container
//                scene.selectionModel.selectcontainer(container);

//                containerContextMenu.popup(mouse.x, mouse.y);
//            }
        }

        onPressed: (mouse) => {
            checkBounds()
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
            _selectionTimer.start();
        }

        onReleased: (mouse) => {
            isDraging = false;
                        ;
        }

        onPositionChanged: (mouse) => {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                var deltaY = mouse.y - prevY;

                container.guiConfig.position.x += deltaX;
                container.guiConfig.position.y += deltaY;
                if(NLStyle.snapEnabled){
                    container.guiConfig.position.y =  Math.ceil(container.guiConfig.position.y / 20) * 20;
                    container.guiConfig.position.x =  Math.ceil(container.guiConfig.position.x / 20) * 20;
                }
                container.guiConfig.positionChanged();

                Object.values(container.nodes).forEach(node => {
                    node.guiConfig.position.x += deltaX;
                    node.guiConfig.position.y += deltaY;
                    if(NLStyle.snapEnabled){
                        node.guiConfig.position.y =  Math.ceil(node.guiConfig.position.y / 20) * 20;
                        node.guiConfig.position.x =  Math.ceil(node.guiConfig.position.x / 20) * 20;
                    }
                    node.guiConfig.positionChanged();
                })

                Object.values(container.containersInside).forEach(container => {
                    container.guiConfig.position.x += deltaX;
                    container.guiConfig.position.y += deltaY;
                    if(NLStyle.snapEnabled){
                        container.guiConfig.position.y =  Math.ceil(container.guiConfig.position.y / 20) * 20;
                        container.guiConfig.position.x =  Math.ceil(container.guiConfig.position.x / 20) * 20;
                    }
                    container.guiConfig.positionChanged();
                })

                prevX = mouse.x - deltaX;
                prevY = mouse.y - deltaY;

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





    //! Top Side Mouse Area
    MouseArea {
        id: topMouseArea
        width: parent.width
        hoverEnabled: true
        enabled: isResizable && !sceneSession.connectingMode
        height: 20
        cursorShape: Qt.SizeVerCursor
        anchors.top: backgroundRect.top
        anchors.topMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        //! Resize properties
        property bool   isDraging:  false
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaY = mouse.y - prevY;
                var correctedDeltaY = Math.floor(deltaY);

                container.guiConfig.position.y += correctedDeltaY;
                container.guiConfig.height -= correctedDeltaY;
                prevY = mouse.y - deltaY;
                if(container.guiConfig.height < 70){
                    container.guiConfig.height = 70;
                    if(deltaY>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //! Bottom Side Mouse Area
    MouseArea {
        id: bottomMouseArea
        width: parent.width
        hoverEnabled: true
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeVerCursor
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -10
        anchors.horizontalCenter: parent.horizontalCenter
        preventStealing: true

        //! Resize properties
        property bool   isDraging:  false
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaY = mouse.y - prevY;
                container.guiConfig.height += deltaY;
                prevY = mouse.y - deltaY;
                if(container.guiConfig.height <= 70){
                    container.guiConfig.height = 70
                }
            }
        }
    }

    //! Left Side Mouse Area
    MouseArea {
        id: leftMouseArea
        width: 20
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: isResizable && !sceneSession.connectingMode
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true


        //! Resize properties
        property bool   isDraging:  false
        property real    prevX:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                var correctedDeltaX = Math.floor(deltaX);

                container.guiConfig.position.x += correctedDeltaX;
                container.guiConfig.width -= correctedDeltaX;
                prevX = mouse.x - deltaX;

                if(container.guiConfig.width < 100){
                    container.guiConfig.width = 100
                    if(deltaX>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //! Right Side Mouse Area
    MouseArea {
        id: rightMouseArea
        width: 12
        cursorShape: Qt.SizeHorCursor
        hoverEnabled: true
        enabled: isResizable && !sceneSession.connectingMode
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: -10
        anchors.verticalCenter: parent.verticalCenter
        preventStealing: true


        //! Resize properties
        property bool   isDraging:  false
        property int    prevX:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                container.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(container.guiConfig.width < 100){
                    container.guiConfig.width = 100
                }
            }
        }
    }

    //! Resize by corners
    //! *****************

    //! Upper right sizing area
    MouseArea {
        id: rightTopCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeBDiagCursor
        hoverEnabled: true
        anchors.right: parent.right
        anchors.top: backgroundRect.top
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                container.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(container.guiConfig.width < 100){
                    container.guiConfig.width = 100
                }
                var deltaY = mouse.y - prevY
                container.guiConfig.position.y += deltaY;
                container.guiConfig.height -= deltaY;
                prevY = mouse.y - deltaY;
                if(container.guiConfig.height <= 70){
                    container.guiConfig.height = 70
                    if(deltaY>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //! Lower right sizing area
    MouseArea {
        id: rightDownCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeFDiagCursor
        hoverEnabled: true
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                container.guiConfig.width += deltaX
                prevX = mouse.x - deltaX;
                if(container.guiConfig.width < 100){
                    container.guiConfig.width = 100
                }
                var deltaY = mouse.y - prevY
                container.guiConfig.height += deltaY;
                prevY = mouse.y - deltaY;
                if(container.guiConfig.height <= 70){
                    container.guiConfig.height = 70
                }
            }
        }
    }

    //! Upper left sizing area
    MouseArea {
        id: leftTopCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeFDiagCursor
        hoverEnabled: true
        anchors.left: parent.left
        anchors.top: backgroundRect.top
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;

        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                container.guiConfig.width -= deltaX
                container.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;
                if(container.guiConfig.width < 100){
                    container.guiConfig.width = 100
                    if(deltaX>0){
                        isDraging = false
                    }
                }
                var deltaY = mouse.y - prevY
                container.guiConfig.position.y += deltaY;
                container.guiConfig.height -= deltaY;
                prevY = mouse.y - deltaY;
                if(container.guiConfig.height <= 70){
                    container.guiConfig.height = 70
                    if(deltaY>0){
                        isDraging = false
                    }
                }
            }
        }
    }

    //! Lower left sizing area
    MouseArea {
        id: leftDownCornerMouseArea
        width: 20
        height: 20
        enabled: isResizable && !sceneSession.connectingMode
        cursorShape: Qt.SizeBDiagCursor
        hoverEnabled: true
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: -10
        anchors.bottomMargin: -10
        preventStealing: true

        //! Movment properties
        property bool   isDraging:  false
        property int    prevX:      0
        property int    prevY:      0

        onPressed: (mouse)=> {
            isDraging = true;
            prevX = mouse.x;
            prevY = mouse.y;
        }

        onReleased: {
            isDraging = false;
            ;
        }

        onPositionChanged: (mouse)=> {
            if (isDraging) {
                var deltaX = mouse.x - prevX;
                container.guiConfig.width -= deltaX
                container.guiConfig.position.x += deltaX;
                prevX = mouse.x - deltaX;
                if(container.guiConfig.width < 100){
                    container.guiConfig.width = 100
                    if(deltaX>0){
                        isDraging = false
                    }
                }
                var deltaY = mouse.y - prevY
                container.guiConfig.height += deltaY;
                prevY = mouse.y - deltaY;
                if(container.guiConfig.height <= 70){
                    container.guiConfig.height = 70
                }
            }
        }
    }

    function checkBounds() {
        //! removing nodes that are no longer in bounds
        Object.values(container.nodes).forEach(node => {
            if (!(node.guiConfig.position.x >= container.guiConfig.position.x &&
                 node.guiConfig.position.y >= container.guiConfig.position.y + containerTitle.height &&
                 node.guiConfig.position.x + node.guiConfig.width <= container.guiConfig.position.x + container.guiConfig.width &&
                 node.guiConfig.position.y + node.guiConfig.height <= container.guiConfig.position.y + container.guiConfig.height)
                )
                container.removeNode(node)
        })
        //! adding nodes that are now in bounds
        Object.values(scene.nodes).forEach(node => {
           if (node.guiConfig.position.x >= container.guiConfig.position.x &&
               node.guiConfig.position.y >= container.guiConfig.position.y  + containerTitle.height &&
               node.guiConfig.position.x + node.guiConfig.width <= container.guiConfig.position.x + container.guiConfig.width &&
               node.guiConfig.position.y + node.guiConfig.height <= container.guiConfig.position.y + container.guiConfig.height
               )
                container.addNode(node);
        })

        Object.values(container.containersInside).forEach(containerInside => {
            if (!(containerInside.guiConfig.position.x >= container.guiConfig.position.x &&
                 containerInside.guiConfig.position.y >= container.guiConfig.position.y + containerTitle.height &&
                 containerInside.guiConfig.position.x + containerInside.guiConfig.width <= container.guiConfig.position.x + container.guiConfig.width &&
                 containerInside.guiConfig.position.y + containerInside.guiConfig.height <= container.guiConfig.position.y + container.guiConfig.height)
                )
                container.removeContainerInside(containerInside)
        })

        Object.values(scene.containers).forEach(containerInside => {
            if ((containerInside.guiConfig.position.x >= container.guiConfig.position.x &&
                 containerInside.guiConfig.position.y >= container.guiConfig.position.y + containerTitle.height &&
                 containerInside.guiConfig.position.x + containerInside.guiConfig.width <= container.guiConfig.position.x + container.guiConfig.width &&
                 containerInside.guiConfig.position.y + containerInside.guiConfig.height <= container.guiConfig.position.y + container.guiConfig.height)
                )
                container.addContainerInside(containerInside)
        })
    }
}
