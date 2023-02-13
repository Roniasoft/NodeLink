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

    /* Object Properties
     * ****************************************************************************************/
    contentWidth: 2000
    contentHeight: 2000

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
        anchors.fill: parent
        viewWidth: contentWidth
        viewHeigth: contentHeight
    }

    //Draw nodes
    Repeater {
        model: scene.nodes
        delegate: NodeView {
            node: modelData
        }
    }
}
