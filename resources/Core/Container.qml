import QtQuick
import QtQuickStream
import NodeLink

/*! ***********************************************************************************************
 * Container for group items
 * ************************************************************************************************/
QSObject {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Name
    property string title: "group item"

    property int   objectType:     NLSpec.ObjectType.Container

    //! Nodes inside container
    property var    nodes: ({})

    //! Link Ui properties
    property ContainerGuiConfig guiConfig: ContainerGuiConfig {
        _qsRepo: root._qsRepo
    }

    /* Functions
     * ****************************************************************************************/
    function addNode(node: Node) {
        nodes[node._qsUuid] = node;
        nodesChanged();
    }

    function removeNode(node: Node) {
        delete nodes[node._qsUuid];
        nodesChanged();
    }

    Component.onCompleted: {
        objectType = NLSpec.ObjectType.Container
    }
}
