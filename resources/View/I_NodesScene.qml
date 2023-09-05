import QtQuick
import QtQuick.Controls

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * I_NodesScene show the abstract the NodesScene properties.
 * ************************************************************************************************/
Flickable {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Scene is the main model containing information about all nodes/links
    property I_Scene        scene:          null

    //! Scene session contains information about scene states (UI related)
    property SceneSession   sceneSession:   null

    //! Scene Background
    property Component      background:     null

    //! Scene Contents (Nodes/Links)
    property Component      contentItem:    null

    //! Scene Foreground
    property Component      foreground:     null

    //! isFlickStarted
    property bool isFlickStarted: false

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: sceneSession.contentWidth
    contentHeight: sceneSession.contentHeight
    contentX: sceneSession.contentX
    contentY: sceneSession.contentY

    //! Update contentX
    onContentXChanged: {
        if (!isFlickStarted && sceneSession.contentX !== contentX)
            sceneSession.contentX = contentX;
    }

    //! Update contentY
    onContentYChanged: {

        if (!isFlickStarted && sceneSession.contentY !== contentY)
            sceneSession.contentY = contentY;
    }

    onFlickStarted: {
        isFlickStarted = true;
    }

    onMovementEnded: {
        if (!isFlickStarted)
            return;
        if (sceneSession.contentX !== contentX)
            sceneSession.contentX = contentX;

        if (sceneSession.contentY !== contentY)
            sceneSession.contentY = contentY;

        isFlickStarted = false

    }

    //! Update width
    onWidthChanged: {
        if (sceneSession.sceneViewWidth !== width)
            sceneSession.sceneViewWidth = width;
    }

    //! Update height
    onHeightChanged: {
        if (sceneSession.sceneViewHeight !== height)
            sceneSession.sceneViewHeight = height;
    }

    focus: true

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }


}
