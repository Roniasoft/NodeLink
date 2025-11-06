pragma Singleton

import QtQuick

QtObject {
    enum NodeType {
        Source       = 0,
        Regex        = 1,
        ResultTrue   = 2,
        ResultFalse  = 3,

        Unknown      = 99
    }

    enum OperationType {
        Operation    = 0,
        Regex        = 1,
        
        Unknown      = 99
    }
}
