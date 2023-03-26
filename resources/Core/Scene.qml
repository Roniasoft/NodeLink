import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The Scene is responsible for managing nodes and connections between them.
 *
 * ************************************************************************************************/
I_Scene {
    id: scene

    /* Property Properties
     * ****************************************************************************************/

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    property Timer _tier: Timer {
        interval: 300
        repeat: false
        running: true
        onTriggered: {
            // example link
//            linkNodes(Object.keys(_node1.ports)[0], Object.keys(_node2.ports)[2]);
//            linkNodes(Object.keys(_node1.ports)[1], Object.keys(_node3.ports)[3]);
//            linkNodes(Object.keys(_node1.ports)[2], Object.keys(_node4.ports)[3]);
        }
    }
}
