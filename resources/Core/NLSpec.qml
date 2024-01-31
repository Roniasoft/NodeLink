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
        Container = 2,

        Unknown = 99
    }

    //! Selection tool object type
    enum SelectionSpecificToolType {
        Node = 0,   //! for single node selection
        Link = 1,   //! for single link selection
        Any  = 2,   //! for single selection with any type
        All  = 3,   //! for multiple selection with any types! clicked still send the last selected one

        Unknown = 99
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
        Input    = 0,
        Output   = 1,
        InAndOut = 2
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

    //! Node Types
    enum NodeType {
        CustomNode = 98,
        Unknown  = 99
    }

}
