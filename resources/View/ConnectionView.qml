import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes

/*! ***********************************************************************************************
 * This class draw linker lines.
 * ************************************************************************************************/

Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property Scene      scene
    property Port       inputPort
    property Port       outputPort

    property SceneSession sceneSession

    property int        linkMode: NLSpec.LinkMode.Connected

    property QtObject   privateProperties: QtObject {
        property point      globalPosInputPort: {

            if (linkMode === NLSpec.LinkMode.Connected) {
               return scene.portsPositions[inputPort._qsUuid]
            } else {
                if(sceneSession.tempInputPort !== null)
                    return scene.portsPositions[sceneSession.tempInputPort._qsUuid]
            }

            return Qt.point(0, 0);
        }
        property point      globalPosOutputPort:  (linkMode === NLSpec.LinkMode.Connected) ?
                                                      scene.portsPositions[outputPort._qsUuid] :
                                                      sceneSession.tempConnectionEndPos

        //! update painted line when change position of input and output ports
        onGlobalPosOutputPortChanged: canvas.requestPaint();
        onGlobalPosInputPortChanged:  canvas.requestPaint()

    }

    /*  Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    antialiasing: true

    //! paint line
    onPaint: {

        var context = canvas.getContext("2d");
        context.reset();

        if (inputPort === null)
            return;

        context.lineWidth = 2;
        context.beginPath();

        // our start position
        context.moveTo(privateProperties.globalPosInputPort.x,
                       privateProperties.globalPosInputPort.y);

        var outputPortMargin = (outputPort !== null) ? privateFunctions.connectionMargin(outputPort) :
                                                            Qt.point(0, 0);
        // random bezier curve, which ends on last X, last Y
        context.bezierCurveTo(privateProperties.globalPosInputPort.x  + privateFunctions.connectionMargin(inputPort).x,
                              privateProperties.globalPosInputPort.y  + privateFunctions.connectionMargin(inputPort).y,
                              privateProperties.globalPosOutputPort.x + outputPortMargin.x ,
                              privateProperties.globalPosOutputPort.y + outputPortMargin.y,
                              privateProperties.globalPosOutputPort.x,
                              privateProperties.globalPosOutputPort.y);

        // glow effect
        context.strokeStyle = 'hsl(' + 10 + ', 50%, 255%)';
        //        context.shadowColor = 'white';
        //        context.shadowBlur = 10;
        // stroke the curve
        context.stroke();
        context.restore();
    }

    /*  Children
    * ****************************************************************************************/
    Connections {
        target: scene

        // Send paint requset when PortsPositionsChanged
        function onPortsPositionsChanged () {
            canvas.requestPaint();
        }
    }

    /* Private Functions
    * ****************************************************************************************/
    property QtObject privateFunctions: QtObject {
        function connectionMargin (inputPort: Port) {
            if(inputPort === null)
                return Qt.point(0, 0);


            switch (inputPort.portSide) {
            case NLSpec.PortPositionSide.Top:
                return Qt.point(0, -30);

            case NLSpec.PortPositionSide.Bottom:
                return Qt.point(0, +30);

            case NLSpec.PortPositionSide.Left:
                return Qt.point(-30, 0);

            case NLSpec.PortPositionSide.Right:
                return Qt.point(+30, 0);
            }
        }
    }
}
