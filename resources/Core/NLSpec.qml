import QtQuick 2.15

QtObject {


    //! Type of node.
    enum NodeType {
        General = 0,
        Root    = 1
    }

    //! Location of port on the node sides
    enum PortPositionSide {
        Top     = 0,
        Botton  = 1,
        Left    = 2,
        Right   = 3
    }

    //! Port type data flow.
    enum PortType {
        Input   = 0,
        Output  = 1
    }
}
