import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * ShortcutManager manage the key shortcut.
 * ************************************************************************************************/

Item {

    /* Property Declarations
    * ****************************************************************************************/
    property Scene              scene

    /* Children
    * ****************************************************************************************/

    //! Delete objects
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered:  {
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

    //! Delete selected Objects (Node or Link)
    function deleteSelectedObject() {
        var selectedNode = scene.selectionModel.selectedNode;
        var selectedLink = scene.selectionModel.selectedLink;

        if((selectedNode !== undefined && selectedNode !== null) ||
            (selectedLink !== undefined && selectedLink !== null))
            deletePopup.open();
    }
}
