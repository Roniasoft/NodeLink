import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Ui for Overview Node Rect
 * ************************************************************************************************/
I_NodesRect {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Overview width, used for calculatin scale for mapping scene -> overview
    property int          overviewWidth

    //! Overview height, used for calculatin scale for mapping scene -> overview
    property int          overviewHeight

    //! Top Left position of node rect (pos of the node in the top left corner)
    property vector2d     nodeRectTopLeft: Qt.vector2d(Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.x )),
                                                       Math.min(...Object.values(scene.nodes).map(node => node.guiConfig.position.y)))

    //! Bottom Right position of node rect (pos of the node in the bottom right corner)
    property vector2d     nodeRectBottomRight: Qt.vector2d(Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.x + node.guiConfig.width)),
                                                           Math.max(...Object.values(scene.nodes).map(node => node.guiConfig.position.y + node.guiConfig.height)))

    //! Scale used for mapping scene -> overview. Min is used to avoid complication in link drawings
    property real         customScaleFactor: Math.min(overviewWidth / (nodeRectBottomRight.x- nodeRectTopLeft.x) > 1 ?
                                                      1 : overviewWidth / (nodeRectBottomRight.x- nodeRectTopLeft.x),
                                                      overviewHeight / (nodeRectBottomRight.y- nodeRectTopLeft.y) > 1 ?
                                                      1 : overviewHeight / (nodeRectBottomRight.y- nodeRectTopLeft.y))
    /*  Object Properties
    * ****************************************************************************************/
    width: (nodeRectBottomRight.x- nodeRectTopLeft.x) * customScaleFactor
    height: (nodeRectBottomRight.y - nodeRectTopLeft.y) * customScaleFactor

    nodeViewUrl: "NodeViewOverview.qml"
    linkViewUrl: "LinkViewOverview.qml"

    extraProperties: QtObject {
        property vector2d nodeRectTopLeft:   root.nodeRectTopLeft
        property vector2d linkRectTopLeft:   root.nodeRectTopLeft.times(sceneSession.zoomManager.zoomFactor)
        property real     customScaleFactor: root.customScaleFactor
    }
}
