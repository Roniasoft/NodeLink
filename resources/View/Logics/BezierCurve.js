.pragma library
.import QtQuick 2.0 as QtQuick

//! Drawing a bezier curve using give context2D
function createLink(context, startPos, cp1, cp2, endPos,
                     isSelected, color, direction, style, type,
                    inputPortSide, outputPortSide) {

    context.reset();
    context.lineWidth = 2;
    context.beginPath();

    // create Link
    switch (type) {
    case 1: { // L Line
        paintLLine(context, startPos, endPos, inputPortSide, outputPortSide);
        break;
    }
    case 2: { // Straight Line
        paintStraightLine(context, startPos, endPos, inputPortSide, outputPortSide, direction);
        break;
    }
    default: { // Bezier Curve
        paintBezierCurve(context, startPos, cp1, cp2, endPos)
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

    // Update arrow style
    context.setLineDash([]);

    //Fill arrow shape
    context.fillStyle = color;
    context.fill();

    // stroke the curve
    context.stroke();
}

//! Paint curve line
function paintBezierCurve(context, startPos, cp1, cp2, endPos) {
    //start position
    context.moveTo(startPos.x, startPos.y);
    context.bezierCurveTo(cp1.x, cp1.y, cp2.x , cp2.y, endPos.x, endPos.y);
}

// Paint L Line.
function paintLLine(context, startPos, endPos, inputType, outputType) {

    var cps = [];
    var cpCal1;
    var cpCal2;
    var dx =  endPos.x - startPos.x

    if (dx < 0){
        var tempEndPos = endPos;
        var tempInputType = inputType;

        inputType = outputType;
        outputType = tempInputType;

        endPos = startPos;
        startPos = tempEndPos;

        dx =  endPos.x - startPos.x
    }

    // start position
    context.moveTo(startPos.x, startPos.y);

    var dy =  endPos.y - startPos.y
    var margin = 20;

    // Paint Line based on dx, dy, and port sides.
    if(dx >= 0) {
        var delta = dx === 0 ? margin : dx;
        if (dy <= 0) {
            switch (inputType) {
            case 0: { // Top
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x, endPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y - margin));
                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, startPos.y - margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x, endPos.y));

                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(startPos.x, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }

            case 1: { // Bottom
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x, startPos.y + margin));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, startPos.y + margin));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, endPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y - margin));
                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x, startPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x , startPos.y + margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x, startPos.y + margin));
                    cps.push(Qt.vector2d(startPos.x + margin, startPos.y + margin));
                    cps.push(Qt.vector2d(startPos.x + margin, endPos.y));
                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(startPos.x, startPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }

            case 2: { // Left
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, endPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y - margin));
                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y  + margin));
                    cps.push(Qt.vector2d(endPos.x, startPos.y  + margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, endPos.y));
                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y  + margin));
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y  + margin));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }

            case 3: { // Right
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x + margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x + margin, endPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y - margin));
                    break;
                }

                case 1: {
                    cps.push(Qt.vector2d(endPos.x ,startPos.y));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x + delta / 2, startPos.y));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, endPos.y));
                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }
            }
        } else if (dy > 0) {
            switch (inputType) {
            case 0: { // Top
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, startPos.y - margin));
                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x, startPos.y - margin));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, startPos.y - margin));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, endPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y + margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x, startPos.y - margin));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, startPos.y - margin));
                    cps.push(Qt.vector2d(startPos.x + delta / 2, endPos.y));

                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(startPos.x, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }

            case 1: { // Bottom
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x, startPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x, startPos.y + margin));
                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x, endPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x , endPos.y + margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x, endPos.y));
                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(startPos.x, startPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }

            case 2: { // Left
                switch (outputType) {
                case 0: { // Top
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, endPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y - margin));
                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, endPos.y  + margin));
                    cps.push(Qt.vector2d(endPos.x, endPos.y  + margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, endPos.y));
                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x - margin, startPos.y + dy / 2));
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y  + dy / 2));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }

            case 3: { // Right
                switch (outputType) {
                case 0: { // Top

                    if(dy < 10) {
                    cps.push(Qt.vector2d(startPos.x + margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x + margin, startPos.y - margin));
                    cps.push(Qt.vector2d(endPos.x, startPos.y - margin));
                    } else {
                        cps.push(Qt.vector2d(endPos.x, startPos.y));
                    }

                    break;
                }

                case 1: { // Bottom
                    cps.push(Qt.vector2d(startPos.x + margin, startPos.y));
                    cps.push(Qt.vector2d(startPos.x + margin, endPos.y + margin));
                    cps.push(Qt.vector2d(endPos.x , endPos.y + margin));
                    break;
                }

                case 2: { // Left
                    cps.push(Qt.vector2d(startPos.x + dx / 2, startPos.y));
                    cps.push(Qt.vector2d(startPos.x + dx / 2, endPos.y));
                    break;
                }

                case 3: { // Right
                    cps.push(Qt.vector2d(endPos.x + margin, startPos.y));
                    cps.push(Qt.vector2d(endPos.x + margin, endPos.y));
                    break;
                }
                }
                break;
            }
            }
        }
    }

    cps.forEach(cp => {
                    context.lineTo(cp.x, cp.y);
                });

    context.lineTo(endPos.x, endPos.y);
}

// Paint Straight Line
function paintStraightLine(context, startPos, endPos, inputType, outputType, direction) {
    // Start position
    context.moveTo(startPos.x, startPos.y);

    // Add margin if necessary
    var correctedStartPos = startPos.plus(connectionMargin(inputType).times(direction === 2 ? 0.1 : 0));
    var correctedEndPos = endPos.plus(connectionMargin(outputType).times(direction === 0 ? 0 : 0.1));

    // Paint Line
    context.lineTo(correctedStartPos.x, correctedStartPos.y);
    context.lineTo(correctedEndPos.x, correctedEndPos.y);
    context.lineTo(endPos.x, endPos.y);
}

//! Connection Margin with port side.
function connectionMargin (portSide) {

    switch (portSide) {
    case 0: // \todo: use NLSpec some how here
        return Qt.vector2d(0, -100);

    case 1:
        return Qt.vector2d(0, +100);

    case 2:
        return Qt.vector2d(-100, 0);

    case 3:
        return Qt.vector2d(+100, 0);

    default:
        return Qt.vector2d(0, 0);
    }
}
