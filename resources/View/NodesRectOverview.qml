import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * Ui for Overview Node Rect
 * ************************************************************************************************/
I_NodesRect {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Top Left position of node rect (pos of the node in the top left corner)
    property vector2d     nodeRectTopLeft

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         overviewScaleFactor: 1.0

    /*  Object Properties
    * ****************************************************************************************/

    //! Registre nodeView and LinkView classes.
    nodeViewUrl: "NodeViewOverview.qml"
    linkViewUrl: "LinkViewOverview.qml"
    containerViewUrl: "ContainerOverview.qml"

    viewProperties: QtObject {
        property vector2d nodeRectTopLeft:     root.nodeRectTopLeft
        property real     overviewScaleFactor: root.overviewScaleFactor
    }
}
