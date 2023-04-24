.pragma library
.import QtQuick 2.0 as QtQuick

// This function takes the point (x,y) to test, a tolerance value,
// and an array of control points that define the Bezier curve, LLine and straight line.
// It evaluates the curve at 100 evenly-spaced values of t between 0 and 1,
// calculates the distance between each point on the curve and the test point,
// and returns true if any of the distances are less than the tolerance.
function isPointOnLink(x, y, tolerance, points, type) {

    // Margin to find point on Line
    var margin = tolerance * 2;
    switch (type) {
    case 1: { // L Line
        for (var t = 1; t < points.length; t++) {
            if(isPositionOnLine(x, y, points[t-1], points[t], margin))
                return true;
        }

        break;
    }
    case 2: { // Straight Line
            if(isPositionOnStraightLine(x, y, points, tolerance))
                return true;

        break;
    }
    default: { // Bezier Curve
        for (var t = 0; t <= 1; t += 0.02) {
            var curvePos = getPositionByTolerance(t, points);
            var distance = Math.sqrt(Math.pow(curvePos.x - x, 2) + Math.pow(curvePos.y - y, 2));
            if (distance < tolerance) {
                return true;
            }
        }
        break;
    }
    }

    return false;
}

function isPositionOnCurve(currentPos, startPos, cp1, cp2, endPos) {
    // Solve equation for x:

    var a = -startPos.x + 3 * cp1.x - 3 * cp2.x + endPos.x;
    var b = 3 * startPos.x - 6 * cp1.x  + 3 * cp2.x;
    var c = -3 * startPos.x + 3 * cp1.x;
    var d = startPos.x - currentPos.x;

    // calculate t value
    var result = solveCubic(a, b, c , d);
    var isPointOnCurve = false;

    // validate y value with the value of t obtained
    result.forEach(res => {
                       if(res >= 0.0 && res <= 1.0) {
                           var y = b0_t(res) * startPos.y +
                           b1_t(res) * cp1.y +
                           b2_t(res) * cp2.y +
                           b3_t(res) * endPos.y;
                           if(y <= currentPos.y + 5 && y >= currentPos.y - 5) {
                               isPointOnCurve = true;
                           }
                       }
                   });

    return isPointOnCurve;
}

//! calculate bezier parameters.
// 0.0 <= t <= 1.0
// https://stackoverflow.com/questions/15397596/find-all-the-points-of-a-cubic-bezier-curve-in-javascript/15399173#15399173
function b0_t(t) { return Math.pow(1 - t, 3) }
function b1_t(t) { return 3 * t * Math.pow(1 - t, 2)}
function b2_t(t) { return 3 * Math.pow(t, 2) * (1 - t)}
function b3_t(t) { return Math.pow(t, 3)}

function cuberoot(x) {
    var y = Math.pow(Math.abs(x), 1/3);
    return x < 0 ? -y : y;
}

