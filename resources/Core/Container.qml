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

    property var containersInside: ({})

    signal cloneFrom(container: Container);

    /* Slots
     * ****************************************************************************************/


    //! Link Ui properties
    property ContainerGuiConfig guiConfig: ContainerGuiConfig {
        _qsRepo: root._qsRepo
    }

    //! Override function
    //! Manage the cloning of containers, enabling each subclass to copy its own properties.
    onCloneFrom: function (container)  {
        root.guiConfig?.setProperties(container.guiConfig);
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

    function addContainerInside(container: Container) {
        containersInside[container._qsUuid] = container;
        containersInsideChanged();
    }

    function removeContainerInside(container: Container) {
        delete containersInside[container._qsUuid];
        containersInsideChanged();
    }

    Component.onCompleted: {
        objectType = NLSpec.ObjectType.Container
    }
}
