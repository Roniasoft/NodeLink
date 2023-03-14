import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * Context Menu
 * ************************************************************************************************/
Menu {
    id: contextMenu

    /* Property Declarations
     * ****************************************************************************************/
    required property Scene  scene;
    required property QSCore coreStreamer;

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
            scene.addNode(coreStreamer.defaultRepo, contextMenu.x,contextMenu.y)
            contextMenu.close()
        }
    }

}
