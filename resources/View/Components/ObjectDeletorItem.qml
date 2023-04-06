import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * ObjectDeletorItem manage the deletion process of selected objects (Node and Lin).
 * ************************************************************************************************/

Item {
    id: root

    enum DeleteObjectType {
        Link     = 0,
        Node     = 1,
        Selected = 2
    }

    /* Property Declarations
    * ****************************************************************************************/
    property int      deleteObjectType: ObjectDeletorItem.DeleteObjectType.Selected
    property Node     node:             null
    property Link     link:             null
    property Scene    scene

    /* Children
    * ****************************************************************************************/

    //! Delete objects
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered:  {
            switch (deleteObjectType) {
            case ObjectDeletorItem.DeleteObjectType.Link : {
                scene.unlinkNodes(link.inputPort._qsUuid, link.outputPort._qsUuid)
                break;
            }

            case ObjectDeletorItem.DeleteObjectType.Node : {
                scene.deleteNode(node._qsUuid);
                break;
            }

            case ObjectDeletorItem.DeleteObjectType.Selected : {
                var selectedode = scene.selectionModel.selectedNode
                if(selectedode !== undefined && selectedode !== null) {
                    scene.deleteNode(selectedode._qsUuid);
                }

                var selectedLink = scene.selectionModel.selectedLink;
                if(selectedLink !== undefined && selectedLink !== null) {
                    scene.unlinkNodes(selectedLink.inputPort._qsUuid, selectedLink.outputPort._qsUuid)
                }
                break;
            }
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
            (selectedLink !== undefined && selectedLink !== null)) {
            deleteObjectType = ObjectDeletorItem.DeleteObjectType.Selected;
            deletePopup.open();
        }
    }

    function unlinkNodes(linkObj : Link) {
        deleteObjectType = ObjectDeletorItem.DeleteObjectType.Link;
        link = linkObj;
        deletePopup.open();
    }

    function deleteNode(nodeObj : Node) {
        deleteObjectType = ObjectDeletorItem.DeleteObjectType.Node;
        node = nodeObj;
        deletePopup.open();
    }
}
