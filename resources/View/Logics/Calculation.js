.pragma library
.import QtQuick 2.0 as QtQuick

function isPositionOnCurve(currentPos, startPos, cp1, cp2, endPos) {
    // Solve equation for x:

    var a = -startPos.x + 3 * cp1.x - 3 * cp2.x + endPos.x;
    var b = 3 * startPos.x - 6 * cp1.x  + 3 * cp2.x;
    var c = -3 * startPos.x + 3 * cp1.x;
    var d = startPos.x - currentPos.x;

    var result = solveCubic(a, b, c , d);
    var isPointOnCurve = false;

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
function b0_t(t) { return Math.pow(1 - t, 3) }
function b1_t(t) { return 3 * t * Math.pow(1 - t, 2)}
function b2_t(t) { return 3 * Math.pow(t, 2) * (1 - t)}
function b3_t(t) { return Math.pow(t, 3)}

function cuberoot(x) {
    var y = Math.pow(Math.abs(x), 1/3);
    return x < 0 ? -y : y;
}

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

