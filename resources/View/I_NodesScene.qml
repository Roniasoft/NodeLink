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

    //! isFlickStarted, set true when a flick process started.
    property bool isFlickStarted: false

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: sceneSession.contentWidth
    contentHeight: sceneSession.contentHeight
    contentX: sceneSession.contentX
    contentY: sceneSession.contentY

    // Update contentY when changed by user (No flick process)
    onContentXChanged: {
        if (!isFlickStarted && (sceneSession.contentX - contentX) !== 0) {

            var isExtendWidthNeed = contentX + root.width > sceneSession.contentWidth;

            // Ignore the negative value.
            var tcontentX = Math.max(0, contentX);

            if (isExtendWidthNeed) {
                // The addWidth needed to add into current flickable width.
                // if width is extended by Node (node creation or movements),
                // we ignore the maximum value and add the addWidth into flickable width.
                var addWidth = contentX + root.width - sceneSession.contentWidth;
                if (sceneSession.contentWidth + addWidth < NLStyle.scene.maximumContentWidth ||
                        sceneSession.contentWidth > NLStyle.scene.maximumContentWidth) {
                    sceneSession.contentWidth += addWidth;

                } else {
                    // Maximum value of contentWidth
                    sceneSession.contentWidth = NLStyle.scene.maximumContentWidth;

                    // Maximum value of contentX
                    tcontentX = sceneSession.contentWidth - root.width;
                }
            }

            sceneSession.contentX = tcontentX;
        }
    }

    // Update contentY when changed by user (No flick process)
    onContentYChanged: {
        if (!isFlickStarted && (sceneSession.contentY - contentY) !== 0) {

            var isExtendHeightNeed = contentY+ root.height > sceneSession.contentHeight;

            // Ignore the negative value.
             var tcontentY = Math.max(0, contentY);

            if (isExtendHeightNeed) {
                // The addHeight needed to add into current flickable height.
                // if width is extended by Node (node creation or movments),
                // we ignore the maximum value and add the addHeight into flickable height.
                var addHeight = contentX + root.height - sceneSession.contentHeight;

                if (sceneSession.contentHeight + addHeight < NLStyle.scene.maximumContentHeight ||
                        sceneSession.contentHeight > NLStyle.scene.maximumContentHeight) {
                    sceneSession.contentHeight += addHeight;
                    tcontentY = contentY;

                } else {
                    sceneSession.contentHeight = NLStyle.scene.maximumContentHeight;
                    tcontentY = sceneSession.contentHeight - root.height;
                }
            }

            sceneSession.contentY = tcontentY;
        }
    }


    //! Indicate start flick process.
    onFlickStarted: {
        isFlickStarted = true;
    }

    //! onMovementEnded to handle movments with flick.
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
