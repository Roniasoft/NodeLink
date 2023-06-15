import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * NoedsRect is an Item that contain a Mousearea to manage I_NodesRect and its events.
 * ************************************************************************************************/
I_NodesRect {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    /*  Children
    * ****************************************************************************************/

    //! Rubber band border with different opacity
    ObjectSelectionView {
        scene: root.scene
        sceneSession: root.sceneSession
    }
}
