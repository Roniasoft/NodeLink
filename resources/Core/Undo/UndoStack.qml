import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The UndoStack is responsible of undo/redo actions and keeping
 * two "stacks" for them.
 * ************************************************************************************************/
QtObject {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    //! Target scene
    required property Scene    scene

    //! Validation of Redo operation
    property bool   isValidRedo:    redoStack.length > 0

    //! Validation of Undo operation
    property bool   isValidUndo:    undoStack.length > 1

    //! Undo stack
    property var    undoStack:      []

    //! Redo stack
    property var    redoStack:      []

    /* Functions
     * ****************************************************************************************/

    //! Update stackFlow Model
    function updateStacks() {
        let dumpedRepo = dumpRepo(scene);
        let undoFirstObj = undoStack.find(obj => obj !== undefined);

        if(NLHashCompareString.compareStringModels(undoFirstObj, dumpedRepo))
            return;

        redoStack = [];
        redoStackChanged();

        //insert object in first of stack
        undoStack.unshift(dumpedRepo);
        undoStackChanged();
    }

    //! Redo operation
    function redo() {
        if(!isValidRedo)
            return;

        var sceneModel = redoStack.shift();
        undoStack.unshift(sceneModel);
        redoStackChanged();
        undoStackChanged();
        setSceneObject(sceneModel);
    }

    //! Undo Operation
    function undo() {
        if(!isValidUndo)
            return;

        // Delete first element of redo stack and move it to redoStack.
        redoStack.unshift(undoStack.shift());
        // Find the first element of redoStack and load it
        var sceneModel = undoStack.find(obj => obj !== undefined);;
        redoStackChanged();
        undoStackChanged();
        setSceneObject(sceneModel);
    }

    //! Dump repo for stack
    function dumpRepo(scene : Scene) : string {
        let repoDump = NLCore.defaultRepo.dumpRepo()
        return JSON.stringify(repoDump, null, 4);
    }

    //! Load from SceneModel string and set to scene
    function setSceneObject(sceneString : string) {

        // Block observers while loading new scene instance
        NLSpec.undo.blockObservers = true;

        var fileObjects = JSON.parse(sceneString);


        NLCore.defaultRepo.loadRepo(fileObjects);

        //One scene exist.
        for (var prop in NLCore.defaultRepo._qsObjects) {
            if(NLCore.defaultRepo._qsObjects[prop].qsType === "Scene") {
                scene = NLCore.defaultRepo._qsObjects[prop];
            }
        }

        // Unblock Observers
        NLSpec.undo.blockObservers = false;
    }
}
