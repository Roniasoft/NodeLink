import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes

import "Logics/BezierCurve.js" as BezierCurve
import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 *  I_LinkView is an interface classs that shows Links (BezierCurve).
 * ************************************************************************************************/

Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property Scene  scene

    property Port   inputPort

    property Port   outputPort

    property Link   link:       Link {}

    property bool   isSelected: link == scene.selectionModel.selectedLink

    property vector2d inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d linkMidPoint: Qt.vector2d(0, 0)

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
        link.controlPoint1 = inputPos.plus(BezierCurve.connectionMargin(inputPort));
        link.controlPoint2 = outputPos.plus(BezierCurve.connectionMargin(outputPort));

        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, link.controlPoint1, link.controlPoint2, outputPos]);
        // draw the curve
        BezierCurve.bezierCurve(context, inputPos, link.controlPoint1,
                                link.controlPoint2, outputPos, isSelected,
                                link.guiConfig.color, link.direction,
                                link.guiConfig.style);
    }

    /* Children
    * ****************************************************************************************/

  // requestPaint when direction of link changed.
  Connections {
      target: link

      function onDirectionChanged() {
          canvas.requestPaint();
      }
  }

  // requestPaint when style of link changed.
  Connections {
      target: link.guiConfig

      function onStyleChanged() {
          canvas.requestPaint();
      }
  }
}
