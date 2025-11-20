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

    //! Uuids of all exist objects in scene.
    property var existObjects: []

    //! If notifySelectedObject is set to false, the selector object must handle this event..
    //! and call the selectedModelChanged() signal.
    property bool notifySelectedObject : true

    onExistObjectsChanged: checkSelectedObjects();

    /* Signals
     * ****************************************************************************************/

    signal selectedObjectChanged();

    /* Functions
     * ****************************************************************************************/

    //! Check all selected objects when necessary, i.e undo/redo
    function checkSelectedObjects () {
        notifySelectedObject = false;
        var changed = false;
        Object.keys(selectedModel).forEach(uuid => {
                                var obj = selectedModel[uuid];
                                // Check if object is null or invalid, or if it doesn't exist in existObjects
                                if (!obj || !obj._qsUuid || !existObjects.includes(uuid)) {
                                    remove(uuid);
                                    changed = true;
                                }
                             });

        notifySelectedObject = true;

        if (changed)
            selectedModelChanged();
    }

    //! Clear all objects from selection model
    function clear() {
        // delete all objects
        Object.entries(selectedModel).forEach(([key, value]) => {
                delete selectedModel[key];
        });

        if (notifySelectedObject)
            selectedModelChanged();
    }


    //! Clear all objects (except one with qsUuid) from selection model
    //! never sends signal for selection model change! as it will be followed by another event
    function clearAllExcept(qsUuid : string) {
        // delete all objects
        Object.entries(selectedModel).forEach(([key, value]) => {
            if(key !== qsUuid)
                delete selectedModel[key];
        });
    }

    //! Remove an object from selection model
    function remove(qsUuid : string) {
        if (isSelected(qsUuid)) {
            delete selectedModel[qsUuid];

            if (notifySelectedObject)
                selectedModelChanged();
        }
    }

    //! Select object nodes (Add Node object to SelectionModel)
    function selectNode(node: Node) {
        // Sanity check - skip null or invalid nodes
        if (!node || !node._qsUuid) {
            return;
        }
        //! clear selection model when selection changed.
        selectedModel[node._qsUuid] = node;

        if (notifySelectedObject)
            selectedModelChanged();
    }

    //! Select container
    function selectContainer(container: Container) {
        // Sanity check - skip null or invalid containers
        if (!container || !container._qsUuid) {
            return;
        }
        //! clear selection model when selection changed.
        selectedModel[container._qsUuid] = container;

        if (notifySelectedObject)
            selectedModelChanged();
    }

    //! Select Link objects  (Add link object to SelectionModel)
    function selectLink(link: Link) {
        // Sanity check - skip null or invalid links
        if (!link || !link._qsUuid) {
            return;
        }

        // Add Link object into selected model.
        selectedModel[link._qsUuid] = link;
        if (notifySelectedObject)
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

        if (lastSelectedObj && lastSelectedObj.objectType === objType)
            return lastSelectedObj;

        return null;
    }

    //! Selects all nodes and links in the scene
    function selectAll(nodes, links, containers) {
        var notifySelectedObjectSession = notifySelectedObject;
        notifySelectedObject = false;

        clear();

        Object.values(nodes).forEach(node => {
            selectNode(node);
        });

        Object.values(links).forEach(link => {
            selectLink(link);
        })

        Object.values(containers).forEach(container => {
            selectContainer(container);
        })

        notifySelectedObject = notifySelectedObjectSession;

        if (notifySelectedObject)
            selectedModelChanged();
    }
}
