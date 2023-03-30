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
    //! Scene Selection Model
    property SelectionModel selectionModel: SelectionModel {}

    //! Undo Core
    property UndoCore       _undoCore:       UndoCore {
        scene: scene
    }

    /* Children
     * ****************************************************************************************/


    Component.onCompleted: {
        // adding example nodes
        for (var i = 0; i < 5; i++) {
            var node = NLCore.createNode();
            node.guiConfig.position.x = Math.random() * 1000;
            node.guiConfig.position.y = Math.random() * 1000;
            node.guiConfig.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
            addNode(node);
            node.addPortByHardCode();
        }
        _timer.start();
    }

    // Adding example links
    property Timer _timer: Timer {
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            // example link
            linkNodes(Object.keys(Object.values(nodes)[1].ports)[1], Object.keys(Object.values(nodes)[2].ports)[3]);
            linkNodes(Object.keys(Object.values(nodes)[1].ports)[1], Object.keys(Object.values(nodes)[3].ports)[3]);
            linkNodes(Object.keys(Object.values(nodes)[2].ports)[0], Object.keys(Object.values(nodes)[0].ports)[2]);
        }
    }


}
