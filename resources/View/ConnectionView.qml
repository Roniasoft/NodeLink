import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes
import "BezierCurve.js" as BezierCurve

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

    property bool isSelected: false

    property vector2d inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    //! update painted line when change position of input and output ports
    onOutputPosChanged: canvas.requestPaint();
    onInputPosChanged:  canvas.requestPaint()


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
        var cp1 = inputPos.plus(BezierCurve.connectionMargin(inputPort));
        var cp2 = outputPos.plus(BezierCurve.connectionMargin(outputPort));

        // draw the curve
        BezierCurve.bezierCurve(context, inputPos, cp1, cp2, outputPos, isSelected);
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
