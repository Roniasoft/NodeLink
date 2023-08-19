import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes

import "Logics/BasicLinkCalculator.js" as BasicLinkCalculator
import "Logics/LinkPainter.js" as LinkPainter
import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 *  I_LinkView is an interface classs that shows Links (BezierCurve).
 * ************************************************************************************************/

Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property Scene          scene

    property SceneSession   sceneSession

    property Port           inputPort

    property Port           outputPort


    property Link       link:       Link {}

    property bool       isSelected: scene?.selectionModel?.isSelected(link?._qsUuid) ?? false

    property vector2d   inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d   outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d   linkMidPoint: Qt.vector2d(0, 0)

    //! outPut port side
    property int        outputPortSide: link.outputPort?.portSide ?? -1

    //! Link color
    property string     linkColor: Object.keys(sceneSession.linkColorOverrideMap).includes(link?._qsUuid ?? "") ? sceneSession.linkColorOverrideMap[link._qsUuid] : link.guiConfig.color

    //! Canvas Dimensions
    property real topLeftX: Math.min(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real topLeftY: Math.min(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    property real bottomRightX: Math.max(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real bottomRightY: Math.max(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    //! update painted line when change position of input and output ports
    onOutputPosChanged: canvas.requestPaint();
    onInputPosChanged:  canvas.requestPaint();
    onIsSelectedChanged: canvas.requestPaint();
    onLinkColorChanged: canvas.requestPaint();


    /*  Object Properties
    * ****************************************************************************************/
    antialiasing: true


    width:  Math.abs(topLeftX - bottomRightX) + 40;
    height: Math.abs(topLeftY - bottomRightY) + 40;
    onWidthChanged: console.log("width = ", width)
    x: topLeftX - 20
    y: topLeftY - 20

    Rectangle {
        color: "transparent"
        border.color: "red"

        anchors.fill: parent
    }

    //! paint line
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        // if null ports then return the function
        if (inputPort === null) {
            context.reset();
            return;
        }

        // Calculate the control points with BasicLinkCalculator
        link.controlPoints = BasicLinkCalculator.calculateControlPoints(inputPos, outputPos, link.direction,
                                                                        link.guiConfig.type, link.inputPort.portSide,
                                                                        outputPortSide, sceneSession.zoomManager.zoomFactor)
        // Calculate position of link setting dialog.
        // Finding the middle point of the link
        // Currently we suppose that the line is a bezzier curve
        // since with the LType it's not possible to find the middle point easily
        // the design needs to be revised
        var zoomFactor = sceneSession.zoomManager.zoomFactor
        var minPoint1 = inputPos.plus(BasicLinkCalculator.connectionMargin(inputPort?.portSide ?? -1, zoomFactor));
        var minPoint2 = outputPos.plus(BasicLinkCalculator.connectionMargin(outputPort?.portSide ?? -1, zoomFactor));
        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, minPoint1, minPoint2, outputPos]);

        var lineWidth = 2 * zoomFactor;
        var arrowHeadLength = 10 * zoomFactor;

        // Draw the curve with LinkPainter
        LinkPainter.createLink(context, inputPos, link.controlPoints, isSelected,
                                linkColor, link.direction,
                                link.guiConfig.style, link.guiConfig.type, lineWidth, arrowHeadLength,
                                link.inputPort.portSide, outputPortSide);
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

  // requestPaint when style AND/OR type of link changed.
  Connections {
      target: link.guiConfig

      function onStyleChanged() {
          canvas.requestPaint();
      }

      function onTypeChanged() {
          canvas.requestPaint();
      }
  }
}
