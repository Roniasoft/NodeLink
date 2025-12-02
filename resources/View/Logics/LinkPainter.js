.pragma library
.import QtQuick 2.0 as QtQuick

//! Check if context is active and ready for painting
function isContextActive(context) {
    if (!context) {
        return false;
    }
    
    try {
        // Try to access a property that requires active context
        // If context is not active, this will throw an error
        var test = context.canvas;
        return true;
    } catch (e) {
        return false;
    }
}

//! Drawing a Link using give context2D
function createLink(context, startPos, controlPoints,
                     isSelected, color, direction, style, type, lineWidth, arrowHeadLength,
                    inputPortSide, outputPortSide) {

    // Check if context is valid and active
    if (!isContextActive(context)) {
        return;
    }

    // Validate input parameters
    if (!startPos || !controlPoints || controlPoints.length === 0) {
        return;
    }

    try {
        // Reset context state - this must be called first
        // Check if context is still active before reset
        if (!isContextActive(context)) {
            return;
        }
        
        try {
            context.reset();
        } catch (e) {
            // Context not active, abort
            return;
        }
        
        // Check again before save
        if (!isContextActive(context)) {
            return;
        }
        
        try {
            context.save(); // Save state before making changes
        } catch (e) {
            // Context not active, abort
            return;
        }
        
        // Check context before each operation
        if (!isContextActive(context)) {
            return;
        }
        
        try {
            context.lineWidth = lineWidth;
        } catch (e) {
            // Context not active, abort
            return;
        }
        
        if (!isContextActive(context)) {
            return;
        }
        
        try {
            context.beginPath();
        } catch (e) {
            // Context not active, abort
            return;
        }

        // create Link
        // Prepare a shallow copy of control points
        var controlPointsCopy = controlPoints.slice();
        switch (type) {
        case 1: { // L Line
            if (isContextActive(context)) {
                paintLStraightLine(context, controlPointsCopy);
            }
            break;
        }
        case 2: { // Straight Line
            if (isContextActive(context)) {
                paintLStraightLine(context, controlPointsCopy);
            }
            break;
        }
        default: { // Bezier Curve
            if (isContextActive(context)) {
                paintBezierCurve(context, controlPointsCopy)
            }
            break;
        }
        }

        // Check context before setting styles
        if (!isContextActive(context)) {
            return;
        }
        
        try {
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
            
            if (!isContextActive(context)) {
                return;
            }
            context.setLineDash(stylePattern);

            // stroke the curve
            if (!isContextActive(context)) {
                return;
            }
            context.stroke();
        } catch (e) {
            // Context not active during style/stroke, try to restore and abort
            try {
                if (isContextActive(context)) {
                    context.restore();
                }
            } catch (e2) {
                // Ignore restore errors
            }
            return;
        }
        
        // Restore state after drawing
        if (!isContextActive(context)) {
            return;
        }
        
        try {
            context.restore(); // Restore state after drawing
        } catch (e) {
            // Context not active, ignore restore
        }
    } catch (e) {
        // Error during painting, try to restore context if possible
        try {
            context.restore();
        } catch (e2) {
            // Ignore restore errors
        }
        return;
    }

    try {
        // Check context before painting arrows
        if (!isContextActive(context)) {
            return;
        }
        
        // Paint Link direction
        var startPosCP = controlPoints[0];
        switch (direction) {
        case 1: { // Unidirectional
            if (isContextActive(context)) {
                arrow(context, controlPoints[(startPosCP === startPos) ? controlPoints.length - 1 : 0], outputPortSide, color, arrowHeadLength);
            }
            if (isContextActive(context)) {
                arrows(context, controlPoints, color, arrowHeadLength, startPos, type)
            }
            break;
        }

        case 2: { // Bidirectional
            if (isContextActive(context)) {
                arrow(context, controlPoints[(startPosCP === startPos) ? controlPoints.length - 1 : 0], outputPortSide, color, arrowHeadLength);
            }
            if (isContextActive(context)) {
                arrow(context, controlPoints[(startPosCP === startPos) ? 0 : controlPoints.length - 1 ], inputPortSide, color, arrowHeadLength);
            }
            break;
        }

        default: // Nondirectional
            break;
        }
    } catch (e) {
        // Error during arrow painting, skip
        // Don't return here, we've already drawn the main line
    }
}

