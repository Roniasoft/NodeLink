import QtQuick

import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Scene GUI Config. To store the visual properties of scene
 * ************************************************************************************************/
QSObject {
    /* Property Properties
     * ****************************************************************************************/
    //! Zoom factor
    property real zoomFactor : 1.0

    //! Width and height of flickable in ui session
    property real contentWidth : NLStyle.scene.defaultContentWidth
    property real contentHeight: NLStyle.scene.defaultContentHeight

    //! ContentX and contentY of flickable in ui session
    property real contentX: NLStyle.scene.defaultContentX
    property real contentY: NLStyle.scene.defaultContentY

    //! Scene view width and height of flickable in ui session
    property real sceneViewWidth
    property real sceneViewHeight

    //! Mouse position in scene, used for paste based on mouse positions! // \TODO: find better approach
    property vector2d       _mousePosition:    Qt.vector2d(0.0, 0.0)

}
