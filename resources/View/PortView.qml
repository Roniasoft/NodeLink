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
    property I_Scene          scene

    //! SceneSession
    property SceneSession   sceneSession: null

    //! GlobalX is set after positioning the port in the scene
    property real           globalX

    //! GlobalY is set after positioning the port in the scene
    property real           globalY

    //! GlobalPos is a 2d vector filled by globalX and globalY
    readonly property vector2d globalPos:      Qt.vector2d(globalX, globalY)

    //! Whenever GlobalPos is changed, we should update the
    //!  related maps in scene/sceneSession
    onGlobalPosChanged: {
        port._position = globalPos;

        if (sceneSession && !sceneSession.isRubberBandMoving) {
            sceneSession.portsVisibility[port._qsUuid] = false;
            sceneSession.portsVisibilityChanged();
        }
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

    opacity: 1    // always visible

    // Behavior on opacity {NumberAnimation{duration: 100}}
    Behavior on scale {NumberAnimation{}}

    //! Mouse Area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -2

        enabled: sceneSession && !sceneSession.connectingMode
        propagateComposedEvents: true

        onPressed: mouse => {
            if (!port.enable)
                return;

            selectionFunction(port._qsUuid);
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

    //! Selects the port's parent node
    function selectionFunction(inputPortId) {
        const isModifiedOn = sceneSession.isShiftModifierPressed;
        var inputPortNodeId = scene.findNodeId(inputPortId)
        var inputPortNode = scene.findNode(inputPortId)

        if(!isModifiedOn)
            scene.selectionModel.clearAllExcept(inputPortNodeId);

        const isAlreadySel = scene.selectionModel.isSelected(inputPortNodeId);

        if(isAlreadySel && isModifiedOn)
            scene.selectionModel.remove(inputPortNodeId);
        else
            scene.selectionModel.selectNode(inputPortNode);
    }


    Text {
        id: portTitle
        text: port.title
        color: "white"
        font.pixelSize: NLStyle.portView.fontSize * (sceneSession ? (1 / sceneSession.zoomManager.zoomFactor) : 1)
        wrapMode: Text.NoWrap
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        anchors.verticalCenter: parent.verticalCenter

        // default: label on right
        anchors.left: parent.right
        anchors.leftMargin: 4


        Component.onCompleted: {
            positionLabel()
        }

        function positionLabel() {
            anchors.left = undefined
            anchors.right = undefined
            anchors.top = undefined
            anchors.bottom = undefined
            anchors.leftMargin = 0
            anchors.rightMargin = 0
            anchors.topMargin = 0
            anchors.bottomMargin = 0

            switch (port.portSide) {
            case NLSpec.PortPositionSide.Left:
                anchors.left = parent.right
                anchors.leftMargin = 4
                break
            case NLSpec.PortPositionSide.Right:
                anchors.right = parent.left
                anchors.rightMargin = 4
                break
            case NLSpec.PortPositionSide.Top:
                anchors.top = parent.bottom
                anchors.topMargin = 2
                break
            case NLSpec.PortPositionSide.Bottom:
                anchors.bottom = parent.top
                anchors.bottomMargin = 2
                break
            }
        }

    }
}
