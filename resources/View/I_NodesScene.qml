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

    //! When contents (contentX and contentY) change with a behavior,
    //! content changed signals must be blocked.
    //! use enableContentsBehavior property to block them when is necessary.
    property bool           enableContentsBehavior:  false

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: scene.sceneGuiConfig.contentWidth
    contentHeight: scene.sceneGuiConfig.contentHeight
    contentX: scene.sceneGuiConfig.contentX
    contentY: scene.sceneGuiConfig.contentY

    // Update contentY when changed by user (No flick process)
    onContentXChanged: {
        if (!flicking && (scene.sceneGuiConfig.contentX - contentX) !== 0) {

            var isExtendWidthNeed = contentX + root.width > scene.sceneGuiConfig.contentWidth;

            // Ignore the negative value.
            var tcontentX = Math.max(0, contentX);

            if (isExtendWidthNeed) {
                // The addWidth needed to add into current flickable width.
                // if width is extended by Node (node creation or movements),
                // we ignore the maximum value and add the addWidth into flickable width.
                var addWidth = contentX + root.width - scene.sceneGuiConfig.contentWidth;
                if (scene.sceneGuiConfig.contentWidth + addWidth < NLStyle.scene.maximumContentWidth) {
                    scene.sceneGuiConfig.contentWidth += addWidth;

                } else {
                    // Maximum value of contentWidth
                    scene.sceneGuiConfig.contentWidth = NLStyle.scene.maximumContentWidth;

                    // Maximum value of contentX
                    tcontentX = scene.sceneGuiConfig.contentWidth - root.width;
                }
            }

            scene.sceneGuiConfig.contentX = tcontentX;
        }
    }

    // Update contentY when changed by user (No flick process)
    onContentYChanged: {
        if (!flicking && (scene.sceneGuiConfig.contentY - contentY) !== 0) {

            var isExtendHeightNeed = contentY + root.height > scene.sceneGuiConfig.contentHeight;

            // Ignore the negative value.
             var tcontentY = Math.max(0, contentY);

            if (isExtendHeightNeed) {
                // The addHeight needed to add into current flickable height.
                // if height is extended by Node (node creation or movements),
                // we ignore the maximum value and add the addHeight into flickable height.
                var addHeight = contentY + root.height - scene.sceneGuiConfig.contentHeight;

                if (scene.sceneGuiConfig.contentHeight + addHeight < NLStyle.scene.maximumContentHeight) {
                    scene.sceneGuiConfig.contentHeight += addHeight;

                } else {
                    scene.sceneGuiConfig.contentHeight = NLStyle.scene.maximumContentHeight;
                    tcontentY = scene.sceneGuiConfig.contentHeight - root.height;
                }
            }

            scene.sceneGuiConfig.contentY = tcontentY;
        }
    }

    //! onMovementEnded to handle movments with flick.
    onFlickEnded: {
        if ((sceneSession.contentX - contentX) !== 0)
            sceneSession.contentX = contentX;

        if ((sceneSession.contentY - contentY) !== 0)
            sceneSession.contentY = contentY;
    }

    //! Update width
    onWidthChanged: {
        if ((sceneSession.sceneViewWidth - width) !== 0)
            sceneSession.sceneViewWidth = width;
    }

    //! Update height
    onHeightChanged: {
        if ((sceneSession.sceneViewHeight - height) !== 0)
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
