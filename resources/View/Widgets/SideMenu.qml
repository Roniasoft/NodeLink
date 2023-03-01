import QtQuick
import NodeLink
import QtQuick.Layouts

/*! ***********************************************************************************************
 * Side Menu
 * ************************************************************************************************/
Item {
    id: sideMenu1

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
        }

        SideMenuButton {
            text: "\uf2f9"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
        }

        SideMenuButton {
            text: "\uf00e"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
        }

        SideMenuButton {
            text: "\ue404"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
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
        }
        SideMenuButton {
            text: "\ue331"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
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
            onClicked: {
                snapGrid.isChecked = !snapGrid.isChecked
                NLStyle.snapEnabled = snapGrid.isChecked
            }
        }
        SideMenuButton {
            text: "\uf773"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
        }
        SideMenuButton {
            text: "\uf518"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
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
        }
    }
}
