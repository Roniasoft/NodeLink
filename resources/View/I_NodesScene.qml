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

    //! SceneGuiConfig to store/retrieve the visual properties of scene
    property SceneGuiConfig sceneGuiConfig: scene.sceneGuiConfig

    //! When contents (contentX and contentY) change with a behavior,
    //! content changed signals must be blocked.
    //! use enableContentsBehavior property to block them when is necessary.
    property bool           enableContentsBehavior:  false

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: sceneGuiConfig.contentWidth
    contentHeight: sceneGuiConfig.contentHeight
    contentX: sceneGuiConfig.contentX
    contentY: sceneGuiConfig.contentY

    // Update contentY when changed by user (No flick process)
    onContentXChanged: {
        if (enableContentsBehavior)
            return;

        if (!flicking && (sceneGuiConfig.contentX - contentX) !== 0) {

            var isExtendWidthNeed = contentX + root.width > sceneGuiConfig.contentWidth;

            // Ignore the negative value.
            var tcontentX = Math.max(0, contentX);

            if (isExtendWidthNeed) {
                // The addWidth needed to add into current flickable width.
                // if width is extended by Node (node creation or movements),
                // we ignore the maximum value and add the addWidth into flickable width.
                var addWidth = contentX + root.width - sceneGuiConfig.contentWidth;
                if (sceneGuiConfig.contentWidth + addWidth < NLStyle.scene.maximumContentWidth) {
                    sceneGuiConfig.contentWidth += addWidth;

                } else {
                    // Maximum value of contentWidth
                    sceneGuiConfig.contentWidth = NLStyle.scene.maximumContentWidth;

                    // Maximum value of contentX
                    tcontentX = sceneGuiConfig.contentWidth - root.width;
                }
            }

            sceneGuiConfig.contentX = tcontentX;
        }
    }

    // Update contentY when changed by user (No flick process)
    onContentYChanged: {
        if (enableContentsBehavior)
            return;

        if (!flicking && (sceneGuiConfig.contentY - contentY) !== 0) {

            var isExtendHeightNeed = contentY + root.height > sceneGuiConfig.contentHeight;

            // Ignore the negative value.
             var tcontentY = Math.max(0, contentY);

            if (isExtendHeightNeed) {
                // The addHeight needed to add into current flickable height.
                // if height is extended by Node (node creation or movements),
                // we ignore the maximum value and add the addHeight into flickable height.
                var addHeight = contentY + root.height - sceneGuiConfig.contentHeight;

                if (sceneGuiConfig.contentHeight + addHeight < NLStyle.scene.maximumContentHeight) {
                    sceneGuiConfig.contentHeight += addHeight;

                } else {
                    sceneGuiConfig.contentHeight = NLStyle.scene.maximumContentHeight;
                    tcontentY = sceneGuiConfig.contentHeight - root.height;
                }
            }

            sceneGuiConfig.contentY = tcontentY;
        }
    }

    //! onMovementEnded to handle movments with flick.
    onFlickEnded: {
        if ((sceneGuiConfig.contentX - contentX) !== 0)
            sceneGuiConfig.contentX = contentX;

        if ((sceneGuiConfig.contentY - contentY) !== 0)
            sceneGuiConfig.contentY = contentY;
    }

    //! Update width
    onWidthChanged: {
        if (sceneGuiConfig && (sceneGuiConfig.sceneViewWidth - width) !== 0)
            sceneGuiConfig.sceneViewWidth = width;
    }

    //! Update height
    onHeightChanged: {
        if (sceneGuiConfig && (sceneGuiConfig.sceneViewHeight - height) !== 0)
            sceneGuiConfig.sceneViewHeight = height;
    }

    focus: true

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }
}