//! Prepare variables to draw between line arrows
function arrows(context, controlPoints, color, headLength, startPos, type) {
    if (!context || !controlPoints || controlPoints.length === 0) {
        return;
    }

    try {
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

            if (targetPoint && angleProperties && (Math.abs(angleProperties.dx) > margin || Math.abs(angleProperties.dy) > margin))
              drawArrow(context, targetPoint, angleProperties.angle, color, headLength);

            return;
        }

        // Draw Arrows for line and L line.
        controlPoints.forEach((cp, index) => {
                                  if (controlPoints.length <= index + 1)
                                    return;

                                  var endPos = controlPoints[index + 1]
                                  var startPosCp = cp;

                                  if (!endPos || !startPosCp) {
                                      return;
                                  }

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
    } catch (e) {
        // Error during arrows painting, skip
        return;
    }
}

//! Prepare variables to draw arrow at the start and end point
function arrow(context, targetPoint, portSide, color, arrowHeadLength) {
    if (!context || !targetPoint) {
        return;
    }

    try {
        const angleVec = arrowAngle(portSide);
        if (!angleVec) {
            return;
        }

        const dx = angleVec.x;
        const dy = angleVec.y;

        // Calculate Arrow angle
        const angle = Math.atan2(dy, dx);

        drawArrow(context, targetPoint, angle, color, arrowHeadLength);
    } catch (e) {
        // Error during arrow calculation, skip
        return;
    }
}

//! Code to draw a simple arrow on TypeScript canvas got from https://stackoverflow.com/a/64756256/867349
function drawArrow(context, targetPoint, angle, color, headlen) {
    // Check if context is valid and active
    if (!isContextActive(context) || !targetPoint) {
        return;
    }

    try {
        // Check context before painting
        if (!isContextActive(context)) {
            return;
        }
        
        //Paint arrow
        context.beginPath();
        context.moveTo(targetPoint.x - headlen * Math.cos(angle - Math.PI / 6), targetPoint.y - headlen * Math.sin(angle - Math.PI / 6));
        context.lineTo(targetPoint.x, targetPoint.y);
        context.lineTo(targetPoint.x - headlen * Math.cos(angle + Math.PI / 6), targetPoint.y - headlen * Math.sin(angle + Math.PI / 6));
        context.lineTo(targetPoint.x - headlen * Math.cos(angle - Math.PI / 6), targetPoint.y - headlen * Math.sin(angle - Math.PI / 6));

        // Check context before each operation
        if (!isContextActive(context)) {
            return;
        }
        
        // Update arrow style
        context.setLineDash([]);

        //Fill arrow shape
        if (!isContextActive(context)) {
            return;
        }
        context.fillStyle = color;
        context.fill();

        // stroke the curve
        if (!isContextActive(context)) {
            return;
        }
        context.stroke();
    } catch (e) {
        // Error during arrow drawing, skip
        return;
    }
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
    if (!isContextActive(context) || !controlPoints || controlPoints.length < 4) {
        return;
    }

    try {
        if (!isContextActive(context)) {
            return;
        }
        
        var startPos = controlPoints.shift();
        var endPos   = controlPoints.pop()

        var cp1 = controlPoints[0];
        var cp2 = controlPoints[1];

        // Validate positions
        if (!startPos || !endPos || !cp1 || !cp2) {
            return;
        }

        // Check context before each operation
        if (!isContextActive(context)) {
            return;
        }
        
        //start position
        context.moveTo(startPos.x, startPos.y);
        
        if (!isContextActive(context)) {
            return;
        }
        
        context.bezierCurveTo(cp1.x, cp1.y, cp2.x , cp2.y, endPos.x, endPos.y);
    } catch (e) {
        // Error during bezier curve painting, skip
        return;
    }
}

// Paint L and Straight Line.
function paintLStraightLine(context, controlPoints) {
    if (!isContextActive(context) || !controlPoints || controlPoints.length < 2) {
        return;
    }

    try {
        if (!isContextActive(context)) {
            return;
        }
        
        var startPos = controlPoints.shift();
        var endPos   = controlPoints.pop()

        // Validate positions
        if (!startPos || !endPos) {
            return;
        }

        // Check context before each operation
        if (!isContextActive(context)) {
            return;
        }
        
        // start position
        context.moveTo(startPos.x, startPos.y);

        controlPoints.forEach(cp => {
                        if (!isContextActive(context)) {
                            return;
                        }
                        if (cp) {
                            try {
                                context.lineTo(cp.x, cp.y);
                            } catch (e) {
                                // Context not active, skip
                            }
                        }
                    });

        if (!isContextActive(context)) {
            return;
        }
        
        context.lineTo(endPos.x, endPos.y);
    } catch (e) {
        // Error during line painting, skip
        return;
    }
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
