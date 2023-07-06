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
    property real maximumZoom   :   1.5

    //! Minimum zoom value
    property real minimumZoom   : 0.5

    //! Zoom factor, control the zoom
    property real zoomFactor    : 1.0

    //! Keep zoom factor before zoomIn and zoomOut.
    property real undoZoomFactor: 1.0

    //! step of zoom in/out
    property real zoomStep      : 0.1

    //! Cumulative  zoom factor
    property real     cumulativeZoomFactor: 1.0

//    ! Behavior on zoomFactor change
//    Behavior on zoomFactor {NumberAnimation{duration: 100}}

    /* Signals
     * ****************************************************************************************/

    //! Fit scene with proper width and height in scene
    signal zoomToFitSignal();

    //! Emit from side menu to update scaling in zoomIn/zoomOut process.
    signal zoomInSignal();
    signal zoomOutSignal()

    //! Set focus to scene.
    signal focusToScene();

    //! Use this when zoomFactor changed very fast.
    signal startAnimated();


    /* Functions
     * ****************************************************************************************/
    //! ZoomIn method
    function zoomIn() {
        if(canZoomIn()) {
            undoZoomFactor = zoomFactor;
            zoomFactor *= (1 + zoomStep);
        }

        focusToScene();
    }

    //! ZoomOut method
    function zoomOut() {
        if(canZoomOut()) {
            undoZoomFactor = zoomFactor;
            zoomFactor *= (1 - zoomStep);
        }
        focusToScene();
    }

    //! Fit scene with proper zoom factor
    function zoomToFit() {
        undoZoomFactor = zoomFactor;
        zoomToFitSignal();
        startAnimated();
        focusToScene();
    }

    //! Undo zoom method
    function undoZoom() {
        zoomFactor = undoZoomFactor;
        startAnimated();
        focusToScene();
    }

    //! Custum zoom method with zoom factor and center point
    function customZoom(zoom : real) {
        zoomFactor = zoom;
        startAnimated();
        focusToScene();
    }

    //! Can zoom In ...
    function canZoomIn() : bool {
        return zoomFactor * (1 + zoomStep) <= maximumZoom;
    }

    //! Can zoom Out ...
    function canZoomOut() : bool {
        return zoomFactor * (1 - zoomStep) >= minimumZoom;
    }
}
