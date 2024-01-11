.pragma library
.import QtQuick 2.0 as QtQuick

//! Drawing a Link using give context2D
function createLink(context, startPos, controlPoints,
                     isSelected, color, direction, style, type, lineWidth, arrowHeadLength,
                    inputPortSide, outputPortSide) {

    context.reset();
    context.lineWidth = lineWidth;
    context.beginPath();

    // create Link
    // Prepare a shallow copy of control points
    var controlPointsCopy = controlPoints.slice();
    switch (type) {
    case 1: { // L Line
        paintLStraightLine(context, controlPointsCopy);
        break;
    }
    case 2: { // Straight Line
        paintLStraightLine(context, controlPointsCopy);
        break;
    }
    default: { // Bezier Curve
        paintBezierCurve(context, controlPointsCopy)
        break;
    }
    }

    // glow effect
    context.strokeStyle = color;
    if(isSelected) {
        context.shadowColor = color;
        context.shadowBlur = 10;
    }

    // Applying style to the Link
    var stylePattern = [];
    switch (style) {
    case 1: { // ِDash
        stylePattern = [5, 2];
        break;
    }
    case 2: { // Dot
        stylePattern = [1, 2];
        break;
    }
    default: // Solid
        break;
    }
    context.setLineDash(stylePattern);

    // stroke the curve
    context.stroke();
    context.restore();

    // Paint Link direction
    var startPosCP = controlPoints[0];
    switch (direction) {
    case 1: { // Unidirectional
        arrow(context, controlPoints[(startPosCP === startPos) ? controlPoints.length - 1 : 0], outputPortSide, color, arrowHeadLength);
        arrows(context, controlPoints, color, arrowHeadLength, startPos, type)
        break;
    }

    case 2: { // Unidirectional
        arrow(context, controlPoints[(startPosCP === startPos) ? controlPoints.length - 1 : 0], outputPortSide, color, arrowHeadLength);
        arrow(context, controlPoints[(startPosCP === startPos) ? 0 : controlPoints.length - 1 ], inputPortSide, color, arrowHeadLength);
        break;
    }

    default: // Nondirectional
        break;
    }
}

//! Prepare variables to draw between line arrows
function arrows(context, controlPoints, color, headLength, startPos, type) {
    if (controlPoints.length === 0)
        return;

    var reverseDirection = (startPos === controlPoints[0]);
    var margin = 10 + headLength;

    // Draw Arrow for bezier curve
    if (type === 0) {
        if (controlPoints.length < 4)
            return;

        margin = 100;

        //! Calculating middle point and angle properties
        var targetPoint = calculateMiddlePointForBrezier(controlPoints[0], controlPoints[3], controlPoints[1], controlPoints[2])
        var angleProperties = calculateMiddleAngleForBrezier(controlPoints[0], controlPoints[3], controlPoints[1], controlPoints[2])

        if (Math.abs(angleProperties.dx) > margin || Math.abs(angleProperties.dy) > margin)
          drawArrow(context, targetPoint, angleProperties.angle, color, headLength);

        return;
    }

    // Draw Arrows for line and L line.
    controlPoints.forEach((cp, index) => {
                              if (controlPoints.length <= index + 1)
                                return;

                              var endPos = controlPoints[index + 1]
                              var startPosCp = cp;

                              if (reverseDirection)
                                [endPos, startPosCp] = [startPosCp, endPos];

                              var targetPoint = findMidPoint(startPosCp, endPos);

                              var dx = startPosCp.x - endPos.x;
                              var dy = startPosCp.y - endPos.y;

                              // Calculate angle using atan2 function
                              var angle = Math.atan2(dy, dx);

                              if (Math.abs(dx) > margin || Math.abs(dy) > margin )
                                drawArrow(context, targetPoint, angle, color, headLength)
                          });
}

//! Prepare variables to draw arrow at the start and end point
function arrow(context, targetPoint, portSide, color, arrowHeadLength) {
    const dx = arrowAngle(portSide).x;
    const dy = arrowAngle(portSide).y;

    // Calculate Arrow angle
    const angle = Math.atan2(dy, dx);

    drawArrow(context, targetPoint, angle, color, arrowHeadLength);
}

