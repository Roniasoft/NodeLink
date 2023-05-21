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

    //! Map <uuid, model(Node And/Or Link)>
    property var selectedModel: ({})


    /* Signals
     * ****************************************************************************************/

    /* Functions
     * ****************************************************************************************/
    //! Clear all objects from selection model
    function clear() {
        selectedNode = null;
        selectedLink = null;
        // delete related links
        Object.entries(selectedModel).forEach(([key, value]) => {
                delete selectedModel[key];
        });

        selectedModelChanged();
    }

    //! Remove an object from selection model
    function remove(qsUuid : string) {
        if(selectedNode._qsUuid === qsUuid)
            selectedNode = null;

        if(selectedLink._qsUuid === qsUuid)
            selectedLink = null;

        if(Object.keys(selectedModel).includes(qsUuid)) {
            delete selectedModel[qsUuid];
            selectedModelChanged();
        }
    }

    function clearSelection() {
    }

    function reset() {
    }

    //! Select an object node
    function select(node: Node) {
        //! clear selection model when selection changed.
        selectedLink = null;
        selectedNode = node;
        selectedModel[node._qsUuid] = node;
        selectedModelChanged();
    }

    //! Toggle Link Selection (deselect if is selected already)
    function toggleLinkSelection(link: Link) {
        if (link === null)
            return;

        // Add Link object into selected model.
        selectedModel[link._qsUuid] = link;

        // toggle selection with last link selection
        selectedNode = null;
        selectedLink = link;;
        selectedModelChanged();
    }

    //! Check an object is selected or not
    function isSelected(qsUuid : string) : bool {
        console.log("is selected ",Object.keys(selectedModel), Object.keys(selectedModel).includes(qsUuid))
        return Object.keys(selectedModel).includes(qsUuid)
    }
}
