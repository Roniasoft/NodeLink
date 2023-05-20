import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Context Menu to manage Node selection actions
 * ************************************************************************************************/
Menu {
    id: contextMenu

    /* Property Declarations
     * ****************************************************************************************/
    required property Scene scene
    required property Node  node

    property bool isNodeLock: false

    /* Object Properties
     * ****************************************************************************************/
    width: 180
    padding: 5
    //background is overrided
    background: Rectangle{
        anchors.fill: parent
        radius: 5
        color: "#262626"
        border.width: 1
        border.color: "#1c1c1c"
    }

    /* Signal
     * ****************************************************************************************/
    signal editNode()

    /* Children
     * ****************************************************************************************/
    ContextMenuItem {
        name: "Edit"
        iconStr: "\uf044"
        onClicked: {
            editNode();
        }
    }

    ContextMenuItem {
        name: "Duplicate Node"
        iconStr: "\uf24d"
        onClicked: {
            scene.cloneNode(node._qsUuid);
        }
    }

    ContextMenuItem {
        name: "Lock Node"
        iconStr: "\uf30d"
        checkable: true
        checked: isNodeLock
        onClicked: {
            isNodeLock = checked;
        }
    }
}
