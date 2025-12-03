import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import Multiple3DEditors

/*! ***********************************************************************************************
 * PropertyPanel - Panel for editing selected node properties
 * ************************************************************************************************/

Rectangle {
    id: root
    
    property Multiple3DEditorsScene scene: null
    
    color: "#1e1e1e"
    radius: 12
    border.color: "#444"
    border.width: 2
    
    // Shadow effect
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        color: "transparent"
        border.color: "#00000040"
        border.width: 1
        radius: parent.radius + 2
        z: -1
    }
    
    // Property for selected node - updated manually to avoid binding loops
    property var selectedNode: null
    
    // Watch for changes and update manually
    Connections {
        target: scene
        function onSelectedNodeIdChanged() {
            updateSelectedNode();
        }
        function onNodesChanged() {
            updateSelectedNode();
        }
    }
    
    function updateSelectedNode() {
        if (!scene || !scene.selectedNodeId || scene.selectedNodeId === "" || !scene.nodes) {
            root.selectedNode = null;
            return;
        }
        root.selectedNode = scene.nodes[scene.selectedNodeId];
    }
    
    Component.onCompleted: {
        updateSelectedNode();
    }
    
    //! Custom SpinBox component with smaller font and consistent styling
    component StyledSpinBox: SpinBox {
        Layout.fillWidth: true
        Layout.preferredHeight: 30
        Material.theme: Material.Dark
        Material.accent: Material.Blue
        contentItem: TextInput {
            text: parent.textFromValue(parent.value, parent.locale)
            font.pixelSize: 11
            color: "#ffffff"
            selectionColor: Material.accent
            selectedTextColor: "#ffffff"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            readOnly: !parent.editable
            validator: parent.validator
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        //! Title
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 45
            color: "#2d2d2d"
            radius: 8
            border.color: "#4a4a4a"
            border.width: 1
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2d2d2d" }
                GradientStop { position: 1.0; color: "#252525" }
            }
            
            Text {
                anchors.centerIn: parent
                text: "⚙️ Node Properties"
                color: "#ffffff"
                font.pixelSize: 15
                font.bold: true
            }
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            
            ColumnLayout {
                width: root.width - 32
                spacing: 12
                
                //! Transform Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: transformContent.implicitHeight + 24
                    color: "#2a2a2a"
                    radius: 6
                    border.color: "#3d3d3d"
                    border.width: 1
                    
                    ColumnLayout {
                        id: transformContent
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        
                        Text {
                            text: "🔄 Transform"
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.bottomMargin: 4
                        }
                        
                        // Position
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "Position"
                                color: "#b0b0b0"
                                font.pixelSize: 11
                            }
                            
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                
                                Text { text: "X:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: posXSpin
                                    from: -10000; to: 10000; stepSize: 1
                                    value: selectedNode ? selectedNode.position.x : 0
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "position", 
                                                Qt.vector3d(value, selectedNode.position.y, selectedNode.position.z));
                                        }
                                    }
                                }
                                
                                Text { text: "Y:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: posYSpin
                                    from: -10000; to: 10000; stepSize: 1
                                    value: selectedNode ? selectedNode.position.y : 0
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "position", 
                                                Qt.vector3d(selectedNode.position.x, value, selectedNode.position.z));
                                        }
                                    }
                                }
                                
                                Text { text: "Z:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: posZSpin
                                    from: -10000; to: 10000; stepSize: 1
                                    value: selectedNode ? selectedNode.position.z : 0
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "position", 
                                                Qt.vector3d(selectedNode.position.x, selectedNode.position.y, value));
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Rotation
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "Rotation"
                                color: "#b0b0b0"
                                font.pixelSize: 11
                            }
                            
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                
                                Text { text: "X:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: rotXSpin
                                    from: -360; to: 360; stepSize: 1
                                    value: selectedNode ? selectedNode.rotation.x : 0
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "rotation", 
                                                Qt.vector3d(value, selectedNode.rotation.y, selectedNode.rotation.z));
                                        }
                                    }
                                }
                                
                                Text { text: "Y:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: rotYSpin
                                    from: -360; to: 360; stepSize: 1
                                    value: selectedNode ? selectedNode.rotation.y : 0
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "rotation", 
                                                Qt.vector3d(selectedNode.rotation.x, value, selectedNode.rotation.z));
                                        }
                                    }
                                }
                                
                                Text { text: "Z:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: rotZSpin
                                    from: -360; to: 360; stepSize: 1
                                    value: selectedNode ? selectedNode.rotation.z : 0
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "rotation", 
                                                Qt.vector3d(selectedNode.rotation.x, selectedNode.rotation.y, value));
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Scale
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "Scale (%)"
                                color: "#b0b0b0"
                                font.pixelSize: 11
                            }
                            
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                
                                Text { text: "X:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: scaleXSpin
                                    from: 1; to: 1000; stepSize: 1
                                    value: selectedNode ? Math.round(selectedNode.scale.x * 100) : 100
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "scale", 
                                                Qt.vector3d(value / 100.0, selectedNode.scale.y, selectedNode.scale.z));
                                        }
                                    }
                                }
                                
                                Text { text: "Y:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: scaleYSpin
                                    from: 1; to: 1000; stepSize: 1
                                    value: selectedNode ? Math.round(selectedNode.scale.y * 100) : 100
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "scale", 
                                                Qt.vector3d(selectedNode.scale.x, value / 100.0, selectedNode.scale.z));
                                        }
                                    }
                                }
                                
                                Text { text: "Z:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                                StyledSpinBox {
                                    id: scaleZSpin
                                    from: 1; to: 1000; stepSize: 1
                                    value: selectedNode ? Math.round(selectedNode.scale.z * 100) : 100
                                    onValueChanged: {
                                        if (selectedNode && scene) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "scale", 
                                                Qt.vector3d(selectedNode.scale.x, selectedNode.scale.y, value / 100.0));
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                //! Geometry Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: geometryContent.implicitHeight + 24
                    color: "#2a2a2a"
                    radius: 6
                    border.color: "#3d3d3d"
                    border.width: 1
                    
                    ColumnLayout {
                        id: geometryContent
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        
                        Text {
                            text: "📐 Geometry"
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.bottomMargin: 4
                        }
                        
                        // Shape Type
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "Shape Type:"
                                color: "#b0b0b0"
                                font.pixelSize: 12
                            }
                            
                            ComboBox {
                                id: shapeTypeCombo
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                Material.theme: Material.Dark
                                
                                model: ["Cube", "Sphere", "Cylinder", "Cone", "Plane", "Rectangle"]
                                
                                currentIndex: {
                                    if (!selectedNode) return 0;
                                    var shape = selectedNode.shapeType || "Cube";
                                    var index = model.indexOf(shape);
                                    return index >= 0 ? index : 0;
                                }
                                
                                onActivated: (index) => {
                                    if (selectedNode && scene) {
                                        var shapeType = model[index];
                                        scene.updateNodeProperty(scene.selectedNodeId, "shapeType", shapeType);
                                    }
                                }
                            }
                        }
                        
                        Text {
                            text: "Dimensions (cm)"
                            color: "#b0b0b0"
                            font.pixelSize: 11
                            Layout.fillWidth: true
                            Layout.topMargin: 4
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text { text: "W:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                            StyledSpinBox {
                                id: widthSpin
                                from: 10; to: 1000; stepSize: 1
                                value: selectedNode ? selectedNode.dimensions.x : 100
                                onValueChanged: {
                                    if (selectedNode && scene) {
                                        scene.updateNodeProperty(scene.selectedNodeId, "dimensions", 
                                            Qt.vector3d(value, selectedNode.dimensions.y, selectedNode.dimensions.z));
                                    }
                                }
                            }
                            
                            Text { text: "H:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                            StyledSpinBox {
                                id: heightSpin
                                from: 10; to: 1000; stepSize: 1
                                value: selectedNode ? selectedNode.dimensions.y : 100
                                onValueChanged: {
                                    if (selectedNode && scene) {
                                        scene.updateNodeProperty(scene.selectedNodeId, "dimensions", 
                                            Qt.vector3d(selectedNode.dimensions.x, value, selectedNode.dimensions.z));
                                    }
                                }
                            }
                            
                            Text { text: "D:"; color: "#b0b0b0"; font.pixelSize: 11; Layout.preferredWidth: 20 }
                            StyledSpinBox {
                                id: depthSpin
                                from: 10; to: 1000; stepSize: 1
                                value: selectedNode ? selectedNode.dimensions.z : 100
                                onValueChanged: {
                                    if (selectedNode && scene) {
                                        scene.updateNodeProperty(scene.selectedNodeId, "dimensions", 
                                            Qt.vector3d(selectedNode.dimensions.x, selectedNode.dimensions.y, value));
                                    }
                                }
                            }
                        }
                    }
                }
                
                //! Material Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: materialContent.implicitHeight + 24
                    color: "#2a2a2a"
                    radius: 6
                    border.color: "#3d3d3d"
                    border.width: 1
                    
                    ColumnLayout {
                        id: materialContent
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        
                        Text {
                            text: "🎨 Material"
                            color: "#ffffff"
                            font.pixelSize: 14
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.bottomMargin: 4
                        }
                        
                        // Material Type
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: "Material Type:"
                                color: "#b0b0b0"
                                font.pixelSize: 12
                            }
                            
                            ComboBox {
                                id: materialTypeCombo
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                Material.theme: Material.Dark
                                
                                model: [
                                    "DefaultMaterial",
                                    "Metal",
                                    "Plastic",
                                    "Glass",
                                    "Rubber",
                                    "Wood"
                                ]
                                
                                currentIndex: {
                                    if (!selectedNode) return 0;
                                    var type = selectedNode.materialType || "DefaultMaterial";
                                    var index = model.indexOf(type);
                                    return index >= 0 ? index : 0;
                                }
                                
                                onActivated: (index) => {
                                    if (selectedNode && scene) {
                                        var materialType = model[index];
                                        scene.updateNodeProperty(scene.selectedNodeId, "materialType", materialType);
                                        
                                        // Apply preset values based on material type
                                        var presets = {
                                            "DefaultMaterial": { metallic: 0.0, roughness: 0.5 },
                                            "Metal": { metallic: 1.0, roughness: 0.1 },
                                            "Plastic": { metallic: 0.0, roughness: 0.3 },
                                            "Glass": { metallic: 0.0, roughness: 0.0 },
                                            "Rubber": { metallic: 0.0, roughness: 0.9 },
                                            "Wood": { metallic: 0.0, roughness: 0.8 }
                                        };
                                        
                                        var preset = presets[materialType];
                                        if (preset) {
                                            scene.updateNodeProperty(scene.selectedNodeId, "metallic", preset.metallic);
                                            scene.updateNodeProperty(scene.selectedNodeId, "roughness", preset.roughness);
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Color & Emissive Color (in one row)
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15
                            
                            RowLayout {
                                spacing: 8
                                Text { 
                                    text: "Color:"; 
                                    color: "#b0b0b0"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 50
                                }
                                Rectangle {
                                    width: 50
                                    height: 32
                                    radius: 4
                                    color: selectedNode ? (typeof selectedNode.color === "string" ? selectedNode.color : selectedNode.color) : "#8080ff"
                                    border.color: "#555"
                                    border.width: 2
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: colorDialog.open();
                                    }
                                }
                            }
                            
                            RowLayout {
                                spacing: 8
                                Text { 
                                    text: "Emissive:"; 
                                    color: "#b0b0b0"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 70
                                }
                                Rectangle {
                                    width: 50
                                    height: 32
                                    radius: 4
                                    color: selectedNode ? (typeof selectedNode.emissiveColor === "string" ? selectedNode.emissiveColor : selectedNode.emissiveColor) : "#000000"
                                    border.color: "#555"
                                    border.width: 2
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: emissiveColorDialog.open();
                                    }
                                }
                            }
                        }
                        
                        // Metallic
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Text { 
                                    text: "Metallic:"; 
                                    color: "#b0b0b0"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 80
                                }
                                Text {
                                    text: metallicSlider.value.toFixed(2)
                                    color: "#aaaaaa"
                                    font.pixelSize: 11
                                    Layout.alignment: Qt.AlignRight
                                }
                            }
                            Slider {
                                id: metallicSlider
                                from: 0; to: 1; stepSize: 0.01
                                value: selectedNode ? selectedNode.metallic : 0
                                Layout.fillWidth: true
                                Material.theme: Material.Dark
                                onValueChanged: {
                                    if (selectedNode && scene) {
                                        scene.updateNodeProperty(scene.selectedNodeId, "metallic", value);
                                    }
                                }
                            }
                        }
                        
                        // Roughness
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Text { 
                                    text: "Roughness:"; 
                                    color: "#b0b0b0"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 80
                                }
                                Text {
                                    text: roughnessSlider.value.toFixed(2)
                                    color: "#aaaaaa"
                                    font.pixelSize: 11
                                    Layout.alignment: Qt.AlignRight
                                }
                            }
                            Slider {
                                id: roughnessSlider
                                from: 0; to: 1; stepSize: 0.01
                                value: selectedNode ? selectedNode.roughness : 0.5
                                Layout.fillWidth: true
                                Material.theme: Material.Dark
                                onValueChanged: {
                                    if (selectedNode && scene) {
                                        scene.updateNodeProperty(scene.selectedNodeId, "roughness", value);
                                    }
                                }
                            }
                        }
                        
                        // Emissive Power
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            RowLayout {
                                Layout.fillWidth: true
                                Text { 
                                    text: "Emissive Power:"; 
                                    color: "#b0b0b0"
                                    font.pixelSize: 12
                                    Layout.preferredWidth: 80
                                }
                                Text {
                                    text: emissivePowerSlider.value.toFixed(1)
                                    color: "#aaaaaa"
                                    font.pixelSize: 11
                                    Layout.alignment: Qt.AlignRight
                                }
                            }
                            Slider {
                                id: emissivePowerSlider
                                from: 0; to: 5; stepSize: 0.1
                                value: selectedNode ? selectedNode.emissivePower : 0
                                Layout.fillWidth: true
                                Material.theme: Material.Dark
                                onValueChanged: {
                                    if (selectedNode && scene) {
                                        scene.updateNodeProperty(scene.selectedNodeId, "emissivePower", value);
                                    }
                                }
                            }
                        }
                    }
                }
                
                //! Delete Button
                Button {
                    text: "🗑️ Delete Node"
                    Material.accent: Material.Red
                    Material.theme: Material.Dark
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    font.pixelSize: 13
                    font.bold: true
                    onClicked: {
                        if (scene && scene.selectedNodeId) {
                            scene.deleteNode(scene.selectedNodeId);
                        }
                    }
                }
            }
        }
    }
    
    //! Color Dialog
    Dialog {
        id: colorDialog
        title: "Select Color"
        modal: true
        anchors.centerIn: parent
        width: 320
        height: 200
        
        contentItem: ColumnLayout {
            spacing: 10
            Layout.fillWidth: true
            
            GridLayout {
                columns: 8
                Layout.fillWidth: true
                
                Repeater {
                    model: [
                        "#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff",
                        "#ffffff", "#000000", "#808080", "#ff8080", "#80ff80", "#8080ff",
                        "#ffff80", "#ff80ff", "#80ffff", "#ff8000", "#8000ff", "#0080ff",
                        "#ff0080", "#00ff80", "#800000", "#008000", "#000080", "#808000"
                    ]
                    
                    Rectangle {
                        width: 30
                        height: 30
                        color: modelData
                        border.color: "#555"
                        border.width: 1
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (selectedNode && scene) {
                                    scene.updateNodeProperty(scene.selectedNodeId, "color", modelData);
                                }
                                colorDialog.close();
                            }
                        }
                    }
                }
            }
            
            Button {
                text: "Close"
                Layout.fillWidth: true
                onClicked: colorDialog.close()
            }
        }
    }
    
    //! Emissive Color Dialog
    Dialog {
        id: emissiveColorDialog
        title: "Select Emissive Color"
        modal: true
        anchors.centerIn: parent
        width: 320
        height: 200
        
        contentItem: ColumnLayout {
            spacing: 10
            Layout.fillWidth: true
            
            GridLayout {
                columns: 8
                Layout.fillWidth: true
                
                Repeater {
                    model: [
                        "#ff0000", "#00ff00", "#0000ff", "#ffff00", "#ff00ff", "#00ffff",
                        "#ffffff", "#000000", "#808080", "#ff8080", "#80ff80", "#8080ff",
                        "#ffff80", "#ff80ff", "#80ffff", "#ff8000", "#8000ff", "#0080ff",
                        "#ff0080", "#00ff80", "#800000", "#008000", "#000080", "#808000"
                    ]
                    
                    Rectangle {
                        width: 30
                        height: 30
                        color: modelData
                        border.color: "#555"
                        border.width: 1
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (selectedNode && scene) {
                                    scene.updateNodeProperty(scene.selectedNodeId, "emissiveColor", modelData);
                                }
                                emissiveColorDialog.close();
                            }
                        }
                    }
                }
            }
            
            Button {
                text: "Close"
                Layout.fillWidth: true
                onClicked: emissiveColorDialog.close()
            }
        }
    }
    
    //! Update spin boxes when selected node changes
    onSelectedNodeChanged: {
        if (selectedNode) {
            posXSpin.value = selectedNode.position.x;
            posYSpin.value = selectedNode.position.y;
            posZSpin.value = selectedNode.position.z;
            rotXSpin.value = selectedNode.rotation.x;
            rotYSpin.value = selectedNode.rotation.y;
            rotZSpin.value = selectedNode.rotation.z;
            scaleXSpin.value = Math.round(selectedNode.scale.x * 100);
            scaleYSpin.value = Math.round(selectedNode.scale.y * 100);
            scaleZSpin.value = Math.round(selectedNode.scale.z * 100);
            widthSpin.value = selectedNode.dimensions.x;
            heightSpin.value = selectedNode.dimensions.y;
            depthSpin.value = selectedNode.dimensions.z;
            metallicSlider.value = selectedNode.metallic;
            roughnessSlider.value = selectedNode.roughness;
            emissivePowerSlider.value = selectedNode.emissivePower;
            
            // Update material type combo
            var type = selectedNode.materialType || "DefaultMaterial";
            var index = materialTypeCombo.model.indexOf(type);
            if (index >= 0) {
                materialTypeCombo.currentIndex = index;
            }
            
            // Update shape type combo
            var shape = selectedNode.shapeType || "Cube";
            var shapeIndex = shapeTypeCombo.model.indexOf(shape);
            if (shapeIndex >= 0) {
                shapeTypeCombo.currentIndex = shapeIndex;
            }
        }
    }
}
