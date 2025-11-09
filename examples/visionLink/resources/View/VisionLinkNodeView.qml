import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

import NodeLink
import VisionLink

NodeView {
    id: nodeView

    contentItem: Loader {
        id: dynamicContent
        anchors.fill: parent

        function loadNodeView() {
            if (!node) return;


            switch (node?.type ?? CSpecs.NodeType.ImageInput)  {
                case (CSpecs.NodeType.ImageInput): {
                    sourceComponent = imageInputComponent;
                    break;
                }
                case (CSpecs.NodeType.ImageResult): {
                    sourceComponent = imageResultComponent;
                    break;
                }
                case (CSpecs.NodeType.Blur): {
                    sourceComponent = blurOperationComponent;
                    break;
                }
                case (CSpecs.NodeType.Brightness): {
                    sourceComponent = brightnessOperationComponent;
                    break;
                }
                case (CSpecs.NodeType.Contrast): {
                    sourceComponent = contrastOperationComponent;
                    break;
                }
            }
        }

        Connections {
            target: node
            function onTypeChanged() {
                dynamicContent.loadNodeView();
            }
        }

        Component.onCompleted: loadNodeView()
    }

    // ===============================
    // Image Result Component
    // ===============================
    Component {
        id: imageResultComponent

        Item {
            id: imageNodeItem
            property var node: nodeView?.node

            //! Header Item
            Item {
                id: titleItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12

                visible: !nodeView.isNodeMinimal
                height: 20

                //! Icon
                Text {
                    id: iconText
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                }

                //! Title Text
                NLTextArea {
                    id: titleTextArea

                    anchors.right: parent.right
                    anchors.left: iconText.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: 40

                    rightPadding: 10

                    readOnly: !nodeView.edit
                    placeholderText: qsTr("Image Result")
                    color: NLStyle.primaryTextColor
                    text: node.title
                    onTextChanged: if (node && node.title !== text) node.title = text
                    font.pointSize: 10
                    font.bold: true
                }
            }

            Item {
                id: imageContainer
                anchors.margins: 5
                anchors.topMargin: 2
                anchors.top: titleItem.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                visible: !nodeView.isNodeMinimal

                property string imageDataUrl: ""
                property bool hasValidImage: false

                function updateImageDisplay() {
                    imageContainer.hasValidImage = false;
                    imageContainer.imageDataUrl = "";

                    if (!imageNodeItem.node || !imageNodeItem.node.nodeData || !imageNodeItem.node.nodeData.data) {
                        console.log("ImageResult: No data to display");
                        return;
                    }

                    var data = imageNodeItem.node.nodeData.data;

                    // Check if it's a QImage (QVariant)
                    if (ImageProcessor.isValidImage(data)) {
                        var dataUrl = ImageProcessor.saveToDataUrl(data);
                        if (dataUrl && dataUrl !== "") {
                            imageContainer.imageDataUrl = dataUrl;
                            imageContainer.hasValidImage = true;
                        } else {
                            console.error("ImageResult: Failed to create data URL");
                        }
                    } else {
                        console.log("ImageResult: Data is not a valid QImage");
                    }
                }

                // Update image data URL when node data changes
                Connections {
                    target: imageNodeItem.node?.nodeData
                    function onDataChanged() {
                        imageContainer.updateImageDisplay();
                    }
                }

                Component.onCompleted: {
                    imageContainer.updateImageDisplay();
                }

                // Display processed image
                Image {
                    id: resultImage
                    anchors.fill: parent
                    source: imageContainer.imageDataUrl
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    asynchronous: true

                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.error("ImageResult: Failed to load image from data URL");
                        }
                    }
                }

                // No image text
                Text {
                    anchors.centerIn: parent
                    text: {
                        if (!imageContainer.hasValidImage) {
                            return qsTr("No Image");
                        } else if (resultImage.status === Image.Loading) {
                            return qsTr("Loading...");
                        } else if (resultImage.status === Image.Error) {
                            return qsTr("Error!");
                        }
                        return "";
                    }
                    color: NLStyle.primaryTextColor
                    font.pixelSize: 14
                    visible: !imageContainer.hasValidImage || resultImage.status !== Image.Ready
                }
            }

            //! Minimal nodeview in low zoomFactor: foreground
            Rectangle {
                id: minimalRectangle
                anchors.fill: parent
                anchors.margins: 10

                color: nodeView.isNodeMinimal ? "#282828" : "transparent"
                radius: NLStyle.radiusAmount.nodeView

                //! OpacityAnimator use when nodeView.isNodeMinimal is true to set opacity = 0.7
                OpacityAnimator {
                    target: minimalRectangle

                    from: minimalRectangle.opacity
                    to: 0.7
                    duration: 200
                    running: nodeView.isNodeMinimal
                }

                //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0
                OpacityAnimator {
                    target: minimalRectangle

                    from: minimalRectangle.opacity
                    to: 0
                    duration: 200
                    running: !nodeView.isNodeMinimal
                }

                //! Minimal Image Display
                Image {
                    id: minimalImage
                    anchors.fill: parent
                    anchors.margins: 5
                    source: imageContainer.imageDataUrl
                    fillMode: Image.PreserveAspectFit
                    visible: nodeView.isNodeMinimal && imageContainer.hasValidImage
                    cache: false
                    asynchronous: true
                }

                //! Text Icon (fallback when no image)
                Text {
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 60
                    anchors.centerIn: parent
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                    visible: nodeView.isNodeMinimal && !imageContainer.hasValidImage
                }
            }
        }
    }

    // ===============================
    // Image Input Component
    // ===============================
    Component {
        id: imageInputComponent

        Item {
            id: imageInputItem
            property var node: nodeView?.node

            //! Header Item
            Item {
                id: titleItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12

                visible: !nodeView.isNodeMinimal
                height: 20

                //! Icon
                Text {
                    id: iconText
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                }

                //! Title Text
                NLTextArea {
                    id: titleTextArea

                    anchors.right: parent.right
                    anchors.left: iconText.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: 40

                    rightPadding: 10

                    readOnly: !nodeView.edit
                    placeholderText: qsTr("Image Input")
                    color: NLStyle.primaryTextColor
                    text: node.title
                    onTextChanged: if (node && node.title !== text) node.title = text
                    font.pointSize: 10
                    font.bold: true
                }
            }

            Item {
                id: imagePreviewContainer
                anchors.margins: 5
                anchors.topMargin: 2
                anchors.top: titleItem.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: loadButton.top
                anchors.bottomMargin: 6

                visible: !nodeView.isNodeMinimal

                property string imageDataUrl: ""

                function updatePreview() {
                    if (node?.nodeData?.data && ImageProcessor.isValidImage(node.nodeData.data)) {
                        imagePreviewContainer.imageDataUrl = ImageProcessor.saveToDataUrl(node.nodeData.data);
                    } else {
                        imagePreviewContainer.imageDataUrl = "";
                    }
                }

                Image {
                    id: previewImage
                    anchors.fill: parent
                    source: imagePreviewContainer.imageDataUrl
                    fillMode: Image.PreserveAspectFit
                    visible: source !== ""
                    cache: false
                }

                Text {
                    anchors.centerIn: parent
                    text: qsTr("No Image")
                    color: NLStyle.primaryTextColor
                    font.pixelSize: 14
                    visible: previewImage.source === "" || previewImage.status !== Image.Ready
                }
            }

            NLButton {
                id: loadButton
                text: qsTr("  Load Image  ")
                anchors.margins: 5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 30
                onClicked: fileDialog.open()
                textColor: "white"
                borderColor: "white"
                radius: 5

                visible: !nodeView.isNodeMinimal
            }

            FileDialog {
                id: fileDialog
                title: qsTr("Select an image")
                nameFilters: ["Images (*.png *.jpg *.jpeg *.bmp)"]
                onAccepted: {                   
                    // Load image using node's loadImage function
                    if (node && node.loadImage) {
                        node.loadImage(fileDialog.currentFile);
                        
                        // Update preview
                        imagePreviewContainer.updatePreview();
                        
                        // Trigger scene update to propagate to connected nodes
                        scene.updateData();
                    }
                }
            }

            //! Minimal nodeview in low zoomFactor: foreground
            Rectangle {
                id: minimalRectangle
                anchors.fill: parent
                anchors.margins: 10

                color: nodeView.isNodeMinimal ? "#282828" : "transparent"
                radius: NLStyle.radiusAmount.nodeView

                //! OpacityAnimator use when nodeView.isNodeMinimal is true to set opacity = 0.7
                OpacityAnimator {
                    target: minimalRectangle

                    from: minimalRectangle.opacity
                    to: 0.7
                    duration: 200
                    running: nodeView.isNodeMinimal
                }

                //! OpacityAnimator use when nodeView.isNodeMinimal is false to set opacity = 0
                OpacityAnimator {
                    target: minimalRectangle

                    from: minimalRectangle.opacity
                    to: 0
                    duration: 200
                    running: !nodeView.isNodeMinimal
                }

                //! Minimal Image Display
                Image {
                    id: minimalImage
                    anchors.fill: parent
                    anchors.margins: 5
                    source: imagePreviewContainer.imageDataUrl
                    fillMode: Image.PreserveAspectFit
                    visible: nodeView.isNodeMinimal && imagePreviewContainer.imageDataUrl !== ""
                    cache: false
                    asynchronous: true
                }

                //! Text Icon (fallback when no image)
                Text {
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 60
                    anchors.centerIn: parent
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                    visible: nodeView.isNodeMinimal && imagePreviewContainer.imageDataUrl === ""
                }
            }
        }
    }

    // ===============================
    // Blur Operation Component
    // ===============================
    Component {
        id: blurOperationComponent

        Item {
            id: blurItem

            property var node: nodeView?.node
            property bool iconOnly: nodeView.isNodeMinimal

            // Update nodeView height when content changes
            onIconOnlyChanged: updateHeight()
            Component.onCompleted: updateHeight()
            
            function updateHeight() {
                if (iconOnly) {
                    nodeView.height = 70; // Minimal height
                } else {
                    // Calculate height: titleItem + controlsColumn + margins
                    var totalHeight = titleItem.height + controlsColumn.height + 24 + 10;
                    nodeView.height = Math.max(totalHeight, 100);
                }
            }

            //! Header with icon and title
            Item {
                id: titleItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12

                visible: !blurItem.iconOnly
                height: 20

                //! Icon
                Text {
                    id: iconText
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                }

                //! Title Text
                NLTextArea {
                    id: titleTextArea
                    anchors.right: parent.right
                    anchors.left: iconText.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: 40
                    rightPadding: 10
                    readOnly: !nodeView.edit
                    placeholderText: qsTr("Blur")
                    color: NLStyle.primaryTextColor
                    selectByMouse: true
                    text: node.title
                    verticalAlignment: Text.AlignVCenter
                    onTextChanged: {
                        if (node && node.title !== text)
                            node.title = text;
                    }
                    font.pointSize: 10
                    font.bold: true
                }
            }

            // Blur Radius Control
            Column {
                id: controlsColumn
                anchors.top: titleItem.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                anchors.topMargin: 5
                spacing: 2
                visible: !blurItem.iconOnly
                
                onHeightChanged: blurItem.updateHeight()

                Row {
                    width: parent.width
                    spacing: 2

                    NLTextArea {
                        width: 60
                        text: "Radius:"
                        color: NLStyle.primaryTextColor
                        font.pointSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Slider {
                        id: blurRadiusSlider
                        width: parent.width - 110
                        from: 0
                        to: 20
                        stepSize: 0.5
                        value: node?.blurRadius ?? 5.0
                        onValueChanged: {
                            if (node && node.blurRadius !== value) {
                                node.blurRadius = value;
                                scene.updateDataFromNode(node);
                            }
                        }
                    }

                    NLTextArea {
                        width: 40
                        text: blurRadiusSlider.value.toFixed(1)
                        color: NLStyle.primaryTextColor
                        font.pointSize: 8
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Status Text
                NLTextArea {
                    id: statusText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: node?.nodeData?.data ? qsTr("✓ Blurred") : qsTr("Waiting...")
                    color: node?.nodeData?.data ? "#4CAF50" : NLStyle.primaryTextColor
                    font.pointSize: 8
                }
            }

            //! Minimal nodeview in low zoomFactor
            Rectangle {
                id: minimalRectangle
                anchors.fill: parent
                anchors.margins: 10
                color: blurItem.iconOnly ? "#282828" : "transparent"
                radius: NLStyle.radiusAmount.nodeView

                NLTextArea {
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                    visible: blurItem.iconOnly
                }
            }
        }
    }

    // ===============================
    // Brightness Operation Component
    // ===============================
    Component {
        id: brightnessOperationComponent

        Item {
            id: brightnessItem
            property var node: nodeView?.node
            property bool iconOnly: nodeView.isNodeMinimal

            // Update nodeView height when content changes
            onIconOnlyChanged: updateHeight()
            Component.onCompleted: updateHeight()
            
            function updateHeight() {
                if (iconOnly) {
                    nodeView.height = 70; // Minimal height
                } else {
                    // Calculate height: titleItem + controlsColumn + margins
                    var totalHeight = titleItem.height + controlsColumn.height + 24 + 10;
                    nodeView.height = Math.max(totalHeight, 100);
                }
            }

            //! Header with icon and title
            Item {
                id: titleItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12

                visible: !brightnessItem.iconOnly
                height: 20

                //! Icon
                Text {
                    id: iconText
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                }

                //! Title Text
                NLTextArea {
                    id: titleTextArea
                    anchors.right: parent.right
                    anchors.left: iconText.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: 40
                    rightPadding: 10
                    readOnly: !nodeView.edit
                    placeholderText: qsTr("Brightness")
                    color: NLStyle.primaryTextColor
                    selectByMouse: true
                    text: node.title
                    verticalAlignment: Text.AlignVCenter
                    onTextChanged: {
                        if (node && node.title !== text)
                            node.title = text;
                    }
                    font.pointSize: 10
                    font.bold: true
                }
            }

            // Brightness Level Control
            Column {
                id: controlsColumn
                anchors.top: titleItem.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                anchors.topMargin: 5
                spacing: 2
                visible: !brightnessItem.iconOnly
                
                onHeightChanged: brightnessItem.updateHeight()

                Row {
                    width: parent.width
                    spacing: 2

                    NLTextArea {
                        width: 60
                        text: "Level:"
                        color: NLStyle.primaryTextColor
                        font.pointSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Slider {
                        id: brightnessLevelSlider
                        width: parent.width - 110
                        from: -1.0
                        to: 1.0
                        stepSize: 0.05
                        value: node?.brightnessLevel ?? 0.0
                        onValueChanged: {
                            if (node && node.brightnessLevel !== value) {
                                node.brightnessLevel = value;
                                scene.updateDataFromNode(node);
                            }
                        }
                    }

                    NLTextArea {
                        width: 40
                        text: brightnessLevelSlider.value.toFixed(2)
                        color: NLStyle.primaryTextColor
                        font.pointSize: 8
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Status Text
                NLTextArea {
                    id: statusText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: node?.nodeData?.data ? qsTr("✓ Adjusted") : qsTr("Waiting...")
                    color: node?.nodeData?.data ? "#4CAF50" : NLStyle.primaryTextColor
                    font.pointSize: 8
                }
            }

            //! Minimal nodeview in low zoomFactor
            Rectangle {
                id: minimalRectangle
                anchors.fill: parent
                anchors.margins: 10
                color: brightnessItem.iconOnly ? "#282828" : "transparent"
                radius: NLStyle.radiusAmount.nodeView

                NLTextArea {
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                    visible: brightnessItem.iconOnly
                }
            }
        }
    }

    // ===============================
    // Contrast Operation Component
    // ===============================
    Component {
        id: contrastOperationComponent

        Item {
            id: contrastItem
            property var node: nodeView?.node
            property bool iconOnly: nodeView.isNodeMinimal

            // Update nodeView height when content changes
            onIconOnlyChanged: updateHeight()
            Component.onCompleted: updateHeight()
            
            function updateHeight() {
                if (iconOnly) {
                    nodeView.height = 70; // Minimal height
                } else {
                    // Calculate height: titleItem + controlsColumn + margins
                    var totalHeight = titleItem.height + controlsColumn.height + 24 + 10;
                    nodeView.height = Math.max(totalHeight, 100);
                }
            }

            //! Header with icon and title
            Item {
                id: titleItem
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12

                visible: !contrastItem.iconOnly
                height: 20

                //! Icon
                Text {
                    id: iconText
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                }

                //! Title Text
                NLTextArea {
                    id: titleTextArea
                    anchors.right: parent.right
                    anchors.left: iconText.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: 40
                    rightPadding: 10
                    readOnly: !nodeView.edit
                    placeholderText: qsTr("Contrast")
                    color: NLStyle.primaryTextColor
                    selectByMouse: true
                    text: node.title
                    verticalAlignment: Text.AlignVCenter
                    onTextChanged: {
                        if (node && node.title !== text)
                            node.title = text;
                    }
                    font.pointSize: 10
                    font.bold: true
                }
            }

            // Contrast Level Control
            Column {
                id: controlsColumn
                anchors.top: titleItem.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                anchors.topMargin: 5
                spacing: 2
                visible: !contrastItem.iconOnly
                
                onHeightChanged: contrastItem.updateHeight()

                Row {
                    width: parent.width
                    spacing: 2

                    NLTextArea {
                        width: 60
                        text: "Level:"
                        color: NLStyle.primaryTextColor
                        font.pointSize: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Slider {
                        id: contrastLevelSlider
                        width: parent.width - 110
                        from: -1.0
                        to: 1.0
                        stepSize: 0.05
                        value: node?.contrastLevel ?? 0.0
                        onValueChanged: {
                            if (node && node.contrastLevel !== value) {
                                node.contrastLevel = value;
                                scene.updateDataFromNode(node);
                            }
                        }
                    }

                    NLTextArea {
                        width: 40
                        text: contrastLevelSlider.value.toFixed(2)
                        color: NLStyle.primaryTextColor
                        font.pointSize: 8
                        horizontalAlignment: Text.AlignRight
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Status Text
                NLTextArea {
                    id: statusText
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: node?.nodeData?.data ? qsTr("✓ Enhanced") : qsTr("Waiting...")
                    color: node?.nodeData?.data ? "#4CAF50" : NLStyle.primaryTextColor
                    font.pointSize: 8
                }
            }

            //! Minimal nodeview in low zoomFactor
            Rectangle {
                id: minimalRectangle
                anchors.fill: parent
                anchors.margins: 10
                color: contrastItem.iconOnly ? "#282828" : "transparent"
                radius: NLStyle.radiusAmount.nodeView

                NLTextArea {
                    font.family: NLStyle.fontType.font6Pro
                    font.pixelSize: 40
                    anchors.centerIn: parent
                    text: scene.nodeRegistry.nodeIcons[node.type]
                    color: node.guiConfig.color
                    font.weight: 400
                    visible: contrastItem.iconOnly
                }
            }
        }
    }
}
