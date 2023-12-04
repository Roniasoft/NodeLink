import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Scene Session, to store certain visual properties (not saved)
 * ************************************************************************************************/
QtObject {

    //! selectionTools contains user-defined tool buttons in Selection tools rect
    property var   selectionToolButtons: []

    //! map<port uuid: string, isVisible: bool>
    property var   portsVisibility: ({})

    //! map<link uuid: string, color: string>
    property var   linkColorOverrideMap: ({})

    //! connectingMode is true When a connection is in progress.
    property bool connectingMode: false

    //! isShiftModifierPressed to manage multi selection
    property bool isShiftModifierPressed: false

    //! isCtrlPressed to draw a Rectangle
    property bool isCtrlPressed: false

    //! Created rubberband is moving ...
    property bool isRubberBandMoving: false

    //! The mouse is inside the created rubberband or not.
    property bool isMouseInRubberBand: false;

    //! Creating rubberband with mouse and pressed and hold the ctrl btn in
    //! SelectionHelperView
    property bool rubberBandSelectionMode: false

	//! Zoom manager
    property ZoomManager zoomManager: ZoomManager {}

    //! Show and hide the overview
    property bool visibleOverview: true

    //! Is scene editable or not
    property bool isSceneEditable: true

    //! Active focus of main scene view
    signal sceneForceFocus()

    //! Start marque(rubber band) selection.
    signal marqueSelectionStart(var mouse);

    //! Update marque(rubber band) selection.
    signal updateMarqueSelection(var mouse);

    //! Sets port visibility
    function setPortVisibility(portId: string, visible: Boolean) {
        portsVisibility[portId] = visible;
        portsVisibilityChanged();
    }
}
