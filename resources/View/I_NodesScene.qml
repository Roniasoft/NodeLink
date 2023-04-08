import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * I_NodesScene show the abstract the NodesScene properties.
 * ************************************************************************************************/

Flickable {
    id: root

    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf"
    }
    FontLoader {
        source: "qrc:/NodeLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf"
    }

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    property SceneSession       sceneSession

    /* Object Properties
    * ****************************************************************************************/
    anchors.fill: parent
    contentWidth: 4000
    contentHeight: 4000
    focus: true
    ScrollBar.horizontal: HorizontalScrollBar{}
    ScrollBar.vertical: VerticalScrollBar{}

    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        var selecteNode = scene.selectionModel.selectedNode
        var selectedLink = scene.selectionModel.selectedLink;

        if((selectedLink !== undefined && selectedLink !== null) ||
           (selecteNode !== undefined && selecteNode !== null)) {
            deletePopup.open();
        }
    }

    /* Children
    * ****************************************************************************************/
    //! Delete objects
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: {
            var selectedode = scene.selectionModel.selectedNode
            if(selectedode !== undefined && selectedode !== null) {
                scene.deleteNode(selectedode._qsUuid);
            }

            var selectedLink = scene.selectionModel.selectedLink;
            if(selectedLink !== undefined && selectedLink !== null) {
                scene.unlinkNodes(selectedLink.inputPort._qsUuid, selectedLink.outputPort._qsUuid)
            }
        }
    }

    //! Delete popup to confirm deletion process
    ConfirmPopUp {
        id: deletePopup
        onAccepted: delTimer.start();
    }
}
