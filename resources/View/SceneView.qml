import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * SceneView show the Nodes, Connections, ports and etc.
 * ************************************************************************************************/

Flickable {
    id: sceneView

    /* Property Declarations
    * ****************************************************************************************/
    property SceneManager scene

    property Node selectedNode

    property QtObject privateProperty: QtObject {
        property bool ctrlPressedAndHold: false
    }


    /* Object Properties
     * ****************************************************************************************/
    contentWidth: 2000
    contentHeight: 2000
    focus:  true

//    ScrollBar.vertical: ScrollBar {
//        width: 5
//        policy: ScrollBar.AsNeeded
//    }

//    ScrollBar.horizontal: ScrollBar {
//        height: 5
////        policy: ScrollBar.AsNeeded
//    }

    /* Children
    * ****************************************************************************************/
    SceneViewBackground {
        id: background
        anchors.fill: parent
        viewWidth: contentWidth
        viewHeigth: contentHeight
    }

    //Draw connecions
    Repeater {
        model: scene.connections
        delegate: ConnectionView {
            connection: modelData
        }
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
                     sceneView.scale += 0.1;
                     else if (sceneView.scale > 0.5) {
                        sceneView.scale -= 0.1;
                     }

                     console.log(sceneView.scale)
        }

        onClicked: {
            sceneManager.selection.select(null)
            sceneView.forceActiveFocus()
        }
    }



    //Draw nodes
    Repeater {
        model: scene.nodes
        delegate: NodeView {
            node: modelData
            sceneManager: scene
            isSelected: modelData === sceneManager.selection.selectedNode
            onClicked: sceneManager.selection.select(modelData)
        }
    }
}
