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
    property bool marqueeSelectionMode: false

	//! Zoom manager
    property ZoomManager zoomManager: ZoomManager {}

    //! Show and hide the overview control in side menu
    property bool enabledOverview: true

    //! Show and hide the overview
    property bool visibleOverview: true

    //! Is scene editable or not
    property bool isSceneEditable: true

    //! To handle the delete prompt:
    //! set to 'true' to display a prompt for every deletion of a node or link,
    //! and 'false' to delete the selected object without additional confirmation.
    property bool  isDeletePromptEnable: true

    //! Pan and flick button
    property int panButton: Qt.RightButton

    //! Marquee selection button
    property int marqueeSelectionButton: Qt.LeftButton

    //! Holds the modifier that should be held during wheel event so zooming is performed
    property int zoomModifier:     Qt.ShiftModifier

    //! Controls whether flicking should happen or not
    property bool flickEnabled: true

    //! Whether adding image should be available for nodes
    property bool  doNodesNeedImage:     true

    //! Active focus of main scene view
    signal sceneForceFocus()

    //! Start marquee(rubber band) selection.
    signal marqueeSelectionStart(var mouse);

    //! Update marquee(rubber band) selection.
    signal updateMarqueeSelection(var mouse);

    //! Sets port visibility
    function setPortVisibility(portId: string, visible: Boolean) {
        portsVisibility[portId] = visible;
        portsVisibilityChanged();
    }
}
