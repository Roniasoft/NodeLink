pragma Singleton
import QtQuick

QtObject {
    //! Type of node.
    enum NodeType {
        Input   = 0,
        AND     = 1,
        OR      = 2,
        NOT     = 3,
        Output  = 4,
        Unknown = 99
    }

    //! Logic operation types
    enum OperationType {
        AND     = 0,
        OR      = 1,
        NOT     = 2,
        Unknown = 99
    }

    //! Boolean states
    enum BooleanState {
        FALSE = 0,
        TRUE  = 1,
        UNDEFINED = 2
    }
}
