import QtQuick
import NodeLink

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    /*  Object Properties
    * ****************************************************************************************/
    width: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.x + node.guiConfig.width)), 1024)
    height: Math.max(...Object.values(scene.nodes).map(node => (node.guiConfig.position.y + node.guiConfig.height)), 768)
    color: "transparent"

    /*  Children
    * ****************************************************************************************/

    //! Nodes
    Repeater {
        model: Object.values(scene.nodes)
        delegate: NodeView {
            id: nodeView
            node: modelData
            scene: root.scene
            sceneSession: root.sceneSession
            isSelected: modelData === scene.selectionModel.selectedNode
            onClicked: scene.selectionModel.select(modelData)
        }
    }

    //! Connections
    Repeater {
        model: Object.entries(scene.portsDownstream).filter(([key, value]) => value.length > 0)
        delegate: ConnectionView {
            startPos: scene.portsPositions[modelData[0]]
            endPos: scene.portsPositions[modelData[1]]
        }
    }
}
