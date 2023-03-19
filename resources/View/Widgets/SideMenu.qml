import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Side Menu
 * ************************************************************************************************/
Item {
    id: sideMenu1

    property SceneUndoObserver undoObserver

    /* Children
     * ****************************************************************************************/

    //! Zoom Buttons
    SideMenuButtonGroup {
        id: buttonGroup1
        //!Each button has a specific icon and position
        SideMenuButton {
            text: "\ue59e"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
                text: "Zoom in"
            }
        }
        SideMenuButton {
            text: "\uf2f9"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
                text: "Reset zoom"
            }
        }

        SideMenuButton {
            text: "\uf00e"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
                text: "Zoom to fit"
            }
        }

        SideMenuButton {
            text: "\ue404"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
                text: "Zoom out"
            }
        }
    }

    //! Undo/Redo
    SideMenuButtonGroup {
        id: buttonGroup2
        anchors.top: buttonGroup1.bottom
        anchors.topMargin: 8
        SideMenuButton {
            text: "\ue455"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            enabled: undoObserver.stackFlow.isValidUndo
            NLToolTip{
                visible: parent.hovered
                text: "Undo"
            }

            onClicked: {
                console.log("Undo click")
                undoObserver.stackFlow.undo();
            }
        }
        SideMenuButton {
            text: "\ue331"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            enabled: undoObserver.stackFlow.isValidRedo
            NLToolTip{
                visible: parent.hovered
                text: "Redo"
            }

            onClicked: {
                console.log("redo click")
                undoObserver.stackFlow.redo();
            }
        }
    }

    //! Snap/Grid Settings
    SideMenuButtonGroup {

        id: buttonGroup3
        anchors.top: buttonGroup2.bottom
        anchors.topMargin: 8
        SideMenuButton {
            id: snapGrid
            text: "\uf850"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            checkable: true
            onCheckedChanged: NLStyle.snapEnabled = snapGrid.checked
            NLToolTip{
                visible: parent.hovered
                text: "Snap tp grid"
            }
        }
        SideMenuButton {
            text: "\uf773"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
            }
        }
        SideMenuButton {
            text: "\uf518"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
            }
        }
    }

    //! Help
    SideMenuButtonGroup {
        id: buttonGroup4
        anchors.top: buttonGroup3.bottom
        anchors.topMargin: 8
        SideMenuButton {
            text: "\uf60b"
            position: "only"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip{
                visible: parent.hovered
                text: "Help"
            }
        }
    }
}
