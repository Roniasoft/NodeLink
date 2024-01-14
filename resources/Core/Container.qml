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

    //! Nodes inside container
    property var    nodes: ({})

    //! Link Ui properties
    property ContainerGuiConfig guiConfig: ContainerGuiConfig {
        _qsRepo: root._qsRepo
    }

    /* Functions
     * ****************************************************************************************/

}
