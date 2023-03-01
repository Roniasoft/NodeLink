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
    height: 250

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
            scene.addNode(contextMenu.x+50,contextMenu.y+50)
            contextMenu.close()
        }
    }
}
