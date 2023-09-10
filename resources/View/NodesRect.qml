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
        scene: root.scene
        sceneSession: root.sceneSession
    }
}
