import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The StackFlowCore representing the ability to undo and redo actions while maintaining
 * a "stack" of changes made.
 * ************************************************************************************************/

QtObject {
    id: root

    /* Property Properties
     * ****************************************************************************************/

    property Scene scene

    //! Validation of Redo operation
    property bool isValidRedo: false

    //! Validation of Undo operation
    property bool isValidUndo: false

    //! Current index of selected Scene
    property int   currentIndex: 0

    //! Array<StackObject>
    property var stackLogger: []

    /* Functions
     * ****************************************************************************************/

    //! Change the target scene
    function setScene(scene : Scene) {
        let obj = createStackObject(1, scene);
        updateStackFlowStatus();
    }

    //!Update isValidRedo & isValidUndo status
    function updateStackFlowStatus() {
        var allObejcts   = stackLogger.length;
        isValidUndo = currentIndex > 1;
        isValidRedo = currentIndex < allObejcts;
    }

    //! Update stackFlow Model
    function updateStackFlow() {

        currentIndex++;
        deleteFromStackFlow(currentIndex);
        let obj = createStackObject(currentIndex, scene);
        stackLogger.push(obj);
        updateStackFlowStatus();
    }

    //! Delete stackFlow model that is ahead of the current model.
    function deleteFromStackFlow(currentIndex : int) {
        for (var prop in stackLogger) {
            if(stackLogger[prop].stackIndex >= currentIndex) {
                stackLogger.splice(currentIndex, 1);
            }
        }
    }

    //! Redo operation
    function redo() {
        if(!isValidRedo)
            return;

        currentIndex++;
        updateStackFlowStatus();
        setSceneObject(currentIndex);
    }

    //! Undo Operation
    function undo() {
        if(!isValidUndo)
            return;

        currentIndex--;
        updateStackFlowStatus();
        setSceneObject(currentIndex);
    }

    //! Create stack object
    function createStackObject(stackIndex : int, scene : Scene) : StackObject {
        let obj = Qt.createQmlObject("import QtQuick; import NodeLink;" + "StackObject {}" , root);
        obj.stackIndex = stackIndex;

        let repoDump = NLCore.defaultRepo.dumpRepo()
        obj.sceneModel = JSON.stringify(repoDump, null, 4);

        return obj;
    }

    //! Load from SceneModel string and set to scene
    function setSceneObject(index : int) {
         NLCore.blockStackFlowConnection = true;
            var fileObjects = ""; // = JSON.parse(stackLogger.find(obj => obj.stackIndex === currentIndex).sceneModel);
            //        let foundScene = null;
            Object.values(stackLogger).find(obj => {
                if (obj.stackIndex === index) {
                    fileObjects = JSON.parse(obj.sceneModel);
                }
                });

        NLCore.defaultRepo._localImports =  ["NodeLink"];
        NLCore.defaultRepo.loadRepo(fileObjects);

        //One scene exist.
        for (var prop in NLCore.defaultRepo._qsObjects) {
            if(NLCore.defaultRepo._qsObjects[prop].qsType === "Scene") {
                scene = NLCore.defaultRepo._qsObjects[prop];
            }
        }

        NLCore.blockStackFlowConnection = false;
    }
}
