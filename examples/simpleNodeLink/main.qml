import QtQuick
import NodeLink
import QtQuickStream
import QtQuick.Dialogs
import QtQuick.Controls 2.12

Window {
    id: window
    width: 1280
    height: 960
    visible: true
    title: qsTr("Simple NodeLink Example")
    color: "#1e1e1e"

    //! init one QSCore with several Repos (Add repos);
    property QSCore coreStreamer: QSCore {
        defaultRepo: createDefaultRepo([ "QtQuickStream" ]);
    }

    property Scene scene: NLCore.createScene(coreStreamer.defaultRepo)


    NLView {
        scene: window.scene
        coreStreamer: window.coreStreamer
        anchors.fill: parent
    }

    //! 2. Save and load handlers
    Rectangle {
        anchors.left:  parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10

        width: 400
        height: 40

        color: "#b0aeab"

        Button {
            text: "Save"

            width: 150
            anchors.left: parent.left
            anchors.margins: 20
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                radius: 5
                color: "#6899e3"
            }

            onClicked: {
                coreStreamer.defaultRepo.initRootObject("QSObject");
                saveDialog.visible = true
            }
        }

        Button {
            text: "Load"
            anchors.right: parent.right
            anchors.margins: 20
            anchors.verticalCenter: parent.verticalCenter

            width: 150
            background: Rectangle {
                radius: 5
                color: "#eb5e65"
            }
            onClicked: loadDialog.visible = true
        }

    }

    //Save
    FileDialog {
        id: saveDialog
        currentFile: "QtQuickStream.QQS.json"
        fileMode: FileDialog.SaveFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            coreStreamer.defaultRepo.saveToFile(saveDialog.currentFile);
        }
    }

    //! Load
    FileDialog {
        id: loadDialog
        currentFile: "QtQuickStream.QQS.json"
        fileMode: FileDialog.OpenFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            coreStreamer.defaultRepo._localImports =  [ "QtQuickStream", "NodeLink"]

            coreStreamer.defaultRepo.loadFromFile(loadDialog.currentFile);

            //One scene exist.
            for (var prop in coreStreamer.defaultRepo._qsObjects) {
                if(coreStreamer.defaultRepo._qsObjects[prop].qsType === "Scene") {
                    window.scene = coreStreamer.defaultRepo._qsObjects[prop];
                }
            }

        }
    }
}
