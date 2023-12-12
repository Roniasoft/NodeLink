.pragma library
.import QtQuick 2.0 as QtQuick

// calculate control points based on direction, type and port sides for all Link types.
function calculateControlPoints(startPos, endPos, direction, type,
                                inputPortSide, outputPortSide) {

    // create Link
    switch (type) {
    case 1: { // L Line
        return lLineControlPoints(startPos, endPos, inputPortSide, outputPortSide);
    }
    case 2: { // Straight Line
        return straightLineControlPoints(startPos, endPos, inputPortSide, outputPortSide, direction);
    }
    default: { // Bezier Curve
        return bezierCurveControlPoints(startPos, endPos, inputPortSide, outputPortSide)
    }
    }
}


//! Control points of curve Link
function bezierCurveControlPoints(startPos, endPos, inputPortSide, outputPortSide) {
    // calculate the control points
    var controlPoint1 = startPos.plus(connectionMargin(inputPortSide));
    var controlPoint2 = endPos.plus(connectionMargin(outputPortSide));

    return [startPos, controlPoint1, controlPoint2, endPos];
}

// Control points of L Line Link.
function lLineControlPoints(startPos, endPos, inputType, outputType) {

    var cps = [];

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

    var dy =  endPos.y - startPos.y
    var margin = 20;

    // Add start points as first control point
    cps.push(startPos);

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

    // Add end points as last control point
    cps.push(endPos);

    return cps;
}

// Paint Straight Line
function straightLineControlPoints(startPos, endPos, inputType, outputType, direction) {
    // Add margin if necessary
    var correctedStartPos = startPos.plus(connectionMargin(inputType).times(direction === 2 ? 0.1 : 0));
    var correctedEndPos = endPos.plus(connectionMargin(outputType).times(direction === 0 ? 0 : 0.1));

    var cps = []

    // Add control points
    cps.push(Qt.vector2d(startPos.x, startPos.y));
    cps.push(Qt.vector2d(correctedStartPos.x, correctedStartPos.y));
    cps.push(Qt.vector2d(correctedEndPos.x, correctedEndPos.y));
    cps.push(Qt.vector2d(endPos.x, endPos.y));

    return cps;
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
