# Serialization Format

## Overview

NodeLink uses **QtQuickStream** for serialization and deserialization of scenes. All scenes, nodes, links, containers, and their properties are saved to JSON files with the `.QQS.json` extension. This document explains the serialization format, how it works, and how to use it in your applications.

---

## File Format

### File Extension

NodeLink saves scenes as **`.QQS.json`** files (QtQuickStream JSON format).

**Example**: `MyScene.QQS.json`

### File Type

- **Format**: JSON (JavaScript Object Notation)
- **Encoding**: UTF-8
- **Structure**: Object map where keys are UUIDs and values are object properties

### File Dialog Configuration

```qml
FileDialog {
    id: saveDialog
    currentFile: "QtQuickStream.QQS.json"
    fileMode: FileDialog.SaveFile
    nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
    onAccepted: {
        NLCore.defaultRepo.saveToFile(saveDialog.currentFile);
    }
}
```

---

## Serialization System

### QtQuickStream

NodeLink uses **QtQuickStream** (QS) for serialization:

- **Repository**: `QSRepository` manages all serializable objects
- **Objects**: All objects inherit from `QSObject` (via `I_Node`, `I_Scene`, etc.)
- **Serializer**: `QSSerializer` handles conversion between objects and JSON

### How It Works

1. **Save Process**:
   - All objects in the repository are serialized to JSON
   - Object references are converted to URLs (`qqs:/UUID`)
   - Properties are serialized based on their types
   - JSON is written to file

2. **Load Process**:
   - JSON file is read and parsed
   - Objects are created from their types
   - Properties are restored from JSON
   - Object references are resolved from URLs

---

## Saving Scenes

### Basic Save

```qml
// Save scene to file
NLCore.defaultRepo.saveToFile("MyScene.QQS.json");
```

### Save with File Dialog

```qml
// examples/simpleNodeLink/main.qml
FileDialog {
    id: saveDialog
    currentFile: "QtQuickStream.QQS.json"
    fileMode: FileDialog.SaveFile
    nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
    onAccepted: {
        NLCore.defaultRepo.saveToFile(saveDialog.currentFile);
    }
}

Button {
    text: "Save"
    onClicked: saveDialog.visible = true
}
```

### What Gets Saved

The following are saved to the file:

- **Scene**: Root scene object with all properties
- **Nodes**: All nodes with their properties (type, title, guiConfig, nodeData, ports)
- **Links**: All links with their properties (inputPort, outputPort, guiConfig, direction)
- **Containers**: All containers with their properties (title, guiConfig, nodes, containersInside)
- **Node Registry**: Registry configuration (if part of scene)
- **Scene GUI Config**: Scene view configuration (zoom, content size, position)

### Serialization Type

NodeLink uses `QSSerializer.SerialType.STORAGE` for saving:

```qml
// In QSRepository.saveToFile()
let repoDump = dumpRepo(QSSerializer.SerialType.STORAGE);
return QSFileIO.write(fileName, JSON.stringify(repoDump, null, 4));
```

**Storage Type**:
- Saves object types as-is
- Sets remote objects to unavailable
- Includes all properties except blacklisted ones

---

## Loading Scenes

### Basic Load

```qml
// Load scene from file
NLCore.defaultRepo.loadFromFile("MyScene.QQS.json");
```

### Load with File Dialog

```qml
// examples/simpleNodeLink/main.qml
FileDialog {
    id: loadDialog
    currentFile: "QtQuickStream.QQS.json"
    fileMode: FileDialog.OpenFile
    nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
    onAccepted: {
        NLCore.defaultRepo.clearObjects();
        NLCore.defaultRepo.loadFromFile(loadDialog.currentFile);
    }
}

Button {
    text: "Load"
    onClicked: loadDialog.visible = true
}
```

### Load Process

1. **Clear Existing Objects** (optional):
   ```qml
   NLCore.defaultRepo.clearObjects();
   ```

2. **Load from File**:
   ```qml
   NLCore.defaultRepo.loadFromFile(fileName);
   ```

3. **Scene is Restored**:
   - All objects are recreated
   - Properties are restored
   - References are resolved
   - Scene is ready to use

### After Loading

After loading, the scene object is automatically restored:

```qml
// Scene is automatically available after load
window.scene = Qt.binding(function() { 
    return NLCore.defaultRepo.qsRootObject;
});
```

---

## File Structure

### JSON Structure