//! Code to draw a simple arrow on TypeScript canvas got from https://stackoverflow.com/a/64756256/867349
function drawArrow(context, targetPoint, angle, color, headlen) {
    //Paint arrow
    context.beginPath();
    context.moveTo(targetPoint.x - headlen * Math.cos(angle - Math.PI / 6), targetPoint.y - headlen * Math.sin(angle - Math.PI / 6));
    context.lineTo(targetPoint.x, targetPoint.y);
    context.lineTo(targetPoint.x - headlen * Math.cos(angle + Math.PI / 6), targetPoint.y - headlen * Math.sin(angle + Math.PI / 6));
    context.lineTo(targetPoint.x - headlen * Math.cos(angle - Math.PI / 6), targetPoint.y - headlen * Math.sin(angle - Math.PI / 6));

    // Update arrow style
    context.setLineDash([]);

    //Fill arrow shape
    context.fillStyle = color;
    context.fill();

    // stroke the curve
    context.stroke();
}

//! Locate the midpoint between startPos and endPos.
function findMidPoint(startPos, endPos) {
    var midX = (startPos.x + endPos.x) / 2;
    var midY = (startPos.y + endPos.y) / 2;

    return Qt.vector2d(midX, midY);
}

//! Calculate the angle formed by two points.
function calculateAngle(startPos, endPos) {
    var dx = startPos.x - endPos.x;
    var dy = startPos.y - endPos.y;

    // Calculate angle using atan2 function
    var angle = Math.atan2(dy, dx) ;

    return angle;
}

//! Caclualtes the middle point of the bezier curve (bezier curve formula)
function calculateMiddlePointForBrezier (startPos, endPos, cp1, cp2) {
    //! Parameter for the middle point
    var t = 0.5;

    var middleX = startPos.x * Math.pow(1 - t, 3) + 3 * cp1.x * Math.pow(1 - t, 2) * t + 3 * cp2.x * (1 - t) * Math.pow(t, 2) + endPos.x * Math.pow(t, 3);
    var middleY = startPos.y * Math.pow(1 - t, 3) + 3 * cp1.y * Math.pow(1 - t, 2) * t + 3 * cp2.y * (1 - t) * Math.pow(t, 2) + endPos.y * Math.pow(t, 3);

    var middlePosition = Qt.vector2d(middleX, middleY)

    return middlePosition;
}

//! Calculating the middle point angle, using bezier formula derivative
function calculateMiddleAngleForBrezier (startPos, endPos, cp1, cp2) {
    //! Parameter for the middle point
    var t = 0.5;

    var dx = -3 * startPos.x * Math.pow(1 - t, 2) + 3 * cp1.x * (Math.pow(1 - t, 2) - 2 * t * (1 - t)) + 3 * cp2.x * (2 * t * (1 - t) - Math.pow(t, 2)) + 3 * endPos.x * Math.pow(t, 2);
    var dy = -3 * startPos.y * Math.pow(1 - t, 2) + 3 * cp1.y * (Math.pow(1 - t, 2) - 2 * t * (1 - t)) + 3 * cp2.y * (2 * t * (1 - t) - Math.pow(t, 2)) + 3 * endPos.y * Math.pow(t, 2);

    // Calculate the angle in radians
    var middleAngle = Math.atan2(dy, dx);

    return {
        angle: middleAngle,
        dx: dx,
        dy: dy
    }
}

//! Paint curve line
function paintBezierCurve(context, controlPoints) {

    var startPos = controlPoints.shift();
    var endPos   = controlPoints.pop()

    var cp1 = controlPoints[0];
    var cp2 = controlPoints[1];

    //start position
    context.moveTo(startPos.x, startPos.y);
    context.bezierCurveTo(cp1.x, cp1.y, cp2.x , cp2.y, endPos.x, endPos.y);
}

// Paint L and Straight Line.
function paintLStraightLine(context, controlPoints) {

    var startPos = controlPoints.shift();
    var endPos   = controlPoints.pop()

    // start position
    context.moveTo(startPos.x, startPos.y);

    controlPoints.forEach(cp => {
                    context.lineTo(cp.x, cp.y);
                });

    context.lineTo(endPos.x, endPos.y);
}

//! Arrow angle with port side.
function arrowAngle (portSide) {

    switch (portSide) {
    case 0: // \todo: use NLSpec some how here
        return Qt.vector2d(0, +1);

    case 1:
        return Qt.vector2d(0, -1);

    case 2:
        return Qt.vector2d(+1, 0);

    case 3:
        return Qt.vector2d(-1, 0);

    default:
        return Qt.vector2d(0, 0);
    }
}
