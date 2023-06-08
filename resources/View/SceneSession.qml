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

    property bool isLeftClickPressedAndHold: false

    //! Sets port visibility
    function setPortVisibility(portId: string, visible: Boolean) {
        portsVisibility[portId] = visible;
        portsVisibilityChanged();
    }
}
