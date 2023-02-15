import QtQuick 2.15

/*! ***********************************************************************************************
 * This class keeps track of a view's selected items
 *
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/
    property Node selectedNode



    /* Signals
     * ****************************************************************************************/
    signal currentChanged(var node);

    signal selectionChanged(var node);


    /* Functions
     * ****************************************************************************************/
    function clear() {

    }

    function clearSelection() {

    }

    function reset() {

    }

    function select(node: Node) {
        selectedNode = node;
    }
}