//! Solve Cubic eqation
//  at^3+bt^2+ct+d = 0
//  a: The coeficient of x to the power of three (at^3).
//  b: the coeficent of x to the power of two (bt^2).
//  c: the coeficent of x to the power of one (ct).
//  d: the coeficent of x to the power of zero (d).
// https://stackoverflow.com/questions/27176423/function-to-solve-cubic-equation-analytically/27176424#27176424
function solveCubic(a, b, c, d) {
    if (Math.abs(a) < 1e-8) { // Quadratic case, ax^2+bx+c=0
        a = b; b = c; c = d;
        if (Math.abs(a) < 1e-8) { // Linear case, ax+b=0
            a = b; b = c;
            if (Math.abs(a) < 1e-8) // Degenerate case
                return [];
            return [-b/a];
        }

        var D = b*b - 4*a*c;
        if (Math.abs(D) < 1e-8)
            return [-b/(2*a)];
        else if (D > 0)
            return [(-b+Math.sqrt(D))/(2*a), (-b-Math.sqrt(D))/(2*a)];
        return [];
    }

    // Convert to depressed cubic t^3+pt+q = 0 (subst x = t - b/3a)
    var p = (3*a*c - b*b)/(3*a*a);
    var q = (2*b*b*b - 9*a*b*c + 27*a*a*d)/(27*a*a*a);
    var roots;

    if (Math.abs(p) < 1e-8) { // p = 0 -> t^3 = -q -> t = -q^1/3
        roots = [cuberoot(-q)];
    } else if (Math.abs(q) < 1e-8) { // q = 0 -> t^3 + pt = 0 -> t(t^2+p)=0
        roots = [0].concat(p < 0 ? [Math.sqrt(-p), -Math.sqrt(-p)] : []);
    } else {
        var D = q*q/4 + p*p*p/27;
        if (Math.abs(D) < 1e-8) {       // D = 0 -> two roots
            roots = [-1.5*q/p, 3*q/p];
        } else if (D > 0) {             // Only one real root
            var u = cuberoot(-q/2 - Math.sqrt(D));
            roots = [u - p/(3*u)];
        } else {                        // D < 0, three roots, but needs to use complex numbers/trigonometric solution
            var u = 2*Math.sqrt(-p/3);
            var t = Math.acos(3*q/p/u)/3;  // D < 0 implies p < 0 and acos argument in [-1..1]
            var k = 2*Math.PI/3;
            roots = [u*Math.cos(t), u*Math.cos(t-k), u*Math.cos(t-2*k)];
        }
    }

    // Convert back from depressed cubic
    for (var i = 0; i < roots.length; i++)
        roots[i] -= b/(3*a);

    return roots;
}

//! calcuate position of point with t and control points
function getPositionByTolerance(t, points) {
    var curveX = Math.pow(1-t, 3)*points[0].x + 3*Math.pow(1-t, 2)*t*points[1].x + 3*(1-t)*Math.pow(t, 2)*points[2].x + Math.pow(t, 3)*points[3].x;
    var curveY = Math.pow(1-t, 3)*points[0].y + 3*Math.pow(1-t, 2)*t*points[1].y + 3*(1-t)*Math.pow(t, 2)*points[2].y + Math.pow(t, 3)*points[3].y;

    return Qt.vector2d(curveX, curveY);
}

// Find point on L line.
function isPositionOnLine(x, y, firstPoint, secondPoint, margin) {
    if((x >= firstPoint.x - margin && x <= secondPoint.x   + margin ) ||
            (x <= firstPoint.x + margin &&  x >= secondPoint.x - margin)) {
        if((y >= firstPoint.y - margin &&  y <= secondPoint.y   + margin) ||
                (y <= firstPoint.y + margin &&  y >= secondPoint.y - margin)) {
            return true;
        }
    }

    return false;
}


// Find point on Straight line.
function isPositionOnStraightLine(x, y, points, margin) {
    // First vertical or horizontal section
    if(points[0] !== points[1])
        if(isPositionOnLine(x, y, points[0], points[1], margin))
            return true;

    // Second vertical or horizontal section
    if(points[2] !== points[3])
        if(isPositionOnLine(x, y, points[2], points[3], margin))
            return true;

        var firstPoint = points[1];
        var secondPoint = points[2]
        var dx = secondPoint.x - firstPoint.x;
        var dy = secondPoint.y - firstPoint.y

        if(Math.abs(dx) >= 10 && Math.abs(dy) >= 10 && Math.abs(dy / dx) >= 0.05) {
            var slope = dy / dx;
            var yInLine = slope * (x - secondPoint.x) + secondPoint.y;
            var xInLine = (y - secondPoint.y + slope * secondPoint.x) / slope;

            if (Math.abs(x - xInLine) <= margin)
                if (Math.abs(y - yInLine) <= margin)
                    return true;

        } else if (dx === 0 || Math.abs(dy / dx) < 0.05 || Math.abs(dy) < 10) { // Horizontal or near horizontal line
            if(isPositionOnLine(x, y, firstPoint, secondPoint, margin))
                return true;

        } else { // Vertical or near vertical line
            if(isPositionOnLine(x, y, firstPoint, secondPoint, margin))
                return true;
        }

        return false;
}

