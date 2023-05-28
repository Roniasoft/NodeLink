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
}
