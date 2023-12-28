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
    property vector2d     nodeRectTopLeft:     viewProperties.nodeRectTopLeft

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         overviewScaleFactor: viewProperties.overviewScaleFactor

    /*  Object Properties
    * ****************************************************************************************/

    // Height and width of canvas, (arrowHeadLength * 2) is the margin
    width: (Math.abs(topLeftX - bottomRightX) + arrowHeadLength * 2) * overviewScaleFactor
    height: (Math.abs(topLeftY - bottomRightY) + arrowHeadLength * 2) * overviewScaleFactor

    // Position of canvas, arrowHeadLength is the margin
    x: ((topLeftX - arrowHeadLength) - nodeRectTopLeft.x) * overviewScaleFactor
    y: ((topLeftY - arrowHeadLength) - nodeRectTopLeft.y) * overviewScaleFactor

    arrowHeadLength: 10 * overviewScaleFactor;

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

        var lineWidth = 2 * overviewScaleFactor;

        var inputPosx = (inputPos.x  - (topLeftX - arrowHeadLength)) * overviewScaleFactor;
        var inputPosy = (inputPos.y  - (topLeftY - arrowHeadLength)) * overviewScaleFactor;
        var mapInputPos = Qt.vector2d(inputPosx,inputPosy);

        var mapControlPoints = [];
        link.controlPoints.forEach(controlPoint => {
                                        var mapControlPointx = (controlPoint.x  - (topLeftX - arrowHeadLength)) * overviewScaleFactor
                                        var mapControlPointy = (controlPoint.y  - (topLeftY - arrowHeadLength)) * overviewScaleFactor
                                        var mapControlPoint  = Qt.vector2d(mapControlPointx, mapControlPointy)
                                        mapControlPoints.push(mapControlPoint)
                                    });

        // Draw the curve with LinkPainter
        LinkPainter.createLink(context, mapInputPos, mapControlPoints, isSelected,
                               linkColor, link.direction,
                               link.guiConfig.style, link.guiConfig.type, lineWidth, arrowHeadLength,
                               link.inputPort.portSide, outputPortSide);
    }
}
