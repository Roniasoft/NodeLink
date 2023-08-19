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

Shape {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene          scene

    property SceneSession   sceneSession

    property Port           inputPort

    property Port           outputPort


    property Link       link:       Link {}

    property bool       isSelected: scene?.selectionModel?.isSelected(link?._qsUuid) ?? false

    property vector2d   inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d   outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d   linkMidPoint: Qt.vector2d(0, 0)

    //! outPut port side
    property int        outputPortSide: link.outputPort?.portSide ?? -1

    //! Link color
    property string     linkColor: Object.keys(sceneSession.linkColorOverrideMap).includes(link?._qsUuid ?? "") ? sceneSession.linkColorOverrideMap[link._qsUuid] : link.guiConfig.color

    property real zoomFactor: sceneSession.zoomManager.zoomFactor

    property real lineWidth: 3 * zoomFactor * (isSelected ? 1.2 : 1.0);


    // Applying style to the Link
    property var stylePattern: {
        switch (link.guiConfig.style) {
        case NLSpec.LinkStyle.Dash: { // ِDash
            return [5, 2];
        }
        case NLSpec.LinkStyle.Dot: { // Dot
            return [1, 2];
        }
        default: // Solid
            return []
        }
    }

    //! LinkView Dimensions
    property real topLeftX: Math.min(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real topLeftY: Math.min(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)

    property real bottomRightX: Math.max(...link.controlPoints.map(controlpoint => controlpoint.x), inputPos.x, outputPos.x)
    property real bottomRightY: Math.max(...link.controlPoints.map(controlpoint => controlpoint.y), inputPos.y, outputPos.y)


    //! update painted line when change position of input and output ports
    onOutputPosChanged:  root.requestPaint();
    onInputPosChanged:   root.requestPaint();
    onIsSelectedChanged: root.requestPaint();
    onLinkColorChanged:  root.requestPaint();

    /*  Object Properties
    * ****************************************************************************************/
    antialiasing: true
    Component.onCompleted: requestPaint();

    width:  Math.abs(topLeftX - bottomRightX) + 20;
    height: Math.abs(topLeftY - bottomRightY) + 20;
    x: topLeftX - 20
    y: topLeftY - 20

    /*  Childeren
    * ****************************************************************************************/

    //! Output Arrow
    ShapePath {
        id: arrowOutSideShape

        fillColor: (link.direction !== NLSpec.LinkDirection.Nondirectional && inputPort) ?
                       linkColor : "transparent"
        strokeColor: fillColor
        capStyle: ShapePath.RoundCap

        property vector2d arrowDimension: LinkPainter.arrowAngle(outputPortSide)
        property vector2d targetPoint: outputPos.minus(Qt.vector2d(root.x, root.y))
        property real     angle: Math.atan2(arrowDimension.y, arrowDimension.x);
        property real     arrowHeadLength: 10 * zoomFactor * (isSelected ? 1.2 : 1.0)

        startX: targetPoint.x - arrowHeadLength * Math.cos(angle - Math.PI / 6)
        startY: targetPoint.y - arrowHeadLength * Math.sin(angle - Math.PI / 6)

        PathLine {
            x: arrowOutSideShape.targetPoint.x
            y: arrowOutSideShape.targetPoint.y
        }

        PathLine {
            x: arrowOutSideShape.targetPoint.x - arrowOutSideShape.arrowHeadLength * Math.cos(arrowOutSideShape.angle + Math.PI / 6)
            y: arrowOutSideShape.targetPoint.y - arrowOutSideShape.arrowHeadLength * Math.sin(arrowOutSideShape.angle + Math.PI / 6)
        }

        PathLine {
            x: arrowOutSideShape.startX
            y: arrowOutSideShape.startY
        }
    }

    //! Input Arrow
    ShapePath {
        id: arrowInSideShape

        fillColor: (link.direction === NLSpec.LinkDirection.Bidirectional && inputPort) ?
                       linkColor : "transparent"
        strokeColor: fillColor
        capStyle: ShapePath.RoundCap

        property vector2d arrowDimension:  LinkPainter.arrowAngle(inputPort?.portSide ?? -1)
        property vector2d targetPoint:      inputPos.minus(Qt.vector2d(root.x, root.y))
        property real     angle:           Math.atan2(arrowDimension.y, arrowDimension.x);
        property real     arrowHeadLength: 10 * zoomFactor * (isSelected ? 1.2 : 1.0)

        startX: targetPoint.x - arrowHeadLength * Math.cos(angle - Math.PI / 6)
        startY: targetPoint.y - arrowHeadLength * Math.sin(angle - Math.PI / 6)

        PathLine {
            x: arrowInSideShape.targetPoint.x
            y: arrowInSideShape.targetPoint.y
        }

        PathLine {
            x: arrowInSideShape.targetPoint.x - arrowInSideShape.arrowHeadLength * Math.cos(arrowInSideShape.angle + Math.PI / 6)
            y: arrowInSideShape.targetPoint.y - arrowInSideShape.arrowHeadLength * Math.sin(arrowInSideShape.angle + Math.PI / 6)
        }

        PathLine {
            x: arrowInSideShape.startX
            y: arrowInSideShape.startY
        }
    }

    //! Main curve/Line
    ShapePath {
        id: shapePath

        strokeColor: inputPort ? linkColor : "transparent"
        strokeWidth: lineWidth
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        strokeStyle: (link.guiConfig.style === NLSpec.LinkStyle.Solid) ?
                         ShapePath.SolidLine :
                         ShapePath.DashLine

        dashPattern: stylePattern
        startX: inputPos.x - root.x
        startY: inputPos.y - root.y
    }

    // requestPaint when style AND/OR type of link changed.
    Connections {
        target: link.guiConfig

        function onTypeChanged() {
            root.requestPaint();
        }
    }

    /* Functions
  * ****************************************************************************************/

    //! paint line
    function requestPaint() {

        shapePath.pathElements = [];

        // if null ports then return the function
        if (!inputPort) {
            return;
        }

        // Calculate the control points with BasicLinkCalculator
        link.controlPoints = BasicLinkCalculator.calculateControlPoints(inputPos, outputPos, link.direction,
                                                                        link.guiConfig.type, link.inputPort.portSide,
                                                                        outputPortSide, sceneSession.zoomManager.zoomFactor)

        // Top left position ot root shape
        var topLeftPosition = Qt.vector2d(root.x, root.y);

        // Calculate position of link setting dialog.
        // Finding the middle point of the link
        // Currently we suppose that the line is a bezzier curve
        // since with the LType it's not possible to find the middle point easily
        // the design needs to be revised
        var zoomFactor = sceneSession.zoomManager.zoomFactor
        var minPoint1 = inputPos.plus(BasicLinkCalculator.connectionMargin(inputPort?.portSide ?? -1, zoomFactor));
        var minPoint2 = outputPos.plus(BasicLinkCalculator.connectionMargin(outputPort?.portSide ?? -1, zoomFactor));
        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, minPoint1, minPoint2, outputPos]);
        linkMidPoint = linkMidPoint.minus(topLeftPosition);


        var linkType = (link.guiConfig.type === NLSpec.LinkType.Bezier) ? "PathCurve" :
                                                                          "PathLine";
        var linkDirection = link.direction;

        // Update pathElements in shapePath
        link.controlPoints.forEach((controlPoint, index) => {
                                       if (index === 0)
                                            return;

                                       // Create proper shape path
                                       let pathElement = Qt.createQmlObject("import QtQuick;" + linkType + "{}", root);
                                       if (!pathElement)
                                            return;

                                       pathElement.x = controlPoint.x - topLeftPosition.x;
                                       pathElement.y = controlPoint.y - topLeftPosition.y;

                                       // Add pathElement into pathElements of shape.
                                       shapePath.pathElements.push(pathElement);
                                   });
    }


}
