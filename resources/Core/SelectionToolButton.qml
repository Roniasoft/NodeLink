import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * SelectionToolsRect Model contain a selection tool button and manage it.
 * ************************************************************************************************/

QtObject {

    /* Property Declarations
    * ****************************************************************************************/

    //! Name
    property string name: ""

    //! Icon
    property string icon: ""

    //! Node and/or Link or all types
    property int    type: NLSpec.SelectionToolObjectType.Node

    /* Signals
    * ****************************************************************************************/

    signal clicked(node: I_Node);

}
