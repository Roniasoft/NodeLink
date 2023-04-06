.pragma library
.import QtQuick 2.0 as QtQuick

//! Drawing a bezier curve using give context2D
function bezierCurve(context, startPos, cp1, cp2, endPos, isSelected) {

    context.reset();
    context.lineWidth = 2;
    context.beginPath();

    // our start position
    context.moveTo(startPos.x, startPos.y);

    // random bezier curve, which ends on last X, last Y
    context.bezierCurveTo(cp1.x, cp1.y, cp2.x , cp2.y, endPos.x, endPos.y);

    // glow effect
    context.strokeStyle = 'hsl(' + 10 + ', 50%, 255%)';
    if(isSelected) {
        context.shadowColor = 'white';
        context.shadowBlur = 10;
    }
    // stroke the curve
    context.stroke();
    context.restore();
}

//! Connection Margin
function connectionMargin (inputPort) {

    if(inputPort === null)
        return Qt.vector2d(0,0);

    switch (inputPort.portSide) {
    case 0: // \todo: use NLSpec some how here
        return Qt.vector2d(0, -100);

    case 1:
        return Qt.vector2d(0, +100);

    case 2:
        return Qt.vector2d(-100, 0);

    case 3:
        return Qt.vector2d(+100, 0);
    }
}
