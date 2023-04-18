import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Simulation Foreground Item is responsible for creating a collection of
 * blocker node on top of scene while simulation is under
 * progress
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Blocker Nodes
    //! Array <Node: uuid>
    property var    nodes: []

    //! Scene
    property Scene  scene

    /*  Children
    * ****************************************************************************************/
    //! Nodes
    Repeater {
        model: nodes
        delegate: BlockerNode {
            node: scene.nodes[modelData]
//            scene: root.scene
        }
    }
}
