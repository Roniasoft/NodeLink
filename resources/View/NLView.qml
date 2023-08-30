import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NodeLink
import QtQuickStream

Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property Scene          scene

    property SceneSession   sceneSession:   SceneSession {}

    property alias          nodesScene:     nodesScene

    /* Children
    * ****************************************************************************************/

    //! Nodes Scene (flickable)
    NodesScene {
        id: nodesScene
        scene: view.scene
        sceneSession: view.sceneSession
    }

    //! Overview Rect
    OverviewNodesScene {
        id: overView
//        visible: NLStyle.overview.visible
        visible: true
        scene: view.scene
        sceneSession: view.sceneSession
        width: 300
        height: 300
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        clip: true
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var diffX = (mouse.x - rect1.x) / Math.min(rect1.scaleFactorWidth,rect1.scaleFactorHeight)
                var diffY = (mouse.y - rect1.y) / Math.min(rect1.scaleFactorWidth,rect1.scaleFactorHeight)
                nodesScene.contentX += diffX
                nodesScene.contentY += diffY
            }
        }

        Rectangle {
                id: rect1

                property real topLeftX: Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x * sceneSession.zoomManager.zoomFactor))
                property real topLeftY: Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y * sceneSession.zoomManager.zoomFactor))
                property real bottomRightX: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.x + node.guiConfig.width) * sceneSession.zoomManager.zoomFactor) )
                property real bottomRightY: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.y + node.guiConfig.height) * sceneSession.zoomManager.zoomFactor) )
                property real scaleFactorWidth: 300 / (bottomRightX- topLeftX) > 1 ? 1 : 300 / (bottomRightX- topLeftX)
                property real scaleFactorHeight: 300 / (bottomRightY- topLeftY) > 1 ? 1 : 300 / (bottomRightY- topLeftY)

                color: "transparent"
                border.color: "red"
                x: (nodesScene.contentX - topLeftX) * Math.min(scaleFactorWidth,scaleFactorHeight)
                y: (nodesScene.contentY - topLeftY) * Math.min(scaleFactorWidth,scaleFactorHeight)
                width: (nodesScene.contentX + nodesScene.width - topLeftX) * Math.min(scaleFactorWidth,scaleFactorHeight) - x
                height: (nodesScene.contentY + nodesScene.height - topLeftY) * Math.min(scaleFactorWidth,scaleFactorHeight) - y

            MouseArea {

                property real    prevX
                property real    prevY
                property bool   isDraging:  false

                anchors.fill: parent
                hoverEnabled: true

                onPressed: (mouse) => {
                    isDraging = true;
                    prevX = mouse.x;
                    prevY = mouse.y;
                }

                onReleased: (mouse) => {
                    isDraging = false;
                }

                onPositionChanged: (mouse) => {
                    if (isDraging) {
                        var diffX = (prevX - mouse.x)
                        var diffY = (prevY - mouse.y)
                        var startingPointInSceneX = ( prevX / Math.min(rect1.scaleFactorWidth,rect1.scaleFactorHeight) )  + rect1.topLeftX
                        var startingPointInSceneY = ( prevY / Math.min(rect1.scaleFactorWidth,rect1.scaleFactorHeight) )  + rect1.topLeftY
                        var endingPointInSceneX = ( mouse.x / Math.min(rect1.scaleFactorWidth,rect1.scaleFactorHeight) )  + rect1.topLeftX
                        var endingPointInSceneY = ( mouse.y / Math.min(rect1.scaleFactorWidth,rect1.scaleFactorHeight) )  + rect1.topLeftY
                        nodesScene.contentX += endingPointInSceneX - startingPointInSceneX
                        nodesScene.contentY += endingPointInSceneY - startingPointInSceneY
                    }
                }
            }
        }

    }

    //! Side Menu
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }


}



//MouseArea {
//    id:mouseArea
//    anchors.fill: parent

    /*  Object Properties
    * ****************************************************************************************/
//    anchors.fill: parent
//            Timer {
//                id: timer
//                repeat: true
//                interval: 100
//                running: true
//                onTriggered: {
//                    rect1.hi = overView.hi();
//                    console.log("hey",rect1.topLeftX,rect1.topLeftY,overView.x,overView.y,nodesScene.width ,nodesScene.height)
//                }
//            }


//            Connections {
//                target: view

//                function onSceneChanged() {
//                    console.log("hahasdf")
//                     rect1.hi = overView.hi();
//                }
//            }
//            Rectangle {
//                id: rect1
//                property real topLeftX: Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x))
//                property real topLeftY: Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y))

//                property real bottomRightX: Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.x + node.guiConfig.width) )
//                property real bottomRightY: Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.y + node.guiConfig.height) )

