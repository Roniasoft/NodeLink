import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * This class keeps the zoom parameters and functions
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/

    //! Maximum zoom value
    property real maximumZoom    : 2.5

    //! Minimum zoom value
    property real minimumZoom    : 0.35

    //! Zoom factor, control the zoom
    property real zoomFactor     : 1.0

    //! step of zoom in/out
    property real zoomStep       : 0.3

    //! In minimalZoomNode, node show a minimal Rectangle without header and description
    property real minimalZoomNode: 0.6

    //! zoom in node edit mode (When a node is in minimal mode)
    property real nodeEditZoom   : 2.0

    //! Maximum zoom steps with wheel
    property int maximumZoomSteps: 4

    //! Each wheelStep is one step in zoom process
    property int wheelStep       : 120

//    ! Behavior on zoomFactor change
//    Behavior on zoomFactor {NumberAnimation{duration: 100}}

    /* Signals
     * ****************************************************************************************/

    //! Fit scene with proper width and height in scene
    signal zoomToFitSignal();

    //! Emit from side menu to update scaling in zoomIn/zoomOut process.
    signal zoomInSignal();
    signal zoomOutSignal();

    //! Zoom In/Out from NodeView
    signal zoomNodeSignal(zoomPoint: vector2d, wheelAngle: int);

    //! Zoom into a node
    signal zoomToNodeSignal(node: Node, targetZoomFactor: real);

    //! Set focus to scene.
    signal focusToScene();

    //! reset zoom with efect on flicable
    signal resetZoomSignal(zoomFactor : real);


    /* Functions
     * ****************************************************************************************/
    //! ZoomIn method
    function zoomIn(wheelData = wheelStep) {

        if (canZoomIn())
            zoomFactor *= (1 + zoomInStep(wheelData));

        focusToScene();
    }

    //! ZoomOut method
    function zoomOut(wheelData = wheelStep) {
        if(canZoomOut())
                zoomFactor /= (1 + zoomOutStep(wheelData));

        focusToScene();
    }

    //! Fit scene with proper zoom factor
    function zoomToFit() {
        zoomToFitSignal();
        focusToScene();
    }

    //! Undo zoom method
    function undoZoom() {
        focusToScene();
    }

    //! Custum zoom method with zoom factor and center point
    function customZoom(zoom : real) {
        zoomFactor = zoom;
        focusToScene();
    }

    //! Can zoom In ...
    function canZoomIn() : bool {
        return zoomFactor - maximumZoom < 0.001;
    }

    //! Can zoom Out ...
    function canZoomOut() : bool {
        return zoomFactor - minimumZoom > 0.001;
    }

    //! Zoom in step
    function zoomInStep(wheelData = wheelStep) : real {
        var zoomStepCount = zoomSteps(wheelData);

        if(canZoomIn()) {
            if (zoomFactor * (1 + zoomStep * zoomStepCount) >= maximumZoom)
                return Math.abs(maximumZoom - zoomFactor) / zoomFactor;
            else
                return zoomStep * zoomStepCount;
        }

        return 0.0;
    }

    //! Zoom out step
    function zoomOutStep(wheelData = wheelStep) : real {
        var zoomStepCount = zoomSteps(wheelData);

        if(canZoomOut()) {
            if (zoomFactor / (1 + zoomStep * zoomStepCount) <= minimumZoom)
                return Math.abs(zoomFactor - minimumZoom) / minimumZoom;
            else
                return zoomStep * zoomStepCount;
        }

        return 0.0;
    }

    //! Calculate zoom steps with wheelData.
    function zoomSteps(wheelData = wheelStep) : int {
        var zoomStepCount = Math.abs(wheelData) / 120;
        zoomStepCount = zoomStepCount > maximumZoomSteps ?
                    maximumZoomSteps : zoomStepCount;

        zoomStepCount = zoomStepCount === 0 ? 1 : zoomStepCount;

        return zoomStepCount;
    }
}