The saved file has the following structure:

```json
{
    "root": "qqs:/<root-object-uuid>",
    "<object-uuid-1>": {
        "qsType": "Scene",
        "title": "My Scene",
        "nodes": {
            "<node-uuid-1>": "qqs:/<node-uuid-1>",
            "<node-uuid-2>": "qqs:/<node-uuid-2>"
        },
        "links": {
            "<link-uuid-1>": "qqs:/<link-uuid-1>"
        },
        "containers": {},
        "nodeRegistry": "qqs:/<registry-uuid>",
        "sceneGuiConfig": "qqs:/<config-uuid>"
    },
    "<node-uuid-1>": {
        "qsType": "SourceNode",
        "type": 0,
        "title": "Source_1",
        "guiConfig": "qqs:/<gui-config-uuid>",
        "nodeData": "qqs:/<node-data-uuid>",
        "ports": {
            "<port-uuid-1>": "qqs:/<port-uuid-1>"
        }
    },
    "<gui-config-uuid>": {
        "qsType": "NodeGuiConfig",
        "position": { "x": 100.0, "y": 200.0 },
        "width": 200,
        "height": 150,
        "color": "#4A90E2",
        "opacity": 1.0,
        "autoSize": true
    },
    "<node-data-uuid>": {
        "qsType": "I_NodeData",
        "data": 42.0
    },
    "<port-uuid-1>": {
        "qsType": "Port",
        "portType": 1,
        "portSide": 3,
        "title": "value",
        "color": "white",
        "enable": true
    },
    "<link-uuid-1>": {
        "qsType": "Link",
        "inputPort": "qqs:/<port-uuid-1>",
        "outputPort": "qqs:/<port-uuid-2>",
        "direction": 1,
        "guiConfig": "qqs:/<link-gui-config-uuid>"
    }
}
```

### Root Object

The `"root"` key contains the UUID reference to the root object (usually the Scene):

```json
{
    "root": "qqs:/550e8400-e29b-41d4-a716-446655440000"
}
```

### Object Entries

Each object is stored with its UUID as the key:

```json
{
    "<uuid>": {
        "qsType": "ObjectType",
        "property1": "value1",
        "property2": "value2",
        "referenceProperty": "qqs:/<other-uuid>"
    }
}
```

### Object Type

Each object has a `"qsType"` property indicating its QML component type:

```json
{
    "qsType": "Scene"        // Scene object
    "qsType": "Node"         // Base Node
    "qsType": "SourceNode"   // Custom node type
    "qsType": "Port"         // Port object
    "qsType": "Link"         // Link object
    "qsType": "NodeGuiConfig" // GUI configuration
}
```

---

## Object References

### QtQuickStream URLs

Object references are stored as **QtQuickStream URLs** with the format:

```
qqs:/<UUID>
```

**Example**:
```json
{
    "inputPort": "qqs:/550e8400-e29b-41d4-a716-446655440000",
    "outputPort": "qqs:/6ba7b810-9dad-11d1-80b4-00c04fd430c8"
}
```

### Reference Resolution

During loading, URLs are resolved to actual object references:

1. URL is parsed: `qqs:/<UUID>`
2. UUID is extracted
3. Object is looked up in repository: `repo._qsObjects[uuid]`
4. Reference is assigned to property

### Nested References

References can be nested:

```json
{
    "node": {
        "guiConfig": "qqs:/<gui-config-uuid>",
        "nodeData": "qqs:/<node-data-uuid>",
        "ports": {
            "<port-uuid>": "qqs:/<port-uuid>"
        }
    }
}
```

---

## Data Types

### Supported Types

QtQuickStream supports serialization of:

#### Primitive Types

- **Numbers**: `int`, `real`, `double`
- **Strings**: `string`
- **Booleans**: `bool`
- **Null**: `null`

```json
{
    "width": 200,
    "height": 150.5,
    "title": "My Node",
    "locked": false,
    "data": null
}
```

#### Complex Types

- **Objects**: Property maps
- **Arrays**: JavaScript arrays
- **Vectors**: `vector2d` (stored as `{x, y}`)
- **Dates**: ISO 8601 strings

```json
{
    "position": { "x": 100.0, "y": 200.0 },
    "colors": ["#FF0000", "#00FF00", "#0000FF"],
    "timestamp": "2024-01-15T10:30:00.000Z"
}
```

#### QML Types

