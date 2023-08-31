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
    property Scene          scene

    property SceneSession   sceneSession

    //! Main LinkView model
    property Link       link:       Link {}

    //! Link input port
    property Port       inputPort: link.inputPort

    //! Link output port
    property Port       outputPort: link.outputPort

    //! Link is selected or not
    property bool       isSelected: scene?.selectionModel?.isSelected(link?._qsUuid) ?? false

    //! Link input position
    property vector2d   inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    //! Link output position
    property vector2d   outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    //! linkMidPoint is the position of link description.
    property vector2d   linkMidPoint: Qt.vector2d(0, 0)

    //! outPut port side
    property int        outputPortSide: link.outputPort?.portSide ?? -1

    //! Link color
    property string     linkColor: Object.keys(sceneSession.linkColorOverrideMap).includes(link?._qsUuid ?? "") ? sceneSession.linkColorOverrideMap[link._qsUuid] : link.guiConfig.color

    //! zoomFactor
    property real zoomFactor: 1

    //! Canvas Dimensions
    property real topLeftX: Math.min(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real topLeftY: Math.min(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    property real bottomRightX: Math.max(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real bottomRightY: Math.max(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    property vector2d     nodeRectTopLeft
    property real          topLeftXroot
    property real          topLeftYroot
//    property real scaleFactorWidth
//    property real scaleFactorHeight
    property real         customScaleFactor
    //! Length of arrow
    property real arrowHeadLength: 10 * customScaleFactor;

    //! Update painted line when change position of input and output ports and some another
    //! properties changed
    onOutputPosChanged:  preparePainter();
    onInputPosChanged:   preparePainter();
    onIsSelectedChanged: preparePainter();
    onLinkColorChanged:  preparePainter();
    onZoomFactorChanged: preparePainter();
    onOutputPortSideChanged: preparePainter();
//    onTopLeftXrootChanged: preparePainter();

//    onXChanged: {
//        console.log("x is: ",link.controlPoints.map(controlpoint => controlpoint.x), "input: ",inputPos.x, "output: ",outputPos.x
//                    ,"input port: ",inputPort,outputPort,link
//                    ,"x is:", x
//                    )
//    }
//    onTopLeftXChanged: {
//        console.log("hey",topLeftX)
//    }



    /*  Object Properties
    * ****************************************************************************************/
    antialiasing: true

    // Height and width of canvas, (arrowHeadLength * 2) is the margin
    width:  (Math.abs(topLeftX - bottomRightX) + arrowHeadLength * 2) * customScaleFactor
    height: (Math.abs(topLeftY - bottomRightY) + arrowHeadLength * 2) * customScaleFactor

    // Position of canvas, arrowHeadLength is the margin
    x: ((topLeftX - arrowHeadLength) - nodeRectTopLeft.x) * customScaleFactor
    y: ((topLeftY - arrowHeadLength) - nodeRectTopLeft.y) * customScaleFactor

//    Rectangle {
//        anchors.fill: parent
//        color:" blue"
//    }

    //! paint line
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        // if null ports then return the function
        if (!inputPort) {
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

        var minPoint1 = inputPos.plus(BasicLinkCalculator.connectionMargin(inputPort?.portSide ?? -1, zoomFactor));
        var minPoint2 = outputPos.plus(BasicLinkCalculator.connectionMargin(outputPort?.portSide ?? -1, zoomFactor));
        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, minPoint1, minPoint2, outputPos]);
        linkMidPoint = linkMidPoint.minus(topLeftPosition);

        var lineWidth = 2 * customScaleFactor;

        //! Correcte control points in ui state
        var controlPoints = [];

        var inputPosx = (inputPos.x  - (topLeftX - arrowHeadLength)) * customScaleFactor
        var inputPosy = (inputPos.y  - (topLeftY - arrowHeadLength)) * customScaleFactor
        var inputPos1 = Qt.vector2d(inputPosx,inputPosy)


        link.controlPoints.forEach(controlPoint => {
                                        var controlPointx = (controlPoint.x  - (topLeftX - arrowHeadLength)) * customScaleFactor
                                        var controlPointy = (controlPoint.y  - (topLeftY - arrowHeadLength)) * customScaleFactor
                                        var controlPoint1 = Qt.vector2d(controlPointx,controlPointy)
                                        controlPoints.push(controlPoint1)
                                    });

        // Draw the curve with LinkPainter
        LinkPainter.createLink(context, inputPos1, controlPoints, isSelected,
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

            link.controlPoints = BasicLinkCalculator.calculateControlPoints(inputPos , outputPos, link.direction,
                                                                            link.guiConfig.type, link.inputPort.portSide,
                                                                            outputPortSide, customScaleFactor);

            // The function controlPointsChanged is invoked once following current change.
            // link.controlPointsChanged();
        }

        // Update painter (must be reset the context when inputPort is NULL)
        canvas.requestPaint();
    }
}
