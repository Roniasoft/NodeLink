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
    Component.onCompleted: {
        //! Bindings are not needed so these are set here
        contentWidth = scene?.sceneGuiConfig?.contentWidth ?? 0;
        contentHeight = scene?.sceneGuiConfig?.contentHeight ?? 0;
        contentX = scene?.sceneGuiConfig?.contentX ?? 0;
        contentY = scene?.sceneGuiConfig?.contentY ?? 0;
    }

    // Update contentY when changed by user (No flick process)
    onContentXChanged: {
        if (scene && Math.abs(scene.sceneGuiConfig.contentX - contentX) > 0.001) {
            scene.sceneGuiConfig.contentX = contentX;
        }

        //! If not flicking and user is near right of content, extend contentWidth
        if (!flickingHorizontally) {
            const threshold = 200; // Pixels
            var isExtendWidthNeed = contentX + width > contentWidth - threshold;
            
            if (isExtendWidthNeed) {
                //! Add three times threshold
                const addWidth = 3 * threshold;

                scene.sceneGuiConfig.contentWidth = Math.min(scene.sceneGuiConfig.contentWidth + addWidth,
                                                             NLStyle.scene.maximumContentWidth)
            }
        }
    }
    
    // Update contentY when changed by user (No flick process)
    onContentYChanged: {
        if (scene && Math.abs(scene.sceneGuiConfig.contentY - contentY) > 0.001) {
            scene.sceneGuiConfig.contentY = contentY;
        }


        //! If not flicking and user is near right of content, extend contentHeight
        if (!flickingHorizontally) {
            const threshold = 200; // Pixels
            var isExtendWidthNeed = contentY + height > contentHeight - threshold;

            if (isExtendWidthNeed) {
                //! Add three times threshold
                const addHeight = 3 * threshold;

                scene.sceneGuiConfig.contentHeight = Math.min(scene.sceneGuiConfig.contentHeight + addHeight,
                                                             NLStyle.scene.maximumContentHeight)
            }
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
