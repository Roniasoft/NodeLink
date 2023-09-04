import QtQuick
import QtQuick.Controls

import NodeLink

import "Logics/BasicLinkCalculator.js" as BasicLinkCalculator
import "Logics/LinkPainter.js" as LinkPainter
import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 *  Link view for overview
 * ************************************************************************************************/

I_LinkView {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/

    //! Top Left position of node rect (pos of the node in the top left corner)
    property vector2d     nodeRectTopLeft:   extraProperties.linkRectTopLeft

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         customScaleFactor: extraProperties.customScaleFactor

    property var mapControlPoints: []

    /*  Object Properties
    * ****************************************************************************************/

    // Height and width of canvas, (arrowHeadLength * 2) is the margin
    width:  (Math.abs(topLeftX - bottomRightX) + arrowHeadLength * 2) * customScaleFactor / zoomFactor
    height: (Math.abs(topLeftY - bottomRightY) + arrowHeadLength * 2) * customScaleFactor / zoomFactor

    // Position of canvas, arrowHeadLength is the margin
    x: ((topLeftX - arrowHeadLength) - nodeRectTopLeft.x) * customScaleFactor / zoomFactor
    y: ((topLeftY - arrowHeadLength) - nodeRectTopLeft.y) * customScaleFactor / zoomFactor

    arrowHeadLength: 10 * customScaleFactor;

    //! paint Link
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        if (!inputPort) {
            context.reset();
            return;
        }

        // Top left position vector
        var topLeftPosition = Qt.vector2d(canvas.x, canvas.y);
        var minPoint1 = inputPos.plus(BasicLinkCalculator.connectionMargin(inputPort?.portSide ?? -1));
        var minPoint2 = outputPos.plus(BasicLinkCalculator.connectionMargin(outputPort?.portSide ?? -1));
        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, minPoint1, minPoint2, outputPos]);
        linkMidPoint = linkMidPoint.minus(topLeftPosition);

        var lineWidth = 2 * customScaleFactor;

        var inputPosx = (inputPos.x  - (topLeftX - arrowHeadLength)) * customScaleFactor / zoomFactor
        var inputPosy = (inputPos.y  - (topLeftY - arrowHeadLength)) * customScaleFactor / zoomFactor
        var mapInputPos = Qt.vector2d(inputPosx,inputPosy);

        var controlPoints = [];
        mapControlPoints.forEach(controlPoint => {
                                        var mapControlPointx = (controlPoint.x  - (topLeftX - arrowHeadLength)) * customScaleFactor / zoomFactor
                                        var mapControlPointy = (controlPoint.y  - (topLeftY - arrowHeadLength)) * customScaleFactor / zoomFactor
                                        var mapControlPoint  = Qt.vector2d(mapControlPointx, mapControlPointy)
                                        controlPoints.push(mapControlPoint)
                                    });

        // Draw the curve with LinkPainter
        LinkPainter.createLink(context, mapInputPos, controlPoints, isSelected,
                               linkColor, link.direction,
                               link.guiConfig.style, link.guiConfig.type, lineWidth, arrowHeadLength,
                               link.inputPort.portSide, outputPortSide);
    }

    /* Functions
    * ****************************************************************************************/

    //! Prepare painter and then call painter of canvas.
    function preparePainter() {
        if(inputPort) {
            mapControlPoints = BasicLinkCalculator.calculateControlPoints(inputPos , outputPos, link.direction,
                                                                            link.guiConfig.type, link.inputPort.portSide,
                                                                            outputPortSide, customScaleFactor);
        }
        canvas.requestPaint();
    }
}
