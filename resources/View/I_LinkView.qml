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
    property Link       link:       Link {}

    //! Link input port
    property Port       inputPort: link.inputPort

    //! Link output port
    property Port       outputPort: link.outputPort

    //! Link is selected or not
    property bool       isSelected: scene?.selectionModel?.isSelected(link?._qsUuid) ?? false

    //! Link input position
    property vector2d   inputPos: inputPort?._position ?? Qt.vector2d(-1, -1)

    //! Link output position
    property vector2d   outputPos: outputPort?._position ?? Qt.vector2d(-1, -1)

    //! linkMidPoint is the position of link description.
    property vector2d   linkMidPoint: Qt.vector2d(0, 0)

    //! outPut port side
    property int        outputPortSide: link.outputPort?.portSide ?? -1

    //! Link color
    property string     linkColor: Object.keys(sceneSession?.linkColorOverrideMap ?? ({})).includes(link?._qsUuid ?? "") ? sceneSession.linkColorOverrideMap[link._qsUuid] : link.guiConfig.color

    //! Canvas Dimensions
    property real topLeftX: Math.min(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real topLeftY: Math.min(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    property real bottomRightX: Math.max(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real bottomRightY: Math.max(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    //! Length of arrow
    property real arrowHeadLength: 10;

    //! Update painted line when change position of input and output ports and some another
    //! properties changed
    onOutputPosChanged:  preparePainter();
    onInputPosChanged:   preparePainter();
    onIsSelectedChanged: preparePainter();
    onLinkColorChanged:  preparePainter();
    onOutputPortSideChanged: preparePainter();

    /*  Object Properties
    * ****************************************************************************************/
    antialiasing: true

    // Height and width of canvas, (arrowHeadLength * 2) is the margin
    width:  (Math.abs(topLeftX - bottomRightX) + arrowHeadLength * 2)
    height: (Math.abs(topLeftY - bottomRightY) + arrowHeadLength * 2)

    // Position of canvas, arrowHeadLength is the margin
    x: (topLeftX - arrowHeadLength)
    y: (topLeftY - arrowHeadLength)

    //! paint Link
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        // if null ports OR not initialized (inputPos.x < 0) then return the function
        if (!inputPort || inputPos.x < 0 ) {
            context.reset();
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
        linkMidPoint = linkMidPoint.minus(topLeftPosition);

        var lineWidth = 2;

        //! Correcte control points in ui state
        var controlPoints = [];
        link.controlPoints.forEach(controlPoint => controlPoints.push(controlPoint.minus(topLeftPosition)));


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
        target: link

        function onDirectionChanged() {
            preparePainter();
        }
    }

    // Prepare painter when style AND/OR type of link changed.
    Connections {
        target: link.guiConfig

        function onStyleChanged() {
            preparePainter();
        }

        function onTypeChanged() {
            preparePainter();
        }
    }


    /* Functions
  * ****************************************************************************************/

    //! Prepare painter and then call painter of canvas.
    function preparePainter() {

        // Update controlPoints when inputPort is known (inputPort !== null).
        if(inputPort) {
            // Calculate the control points with BasicLinkCalculator
            link.controlPoints = BasicLinkCalculator.calculateControlPoints(inputPos, outputPos, link.direction,
                                                                            link.guiConfig.type, link.inputPort.portSide,
                                                                            outputPortSide);

            // The function controlPointsChanged is invoked once following current change.
            // link.controlPointsChanged();
        }

        // Update painter (must be reset the context when inputPort is NULL)
        canvas.requestPaint();
    }
}
