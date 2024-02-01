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

    onExistObjectsChanged: checkSelectedObjects();

    /* Signals
     * ****************************************************************************************/

    signal selectedObjectChanged();

    /* Functions
     * ****************************************************************************************/

    //! Check all selected objects when necessary, i.e undo/redo
    function checkSelectedObjects () {
        Object.keys(selectedModel).forEach(uuid => {
                                 if (!existObjects.includes(uuid))
                                        remove(uuid);
                             });
    }

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
    function selectNode(node: Node, notifySelectedObject = true) {
        //! clear selection model when selection changed.
        selectedModel[node._qsUuid] = node;

        //! If notifySelectedObject is set to false, the selector object must handle this event..
        //! and call the selectedModelChanged() signal.
        if (notifySelectedObject)
            selectedModelChanged();
    }

    //! Select container
    function selectContainer(container: Containe, notifySelectedObject = true) {
        //! clear selection model when selection changed.
        selectedModel[container._qsUuid] = container;

        //! If notifySelectedObject is set to false, the selector object must handle this event..
        //! and call the selectedModelChanged() signal.
        if (notifySelectedObject)
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

        if (lastSelectedObj && lastSelectedObj.objectType === objType)
            return lastSelectedObj;

        return null;
    }

    //! Selects all nodes and links in the scene
    function selectAll(nodes, links, containers) {
        clear();

        Object.values(nodes).forEach(node => {
            selectedModel[node._qsUuid] = node;
        });

        Object.values(links).forEach(link => {
            selectedModel[link._qsUuid] = link;
        })

        Object.values(containers).forEach(container => {
            selectedModel[container._qsUuid] = container;
        })

        selectedModelChanged();

    }
}
