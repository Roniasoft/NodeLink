import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * NLRepeater is a component for managing model overlays, it converts JS arrays to ListModel
 * to intelligently control model changes.
 * ************************************************************************************************/
Repeater {
    id: root

    /* Property Declarations
    * ****************************************************************************************/

    //! Temp model for connection to repeater and
    //! intelligent control of model changes
    property ListModel repeaterModel: ListModel {}

    /*  Object Properties
    * ****************************************************************************************/
    model: repeaterModel

    /* Functions
     * ****************************************************************************************/
    //! Add an element into model
    function addElement(qsObj) {
        repeaterModel.append({"qsObj": qsObj})
    }

    //! Remove an element from model
    function removeElement(qsObj) {
        for(var index = 0; index < repeaterModel.count; index++) {
            if(repeaterModel.get(index).qsObj._qsUuid === qsObj._qsUuid) {
                repeaterModel.remove(index)
                return;
            }
        }
    }
}
