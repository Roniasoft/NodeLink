import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The UndoStack representing the ability to undo and redo actions while maintaining
 * two "stacks" of changes made.
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Properties
     * ****************************************************************************************/

    property Scene scene

    //! Validation of Redo operation
    property bool isValidRedo: redoStack.length > 0

    //! Validation of Undo operation
    property bool isValidUndo: undoStack.length > 1

    //! Undo stack
    property var undoStack: []

    //! Redo stack
    property var redoStack: []

    /* Functions
     * ****************************************************************************************/

    //! Update stackFlow Model
    function updateStackFlow() {
        let targetObj = createStackObject(scene);
        let undoFirstObj = undoStack.find(obj => obj !== undefined);

        if(NLHashCompareString.compareStringModels(undoFirstObj, targetObj))
            return;

        redoStack = [];
        redoStackChanged();

        //insert object in first of stack
        undoStack.unshift(targetObj);
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

    //! Create stack object
    function createStackObject(scene : Scene) : string {
        let repoDump = NLCore.defaultRepo.dumpRepo()
        return JSON.stringify(repoDump, null, 4);
    }

    //! Load from SceneModel string and set to scene
    function setSceneObject(sceneString : string) {
        NLSpec.undoProperty.blockUndoStackConnection = true;

        var fileObjects = JSON.parse(sceneString);


        NLCore.defaultRepo.loadRepo(fileObjects);

        //One scene exist.
        for (var prop in NLCore.defaultRepo._qsObjects) {
            if(NLCore.defaultRepo._qsObjects[prop].qsType === "Scene") {
                scene = NLCore.defaultRepo._qsObjects[prop];
            }
        }

        NLSpec.undoProperty.blockUndoStackConnection = false;
    }
}