- **QSObject References**: `qqs:/UUID`
- **Nested QSObjects**: Serialized as objects with `qsType`

```json
{
    "guiConfig": {
        "qsType": "NodeGuiConfig",
        "width": 200,
        "height": 150
    }
}
```

### Type Conversion

#### Vector2D

`vector2d` is serialized as an object:

```qml
// In memory
position: Qt.vector2d(100, 200)

// In JSON
{
    "position": { "x": 100.0, "y": 200.0 }
}
```

#### Arrays

Arrays are serialized as JSON arrays:

```qml
// In memory
colors: ["#FF0000", "#00FF00"]

// In JSON
{
    "colors": ["#FF0000", "#00FF00"]
}
```

#### Maps/Objects

Maps are serialized as JSON objects:

```qml
// In memory
nodes: {
    "uuid1": node1,
    "uuid2": node2
}

// In JSON
{
    "nodes": {
        "uuid1": "qqs:/uuid1",
        "uuid2": "qqs:/uuid2"
    }
}
```

---

## Blacklisted Properties

Some properties are **not serialized** (blacklisted):

### Default Blacklist

Properties starting or ending with `_` (underscore):

```qml
// These are NOT saved:
property var _internalProperty
property var property_
```

### Explicit Blacklist

Properties in `QSSerializer.blackListedPropNames`:

- `objectName`
- `selectionModel`

### Why Blacklist?

- **Internal properties**: Properties used for internal state
- **Temporary properties**: Properties that shouldn't persist
- **Computed properties**: Properties that are calculated, not stored

---

## Complete Example

### Saving a Scene

```qml
// main.qml
Window {
    property Scene scene: Scene { }
    
    Component.onCompleted: {
        // Initialize repository
        NLCore.defaultRepo = NLCore.createDefaultRepo([
            "QtQuickStream", 
            "NodeLink", 
            "MyApp"
        ]);
        NLCore.defaultRepo.initRootObject("Scene");
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });
    }
    
    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            NLCore.defaultRepo.saveToFile(saveDialog.currentFile);
        }
    }
    
    Button {
        text: "Save"
        onClicked: saveDialog.visible = true
    }
}
```

### Loading a Scene

```qml
// main.qml
Window {
    property Scene scene: Scene { }
    
    FileDialog {
        id: loadDialog
        fileMode: FileDialog.OpenFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            // Clear existing objects
            NLCore.defaultRepo.clearObjects();
            
            // Load from file
            NLCore.defaultRepo.loadFromFile(loadDialog.currentFile);
            
            // Scene is automatically restored
            window.scene = Qt.binding(function() { 
                return NLCore.defaultRepo.qsRootObject;
            });
        }
    }
    
    Button {
        text: "Load"
        onClicked: loadDialog.visible = true
    }
}
```

### Example JSON File

```json
{
    "root": "qqs:/a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "a1b2c3d4-e5f6-7890-abcd-ef1234567890": {
        "qsType": "Scene",
        "title": "My Calculator Scene",
        "nodes": {
            "b2c3d4e5-f6a7-8901-bcde-f12345678901": "qqs:/b2c3d4e5-f6a7-8901-bcde-f12345678901",
            "c3d4e5f6-a7b8-9012-cdef-123456789012": "qqs:/c3d4e5f6-a7b8-9012-cdef-123456789012"
        },
        "links": {
            "d4e5f6a7-b8c9-0123-def0-234567890123": "qqs:/d4e5f6a7-b8c9-0123-def0-234567890123"
        },
        "containers": {}
    },
    "b2c3d4e5-f6a7-8901-bcde-f12345678901": {
        "qsType": "SourceNode",
        "type": 0,
        "title": "Source_1",
        "guiConfig": "qqs:/e5f6a7b8-c9d0-1234-ef01-345678901234",
        "nodeData": "qqs:/f6a7b8c9-d0e1-2345-f012-456789012345",
        "ports": {
            "a7b8c9d0-e1f2-3456-0123-567890123456": "qqs:/a7b8c9d0-e1f2-3456-0123-567890123456"
        }
    },
    "e5f6a7b8-c9d0-1234-ef01-345678901234": {
        "qsType": "NodeGuiConfig",
        "position": { "x": 100.0, "y": 200.0 },
        "width": 200,
        "height": 150,
        "color": "#4A90E2",
        "opacity": 1.0,
        "autoSize": true,
        "minWidth": 120,
        "minHeight": 80
    },
    "f6a7b8c9-d0e1-2345-f012-456789012345": {
        "qsType": "I_NodeData",
        "data": 42.0
    },
    "a7b8c9d0-e1f2-3456-0123-567890123456": {
        "qsType": "Port",
        "portType": 1,
        "portSide": 3,
        "title": "value",
        "color": "white",
        "enable": true
    },
    "d4e5f6a7-b8c9-0123-def0-234567890123": {
        "qsType": "Link",
        "inputPort": "qqs:/a7b8c9d0-e1f2-3456-0123-567890123456",
        "outputPort": "qqs:/b8c9d0e1-f2a3-4567-1234-678901234567",
        "direction": 1,
        "guiConfig": "qqs:/c9d0e1f2-a3b4-5678-2345-789012345678"
    }
}
```

