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
    property real maximumZoom :     2.5

    //! Minimum zoom value
    property real minimumZoom :     0.35

    //! Zoom factor, control the zoom
    property real zoomFactor:       1.0

    //! step of zoom in/out
    property real zoomStep:         0.1

    //! In minimalZoomNode, node show a minimal Rectangle without header and description
    property real minimalZoomNode:  0.6

    //! zoom in node edit mode (When a node is in minimal mode)
    property real nodeEditZoom :    2.0

    /* Signals
     * ****************************************************************************************/

    //! Fit scene with proper width and height in scene
    signal zoomToFitSignal();

    //! Emit from side menu to update scaling in zoomIn/zoomOut process.
    signal zoomInSignal();
    signal zoomOutSignal();

    //! Zoom In/Out from NodeView:
    //! zoomPoint must be in local coordinates of NodeView, mapping is handled by NodesScene itself
    signal zoomNodeSignal(point zoomPoint, Item nodeView, int wheelAngle);

    //! Zoom into a node
    signal zoomToNodeSignal(node: Node, targetZoomFactor: real);

    //! Set focus to scene.
    signal focusToScene();

    //! Use this when zoomFactor changed very fast.
    signal startAnimated();

    //! reset zoom with efect on flicable
    signal resetZoomSignal(zoomFactor : real);


    /* Functions
     * ****************************************************************************************/
    //! ZoomIn method
    function zoomIn() {
        if(canZoomIn())
            zoomFactor += zoomInStep();

        focusToScene();
    }

    //! ZoomOut method
    function zoomOut() {
        if(canZoomOut())
            zoomFactor -= zoomOutStep();

        focusToScene();
    }

    //! Fit scene with proper zoom factor
    function zoomToFit() {
        zoomToFitSignal();
        startAnimated();
        focusToScene();
    }

    //! Undo zoom method
    function undoZoom() {
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
        return zoomFactor - maximumZoom < 0.0001;
    }

    //! Can zoom Out ...
    function canZoomOut() : bool {
        return zoomFactor - minimumZoom > 0.0001;
    }

    //! Zoom in step
    function zoomInStep() : real {
        if (canZoomIn()) return Math.min(zoomStep, maximumZoom - zoomFactor);

        return 0
    }

    //! Zoom out step
    function zoomOutStep() : real {
        if (canZoomOut()) return Math.min(zoomStep, zoomFactor - minimumZoom);

        return 0
    }
}
