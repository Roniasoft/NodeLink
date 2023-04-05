import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Shapes
import "Logics/BezierCurve.js" as BezierCurve
import "Logics/Calculation.js" as Calculation

/*! ***********************************************************************************************
 * A view for the links (BezierCurve)
 * Using a js canvas for drawing
 * ************************************************************************************************/
Canvas {
    id: canvas

    /* Property Declarations
    * ****************************************************************************************/
    property Scene  scene

    property Port   inputPort

    property Port   outputPort

    property Link   link:       Link {}

    property bool   isSelected: link == scene.selectionModel.selectedLink

    property vector2d inputPos: scene?.portsPositions[inputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d outputPos: scene?.portsPositions[outputPort?._qsUuid] ?? Qt.vector2d(0, 0)

    property vector2d linkMidPoint: Qt.vector2d(0, 0)

    //! update painted line when change position of input and output ports
    onOutputPosChanged: canvas.requestPaint();
    onInputPosChanged:  canvas.requestPaint();
    onIsSelectedChanged: canvas.requestPaint();


    /*  Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    antialiasing: true

    //! paint line
    onPaint: {

        // create the context
        var context = canvas.getContext("2d");

        // if null ports then return the function
        if (inputPort === null) {
            context.reset();
            return;
        }

        // calculate the control points
        link.controlPoint1 = inputPos.plus(BezierCurve.connectionMargin(inputPort));
        link.controlPoint2 = outputPos.plus(BezierCurve.connectionMargin(outputPort));

        linkMidPoint = Calculation.getPositionByTolerance(0.5, [inputPos, link.controlPoint1, link.controlPoint2, outputPos]);
        // draw the curve
        BezierCurve.bezierCurve(context, inputPos, link.controlPoint1, link.controlPoint2, outputPos, isSelected, link.guiConfig.color);
    }

    /*  Children
    * ****************************************************************************************/

    //! Link tools
    LinkToolsRect {
        id: linkToolRect

        x: linkMidPoint.x
        y: linkMidPoint.y - height * 2

        visible: isSelected
        scene: canvas.scene
        link: canvas.link

        onEditDescription: (isEditable) => {
                               descriptionText.focus = isEditable
                           }
    }

    // Description view
    TextArea {
        id: descriptionText
        x: linkMidPoint.x
        y: linkMidPoint.y

        text: link.guiConfig.description
        visible: link.guiConfig.description.length > 0 || activeFocus

        color: "white"
        font.family: "Roboto"
        font.pointSize: 14

        onTextChanged: {
            if (link && link.description !== text)
                link.guiConfig.description = text;
        }

        background: Rectangle {
            radius: 5
            border.width: 3
            border.color: isSelected ? link.guiConfig.color : "transparent"
            color: "#1e1e1e"
        }

        onFocusChanged: {
            if(focus && !isSelected) {
                scene.selectionModel.toggleLinkSelection(link);
            }
        }
    }

    Connections {
        target: scene

        // Send paint requset when PortsPositionsChanged
        function onPortsPositionsChanged () {
            canvas.requestPaint();
        }
    }

    Connections {
        target: link.guiConfig

        // Send paint requset when ColorChanged
        function onColorChanged () {
            canvas.requestPaint();
        }
    }

    //! To hide color picker if selected node is changed and
    //! remove focus on description TextArea
    Connections {
        target: canvas
        function onIsSelectedChanged() {
            linkToolRect.colorPicker.visible = false;
            descriptionText.focus = false;
        }
    }
}
