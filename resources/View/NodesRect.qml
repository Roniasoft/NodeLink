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
            property int imagesNumber: imageFlickable.node.imagesModel.imagesSources.length
            x: modelData.guiConfig.position.x + 3
            y: modelData.guiConfig.position.y - height - 5
            scene: root.scene
            sceneSession: root.sceneSession
            node: modelData

            onImagesNumberChanged: {
                imageFlickable.adjustingY();
            }

            Connections {
                property SelectionModel selectionModel: root.scene.selectionModel
                target: selectionModel
                function onSelectedModelChanged() {
                        imageFlickable.adjustingY();
                }
            }

            //! Adjusting image flickable place
            function adjustingY() {
                if (imageFlickable.imagesNumber !== 0) {
                    if (!objectSelectionView.hasSelectedObject)
                        imageFlickable.y = Qt.binding(function() { return modelData.guiConfig.position.y - height - 5;});
                    Object.values(selectionModel.selectedModel).forEach(node =>{
                        if (imageFlickable.node === node) {
                            imageFlickable.y = Qt.binding(function() { return modelData.guiConfig.position.y - height - 49;});
                            return;
                        }
                        else
                            imageFlickable.y = Qt.binding(function() { return modelData.guiConfig.position.y - height - 5;});
                    })
                }
            }

        }
    }
}
