
pragma Singleton

import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The NLStackFlow representing the ability to undo and redo actions while maintaining
 * a "stack" of changes made.
 * ************************************************************************************************/

QtObject {
    id: root

    //! current Scene Uuid
    property string currentSceneUuid: ""

    //! Validation of Redo operation
    property bool isValidRedo: false

    //! Validation of Undo operation
    property bool isValidUndo: false

    //! Current index of selected Scene
    property int   currentIndex: 1

    //! currentIndexMap keep the current index of all scenes
    //! map <SceneUUID : string, currentIndex : int>
    property var currentIndexMap: ({})

    //! map<SceneUUID, map<changeIndex: int, scene: Scene>>
    property var stackLogger: ({})

    //! Change the target scene
    function setScene(scene : Scene) {
        currentSceneUuid = scene._qsUuid;

        if (!Object.keys(stackLogger).includes(currentSceneUuid)) {
            stackLogger[currentSceneUuid] = [];
            currentIndexMap[currentSceneUuid] = 1;

            let obj = createStackObject(1, scene);
             stackLogger[currentSceneUuid].push(obj);
        }
        updateStackFlowStatus();
    }

    //!Update isValidRedo & isValidUndo status
    function updateStackFlowStatus() {
        var currentIndex = currentIndexMap[currentSceneUuid];
        var allObejcts   = stackLogger[currentSceneUuid].length;
        isValidUndo = currentIndex > 1;
        isValidRedo = currentIndex < allObejcts;
    }

    //! Update stackFlow Model
    function updateStackFlow(scene : Scene) {
        var sceneUUID = scene._qsUuid;

        var currentIndex = currentIndexMap[currentSceneUuid] + 1;
        currentIndexMap[currentSceneUuid] = currentIndex;

        deleteFromStackFlow(currentIndex, scene);
        let obj = createStackObject(currentIndex, scene);
         stackLogger[currentSceneUuid].push(obj);

        updateStackFlowStatus();
    }

    function deleteFromStackFlow(currentIndex : int, scene : Scene) {
        stackLogger[currentSceneUuid].splice(stackLogger[currentSceneUuid].findIndex(obj => obj.stackIndex >= currentIndex), 1);
//        for (const [objId, obj] of Object.entries(stackLogger)) {

//            if(obj.stackIndex >= currentIndex) {

//            }
//        }
//        Object.values(stackLogger).find(sObj => {
//            if (sObj.stackIndex >= currentIndex) {
//                delete stackLogger[portId];
//            }
//        });
    }

    //! Redo operation
    function redo() {
        if(!isValidRedo)
            return;

        var currentIndex = currentIndexMap[currentSceneUuid] + 1;
        currentIndexMap[currentSceneUuid] = currentIndex;

        updateStackFlowStatus();
//        let foundScene = null;

        return stackLogger[currentSceneUuid].find(obj => obj.stackIndex === currentIndex);
    }

    //! Undo Operation
    function undo() {
        if(!isValidUndo)
            return;

        var currentIndex = currentIndexMap[currentSceneUuid] - 1;
        currentIndexMap[currentSceneUuid] = currentIndex;

        updateStackFlowStatus();
//        let foundScene = null;

        return stackLogger[currentSceneUuid].find(obj => obj.stackIndex === currentIndex);
    }

    //! Create stack object
    function createStackObject(stackIndex : int, scene : Scene) : StackObject {
        let obj = Qt.createQmlObject("import QtQuick;" + "StackObject {}" , root);
        obj.stackIndex = stackIndex;
        obj.sceneModel = scene;

        return obj;

    }
}
