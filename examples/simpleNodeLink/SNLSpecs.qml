pragma Singleton

import QtQuick
import QtQuick.Controls

QtObject {
    //! Type of node.
    enum NodeType {
        General     = 0,
        Root        = 1,
        Step        = 2,
        Transition  = 3,
        Macro       = 4,

        Unknown     = 5
    }
}
