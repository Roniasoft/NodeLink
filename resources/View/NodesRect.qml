import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * NoedsRect is an Item that contain a Mousearea to manage I_NodesRect and its events.
 * ************************************************************************************************/
I_NodesRect {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Z factor to manage node view (maximum in NodeView is 3) and another layers order, maximum is 4
    z: 4

    /*  Children
    * ****************************************************************************************/

    //! Rubber band border with different opacity
    ObjectSelectionView {
        id: objectSelectionView
        scene: root.scene
        sceneSession: root.sceneSession
    }

    Repeater {
        model: Object.values(root.scene.nodes)
        delegate: ImagesFlickable {
            id: imageFlickable
            width: modelData.guiConfig.width - 6
            height: modelData.guiConfig.height * 0.35
            x: modelData.guiConfig.position.x + 3
            y: modelData.guiConfig.position.y - height - 5 - (selectedAlone ? 45 : 0)
            scene: root.scene
            sceneSession: root.sceneSession
            node: modelData
        }
    }
}
