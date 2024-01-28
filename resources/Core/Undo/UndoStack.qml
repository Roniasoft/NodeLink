import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The UndoStack is responsible of undo/redo actions and keeping
 * two "stacks" for them.
 * ************************************************************************************************/
QtObject {
    id: root

    /* Property Declarations
     * ****************************************************************************************/
    //! Target scene
    required property I_Scene       scene

    //! Validation of Redo operation
    property bool   isValidRedo:    redoStack.length > 0

    //! Validation of Undo operation
    property bool   isValidUndo:    undoStack.length > 1

    //! Undo stack
    property var    undoStack:      []

    //! Redo stack
    property var    redoStack:      []

    property var    correctRepo:    scene?._qsRepo ?? NLCore.defaultRepo

    property Timer timer : Timer {
        repeat: false
        interval: 300
        onTriggered: {
            root.updateStacks();
        }
    }

    /* Signals
     * ****************************************************************************************/
    signal stacksUpdated();

    signal undoRedoDone()

    signal updateUndoStack();

    /* Object Properties
     * ****************************************************************************************/
    Component.onCompleted: timer.start();

    onUpdateUndoStack: {
        if (!NLSpec.undo.blockObservers)
            timer.restart();
    }

    /* Functions
     * ****************************************************************************************/
    //! Update stackFlow Model
    function updateStacks() {
        let dumpedRepo = dumpRepo(scene);
        let undoFirstObj = undoStack.find(obj => obj !== undefined);

        if(HashCompareString.compareStringModels(undoFirstObj, dumpedRepo))
            return;

        redoStack = [];
        redoStackChanged();

        //insert object in first of stack
        undoStack.unshift(dumpedRepo);
        undoStackChanged();
        stacksUpdated();
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
        stacksUpdated();
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
        stacksUpdated();
    }

    //! Dump repo for stack
    function dumpRepo(scene : I_Scene) : string {
        let repoDump = correctRepo.dumpRepo()
        return JSON.stringify(repoDump, null, 4);
    }

    //! Load from SceneModel string and set to scene
    function setSceneObject(sceneString : string) {

        // Block observers while loading new scene instance
        NLSpec.undo.blockObservers = true;

        var fileObjects = JSON.parse(sceneString);

        // Update imports if necessary
        var nodeLinkImport = "NodeLink";
        if(!correctRepo._allImports.includes(nodeLinkImport)) {
            correctRepo._localImports.push(nodeLinkImport);
            correctRepo._localImportsChanged();
        }

        correctRepo.loadRepo(fileObjects);

        // Unblock Observers
        NLSpec.undo.blockObservers = false;
        undoRedoDone();
    }
}
