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

    property Scene scene: NLCore.createScene()

    Component.onCompleted: NLCore.defaultRepo.initRootObject("QSObject");

    NLView {
        scene: window.scene
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
            NLCore.defaultRepo.saveToFile(saveDialog.currentFile);
        }
    }

    //! Load
    FileDialog {
        id: loadDialog
        currentFile: "QtQuickStream.QQS.json"
        fileMode: FileDialog.OpenFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            NLCore.defaultRepo._localImports =  [ "QtQuickStream", "NodeLink"]

            NLCore.defaultRepo.loadFromFile(loadDialog.currentFile);

            //One scene exist.
            for (var prop in NLCore.defaultRepo._qsObjects) {
                if(NLCore.defaultRepo._qsObjects[prop].qsType === "Scene") {
                    window.scene = NLCore.defaultRepo._qsObjects[prop];
                }
            }

        }
    }
}
