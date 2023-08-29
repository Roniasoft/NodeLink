import QtQuick
import NodeLink
import QtQuick.Controls
import QtQuick.Layouts

/*! ***********************************************************************************************
 * This class show node ui.
 * ************************************************************************************************/
Rectangle {
    id: nodeView

    /* Property Declarations
     * ****************************************************************************************/
    property Node         node

    property Scene        scene

    property SceneSession sceneSession


    //! Node is selected or not
    property bool         isSelected:     scene?.selectionModel?.isSelected(modelData?._qsUuid ?? "") ?? false

    //! Node is in minimal state or not (based in zoom factor)
    property bool         isNodeMinimal:  true
    property real          topLeftX
    property real          topLeftY
    property real scaleFactorWidth
    property real scaleFactorHeight


    /* Object Properties
     * ****************************************************************************************/
    width: node.guiConfig.width * scaleFactorWidth
    height: node.guiConfig.height * scaleFactorHeight
    x: (node.guiConfig?.position?.x - topLeftX) * scaleFactorWidth/* * 0.2*/
    y: (node.guiConfig?.position?.y - topLeftY) * scaleFactorHeight/* * 0.2*/

    color: Qt.darker(node.guiConfig.color, 10)
    border.color: node.guiConfig.locked ? "gray" : Qt.lighter(node.guiConfig.color, nodeView.isSelected ? 1.2 : 1)
    border.width: (nodeView.isSelected ? 3 : 2)
    opacity: nodeView.isSelected ? 1 :  nodeView.isNodeMinimal ? 0.6 : 0.8
    z: node.guiConfig.locked ? 1 : (isSelected ? 3 : 2)
    radius: NLStyle.radiusAmount.nodeView * Math.min(scaleFactorHeight,scaleFactorWidth)
    smooth: true
    antialiasing: true
    layer.enabled: false


    Behavior on color {ColorAnimation {duration:100}}
    Behavior on border.color {ColorAnimation {duration:100}}

    /* Slots
     * ****************************************************************************************/

    //! When node is selected, width, height, x, and y
    //! changed must be sent into rubber band
    onWidthChanged: dimensionChanged();
    onHeightChanged: dimensionChanged();

    onXChanged: dimensionChanged();
    onYChanged: dimensionChanged();

    onIsSelectedChanged: {
        //! Current nodeView keep the focus, current focus handle in the upper layers.
        nodeView.forceActiveFocus();

    }


    /* Children
    * ****************************************************************************************/

    //! Header Item

    //! Minimal nodeview in low zoomFactor
    Rectangle {
        id: minimalRectangle
        anchors.fill: parent
        anchors.margins: 10

        color: nodeView.isNodeMinimal ? "#282828" : "trasparent"
        radius: NLStyle.radiusAmount.nodeView * Math.min(scaleFactorHeight,scaleFactorWidth)

        //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0.7
        OpacityAnimator {
            target: minimalRectangle

            from: minimalRectangle.opacity
            to: 0.7
            duration: 200
            running: nodeView.isNodeMinimal
        }

        //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0
        OpacityAnimator {
            target: minimalRectangle

            from: minimalRectangle.opacity
            to: 0
            duration: 200
            running: !nodeView.isNodeMinimal
        }

        //! Text Icon
        Text {
            font.family: NLStyle.fontType.font6Pro
            font.pixelSize: 60 * Math.min(scaleFactorHeight,scaleFactorWidth)
            anchors.centerIn: parent
            text: NLStyle.nodeIcons[node.type]
            color: node.guiConfig.color
            font.weight: 400
            visible: nodeView.isNodeMinimal
        }
    }

    //! Manage node selection and position change.


    //! Top Ports
    Row {
        id: topRow
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Top);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (sceneSession.portsVisibility[modelData._qsUuid])? 1 : 0

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(topRow.x + x + NLStyle.portView.size / 2,
                                                              topRow.y + y + NLStyle.portView.size / 2)


//                globalX: nodeView.x + positionMapped.x
//                globalY: nodeView.y + positionMapped.y
            }
        }
    }

    //! Left Ports
    Column {
        id: leftColumn
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Left);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (sceneSession.portsVisibility[modelData._qsUuid])? 1 : 0

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(leftColumn.x + x + NLStyle.portView.size / 2,
                                                     leftColumn.y + y + NLStyle.portView.size / 2)


//                globalX: nodeView.x + positionMapped.x
//                globalY: nodeView.y + positionMapped.y
            }
        }
    }

    //! Right Ports
    Column {
        id: rightColumn
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5         // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Right);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (sceneSession.portsVisibility[modelData._qsUuid]) ? 1 : 0

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(rightColumn.x + x + NLStyle.portView.size / 2,
                                                              rightColumn.y + y + NLStyle.portView.size / 2)


//                globalX: nodeView.x + positionMapped.x
//                globalY: nodeView.y + positionMapped.y
            }
        }
    }

    //! Bottom Ports
    Row {
        id: bottomRow
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: -(NLStyle.portView.size + NLStyle.portView.borderSize - nodeView.border.width) / 2 // we should use the size/2 of port from global style file
        spacing: 5          // this can also be defined in the style file

        Repeater {
            model: Object.values(node.ports).filter(port => port.portSide === NLSpec.PortPositionSide.Bottom);
            delegate: PortView {
                port: modelData
                scene: nodeView.scene
                sceneSession: nodeView.sceneSession
                opacity: (sceneSession.portsVisibility[modelData._qsUuid]) ? 1 : 0

                //! Mapped position based on PortView, container and zoom factor
                property vector2d positionMapped: Qt.vector2d(bottomRow.x + x + NLStyle.portView.size / 2,
                                                              bottomRow.y + y + NLStyle.portView.size / 2)


//                globalX: nodeView.x + positionMapped.x
//                globalY: nodeView.y + positionMapped.y
            }
        }
    }
    //! Reset some properties when selection model changed.

    /* Functions
     * ****************************************************************************************/

    //! Handle dimension change
    function dimensionChanged() {
        if(nodeView.isSelected)
            scene.selectionModel.selectedObjectChanged();
    }
}
