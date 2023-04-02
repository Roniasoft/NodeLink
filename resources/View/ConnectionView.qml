import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes
import "Logics/BezierCurve.js" as BezierCurve

/*! ***********************************************************************************************
 * A view for the connections (BezierCurve)
 * Using a js canvas for drawing
 * ************************************************************************************************/
Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property Scene  scene

    property Port   inputPort

    property Port   outputPort

    property Connection connection: Connection {};

    property bool isSelected: false

    property vector2d inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    //! update painted line when change position of input and output ports
    onOutputPosChanged: canvas.requestPaint();
    onInputPosChanged:  canvas.requestPaint();
    onIsSelectedChanged: canvas.requestPaint();


    /*  Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    antialiasing: true

    //! paint line
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        // if null ports then return the function
        if (inputPort === null) {
            context.reset();
            return;
        }

        // calculate the control points
        connection.controlPoint1 = inputPos.plus(BezierCurve.connectionMargin(inputPort));
        connection.controlPoint2 = outputPos.plus(BezierCurve.connectionMargin(outputPort));

        // draw the curve
        BezierCurve.bezierCurve(context, inputPos, connection.controlPoint1, connection.controlPoint2, outputPos, isSelected);
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
}
