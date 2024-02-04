import QtQuick
import NodeLink
import QtQuickStream

/*! ***********************************************************************************************
 * The I_Node is the interface/base class for all objects inside the scene
 *
 * ************************************************************************************************/
QSObject {

    //! Type
    property int            objectType:     NLSpec.ObjectType.Unknown

    //! NodeData
    property I_NodeData     nodeData:       null

    /* Signals
       * ****************************************************************************************/

    //! Emit clone signal in clone or copy a node
    signal cloneFrom(baseNode: I_Node);

    /* Slots
     * ****************************************************************************************/

    //! will be called for all subclasses as well! add new object in each subclass
    //! Manage the cloning of nodes, enabling each subclass to copy its own properties.
    onCloneFrom: function (baseNode)  {
        // Copy direct properties in root.
        objectType = baseNode.objectType;
        nodeData?.setProperties(baseNode.nodeData);
    }
}
