import QtQuick
import NodeLink
import QtQuick.Controls

/*! ***********************************************************************************************
 * LinkView use I_LinkView (BezierCurve) to manages link children.
 * ************************************************************************************************/
I_LinkView {
    id: linkView

    /*  Object Properties
    * ****************************************************************************************/

    z: isSelected ? 10 : 0

    onIsSelectedChanged: {
        if(isSelected)
            forceActiveFocus();
        else
            link.guiConfig._isEditableDescription = false;
    }


    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if(linkView.isSelected)
            deletePopup.open();
    }

    /* Children
    * ****************************************************************************************/

    //! Delete link
    Timer {
        id: delTimer
        repeat: false
        running: false
        interval: 100
        onTriggered: scene.deleteSelectedObjects();
    }

    //! Delete popup to confirm deletion process
    ConfirmPopUp {
        id: deletePopup
        onAccepted: delTimer.start();
    }

    // Description view
    TextArea {
        id: descriptionText
        x: linkMidPoint.x
        y: linkMidPoint.y

        text: link.guiConfig.description
        visible: link.guiConfig.description.length > 0 || link.guiConfig._isEditableDescription

        color: "white"
        font.family: "Roboto"
        font.pointSize: 14
        focus: link.guiConfig._isEditableDescription

        onTextChanged: {
            if (link && link.description !== text)
                link.guiConfig.description = text;
        }

        leftPadding: 10
        rightPadding: 10

        background: Rectangle {
            radius: 5
            border.width: 3
            border.color: isSelected ? link.guiConfig.color : "transparent"
            color: "#1e1e1e"
        }

        onFocusChanged: {
            if(focus && !isSelected) {
                scene.selectionModel.toggleLinkSelection(link);
                link.guiConfig._isEditableDescription = true;
            } else if (focus) {
               link.guiConfig._isEditableDescription = true;
            }
        }
    }

    Connections {
        target: scene

        // Send paint requset when PortsPositionsChanged
        function onPortsPositionsChanged () {
            linkView.requestPaint();
        }
    }

    Connections {
        target: link.guiConfig

        // Send paint requset when ColorChanged
        function onColorChanged () {
            linkView.requestPaint();
        }

        function on_isEditableDescription () {
            descriptionText.focus = link.guiConfig._isEditableDescription;

        }
    }

    //! To hide color picker if selected node is changed and
    //! remove focus on description TextArea
    Connections {
        target: linkView
        function onIsSelectedChanged() {
                descriptionText.focus = false;
        }
    }

//    MouseArea {
//       anchors.fill: parent

//       enabled: isSelected && !descriptionText.activeFocus
//       onDoubleClicked: descriptionText.forceActiveFocus();
//    }
}
