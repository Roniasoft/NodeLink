import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Port view draw a port on the node based on Port model.
 * ************************************************************************************************/

Rectangle {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    //! Port Model
    property Port           port

    //! Scene
    property Scene          scene

    //! SceneSession
    property SceneSession   sceneSession

    //! GlobalX is set after positioning the port in the scene
    property int            globalX

    //! GlobalY is set after positioning the port in the scene
    property int            globalY

    //! GlobalPos is a 2d vector filled by globalX and globalY
    readonly property vector2d globalPos:      Qt.vector2d(globalX, globalY)

    //! Whenever GlobalPos is changed, we should update the
    //!  related maps in scene/sceneSession
    onGlobalPosChanged: {
        scene.portsPositions[port._qsUuid] = globalPos;
        scene.portsPositionsChanged();

        sceneSession.portsVisibility[port._qsUuid] = false;
        sceneSession.portsVisibilityChanged();
    }

    /* Object Properties
     * ****************************************************************************************/
    width: NLStyle.portView.size
    border.width: NLStyle.portView.borderSize
    height: width
    radius: width
    color: "#8b6cef"
    border.color: "#363636"
    scale: mouseArea.containsMouse ? 1.1 : 1


    // Behavior on opacity {NumberAnimation{duration: 100}}
    Behavior on scale {NumberAnimation{}}

    //! Mouse Area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !sceneSession.connectingMode
        propagateComposedEvents: true

        onPressed: mouse => {
            sceneSession.connectingMode = true;
            //Set mouse.accepeted to false to pass mouse events to last active parent
            mouse.accepted = false
        }

        onReleased: mouse => {
            sceneSession.connectingMode = false;
            //Set mouse.accepeted to false to pass mouse events to last active parent
            mouse.accepted = false
        }
    }
}
