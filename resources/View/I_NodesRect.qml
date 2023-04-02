import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * I_NodesRect is an interface classs that shows nodes.
 * ************************************************************************************************/

Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    property int                contentWidth

    property int                contentHeight

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
            contentWidth: root.contentWidth
            contentHeight: root.contentHeight
        }
    }

    //! Connections
    Repeater {
        model: scene.connections

        delegate: ConnectionView {
            scene: root.scene
            inputPort: modelData.inputPort
            outputPort: modelData.outputPort
            connection: modelData
            isSelected: modelData.isSelected
        }
    }
}
