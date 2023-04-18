.pragma library
.import QtQuick 2.0 as QtQuick

//! Drawing a bezier curve using give context2D
function bezierCurve(context, startPos, cp1, cp2, endPos, isSelected, color, direction) {

    context.reset();
    context.lineWidth = 2;
    context.beginPath();

    // our start position
    context.moveTo(startPos.x, startPos.y);

    // random bezier curve, which ends on last X, last Y
    context.bezierCurveTo(cp1.x, cp1.y, cp2.x , cp2.y, endPos.x, endPos.y);

    // glow effect
    context.strokeStyle = color;
    if(isSelected) {
        context.shadowColor = color;
        context.shadowBlur = 10;
    }
    // stroke the curve
    context.stroke();
    context.restore();

    // Paint Link direction
    switch (direction) {
    case 1: { // Unidirectional
        arrow(context, cp2, endPos, color);
        break;
    }

    case 2: { // Unidirectional
        arrow(context, cp2, endPos, color);
        arrow(context, cp1, startPos, color);
        break;
    }

    default: // Nondirectional
        break;
    }
}

// Code to draw a simple arrow on TypeScript canvas got from https://stackoverflow.com/a/64756256/867349
function arrow(context, from, to, color) {
    const dx = to.x - from.x;
    const dy = to.y - from.y;

    const headlen = Math.sqrt(dx * dx + dy * dy) * 0.1; // length of head in pixels
    const angle = Math.atan2(dy, dx);

    //Paint arrow
    context.beginPath();
    context.moveTo(to.x - headlen * Math.cos(angle - Math.PI / 6), to.y - headlen * Math.sin(angle - Math.PI / 6));
    context.lineTo(to.x, to.y);
    context.lineTo(to.x - headlen * Math.cos(angle + Math.PI / 6), to.y - headlen * Math.sin(angle + Math.PI / 6));
    context.lineTo(to.x - headlen * Math.cos(angle - Math.PI / 6), to.y - headlen * Math.sin(angle - Math.PI / 6));

    //Fill arrow shape
    context.fillStyle = color;
    context.fill();

    // stroke the curve
    context.stroke();
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
