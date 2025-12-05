import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes

import "Logics/BasicLinkCalculator.js" as BasicLinkCalculator
import "Logics/LinkPainter.js" as LinkPainter
import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 *  I_LinkView is an interface classs that shows Links (BezierCurve).
 * ************************************************************************************************/

Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property I_Scene        scene

    property SceneSession   sceneSession

    //! viewProperties encompasses all view properties that are not included
    //! in either the scene or the scene session.
    property QtObject   viewProperties: null

    //! Main LinkView model
    property var        link:       Link {}

    //! Link input port
    property Port       inputPort: link.inputPort

    //! Link output port
    property Port       outputPort: link.outputPort

    //! Link is selected or not
    property bool       isSelected: scene?.selectionModel?.isSelected(link?._qsUuid) ?? false

    //! Link input position
    property vector2d   inputPos: {
        if (inputPort && inputPort._position) {
            return inputPort._position;
        }
        return Qt.vector2d(-1, -1);
    }

    //! Link output position
    property vector2d   outputPos: {
        if (outputPort && outputPort._position) {
            return outputPort._position;
        }
        return Qt.vector2d(-1, -1);
    }

    //! linkMidPoint is the position of link description.
    property vector2d   linkMidPoint: Qt.vector2d(0, 0)

    //! outPut port side
    property int        outputPortSide: link.outputPort?.portSide ?? -1

    //! Link color
    property string     linkColor: Object.keys(sceneSession?.linkColorOverrideMap ?? ({})).includes(link?._qsUuid ?? "") ? sceneSession.linkColorOverrideMap[link._qsUuid] : link.guiConfig.color

    //! Canvas Dimensions
    function safePoints() {
        if (Array.isArray(link.controlPoints) && link.controlPoints.length > 0) {
            return link.controlPoints;
        } else if (link.controlPoints) {
            return [link.controlPoints];
        } else {
            return [];
        }
    }

    property real topLeftX: {
        var points = safePoints();
        var xValues = points.length > 0 ? points.map(p => p.x) : [];
        if (inputPos.x >= 0) xValues.push(inputPos.x);
        if (outputPos.x >= 0) xValues.push(outputPos.x);
        return xValues.length > 0 ? Math.min(...xValues) : 0;
    }
    
    property real topLeftY: {
        var points = safePoints();
        var yValues = points.length > 0 ? points.map(p => p.y) : [];
        if (inputPos.y >= 0) yValues.push(inputPos.y);
        if (outputPos.y >= 0) yValues.push(outputPos.y);
        return yValues.length > 0 ? Math.min(...yValues) : 0;
    }
    
    property real bottomRightX: {
        var points = safePoints();
        var xValues = points.length > 0 ? points.map(p => p.x) : [];
        if (inputPos.x >= 0) xValues.push(inputPos.x);
        if (outputPos.x >= 0) xValues.push(outputPos.x);
        return xValues.length > 0 ? Math.max(...xValues) : 0;
    }
    
    property real bottomRightY: {
        var points = safePoints();
        var yValues = points.length > 0 ? points.map(p => p.y) : [];
        if (inputPos.y >= 0) yValues.push(inputPos.y);
        if (outputPos.y >= 0) yValues.push(outputPos.y);
        return yValues.length > 0 ? Math.max(...yValues) : 0;
    }

    //! Length of arrow
    property real arrowHeadLength: 10;

    //! Update painted line when change position of input and output ports and some another
    //! properties changed
    onOutputPosChanged:  {
        // Always call preparePainter when position changes, even if it's not valid yet
        // This ensures links are painted as soon as positions become valid
        if (canvas && canvas.available) {
            preparePainter();
        }
    }
    onInputPosChanged:   {
        // Always call preparePainter when position changes, even if it's not valid yet
        // This ensures links are painted as soon as positions become valid
        if (canvas && canvas.available) {
            preparePainter();
        }
    }
    onIsSelectedChanged: {
        // Only paint if positions are valid
        if (canvas && canvas.available && inputPos && outputPos && 
            inputPos.x >= -1000 && inputPos.y >= -1000 && 
            outputPos.x >= -1000 && outputPos.y >= -1000) {
            preparePainter();
        }
    }
    onLinkColorChanged:  {
        // Only paint if positions are valid
        if (canvas && canvas.available && inputPos && outputPos && 
            inputPos.x >= -1000 && inputPos.y >= -1000 && 
            outputPos.x >= -1000 && outputPos.y >= -1000) {
            preparePainter();
        }
    }
    onOutputPortSideChanged: {
        // Only paint if positions are valid
        if (canvas && canvas.available && inputPos && outputPos && 
            inputPos.x >= -1000 && inputPos.y >= -1000 && 
            outputPos.x >= -1000 && outputPos.y >= -1000) {
            preparePainter();
        }
    }

    /*  Object Properties
    * ****************************************************************************************/
    antialiasing: true

    // Height and width of canvas, (arrowHeadLength * 2) is the margin
    width:  {
        var w = Math.abs(topLeftX - bottomRightX) + arrowHeadLength * 2;
        return (isNaN(w) || w <= 0) ? 1 : w;
    }
    height: {
        var h = Math.abs(topLeftY - bottomRightY) + arrowHeadLength * 2;
        return (isNaN(h) || h <= 0) ? 1 : h;
    }

    // Position of canvas, arrowHeadLength is the margin
    x: (topLeftX - arrowHeadLength)
    y: (topLeftY - arrowHeadLength)

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

        // if null ports OR not initialized (inputPos.x < 0) then return the function
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

        // Calculate position of link setting dialog.
        // Finding the middle point of the link
        // Currently we suppose that the line is a bezzier curve
        // since with the LType it's not possible to find the middle point easily
        // the design needs to be revised

        var minPoint1 = inputPos.plus(BasicLinkCalculator.connectionMargin(inputPort?.portSide ?? -1));
        var minPoint2 = outputPos.plus(BasicLinkCalculator.connectionMargin(outputPort?.portSide ?? -1));
        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, minPoint1, minPoint2, outputPos]);
        if (linkMidPoint && typeof linkMidPoint.minus === 'function') {
            linkMidPoint = linkMidPoint.minus(topLeftPosition);
        } else if (linkMidPoint && typeof linkMidPoint.x === 'number' && typeof linkMidPoint.y === 'number') {
            linkMidPoint = Qt.vector2d(linkMidPoint.x - topLeftPosition.x, linkMidPoint.y - topLeftPosition.y);
        }

        var lineWidth = 2;

        //! Correcte control points in ui state
        var controlPoints = [];
        link.controlPoints.forEach(controlPoint => {
            if (controlPoint && typeof controlPoint.minus === 'function') {
                controlPoints.push(controlPoint.minus(topLeftPosition));
            } else if (controlPoint && typeof controlPoint.x === 'number' && typeof controlPoint.y === 'number') {
                // Fallback: create vector2d from x and y if minus is not available
                controlPoints.push(Qt.vector2d(controlPoint.x - topLeftPosition.x, controlPoint.y - topLeftPosition.y));
            }
        });


        // Draw the curve with LinkPainter
        LinkPainter.createLink(context, inputPos.minus(topLeftPosition), controlPoints, isSelected,
                               linkColor, link.direction,
                               link.guiConfig.style, link.guiConfig.type, lineWidth, arrowHeadLength,
                               link.inputPort.portSide, outputPortSide);
    }

    /* Children
    * ****************************************************************************************/

    // Prepare painter when direction of link changed.
    Connections {
        target: link ? link : null

        function onDirectionChanged() {
            // Only paint if positions are valid
            if (canvas && canvas.available && inputPos && outputPos && 
                inputPos.x >= -1000 && inputPos.y >= -1000 && 
                outputPos.x >= -1000 && outputPos.y >= -1000) {
                preparePainter();
            }
        }
    }
    
    // Force update when port._position changes
    // This ensures links are repainted when port positions are updated
    // Monitor port._position changes and trigger repaint
    property vector2d _lastInputPos: Qt.vector2d(-1, -1)
    property vector2d _lastOutputPos: Qt.vector2d(-1, -1)
    
    // Timer to check for port position changes
    Timer {
        id: portPositionCheckTimer
        interval: 16  // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            if (!canvas || !canvas.available) return;
            
            // Check if input port position changed
            var currentInputPos = inputPort?._position ?? Qt.vector2d(-1, -1);
            if (currentInputPos.x !== _lastInputPos.x || currentInputPos.y !== _lastInputPos.y) {
                _lastInputPos = currentInputPos;
                inputPos = currentInputPos;
                preparePainter();
            }
            
            // Check if output port position changed
            var currentOutputPos = outputPort?._position ?? Qt.vector2d(-1, -1);
            if (currentOutputPos.x !== _lastOutputPos.x || currentOutputPos.y !== _lastOutputPos.y) {
                _lastOutputPos = currentOutputPos;
                outputPos = currentOutputPos;
                preparePainter();
            }
        }
    }

    // Prepare painter when style AND/OR type of link changed.
    Connections {
        target: link && link.guiConfig ? link.guiConfig : null

        function onStyleChanged() {
            // Only paint if positions are valid
            if (canvas && canvas.available && inputPos && outputPos && 
                inputPos.x >= -1000 && inputPos.y >= -1000 && 
                outputPos.x >= -1000 && outputPos.y >= -1000) {
                preparePainter();
            }
        }

        function onTypeChanged() {
            // Only paint if positions are valid
            if (canvas && canvas.available && inputPos && outputPos && 
                inputPos.x >= -1000 && inputPos.y >= -1000 && 
                outputPos.x >= -1000 && outputPos.y >= -1000) {
                preparePainter();
            }
        }
    }


    /* Functions
  * ****************************************************************************************/

    //! Prepare painter and then call painter of canvas.
    function preparePainter() {
        // Check if canvas is available and has valid dimensions before painting
        if (!canvas || !canvas.available) {
            return;
        }
        
        // Check if positions are valid (not off-screen or behind camera)
        // Positions with x < -1000 or y < -1000 are considered off-screen
        if (!inputPos || !outputPos || 
            inputPos.x < -1000 || inputPos.y < -1000 || 
            outputPos.x < -1000 || outputPos.y < -1000) {
            return;
        }
        
        // Check if dimensions are valid (avoid NaN and negative values)
        var w = width;
        var h = height;
        if (isNaN(w) || isNaN(h) || w <= 0 || h <= 0) {
            return;
        }

        // Update controlPoints when inputPort is known (inputPort !== null).
        if(inputPort && inputPos && outputPos && inputPos.x >= 0 && outputPos.x >= 0) {
            try {
                // Calculate the control points with BasicLinkCalculator
                if (link && link.guiConfig && link.inputPort) {
                    link.controlPoints = BasicLinkCalculator.calculateControlPoints(inputPos, outputPos, link.direction,
                                                                                    link.guiConfig.type, link.inputPort.portSide,
                                                                                    outputPortSide);
                }

                // The function controlPointsChanged is invoked once following current change.
                // link.controlPointsChanged();
            } catch (e) {
                // Error calculating control points, skip painting
                return;
            }
        }

        // Update painter (must be reset the context when inputPort is NULL)
        // Only request paint if canvas is ready and valid, and positions are valid
        if (canvas && canvas.available && !isNaN(w) && !isNaN(h) && w > 0 && h > 0 &&
            inputPos && outputPos && 
            inputPos.x >= -1000 && inputPos.y >= -1000 && 
            outputPos.x >= -1000 && outputPos.y >= -1000) {
            try {
                canvas.requestPaint();
            } catch (e) {
                // Canvas not ready for painting, ignore
            }
        }
    }
}
