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
    property vector2d     nodeRectTopLeft:     viewProperties?.nodeRectTopLeft ?? Qt.vector2d(0, 0)

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         overviewScaleFactor: viewProperties?.overviewScaleFactor ?? 1.0

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
        // Check if canvas is available and has valid dimensions
        if (!canvas || !canvas.available || width <= 0 || height <= 0) {
            return;
        }
        
        // Check if positions are valid (not off-screen or behind camera)
        // Positions with x < -1000 or y < -1000 are considered off-screen
        if (!inputPos || !outputPos || 
            inputPos.x < -1000 || inputPos.y < -1000 || 
            outputPos.x < -1000 || outputPos.y < -1000) {
            return;
        }

        // create the context
        var context = canvas.getContext("2d");
        
        // Check if context is valid
        if (!context) {
            return;
        }
        
        // Helper function to check if context is active
        function isContextActive(ctx) {
            if (!ctx) return false;
            try {
                // Try to access a property that requires active context
                var test = ctx.canvas;
                return true;
            } catch (e) {
                return false;
            }
        }
        
        // Final check before any operations
        if (!isContextActive(context)) {
            return;
        }

        if (!inputPort || inputPos.x < 0 || outputPos.x < 0) {
            try {
                if (isContextActive(context)) {
                    context.reset();
                }
            } catch (e) {
                // Context not active, ignore
            }
            return;
        }
        
        // Check if controlPoints are valid
        if (!link || !link.controlPoints || link.controlPoints.length === 0) {
            try {
                if (isContextActive(context)) {
                    context.reset();
                }
            } catch (e) {
                // Context not active, ignore
            }
            return;
        }
        
        // Final check before painting
        if (!isContextActive(context)) {
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
