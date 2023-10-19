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
    contentWidth: scene?.sceneGuiConfig?.contentWidth ?? 0
    contentHeight: scene?.sceneGuiConfig?.contentHeight ?? 0
    contentX: scene?.sceneGuiConfig?.contentX ?? 0
    contentY: scene?.sceneGuiConfig?.contentY ?? 0

    // Update contentY when changed by user (No flick process)
    onContentXChanged: {
        if (!isFlickStarted && (scene.sceneGuiConfig.contentX - contentX) !== 0) {

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
        if (!isFlickStarted && (scene.sceneGuiConfig.contentY - contentY) !== 0) {

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


    //! Indicate start flick process.
    onFlickStarted: {
        isFlickStarted = true;
    }

    //! onMovementEnded to handle movments with flick.
    onMovementEnded: {
        if (!isFlickStarted)
            return;
        if (scene.sceneGuiConfig.contentX !== contentX)
            scene.sceneGuiConfig.contentX = contentX;

        if (scene.sceneGuiConfig.contentY !== contentY)
            scene.sceneGuiConfig.contentY = contentY;

        isFlickStarted = false
    }

    //! Update width
    onWidthChanged: {
        if (scene && scene.sceneGuiConfig.sceneViewWidth !== width)
            scene.sceneGuiConfig.sceneViewWidth = width;
    }

    //! Update height
    onHeightChanged: {
        if (scene && scene.sceneGuiConfig.sceneViewHeight !== height)
            scene.sceneGuiConfig.sceneViewHeight = height;
    }

	//! Update sceneGuiConfig properties (specifically, sceneViewWidth and sceneViewHeight)
    //! following a scene change from null to a defined object.
    onSceneChanged: {
        if (!scene)
            return;

        if (scene.sceneGuiConfig.sceneViewWidth !== width)
            scene.sceneGuiConfig.sceneViewWidth = width;

        if (scene.sceneGuiConfig.sceneViewHeight !== height)
            scene.sceneGuiConfig.sceneViewHeight = height;
    }

    focus: true

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }


}
