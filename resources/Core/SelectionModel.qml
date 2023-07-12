import QtQuick

/*! ***********************************************************************************************
 * This class keeps track of a view's selected items
 *
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/
    //! Map <uuid, model(Node And/Or Link)>
    property var selectedModel: ({})


    /* Signals
     * ****************************************************************************************/

    signal selectedObjectChanged();

    /* Functions
     * ****************************************************************************************/
    //! Clear all objects from selection model
    function clear() {
        // delete all objects
        Object.entries(selectedModel).forEach(([key, value]) => {
                delete selectedModel[key];
        });
        selectedModelChanged();
    }


    //! Clear all objects (except one with qsUuid) from selection model
    function clearAllExcept(qsUuid : string) {
        // delete all objects
        Object.entries(selectedModel).forEach(([key, value]) => {
            if(key !== qsUuid)
                delete selectedModel[key];
        });
    }

    //! Remove an object from selection model
    function remove(qsUuid : string) {
        if(isSelected(qsUuid)) {
            delete selectedModel[qsUuid];
            selectedModelChanged();
        }
    }

    //! Select object nodes (Add Node object to SelectionModel)
    function selectNode(node: Node) {
        //! clear selection model when selection changed.
        selectedModel[node._qsUuid] = node;
        selectedModelChanged();
    }

    //! Select Link objects  (Add link object to SelectionModel)
    function selectLink(link: Link) {
        if (link === null)
            return;

        // Add Link object into selected model.
        selectedModel[link._qsUuid] = link;
        selectedModelChanged();
    }

    //! Check an object is selected or not
    function isSelected(qsUuid : string) : bool {
        return Object.keys(selectedModel).includes(qsUuid)
    }

    //! Return last selected object
    function lastSelectedObject(objType : int) {
        var lastSelectedObj = null;
        if(Object.keys(selectedModel).length === 0)
            return lastSelectedObj;

        lastSelectedObj = Object.values(selectedModel)[Object.keys(selectedModel).length - 1];

        if (lastSelectedObj.objectType === objType)
            return lastSelectedObj;

        return null;
    }
}
