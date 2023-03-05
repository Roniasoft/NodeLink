import QtQuick
import NodeLink
import QtQuick.Layouts

/*! ***********************************************************************************************
 * Side Menu
 * ************************************************************************************************/
Item {

    /* Property Declarations
    * ****************************************************************************************/
    property Scene  scene

    /* Children
     * ****************************************************************************************/

    //! Zoom Buttons
    SideMenuButtonGroup {
        id: buttonGroup1

        property real tempZoomFactor: 1.0
        //!Each button has a specific icon and position
        SideMenuButton {
            text: "\ue59e"
            position: "top"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34

            onClicked: {
                if(scene.zoomFactor >= 3)
                    return;

                buttonGroup1.tempZoomFactor = scene.zoomFactor;
                scene.zoomFactor            += 0.05;
                scene.zoomPoint             = Qt.point(0, 0);
            }
        }

        SideMenuButton {
            text: "\uf2f9"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34

            onClicked: {
                scene.zoomFactor    = buttonGroup1.tempZoomFactor;
            }
        }

        SideMenuButton {
            text: "\uf00e"
            position: "middle"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34

            onClicked: {
                scene.fittingType = NLSpec.FittingType.AutoFit;
            }
        }

        SideMenuButton {
            text: "\ue404"
            position: "bottom"
            Layout.preferredHeight: 34
            Layout.preferredWidth: 34

            onClicked: {
                if(scene.zoomFactor <= 0.5)
                    return;

                buttonGroup1.tempZoomFactor = scene.zoomFactor;
                scene.zoomFactor            -= 0.05;
                scene.zoomPoint             = Qt.point(0, 0);
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
