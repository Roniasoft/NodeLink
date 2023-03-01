import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Context Menu
 * ************************************************************************************************/
Menu {
    id: contextMenu

    /* Property Declarations
     * ****************************************************************************************/
    required property Scene scene;

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

    /* Children
     * ****************************************************************************************/
    ContextMenuItem{
        id: addCard
        onClicked: {
            scene.addNode(contextMenu.x,contextMenu.y)
            contextMenu.close()
        }
    }

}
