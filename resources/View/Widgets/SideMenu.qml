import QtQuick
import NodeLink
import QtQuick.Layouts
import "../Components"

/*! ***********************************************************************************************
 * Side Menu
 * ************************************************************************************************/

Item {

    //!Each group consists of one or more buttons
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
    SideMenuButtonGroup {
        id: buttonGroup3
        anchors.top: buttonGroup2.bottom
        anchors.topMargin: 8
        SideMenuButton {
            text: "\uf850"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34
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
