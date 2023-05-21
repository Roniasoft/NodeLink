pragma Singleton

import QtQuick
import QtQuick.Controls

QtObject {

    //! Flag for blocking observers while undo operations are under progress
    property QtObject undo: QtObject {
        property bool blockObservers: false
    }

    //! Object types
    enum ObjectType {
        Node = 0,
        Link = 1,

        Unknown = 99
    }

    //! Type of node.
    enum NodeType {
        General     = 0,
        Root        = 1,
        Step        = 2,
        Transition  = 3,
        Macro       = 4,
        Link        = 5,

        Unknown     = 6
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
        Bezier   = 0,   //! Bezzier Curve
        LLine    = 1,   //! A line like L (with one control point)
        Straight = 2,   //! Straight Line

        Unknown  = 99
    }

    //! Link Direction.
    enum LinkDirection {
        Nondirectional  = 0,
        Unidirectional  = 1,
        Bidirectional   = 2
    }

    //! Link Style.
    enum LinkStyle {
        Solid  = 0,
        Dash   = 1,
        Dot    = 2
    }

}
