import QtQuick 2.15

/*! ***********************************************************************************************
 * This class keeps track of a view's selected items
 *
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/
    //! Selected Node
    property Node selectedNode

    //! Selected Link
    property Link selectedLink



    /* Signals
     * ****************************************************************************************/

    /* Functions
     * ****************************************************************************************/
    function clear() {
        selectedNode = null;
        selectedLink = null;
    }

    function clearSelection() {
    }

    function reset() {
    }

    function select(node: Node) {
        selectedNode = node;
    }

    //! Toggle Link Selection (deselect if is selected already)
    function toggleLinkSelection(link: Link) {
        if (link === null)
            return;

        // toggle selection
        selectedLink = (selectedLink === null || link._qsUuid !== selectedLink._qsUuid)
                ? link
                : null;
    }
}
