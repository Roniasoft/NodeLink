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
    property string title: "Untitled"

    //! Object type
    property int   objectType:     NLSpec.ObjectType.Container

    //! Nodes inside container
    property var    nodes: ({})

    //! Containers inside container
    property var containersInside: ({})

    //! Container Ui properties
    property ContainerGuiConfig guiConfig: ContainerGuiConfig {
        _qsRepo: root._qsRepo
    }

    /* Signals
    * ****************************************************************************************/
    signal cloneFrom(container: Container);

    /* Children
    * ****************************************************************************************/
    //! Override function
    //! Manage the cloning of containers, enabling each subclass to copy its own properties.
    onCloneFrom: function (container)  {
        root.guiConfig?.setProperties(container.guiConfig);
    }

    //! Fixing Object Type
    Component.onCompleted: {
        objectType = NLSpec.ObjectType.Container
    }
    /* Functions
     * ****************************************************************************************/
    //! Adding inner node
    function addNode(node: Node) {
        nodes[node._qsUuid] = node;
        nodesChanged();
    }

    //! Removing inner node
    function removeNode(node: Node) {
        delete nodes[node._qsUuid];
        nodesChanged();
    }

    //! Adding inner container
    function addContainerInside(container: Container) {
        containersInside[container._qsUuid] = container;
        containersInsideChanged();
    }

    //! Removing inner container
    function removeContainerInside(container: Container) {
        delete containersInside[container._qsUuid];
        containersInsideChanged();
    }
}
