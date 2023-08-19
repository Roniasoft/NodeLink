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

        confirmText: "Are you sure you want to delete " +
                                     (Object.keys(scene.selectionModel.selectedModel).length > 1 ?
                                         "these items?" : "this item?");

        sceneSession: linkView.sceneSession
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
        font.family: NLStyle.fontType.roboto
        font.pointSize: 14
        focus: link.guiConfig._isEditableDescription

        //! Scale with zoomFactor
        transform: Scale {
            xScale: sceneSession.zoomManager.zoomFactor
            yScale: sceneSession.zoomManager.zoomFactor
        }

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
