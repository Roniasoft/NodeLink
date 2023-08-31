import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes

import "Logics/BasicLinkCalculator.js" as BasicLinkCalculator
import "Logics/LinkPainter.js" as LinkPainter
import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 *  Link view for overview
 * ************************************************************************************************/

Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property Scene        scene

    property SceneSession sceneSession

    //! Main LinkView model
    property Link         link:       Link {}

    //! Link input port
    property Port         inputPort: link.inputPort

    //! Link output port
    property Port         outputPort: link.outputPort

    //! Link is selected or not
    property bool         isSelected: scene?.selectionModel?.isSelected(link?._qsUuid) ?? false

    //! Link input position
    property vector2d     inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    //! Link output position
    property vector2d     outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    //! linkMidPoint is the position of link description.
    property vector2d     linkMidPoint: Qt.vector2d(0, 0)

    //! outPut port side
    property int          outputPortSide: link.outputPort?.portSide ?? -1

    //! Link color
    property string       linkColor: Object.keys(sceneSession.linkColorOverrideMap).includes(link?._qsUuid ?? "") ? sceneSession.linkColorOverrideMap[link._qsUuid] : link.guiConfig.color

    //! zoomFactor
    property real         zoomFactor: 1

    //! Canvas Dimensions
    property real         topLeftX: Math.min(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real         topLeftY: Math.min(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    property real         bottomRightX: Math.max(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real         bottomRightY: Math.max(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    //! Top Left position of node rect (pos of the node in the top left corner)
    property vector2d     nodeRectTopLeft

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         customScaleFactor

    //! Length of arrow
    property real         arrowHeadLength: 10 * customScaleFactor;

    //! Update painted line when change position of input and output ports and some another
    //! properties changed
    onOutputPosChanged:  preparePainter();
    onInputPosChanged:   preparePainter();
    onIsSelectedChanged: preparePainter();
    onLinkColorChanged:  preparePainter();
    onZoomFactorChanged: preparePainter();
    onOutputPortSideChanged: preparePainter();

    /*  Object Properties
    * ****************************************************************************************/
    antialiasing: true

    // Height and width of canvas, (arrowHeadLength * 2) is the margin
    width:  (Math.abs(topLeftX - bottomRightX) + arrowHeadLength * 2) * customScaleFactor
    height: (Math.abs(topLeftY - bottomRightY) + arrowHeadLength * 2) * customScaleFactor

    // Position of canvas, arrowHeadLength is the margin
    x: ((topLeftX - arrowHeadLength) - nodeRectTopLeft.x) * customScaleFactor
    y: ((topLeftY - arrowHeadLength) - nodeRectTopLeft.y) * customScaleFactor

    //! paint line
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        if (!inputPort) {
            context.reset();
            return;
        }

        // Top left position vector
        var topLeftPosition = Qt.vector2d(canvas.x, canvas.y);
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
        if(inputPort) {
            link.controlPoints = BasicLinkCalculator.calculateControlPoints(inputPos , outputPos, link.direction,
                                                                            link.guiConfig.type, link.inputPort.portSide,
                                                                            outputPortSide, customScaleFactor);
        }
        canvas.requestPaint();
    }
}
