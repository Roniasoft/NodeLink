import QtQuick
import NodeLink

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
QtObject {

    //! map<port uuid: string, isVisible: bool>
    property var   portsVisibility: ({})

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

    //! Active focus of main scene view
    signal sceneForceFocus()

    //! Sets port visibility
    function setPortVisibility(portId: string, visible: Boolean) {
        portsVisibility[portId] = visible;
        portsVisibilityChanged();
    }
}
