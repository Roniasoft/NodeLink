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
    property real zoomFactor

    //! width and height of flickable in ui session
    property real contentWidth : NLStyle.scene.defaultContentWidth
    property real contentHeight: NLStyle.scene.defaultContentHeight

    //! ContentX and contentY of flickable in ui session
    property real contentX: NLStyle.scene.defaultContentX
    property real contentY: NLStyle.scene.defaultContentY

    //! ContentX and contentY of flickable in ui session
    property real sceneViewWidth
    property real sceneViewHeight
}