---

## Best Practices

### 1. File Naming

- Use descriptive names: `CalculatorScene.QQS.json`
- Include version or date if needed: `Scene_v1.0.QQS.json`
- Use consistent naming conventions

### 2. Save Before Load

Always clear objects before loading:

```qml
NLCore.defaultRepo.clearObjects();
NLCore.defaultRepo.loadFromFile(fileName);
```

### 3. Error Handling

Handle save/load errors:

```qml
FileDialog {
    onAccepted: {
        var success = NLCore.defaultRepo.saveToFile(currentFile);
        if (!success) {
            console.error("Failed to save file:", currentFile);
            // Show error message to user
        }
    }
}
```

### 4. Backup Files

Create backups before overwriting:

```qml
function saveWithBackup(fileName) {
    // Create backup
    var backupName = fileName + ".backup";
    if (QFile.exists(fileName)) {
        QFile.copy(fileName, backupName);
    }
    
    // Save new file
    NLCore.defaultRepo.saveToFile(fileName);
}
```

### 5. Version Compatibility

Consider versioning for file format changes:

```qml
// Add version to scene
scene.version = "1.0";

// Check version on load
if (scene.version !== "1.0") {
    console.warn("File version mismatch:", scene.version);
    // Handle migration if needed
}
```

### 6. Large Files

For large scenes:

- Consider compression for storage
- Implement incremental saves
- Use background saving for better UX

### 7. Custom Data Serialization

For custom data types:

```qml
// Custom node data
I_NodeData {
    property var data: null
    
    // Serialize complex data
    function serializeData() {
        return JSON.stringify(data);
    }
    
    // Deserialize complex data
    function deserializeData(jsonString) {
        data = JSON.parse(jsonString);
    }
}
```

---

## Troubleshooting

### File Not Saving

- Check file path permissions
- Verify repository is initialized
- Check console for error messages

### File Not Loading

- Verify file format is correct JSON
- Check that all required node types are registered
- Ensure imports are set correctly before loading

### Missing Properties

- Check if property is blacklisted (starts/ends with `_`)
- Verify property is not readonly
- Ensure property is part of QSObject

### Broken References

- Verify all referenced objects exist in file
- Check UUID format is correct
- Ensure objects are created before references are resolved

### Type Mismatches

- Verify custom node types are registered
- Check that QML component names match `qsType`
- Ensure imports include required modules

---

## Advanced Topics

### Custom Serialization

You can implement custom serialization logic:

```qml
// In custom node
Node {
    function customSerialize() {
        return {
            type: type,
            title: title,
            customData: myCustomData
        };
    }
    
    function customDeserialize(data) {
        type = data.type;
        title = data.title;
        myCustomData = data.customData;
    }
}
```

### Migration

Handle file format changes:

```qml
function migrateScene(scene, fromVersion, toVersion) {
    if (fromVersion === "1.0" && toVersion === "2.0") {
        // Migrate from v1.0 to v2.0
        Object.values(scene.nodes).forEach(node => {
            // Update node properties
            if (!node.newProperty) {
                node.newProperty = defaultValue;
            }
        });
    }
}
```

### Export/Import

Convert to other formats:

```qml
function exportToJSON(scene) {
    var exportData = {
        version: "1.0",
        nodes: [],
        links: []
    };
    
    Object.values(scene.nodes).forEach(node => {
        exportData.nodes.push({
            type: node.type,
            title: node.title,
            position: {
                x: node.guiConfig.position.x,
                y: node.guiConfig.position.y
            }
        });
    });
    
    return JSON.stringify(exportData, null, 2);
}
```