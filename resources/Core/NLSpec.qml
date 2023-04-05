pragma Singleton

import QtQuick
import QtQuick.Controls

QtObject {

    //! Flag for blocking observers while undo operations are under progress
    property QtObject undo: QtObject {
        property bool blockObservers: false
    }

    //! Type of node.
    enum NodeType {
        General     = 0,
        Root        = 1,
        Step        = 2,
        Transition  = 3,
        Macro       = 4
    }

    //! Location of port on the node sides
    enum PortPositionSide {
        Top     = 0,
        Bottom  = 1,
        Left    = 2,
        Right   = 3,
        Unknown = 99
    }

    //! Port type data flow.
    enum PortType {
        Input   = 0,
        Output  = 1
    }

    //! Type of link
    enum LinkType {
        Bezier = 0,

        Unknown = 99
    }
}
