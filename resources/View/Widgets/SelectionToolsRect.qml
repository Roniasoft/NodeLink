import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import NodeLink

/*! ***********************************************************************************************
 * The toolbar appearing on top of
 * each selected objects (Node AND/OR Link).
 * ************************************************************************************************/

Rectangle {
    id: toolsItem

    /* Property Declarations
     * ****************************************************************************************/
    required property I_Scene       scene
    required property SceneSession  sceneSession

    //! Selected model (Node AND/OR links)
    property SelectionModel selectionModel: scene?.selectionModel ?? null

    //! Find all selected nodes
    property var selectedNode: Object.values(selectionModel?.selectedModel ?? ({})).filter(obj => obj?.objectType === NLSpec.ObjectType.Node)

    //! Find all selected links
    property var selectedLink: Object.values(selectionModel?.selectedModel ?? ({})).filter(obj => obj?.objectType === NLSpec.ObjectType.Link)

    /* Object Properties
     * ****************************************************************************************/
    radius: NLStyle.radiusAmount.itemButton
    height: 34
    width: layout.implicitWidth + 4
    border.color: "#363636"
    color: "#1e1e1e"
    z: 1000

    /* Children
     * ****************************************************************************************/

    //! A row of different buttons
    RowLayout {
        id: layout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3

        //! To display a representative property of links
        property var selectedObject: Object.values(selectionModel?.selectedModel ?? ({}))?.find((obj, index) => index === 0);

        property bool selectedNodeOnly: selectedNode.length > 0 && selectedLink.length === 0
        property bool selectedLinkOnly: selectedLink.length > 0 && selectedNode.length === 0

        property bool selectedANodeOnly: selectedNode.length === 1 && selectedLink.length === 0
        property bool selectedALinkOnly: selectedLink.length === 1 && selectedNode.length === 0

        //! Custom Tool  buttons
        Repeater {
            model: (sceneSession?.selectionToolButtons ?? []).
            filter(selectionTool => (selectionTool.enable && (selectionTool.type === NLSpec.SelectionSpecificToolType.All ||
            (layout.selectedANodeOnly && (selectionTool.type === NLSpec.SelectionSpecificToolType.Node || selectionTool.type === NLSpec.SelectionSpecificToolType.Any) ||
            (layout.selectedALinkOnly && (selectionTool.type === NLSpec.SelectionSpecificToolType.Link || selectionTool.type === NLSpec.SelectionSpecificToolType.Any))))));

            delegate: NLToolButton {
                text: modelData.icon
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                Layout.topMargin: 2
                Layout.bottomMargin: 2
                onClicked: {
                    // we need to figure out how we can handle custom buttons for multiple selection
                    modelData.clicked(layout.selectedObject);
                }
            }
        }

        //! Node/Link: Color change
        NLToolButton {
            id: colorButton1
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            text: "\uf53f"

            //! Color changer appears on all selected items
            onClicked: {
                colorPicker.visible = !colorPicker.visible
            }

            //! Set invisible when focus is false.
            onFocusChanged: {
                if(!focus)
                    colorPicker.visible = false;
            }

            //defining a color picker element to be used in the first button
            ColorPicker {
                id: colorPicker
                anchors.top: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 5
                visible: false
                onColorChanged: (colorName) => {
                                    Object.values(selectionModel.selectedModel).forEach(obj => {
                                                             obj.guiConfig.color = colorName;
                                                         });
                                }
           }
        }

        //! Node: Duplicating the card
        NLToolButton {
            id: duplicateButton
            text: "\uf24d"
            visible: layout.selectedANodeOnly
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            onClicked: scene.cloneNode(layout.selectedObject?._qsUuid);
        }

        //! Node: Locking the card
        NLToolButton {
            id: lockButton
            text: "\uf30d"
            visible: layout.selectedANodeOnly
            checkable: true
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            checked: layout.selectedObject?.guiConfig?.locked ?? false

            //! Enabling read only
            onClicked: layout.selectedObject.guiConfig.locked = checked;
        }

        //! Link: Edit discription
        NLToolButton {
            id: editLabelButton
            text: "\uf27a"
            visible: layout.selectedALinkOnly
            checkable: true
            checked: layout.selectedObject?.guiConfig?._isEditableDescription ?? false
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2

            //Enabling read only
            onClicked:{
                layout.selectedObject.guiConfig._isEditableDescription = editLabelButton.checked
            }

        }

        //! Link: Direction button
        NLToolButton {
            id: directionButton

            text: NLStyle.linkDirectionIcon[layout.selectedObject?.direction]
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            visible: layout.selectedLinkOnly
            onClicked: menu.open()

            // Select link direction
            Menu {
                id: menu
                y: directionButton.height

                // Nondirectional MenuItem
                NLMenuItem {
                    text: NLStyle.linkDirectionIcon[NLSpec.LinkDirection.Nondirectional]
                    description: "Nondirectional"
                    checked: layout.selectedObject?.direction === NLSpec.LinkDirection.Nondirectional
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.direction = NLSpec.LinkDirection.Nondirectional
                                             });
                    }
                }

                // Unidirectional MenuItem
                NLMenuItem {
                    text: NLStyle.linkDirectionIcon[NLSpec.LinkDirection.Unidirectional]
                    description: "Unidirectional"
                    checked: layout.selectedObject?.direction === NLSpec.LinkDirection.Unidirectional
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.direction = NLSpec.LinkDirection.Unidirectional
                                             });
                    }
                }

                // Bidirectional MenuItem
                NLMenuItem {
                    text: NLStyle.linkDirectionIcon[NLSpec.LinkDirection.Bidirectional]
                    description: "Bidirectional"
                    checked: layout.selectedObject?.direction === NLSpec.LinkDirection.Bidirectional
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.direction = NLSpec.LinkDirection.Bidirectional
                                             });
                    }
                }

                background: Item {
                    implicitWidth: 135
                    implicitHeight: 80
                    Rectangle {
                        id: toolButtonController
                        anchors.fill: parent
                        radius: NLStyle.radiusAmount.itemButton
                        color: "#1e1e1e"
                        opacity: enabled ? 1 : 0.3
                    }
                }
            }
        }

        //! Link: Style button
        NLToolButton {
            id: styleButton
            text: NLStyle.linkStyleIcon[layout.selectedObject?.guiConfig?.style]
            visible: layout.selectedLinkOnly
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            onClicked: styleMenu.open()

            // Select link Style
            Menu {
                id: styleMenu
                y: styleButton.height

                // Solid Line MenuItem
                NLMenuItem {
                    text: NLStyle.linkStyleIcon[NLSpec.LinkStyle.Solid]
                    description: "Solid Line"
                    checked: layout.selectedObject?.guiConfig?.style === NLSpec.LinkStyle.Solid
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.guiConfig.style = NLSpec.LinkStyle.Solid
                                             });
                    }
                }

                // Dash Line MenuItem
                NLMenuItem {
                    text: NLStyle.linkStyleIcon[NLSpec.LinkStyle.Dash]
                    description: "Dash Line"
                    checked: layout.selectedObject?.guiConfig?.style === NLSpec.LinkStyle.Dash
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.guiConfig.style = NLSpec.LinkStyle.Dash
                                             });
                    }
                }

                // Dot Line MenuItem
                NLMenuItem {
                    text: NLStyle.linkStyleIcon[NLSpec.LinkStyle.Dot]
                    description: "Dot Line"
                    checked: layout.selectedObject?.guiConfig?.style === NLSpec.LinkStyle.Dot
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.guiConfig.style = NLSpec.LinkStyle.Dot
                                             });
                    }
                }

                background: Item {
                    implicitWidth: 135
                    implicitHeight: 80
                    Rectangle {
                        anchors.fill: parent
                        radius: NLStyle.radiusAmount.itemButton
                        color: "#1e1e1e"
                        opacity: enabled ? 1 : 0.3
                    }
                }
            }
        }

        //! Link: Type Link button
        NLToolButton {
            id: typeButton
            text: NLStyle.linkTypeIcon[layout.selectedObject?.guiConfig?.type]
            visible: layout.selectedLinkOnly
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            onClicked: typeMenu.open()

            // Select link Type
            Menu {
                id: typeMenu
                y: typeButton.height

                // Bezier Line MenuItem
                NLMenuItem {
                    text: NLStyle.linkTypeIcon[NLSpec.LinkType.Bezier]
                    description: "Bezier Line"
                    checked: layout.selectedObject?.guiConfig?.type === NLSpec.LinkType.Bezier
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.guiConfig.type = NLSpec.LinkType.Bezier
                                             });
                    }
                }

                // L Line MenuItem
                NLMenuItem {
                    text: NLStyle.linkTypeIcon[NLSpec.LinkType.LLine]
                    description: "L Line"
                    checked: layout.selectedObject?.guiConfig?.type === NLSpec.LinkType.LLine
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.guiConfig.type = NLSpec.LinkType.LLine
                                             });
                    }
                }

                // Straight Line MenuItem
                NLMenuItem {
                    text: NLStyle.linkTypeIcon[NLSpec.LinkType.Straight]
                    description: "Straight Line"
                    checked: layout.selectedObject?.guiConfig?.type === NLSpec.LinkType.Straight
                    onTriggered: {
                        selectedLink.forEach(link => {
                                                 link.guiConfig.type = NLSpec.LinkType.Straight
                                             });
                    }
                }

                background: Item {
                    implicitWidth: 135
                    implicitHeight: 80
                    Rectangle {
                        anchors.fill: parent
                        radius: NLStyle.radiusAmount.itemButton
                        color: "#1e1e1e"
                        opacity: enabled ? 1 : 0.3
                    }
                }
            }
        }

        //! Node/Link: Delete button
        NLToolButton {
            id: deleteButton
            text: "\uf2ed"
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            //popup appears on click
            onClicked: deletePopup.open();

            //! Delete objects
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

                sceneSession: toolsItem.sceneSession
                confirmText: "Are you sure you want to delete " +
                             (Object.keys(selectionModel?.selectedModel ?? ({})).length > 1 ?
                                 "these items?" : "this item?");
                onAccepted: delTimer.start();
            }

        }
    }
}
