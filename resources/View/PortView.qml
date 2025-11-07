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

    // This gets set from parent
    property real nodeWidth: 0

    /* Object Properties
     * ****************************************************************************************/

    width: NLStyle.portView.size
    height: NLStyle.portView.size

    radius: width / 2
    color: "#8b6cef"

    border.color: "#363636"

    opacity: 1    // always visible

    border.width: NLStyle.portView.borderSize


    // TextMetrics to measure actual text width
    TextMetrics {
        id: textMetrics
        font: portTitle.font
        text: port.title
    }

    // Calculate available space based on node width and port side
    function calculateAvailableSpace() {
        if (nodeWidth <= 0) return 100;

        var availableSpace = 0;
        switch (port.portSide) {
        case NLSpec.PortPositionSide.Left:
        case NLSpec.PortPositionSide.Right:
            // Each side gets half the node width minus port circle and margins
            availableSpace = (nodeWidth / 2) - (width + 25);
            break;
        case NLSpec.PortPositionSide.Top:
        case NLSpec.PortPositionSide.Bottom:
            availableSpace = 80; // Fixed reasonable amount
            break;
        }
        return Math.max(availableSpace, 20); // Minimum 20px
    }

    // Determine if we need to elide based on text width vs available space
    function needsElide() {
        var availableSpace = calculateAvailableSpace();
        return textMetrics.width > availableSpace;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -2

        enabled: sceneSession && !sceneSession.connectingMode
        propagateComposedEvents: true

        onPressed: mouse => {
            if (!port.enable) return;
            selectionFunction(port._qsUuid);
            sceneSession.connectingMode = true;
            mouse.accepted = false
        }

        onReleased: mouse => {
            sceneSession.connectingMode = false;
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

    // DYNAMIC TEXT WITH PROPER ELIDE LOGIC
    Text {
        id: portTitle
        text: port.title
        color: "white"
        font.pixelSize: NLStyle.portView.fontSize * (sceneSession ? (1 / sceneSession.zoomManager.zoomFactor) : 1)
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter

        // Dynamic width: constrained only if text is too long
        width: root.needsElide() ? root.calculateAvailableSpace() : implicitWidth

        // Smart elide: only when needed, different modes per side
        elide: root.needsElide() ? (
            port.portSide === NLSpec.PortPositionSide.Left ? Text.ElideRight :
            port.portSide === NLSpec.PortPositionSide.Right ? Text.ElideLeft :
            Text.ElideMiddle
        ) : Text.ElideNone

        anchors.verticalCenter: parent.verticalCenter

        Component.onCompleted: {
            positionLabel()
            reportSize()

            // Update text metrics when text changes
            port.titleChanged.connect(function() {
                textMetrics.text = port.title;
            });
        }
        onTextChanged: reportSize()
        onFontChanged: reportSize()
        onImplicitWidthChanged: reportSize()

        function positionLabel() {
            anchors.left = undefined
            anchors.right = undefined
            anchors.top = undefined
            anchors.bottom = undefined

            if (port.portSide === NLSpec.PortPositionSide.Left) {
                anchors.left = parent.right
                anchors.leftMargin = 8
                horizontalAlignment = Text.AlignLeft
            } else if (port.portSide === NLSpec.PortPositionSide.Right) {
                anchors.right = parent.left
                anchors.rightMargin = 8
                horizontalAlignment = Text.AlignRight
            } else if (port.portSide === NLSpec.PortPositionSide.Top) {
                anchors.top = parent.bottom
                anchors.topMargin = 2
                horizontalAlignment = Text.AlignHCenter
            } else if (port.portSide === NLSpec.PortPositionSide.Bottom) {
                anchors.bottom = parent.top
                anchors.bottomMargin = 2
                horizontalAlignment = Text.AlignHCenter
            }
        }

        function reportSize() {
            port._measuredTitleWidth = implicitWidth
            if (port.node) port.node.requestRecalculateFromPort()
        }
    }

    // Update text width when node resizes
    onNodeWidthChanged: {
        portTitle.width = root.needsElide() ? root.calculateAvailableSpace() : portTitle.implicitWidth;
    }
}