//                property real scaleFactorWidth: 300 / (bottomRightX- topLeftX) > 1 ? 1 : 300 / (bottomRightX- topLeftX)
//                property real scaleFactorHeight: 300 / (bottomRightY- topLeftY) > 1 ? 1 : 300 / (bottomRightY- topLeftY)
//                color: "transparent"
//                border.color: "red"
////                property var hi
////                property real minX : Math.min(hi.node1.guiConfig.position.x, hi.node2.guiConfig.position.x,
////                                    hi.node3.guiConfig.position.x, hi.node4.guiConfig.position.x)
////                property real maxX : Math.max(hi.node1.guiConfig.position.x, hi.node2.guiConfig.position.x,
////                                    hi.node3.guiConfig.position.x, hi.node4.guiConfig.position.x)
////                property real minY : Math.min(hi.node1.guiConfig.position.y, hi.node2.guiConfig.position.y,
////                                    hi.node3.guiConfig.position.y, hi.node4.guiConfig.position.y)
////                property real maxY : Math.max(hi.node1.guiConfig.position.y, hi.node2.guiConfig.position.y,
////                                    hi.node3.guiConfig.position.y, hi.node4.guiConfig.position.y)
//                x: (nodesScene.contentX - topLeftX) * Math.min(scaleFactorWidth,scaleFactorHeight)
//                y: (nodesScene.contentY - topLeftY) * Math.min(scaleFactorWidth,scaleFactorHeight)

//                width: (nodesScene.contentX + nodesScene.width - topLeftX) * Math.min(scaleFactorWidth,scaleFactorHeight) - x
//                height: (nodesScene.contentY + nodesScene.height - topLeftY) * Math.min(scaleFactorWidth,scaleFactorHeight) - y

////                x : (minX - topLeftX) * Math.min(scaleFactorWidth,scaleFactorHeight)
////                y : (minY - topLeftY) * Math.min(scaleFactorHeight,scaleFactorWidth)
////                width : (maxX + hi.node2.guiConfig.width - minX) * Math.min(scaleFactorWidth,scaleFactorHeight)
////                height : (maxY + hi.node4.guiConfig.height - minY) * Math.min(scaleFactorWidth,scaleFactorHeight)

//            }

//        }
//function calculateManhattenDistance (x1,y1,x2,y2) {
//    return Math.abs(x1-x2) + Math.abs(y1-y2)
//}

//function hi() {
//    var minTopLeft = Number.MAX_VALUE
//    var minTopRight = Number.MAX_VALUE
//    var minBottomLeft = Number.MAX_VALUE
//    var minBottomRight = Number.MAX_VALUE
//    var nodes = []
//    Object.values(scene.nodes).forEach(node => {

//            nodes.push(node)
//    });

//    var node1, node2, node3, node4;


//    Object.values(scene.nodes).forEach(node => {
//        if (node.guiConfig.position.x >= nodesScene.contentX && node.guiConfig.position.y >= nodesScene.contentY &&
//            node.guiConfig.position.x + node.guiConfig.width <= nodesScene.contentX + nodesScene.width &&
//            node.guiConfig.position.y + node.guiConfig.height<= nodesScene.contentY + nodesScene.height) {

//            var x = node.guiConfig.position.x;
//            var y = node.guiConfig.position.y;
//            var width = node.guiConfig.width;
//            var height = node.guiConfig.height;

//            var topLeftDistance = calculateManhattenDistance (x , y , nodesScene.contentX , nodesScene.contentY)
//            var topRightDistance = calculateManhattenDistance (x + width , y , nodesScene.contentX + nodesScene.width , nodesScene.contentY)
//            var bottomLeftDistance = calculateManhattenDistance (x , y + height , nodesScene.contentX , nodesScene.contentY + nodesScene.height)
//            var bottomRightDistance = calculateManhattenDistance (x + width , y + height, nodesScene.contentX + nodesScene.width ,
//                                                                  nodesScene.contentY + nodesScene.height)

//            if (topLeftDistance <= minTopLeft) {
//                minTopLeft = topLeftDistance
//                node1 = node;
//            }

//            // Node 2
//            if (topRightDistance <= minTopRight) {
//                minTopRight = topRightDistance;
//                node2 = node;
//            }

//            // Node 3
//            if (bottomLeftDistance <= minBottomLeft) {
//                minBottomLeft = bottomLeftDistance;
//                node3 = node;
//            }

//            // Node 4
//            if (bottomRightDistance <= minBottomRight) {
//                minBottomRight = bottomRightDistance;
//                node4 = node;
//            }
//        }
//    });

//    console.log(node1,node2,node3,node4)
//    return {

//        node1: node1,
//        node2: node2,
//        node3: node3,
//        node4: node4
//    };
//}
