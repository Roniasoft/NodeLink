import QtQuick
import NodeLink
import QtQuick.Shapes

Shape {
    /* Property Declarations
    * ****************************************************************************************/
    property point startPos

    property point endPos

    antialiasing: true
    smooth: true
//    layer.enabled: true
//    layer.samples: 8
//    layer.smooth: true
//    layer.
    ShapePath {
        id: path

        startX: startPos.x
        startY: startPos.y

        strokeWidth: 2
        strokeColor: "green"
        fillColor: "green"


//        PathCurve {
//            x: connection.outputPort.x -50
//            y: (connection.outputPort.y + connection.inputPort.y) / 2
//        }

        PathCurve {
            id: endPoint
            x: endPos.x
            y: endPos.y
        }
    }

//    MouseArea {
//        anchors.fill: parent
//        propagateComposedEvents: true
//        preventStealing: true
//        onClicked: mouse => {
//                       endPoint.x = mouse.x;
//                       endPoint.y = mouse.y;
//                   }

//        onPositionChanged: mouse => {
//                               endPoint.x = mouse.x;
//                               endPoint.y = mouse.y;
//                           }
//    }
}
