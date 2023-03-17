
import QtQuick
import QtQuick.Controls
import NodeLink


QtObject {

    //! stackIndex
    property int stackIndex: 0

    //! Scene model
    property Scene sceneModel

    //! Scene Uuid, for search in StackObjects
    property string sceneUuid: sceneModel._qsUuid

}
