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
    property var    nodes: Object.values(scene.nodes).filter(node => node?.status === NotionNode.NodeStatus.Inactive)
                                                     .map(node => node._qsUuid);

    //! Scene
    property Scene  scene

    property SceneSession   sceneSession

    /*  Children
    * ****************************************************************************************/
    //! Nodes
    Repeater {
        model: nodes
        delegate: BlockerNode {
            sceneSession: root.sceneSession
            node: scene.nodes[modelData]
        }
    }
}
