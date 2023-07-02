.pragma library
.import QtQuick 2.0 as QtQuick

//! Drawing a Link using give context2D
function createLink(context, startPos, controlPoints,
                     isSelected, color, direction, style, type, lineWidth,
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
        arrow(context, controlPoints[(startPosCP === startPos) ? controlPoints.length - 1 : 0], outputPortSide, color);
        break;
    }

    case 2: { // Unidirectional
        arrow(context, controlPoints[(startPosCP === startPos) ? controlPoints.length - 1 : 0], outputPortSide, color);
        arrow(context, controlPoints[(startPosCP === startPos) ? 0 : controlPoints.length - 1 ], inputPortSide, color);
        break;
    }

    default: // Nondirectional
        break;
    }
}

// Code to draw a simple arrow on TypeScript canvas got from https://stackoverflow.com/a/64756256/867349
function arrow(context, targetPoint, portSide, color) {
    const dx = arrowAngle(portSide).x;
    const dy = arrowAngle(portSide).y;

    const headlen = 10; // length of head in pixels
    // Calculate Arrow angle
    const angle = Math.atan2(dy, dx);

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
