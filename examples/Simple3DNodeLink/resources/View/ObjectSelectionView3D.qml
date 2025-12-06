import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * ObjectSelectionView3D - Custom ObjectSelectionView for 3D view that calculates positions
 * from actual node view positions instead of guiConfig.position
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property I_Scene        scene
    property SceneSession   sceneSession
    property SelectionModel selectionModel: scene?.selectionModel ?? null
    property var            view3d: null  // Reference to View3D for coordinate conversion
    property var            nodesOverlay: null  // Reference to nodesOverlay to find node views

    property bool           hasSelectedObject: Object.values(selectionModel?.selectedModel ?? ({})).length > 0

    /*  Object Properties
    * ****************************************************************************************/
    visible: hasSelectedObject && sceneSession.isSceneEditable
    z: 1000

    Keys.forwardTo: parent

    /*  Children
    * ****************************************************************************************/
    //! Rubber band border with different opacity
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        opacity: 0.5

        visible: rubberBand.visible
        border.width: 3
        border.color: "#8F30FA"
    }

    //! Rubber band to handle selection rect
    Rectangle {
        id: rubberBand

        anchors.fill: parent
        color: Object.values(scene?.selectionModel?.selectedModel ?? ({})).length> 1 ? "#8F30FA" :
                                                                             "transparent"
        opacity: 0.2

        visible: Object.values(scene?.selectionModel?.selectedModel ?? ({})).length > 1
   }

    //! selected object tool rect
    SelectionToolsRect {
        anchors.bottom: parent.top
        anchors.bottomMargin: selectedContainerOnly ? Object.values(scene.selectionModel.selectedModel)[0].guiConfig.containerTextHeight + 5 : 5
        anchors.horizontalCenter: parent.horizontalCenter
        //! This prevents header item from moving over NodeView
        transformOrigin: Item.Bottom
        //! This is for keeping size fixed and ignoring scale (no zoom in 3D view)
        scale: 1.0
        scene: root.scene
        sceneSession: root.sceneSession

        visible: hasSelectedObject
    }

    //! Timer to set false the rubberBand moving
    Timer {
        id: _timer

        repeat: false
        running: false
        interval: 10

        onTriggered: sceneSession.isRubberBandMoving = false;
    }

    //! Connection to calculate rubber band Dimensions when necessary.
    Connections {
        target: scene?.selectionModel ?? null

        function onSelectedModelChanged() {
            calculateDimensions();
        }
    }

    //! Timer to periodically update dimensions when nodes move
    Timer {
        id: _timerUpdateDimention

        running: hasSelectedObject
        repeat: true
        interval: 16  // ~60 FPS

        onTriggered: calculateDimensions();
    }

    /*  Functions
    * ****************************************************************************************/

    //! Find node view in nodesOverlay by node UUID
    function findNodeView(nodeUuid) {
        if (!nodesOverlay || !nodesOverlay.children) return null;
        
        for (var i = 0; i < nodesOverlay.children.length; i++) {
            var child = nodesOverlay.children[i];
            if (child && child.nodeData && child.nodeData._qsUuid === nodeUuid) {
                return child;
            }
        }
        return null;
    }

    //! calculate X, Y, width and height of rubber band from actual node view positions
    function calculateDimensions() {
        var firstObj = Object.values(scene.selectionModel.selectedModel)[0];
        if (firstObj === undefined)
            return;

        var isNodeFirstObj = firstObj.objectType === NLSpec.ObjectType.Node || firstObj.objectType === NLSpec.ObjectType.Container;
        
        if (!isNodeFirstObj) {
            // For links, use port positions
            var portPosVecOut = firstObj?.outputPort?._position
            var position = firstObj?.inputPort?._position;
            var leftX = (position.x < portPosVecOut.x) ? position.x : portPosVecOut.x;
            var topY = (position.y < portPosVecOut.y) ? position.y : portPosVecOut.y;
            var rightX = (position.x > portPosVecOut.x) ? position.x : portPosVecOut.x;
            var bottomY = (position.y > portPosVecOut.y) ? position.y : portPosVecOut.y;
            
            root.width = (rightX - leftX + 10)
            root.height = (bottomY - topY + 10)
            root.x = leftX - 5;
            root.y = topY - 5;
            return;
        }

        // For nodes, find the actual node view position
        var nodeView = findNodeView(firstObj._qsUuid);
        if (!nodeView) {
            // Fallback to guiConfig.position if node view not found
            var position = firstObj.guiConfig?.position;
            var leftX = position.x;
            var topY = position.y;
            var rightX = position.x + firstObj.guiConfig.width;
            var bottomY = position.y + firstObj.guiConfig.height;
            
            root.width = (rightX - leftX + 10)
            root.height = (bottomY - topY + 10)
            root.x = leftX - 5;
            root.y = topY - 5;
            return;
        }

        // Get actual position from node view
        var leftX = nodeView.x;
        var topY = nodeView.y;
        var rightX = nodeView.x + nodeView.width;
        var bottomY = nodeView.y + nodeView.height;

        // Calculate bounds for all selected nodes
        Object.values(scene.selectionModel.selectedModel).forEach(obj => {
            if (!obj)
                return;
            if (obj.objectType === NLSpec.ObjectType.Node || obj.objectType === NLSpec.ObjectType.Container) {
                var nodeViewObj = findNodeView(obj._qsUuid);
                if (nodeViewObj) {
                    var tempLeftX = nodeViewObj.x;
                    var tempTopY = nodeViewObj.y;
                    var tempRightX = nodeViewObj.x + nodeViewObj.width;
                    var tempBottomY = nodeViewObj.y + nodeViewObj.height;
                    
                    if (tempLeftX < leftX) {
                        leftX = tempLeftX;
                    }
                    if (tempTopY < topY) {
                        topY = tempTopY;
                    }
                    if (rightX < tempRightX) {
                        rightX = tempRightX;
                    }
                    if (bottomY < tempBottomY) {
                        bottomY = tempBottomY;
                    }
                } else {
                    // Fallback to guiConfig.position
                    var pos = obj.guiConfig.position;
                    var tempLeftX = pos.x;
                    var tempTopY = pos.y;
                    var tempRightX = pos.x + obj.guiConfig.width;
                    var tempBottomY = pos.y + obj.guiConfig.height;
                    
                    if (tempLeftX < leftX) {
                        leftX = tempLeftX;
                    }
                    if (tempTopY < topY) {
                        topY = tempTopY;
                    }
                    if (rightX < tempRightX) {
                        rightX = tempRightX;
                    }
                    if (bottomY < tempBottomY) {
                        bottomY = tempBottomY;
                    }
                }
            } else if (obj.objectType === NLSpec.ObjectType.Link) {
                var portPosVecIn = obj?.inputPort?._position
                var portPosVecOut = obj?.outputPort?._position
                var tempLeftX = (portPosVecIn.x < portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                var tempTopY = (portPosVecIn.y < portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;
                var tempRightX = (portPosVecIn.x > portPosVecOut.x) ? portPosVecIn.x : portPosVecOut.x;
                var tempBottomY = (portPosVecIn.y > portPosVecOut.y) ? portPosVecIn.y : portPosVecOut.y;
                
                if (tempLeftX < leftX)
                   leftX = tempLeftX;
                if (tempTopY < topY)
                   topY = tempTopY;
                if (tempRightX > rightX)
                   rightX = tempRightX;
                if (tempBottomY > bottomY)
                   bottomY = tempBottomY;
            }
        });
        
        var margin = 5;

        // Update dimensions
        root.width = (rightX - leftX + 2 * margin)
        root.height = (bottomY - topY + 2 * margin)
        root.x = leftX - margin;
        root.y = topY - margin;
    }
}

