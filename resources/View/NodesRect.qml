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
    SelectionRubberBand {
        scene: root.scene
    }

    //! User Connection Curve
    UserLinkView {
        scene: root.scene
        anchors.fill: parent
    }
}
