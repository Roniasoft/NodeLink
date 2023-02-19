import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * SceneView show the Nodes, Connections, ports and etc.
 * ************************************************************************************************/

Flickable {
    id: flickable

    /* Property Declarations
    * ****************************************************************************************/
    property Scene scene

    property Node selectedNode

    property QtObject privateProperty: QtObject {
        property bool ctrlPressedAndHold: false
    }


    /* Object Properties
     * ****************************************************************************************/
    contentWidth: 2000
    contentHeight: 2000
    focus:  true

    ScrollBar.vertical: ScrollBar {
        width: 5
        policy: ScrollBar.AsNeeded
    }

    ScrollBar.horizontal: ScrollBar {
        height: 5
        policy: ScrollBar.AsNeeded
    }

    /* Children
    * ****************************************************************************************/
    SceneViewBackground {
        id: background
        anchors.fill: parent
        viewWidth: contentWidth
        viewHeigth: contentHeight
    }


    Keys.onPressed: event => {
            if (event.key === Qt.Key_Control) {
                privateProperty.ctrlPressedAndHold = true
            }
        }
    Keys.onReleased: privateProperty.ctrlPressedAndHold = false

    MouseArea {
        anchors.fill: parent
        z: -10
        onWheel: wheel => {
                     if(!privateProperty.ctrlPressedAndHold)
                     return;
                     if(wheel.angleDelta.y > 0)
                     flickable.scale += 0.1;
                     else if (flickable.scale > 0.5) {
                        flickable.scale -= 0.1;
                     }

                     console.log(flickable.scale)
        }

        onClicked: {
            scene.selectionModel.select(null)
            flickable.forceActiveFocus()
        }
    }

    // Draw nodes
    Repeater {
        model: Object.values(scene.nodes)
        delegate: NodeView {
            node: modelData
            scene: flickable.scene
            isSelected: modelData === scene.selectionModel.selectedNode
            onClicked: scene.selectionModel.select(modelData)
        }
    }

    Repeater {
        model: Object.entries(scene.portsDownstream).filter(([key, value]) => value.length > 0)
        delegate: ConnectionView {
            startPos: scene.portsPositions[modelData[0]]
            endPos: scene.portsPositions[modelData[1]]
        }
    }

}
