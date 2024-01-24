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
    //! Current node (or container)
    property var     node

    //! Scene is the main model containing information about all nodes/links
    property I_Scene  scene

    //! SceneSession
    property SceneSession   sceneSession:   null

    //! viewProperties encompasses all view properties that are not included
    //! in either the scene or the scene session.
    property QtObject       viewProperties: null

    //! Node Contents
    property Component      contentItem:    null

    //! Scale factor to rescale the node view.
    property real           scaleFactor:    1.0

    //! Correct position based on zoomPoint and zoomFactor
    property vector2d       positionMapped: node.guiConfig?.position ?? Qt.vector2d(0, 0)

    //! Whether the object is a container or not
    property bool           isContainer:    false
    /* Object Properties
    * ****************************************************************************************/

    visible: node && scene

    width: node.guiConfig.width
    height: node.guiConfig.height
    x: positionMapped.x
    y: positionMapped.y
    smooth: true
    antialiasing: true

    color: Qt.darker(node?.guiConfig?.color ?? "transparent", 10)
    border.color: (node?.guiConfig?.locked ?? true) ? NLStyle.node.borderLockColor : node.guiConfig.color
    border.width: NLStyle.node.borderWidth
    opacity: NLStyle.node.defaultOpacity
    z: (node?.guiConfig?.locked ?? false) ? 1 : 2

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
