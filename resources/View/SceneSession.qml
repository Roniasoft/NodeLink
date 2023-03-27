import QtQuick
import NodeLink

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
QtObject {

    property Port tempInputPort

    property vector2d tempConnectionEndPos: Qt.vector2d(0, 0)

    //! map<port uuid: string, isVisible: bool>
    property var   portsVisibility: ({})

    //! connectingMode is true When a connection is in progress.
    property bool connectingMode: false
}
