import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import NodeLink

/*! ***********************************************************************************************
 * LinkView use I_LinkView (BezierCurve) to manages link children.
 * ************************************************************************************************/
I_LinkView {
    id: linkView

    /*  Object Properties
    * ****************************************************************************************/

    z: isSelected ? 10 : 1

    onIsSelectedChanged: {
        if(isSelected)
            forceActiveFocus();
        else {
            link.guiConfig._isEditableDescription = false;

            //! To hide color picker if selected node is changed and
            //! remove focus on description TextArea
            descriptionText.focus = false;
        }
    }


    //! Handle key pressed (Del: delete selected node and link)
    Keys.onDeletePressed: {
        if (!isSelected)
            return;

        if (!sceneSession.isSceneEditable) {
            infoPopup.open();
            return;
        }

        if (sceneSession.isDeletePromptEnable)
            deletePopup.open();
        else
            delTimer.start();
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

        confirmText: "Are you sure you want to delete " +
                                     (Object.keys(scene?.selectionModel?.selectedModel ?? ({})).length > 1 ?
                                         "these items?" : "this item?");

        sceneSession: linkView.sceneSession
        onAccepted: delTimer.start();
    }

    //! Information of a process
    ConfirmPopUp {
        id: infoPopup

        confirmText: "Can not be deleted! the scene is not editable"
        sceneSession: root.sceneSession
        keyButtons: [MessageDialog.Ok]
    }

    //! Bubble icon to appear when there is desciption but editMode is not enabled
    Text {
        id: descriptionIcon
        text: '\ue32e'
        font.pixelSize: 25
        x: linkMidPoint.x
        y: linkMidPoint.y
        color: NLStyle.primaryTextColor
        font.family: NLStyle.fontType.font6Pro
        visible: link.guiConfig.description.length > 0 && !link.guiConfig._isEditableDescription

        MouseArea {
            anchors.fill: parent
            onClicked: {
                link.guiConfig._isEditableDescription = true
            }
        }
    }

    // Description view
    NLTextArea {
        id: descriptionText

        x: linkMidPoint.x
        y: linkMidPoint.y

        text: link.guiConfig.description
        visible: (link.guiConfig.description.length > 0 || link.guiConfig._isEditableDescription) && !descriptionIcon.visible

        color: NLStyle.primaryTextColor
        font.family: NLStyle.fontType.roboto
        font.pointSize: 14
        focus: link.guiConfig._isEditableDescription

        onTextChanged: {
            if (link && link.description !== text)
                link.guiConfig.description = text;
        }

        leftPadding: 10
        rightPadding: 10

        background: Rectangle {
            radius: NLStyle.radiusAmount.linkView
            border.width: 3
            border.color: isSelected ? link.guiConfig.color : "transparent"
            color: "#1e1e1e"
        }

        onFocusChanged: {
            // select Link only when shiftModifier was pressed.
            if (sceneSession.isShiftModifierPressed) {
                linkView.forceActiveFocus();
                scene.selectionModel.selectLink(link);
                return;
            }

            if (focus && !isSelected) {
                scene.selectionModel.clear(link?._qsUuid);
                scene.selectionModel.selectLink(link);
                if (!sceneSession.isShiftModifierPressed)
                    link.guiConfig._isEditableDescription = true;
            } else if (focus) {
               link.guiConfig._isEditableDescription = true;
            }
        }
    }

    Connections {
        target: link.guiConfig

        //! Get the IsEditableDescriptionChanged signal and change
        //! focus to corresponding Item view
        function on_IsEditableDescriptionChanged () {
            if(link.guiConfig._isEditableDescription)
                descriptionText.forceActiveFocus();
        }
    }
}
