import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * I_NodeView show the abstract the NodeView properties.
 * ************************************************************************************************/

Rectangle {

    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Current node
    property Node  node

    //! Scene is the main model containing information about all nodes/links
    property Scene scene

    property SceneSession   sceneSession:   null

    //! Node Contents
    property Component      contentItem:    null

    //! Scale factor to rescale the node view.
    property real           scaleFactor:    1.0

    //! A node is editable or not
    property bool         isNodeEditable: sceneSession?.isSceneEditable ?? true

    //! Correct position based on zoomPoint and zoomFactor
    property vector2d       positionMapped: node.guiConfig?.position?.times(scaleFactor)

    /* Object Properties
    * ****************************************************************************************/

    //! NodeView scales relative to top left
    transform: Scale {
        xScale: scaleFactor
        yScale: scaleFactor
    }


    width: node.guiConfig.width
    height: node.guiConfig.height
    x: positionMapped.x
    y: positionMapped.y
    smooth: true
    antialiasing: true

    color: Qt.darker(node.guiConfig.color, 10)
    border.color: node.guiConfig.locked ? "gray" : node.guiConfig.color
    border.width: 2
    opacity: 0.8
    z: node.guiConfig.locked ? 1 : 2

    Behavior on color {ColorAnimation {duration:100}}
    Behavior on border.color {ColorAnimation {duration:100}}

    /* Children
    * ****************************************************************************************/

    //! Content Loader
    Loader {
        id: contentLoader
        anchors.fill: parent
        sourceComponent: contentItem
    }
}
