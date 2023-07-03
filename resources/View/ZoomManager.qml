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
    property real maximumZoom   :   2.0

    //! Minimum zoom value
    property real minimumZoom   : 0.5

    //! Zoom factor, control the zoom
    property real zoomFactor    : 1.0

    //! Keep zoom factor before zoomIn and zoomOut.
    property real undoZoomFactor: 1.0

    //! step of zoom in/out
    property real zoomStep      : 0.05

    //! zoom scene relative to zoomPoint
    property vector2d zoomPoint    : Qt.vector2d(0, 0)

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
    function zoomIn(zoomCenterPoint : vector2d) {
        if((maximumZoom - zoomFactor) >= zoomStep) {
            undoZoomFactor = zoomFactor;
            zoomFactor *= (1 + zoomStep);
            zoomPoint = zoomCenterPoint;
        }

        focusToScene();
    }

    //! ZoomOut method
    function zoomOut(zoomCenterPoint : vector2d) {
        if((zoomFactor - minimumZoom) >= zoomStep) {
            undoZoomFactor = zoomFactor;
            zoomFactor *= (1 - zoomStep);
            zoomPoint = zoomCenterPoint;
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
    function customZoom(zoom : real, zoomCenterPoint : vector2d) {
        zoomFactor = zoom;
        zoomPoint = zoomCenterPoint;
        startAnimated();
        focusToScene();
    }

    //! Can zoom In ...
    function canZoomIn() : bool {
        return zoomFactor < (maximumZoom - zoomStep);
    }

    //! Can zoom Out ...
    function canZoomOut() : bool {
        return zoomFactor > (minimumZoom + zoomStep);
    }
}
