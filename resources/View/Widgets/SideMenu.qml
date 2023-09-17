import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Side Menu
 * ************************************************************************************************/
Item {
    id: sideMenu1

    property I_Scene      scene
    property SceneSession sceneSession

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

            onClicked: sceneSession.zoomManager.zoomInSignal();
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

            onClicked: sceneSession.zoomManager.resetZoomSignal(1.0);
        }

        SideMenuButton {
            text: "\uf00e"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            NLToolTip {
                visible: parent.hovered
                text: "Zoom to fit"
            }

            onClicked: sceneSession.zoomManager.zoomToFit();
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

            onClicked: sceneSession.zoomManager.zoomOutSignal();
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
            enabled: scene._undoCore.undoStack.isValidUndo
            NLToolTip{
                visible: parent.hovered
                text: "Undo"
            }

            onClicked: {
                scene._undoCore.undoStack.undo();

                // Set the focus within the scene
                sceneSession.sceneForceFocus();
            }
        }
        SideMenuButton {
            text: "\ue331"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
            enabled: scene._undoCore.undoStack.isValidRedo
            NLToolTip{
                visible: parent.hovered
                text: "Redo"
            }

            onClicked: {
                scene._undoCore.undoStack.redo();

                // Set the focus within the scene
                sceneSession.sceneForceFocus();
            }
        }
    }

    //! Snap/Grid/Overview Settings
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
                text: "Snap to grid"
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

        //! Show/hide the overview
        SideMenuButton {
            text: "\uf065"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34

            checkable: true
            checked: sceneSession.visibleOverview

            NLToolTip{
                text: ((sceneSession.visibleOverview ? "Hide " : "Show ") +"the overview")
                visible: parent.hovered
            }

            onClicked: {
                sceneSession.visibleOverview = !sceneSession.visibleOverview

                // Set the focus within the scene
                sceneSession.sceneForceFocus();
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

            onClicked:  {
                // Set the focus within the scene
                sceneSession.sceneForceFocus();
            }
        }
    }
}
