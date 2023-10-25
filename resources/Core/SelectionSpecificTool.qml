import QtQuick

import NodeLink

/*! ***********************************************************************************************
 * SelectionSpecificTool contains a selection tool button model.
 * ************************************************************************************************/

QtObject {

    /* Property Declarations
    * ****************************************************************************************/

    //! Name can be used for debugging (Optional)
    property string name: ""

    //! Icon which will be shown in menu (get from fontAwesome 6)
    property string icon: ""

    //! Enable can be used to control when the corrosponding button should be visible (Optional)
    property bool   enable: true

    //! Node and/or Link or all types
    property int    type: NLSpec.SelectionSpecificToolType.Any

    /* Signals
    * ****************************************************************************************/

    //! should be called upon clicking the corrosponding button
    signal clicked(node: I_Node);

}
