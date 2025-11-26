# API Reference: C++ Classes

## Overview

This document provides a comprehensive reference for all C++ classes available in the NodeLink framework. These classes are registered with the QML engine and can be used directly from QML code. They provide performance-critical operations, utility functions, and advanced features that benefit from C++ implementation.

---

## ObjectCreator

**Location**: `include/NodeLink/Core/objectcreator.h`  
**Source**: `Source/Core/objectcreator.cpp`  
**QML Name**: `ObjectCreator`  
**Type**: QML Singleton  
**Inherits**: `QObject`  
**Purpose**: Factory class for creating QML components programmatically with caching for improved performance.

### Where to Use

**ObjectCreator** is used in the following contexts:

1. **Dynamic Component Creation** (View Layer):
   - Create node views dynamically from QML components
   - Create link views dynamically
   - Create container views dynamically
   - Batch creation of multiple items for performance

   ```qml
   // resources/View/I_NodesRect.qml
   // Create multiple node views at once
   var result = ObjectCreator.createItems(
       "node",           // Property name
       nodeArray,        // Array of node objects
       root,             // Parent item
       nodeViewUrl,      // Component URL
       baseProperties    // Base properties for all items
   );
   
   var createdItems = result.items;
   var needsPropertySet = result.needsPropertySet;
   ```

2. **Single Item Creation**:
   - Create individual QML items programmatically
   - Set initial properties during creation

   ```qml
   // Create a single item
   var result = ObjectCreator.createItem(
       parentItem,       // Parent QQuickItem
       componentUrl,     // URL to QML component
       properties        // Initial properties map
   );
   
   var item = result.item;
   var needsPropertySet = result.needsPropertySet;
   ```

3. **Performance Optimization**:
   - Component caching for faster subsequent creations
   - Batch operations for creating multiple items efficiently
   - Asynchronous component loading

**Use Cases**:
- **Node View Creation**: Dynamically create NodeView components for each node in the scene
- **Link View Creation**: Create LinkView components for connections
- **Container View Creation**: Create ContainerView components for containers
- **Batch Operations**: Create multiple views at once for better performance

### Public Methods

#### `createItem(parentItem: QQuickItem, componentUrl: string, properties: QVariantMap): QVariantMap`

Creates a single QML item from a component URL.

**Parameters**:
- `parentItem`: Parent QQuickItem for the created item
- `componentUrl`: URL string to the QML component file
- `properties`: QVariantMap of initial properties to set on the created item

**Returns**: QVariantMap with:
- `item`: QVariant containing the created QQuickItem (or null if creation failed)
- `needsPropertySet`: Boolean indicating if properties need to be set manually (Qt < 6.2.4)

**Example**:
```qml
var result = ObjectCreator.createItem(
    parentItem,
    "qrc:/MyApp/MyComponent.qml",
    {
        "property1": value1,
        "property2": value2
    }
);

if (result.item) {
    var createdItem = result.item;
    // Use created item
}
```

**Note**: For Qt 6.2.4+, properties are set automatically during creation. For older versions, you may need to set properties manually if `needsPropertySet` is `true`.

#### `createItems(name: string, itemArray: QVariantList, parentItem: QQuickItem, componentUrl: string, baseProperties: QVariantMap): QVariantMap`

Creates multiple QML items from the same component in a batch operation.

**Parameters**:
- `name`: Property name to set for each item in the array
- `itemArray`: QVariantList of objects to create items for
- `parentItem`: Parent QQuickItem for all created items
- `componentUrl`: URL string to the QML component file
- `baseProperties`: QVariantMap of base properties applied to all items

**Returns**: QVariantMap with:
- `items`: QVariantList of created QQuickItem objects
- `needsPropertySet`: Boolean indicating if properties need to be set manually

**Example**:
```qml
// Create node views for multiple nodes
var nodeArray = Object.values(scene.nodes);
var result = ObjectCreator.createItems(
    "node",                    // Property name
    nodeArray,                 // Array of node objects
    nodesRect,                 // Parent item
    "qrc:/NodeLink/NodeView.qml",  // Component URL
    {                          // Base properties
        "scene": scene,
        "sceneSession": sceneSession
    }
);

var createdViews = result.items;
createdViews.forEach(function(view) {
    // Process each created view
});
```

**Performance**: This method is optimized for batch creation and includes component caching. Use this instead of multiple `createItem()` calls for better performance.

### Private Methods

#### `getOrCreateComponent(componentUrl: string): QQmlComponent*`

Internal method that caches components for reuse. Components are cached in a QHash for fast subsequent access.

**Note**: This is a private method and cannot be called directly from QML.

### Implementation Details

- **Component Caching**: Components are cached in `m_components` QHash to avoid reloading
- **Asynchronous Loading**: Components are loaded asynchronously for better performance
- **Memory Management**: Created items use `QQmlEngine::JavaScriptOwnership` for proper cleanup
- **Qt Version Compatibility**: Handles differences between Qt 5 and Qt 6 for property setting

---

## HashCompareStringCPP

**Location**: `include/NodeLink/Core/HashCompareStringCPP.h`  
**Source**: `Source/Core/HashCompareStringCPP.cpp`  
**QML Name**: `HashCompareString`  
**Type**: QML Singleton  
**Inherits**: `QObject`  
**Purpose**: Provides efficient string comparison using MD5 hashing for comparing UUID strings and other identifiers.

### Where to Use

**HashCompareStringCPP** is used in the following contexts:

1. **UUID Comparison** (Scene Link Validation):
   - Compare port UUIDs when checking for duplicate links
   - Compare node UUIDs when validating connections
   - Efficient comparison of string identifiers

   ```qml
   // resources/Core/Scene.qml
   function canLinkNodes(portA: string, portB: string): bool {
       // Check for duplicate links
       var sameLinks = Object.values(links).filter(link =>
           HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
           HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));
       
       if (sameLinks.length > 0)
           return false;
       
       // Compare node UUIDs
       var nodeA = findNodeId(portA);
       var nodeB = findNodeId(portB);
       if (HashCompareString.compareStringModels(nodeA, nodeB))
           return false;  // Same node
   }
   ```

2. **Link Validation**:
   - Check if a link already exists between two ports
   - Validate port connections
   - Prevent duplicate connections

   ```qml
   // Check for existing link
   var existingLink = Object.values(links).find(link =>
       HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
       HashCompareString.compareStringModels(link.outputPort._qsUuid, portB)
   );
   ```

3. **Performance-Critical Comparisons**:
   - When comparing many strings (e.g., iterating over all links)
   - UUID comparisons in validation loops
   - String identity checks

**Use Cases**:
- **Calculator Example**: Validates links and prevents duplicates
- **Logic Circuit Example**: Validates gate connections
- **VisionLink Example**: Validates image processing pipeline connections
- **Chatbot Example**: Validates conversation flow connections
- **All Scene Implementations**: Link validation and UUID comparison

### Public Methods

#### `compareStringModels(strModelFirst: string, strModelSecond: string): bool`

Compares two strings using MD5 hash comparison for efficient equality checking.

**Parameters**:
- `strModelFirst`: First string to compare
- `strModelSecond`: Second string to compare

**Returns**: `true` if strings are equal (same MD5 hash), `false` otherwise

**Example**:
```qml
// Compare UUIDs
var port1Uuid = port1._qsUuid;
var port2Uuid = port2._qsUuid;

if (HashCompareString.compareStringModels(port1Uuid, port2Uuid)) {
    console.log("Ports have the same UUID");
}

// Check for duplicate link
var isDuplicate = Object.values(links).some(function(link) {
    return HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
           HashCompareString.compareStringModels(link.outputPort._qsUuid, portB);
});
```

**Performance**: Uses MD5 hashing for efficient comparison, especially useful when comparing many strings in loops.

**Algorithm**: 
1. Computes MD5 hash of both strings
2. Compares the hash values
3. Returns `true` if hashes match (strings are equal)

---

## BackgroundGridsCPP

**Location**: `include/NodeLink/View/BackgroundGridsCPP.h`  
**Source**: `Source/View/BackgroundGridsCPP.cpp`  
**QML Name**: `BackgroundGridsCPP`  
**Type**: QML Element  
**Inherits**: `QQuickItem`  
**Purpose**: High-performance background grid rendering using Qt's Scene Graph (QSG) for GPU-accelerated rendering.

### Where to Use

**BackgroundGridsCPP** is used in the following contexts:

1. **Scene Background** (View Layer):
   - Render background grid in the scene view
   - Provide visual reference for node positioning
   - Support snap-to-grid functionality

   ```qml
   // resources/View/SceneViewBackground.qml
   BackgroundGridsCPP {
       anchors.fill: parent
       spacing: NLStyle.backgroundGrid.spacing
   }
   ```

2. **Grid Visualization**:
   - Display grid points or lines in the scene
   - Provide visual feedback for alignment
   - Support zoom-aware grid rendering

   ```qml
   // Custom grid configuration
   BackgroundGridsCPP {
       id: backgroundGrid
       anchors.fill: parent
       spacing: 20  // Grid spacing in pixels
       
       onSpacingChanged: {
           console.log("Grid spacing changed to:", spacing);
       }
   }
   ```

3. **Performance-Critical Rendering**:
   - When rendering large scenes with many grid points
   - When grid needs to update frequently
   - When smooth scrolling/zooming is required

**Use Cases**:
- **All NodeLink Views**: Background grid in scene canvas
- **Zoom Operations**: Grid updates when zooming
- **Snap-to-Grid**: Visual feedback for grid snapping
- **Large Scenes**: Efficient rendering of grid for large canvases

### Properties

#### `spacing: int`

Grid spacing in pixels. Determines the distance between grid points.

**Default**: `0` (grid disabled)

**Access**: Read/Write

**Signal**: `spacingChanged()` emitted when spacing changes

**Example**:
```qml
BackgroundGridsCPP {
    spacing: 20  // 20 pixels between grid points
}
```

**Note**: Setting spacing to `0` or negative value disables grid rendering.

### Signals

#### `spacingChanged()`

Emitted when the `spacing` property changes.

**Example**:
```qml
BackgroundGridsCPP {
    onSpacingChanged: {
        console.log("Grid spacing:", spacing);
    }
}
```

### Implementation Details

- **Scene Graph Rendering**: Uses `QQuickItem::updatePaintNode()` for GPU-accelerated rendering
- **Triangle-Based Grid**: Renders grid as series of small triangles for efficient GPU rendering
- **Automatic Updates**: Grid automatically updates when spacing or item size changes
- **Performance**: Optimized for rendering thousands of grid points efficiently
- **Memory Efficient**: Only allocates geometry when spacing > 0 and item has valid size

**Rendering Algorithm**:
1. Calculates number of grid points based on spacing and item size
2. Creates triangle geometry for each grid point (2x2 pixel squares)
3. Uses QSGFlatColorMaterial for rendering
4. Updates geometry only when spacing or size changes

---

## NLUtilsCPP

**Location**: `Utils/NLUtilsCPP.h`  
**Source**: `Utils/NLUtilsCPP.cpp`  
**QML Name**: `NLUtilsCPP`  
**Type**: QML Element  
**Inherits**: `QObject`  
**Purpose**: Utility functions for common operations like image conversion and key sequence formatting.

### Where to Use

**NLUtilsCPP** is used in the following contexts:

1. **Image Processing**:
   - Convert image files to base64 strings
   - Convert image URLs to data strings
   - Prepare images for QML Image components

   ```qml
   // Convert image file to base64 string
   var imageString = NLUtilsCPP.imageURLToImageString("file:///path/to/image.png");
   // Use in Image component
   Image {
       source: "data:image/png;base64," + imageString
   }
   ```

2. **Key Sequence Formatting**:
   - Format keyboard shortcuts for display
   - Convert QKeySequence::StandardKey to readable string
   - Display shortcuts in UI

   ```qml
   // Format key sequence for display
   var keyString = NLUtilsCPP.keySequenceToString(QKeySequence.Copy);
   // Result: "Ctrl + C" (platform-specific)
   ```

**Use Cases**:
- **Image Handling**: Converting images for display in QML
- **UI Display**: Formatting keyboard shortcuts in menus and tooltips
- **File Operations**: Reading and converting image files

### Public Methods

#### `imageURLToImageString(url: string): string`

Reads an image file and converts it to a base64-encoded string.

**Parameters**:
- `url`: File path or URL to the image file (supports `file://` URLs)

**Returns**: Base64-encoded string of the image data, or empty string on failure

**Example**:
```qml
// Load image from file
var imagePath = fileDialog.selectedFile;
var base64String = NLUtilsCPP.imageURLToImageString(imagePath);

// Use in Image component
Image {
    source: "data:image/png;base64," + base64String
}
```

**Error Handling**: Returns empty string if file cannot be opened or read.

#### `keySequenceToString(keySequence: int): string`

Converts a QKeySequence::StandardKey integer to a formatted string representation.

**Parameters**:
- `keySequence`: Integer value from QKeySequence::StandardKey enum

**Returns**: Formatted string with platform-specific key sequence (e.g., "Ctrl + C", "Cmd + C")

**Example**:
```qml
// Format standard key sequences
var copyKey = NLUtilsCPP.keySequenceToString(QKeySequence.Copy);
// Result: "Ctrl + C" (Windows/Linux) or "Cmd + C" (macOS)

var pasteKey = NLUtilsCPP.keySequenceToString(QKeySequence.Paste);
// Result: "Ctrl + V" (Windows/Linux) or "Cmd + V" (macOS)

// Display in UI
Text {
    text: "Copy: " + copyKey
}
```

**Format**: Keys are separated by " + " (space, plus, space) for readability.

**Platform Support**: Returns platform-specific key representations (Ctrl on Windows/Linux, Cmd on macOS).

---

## Common Usage Patterns

### Creating Multiple Node Views

```qml
// Batch create node views for better performance
function onNodesAdded(nodeArray) {
    var result = ObjectCreator.createItems(
        "node",
        nodeArray,
        nodesRect,
        "qrc:/NodeLink/NodeView.qml",
        {
            "scene": scene,
            "sceneSession": sceneSession
        }
    );
    
    // Handle property setting for older Qt versions
    if (result.needsPropertySet) {
        for (var i = 0; i < result.items.length; i++) {
            result.items[i].node = nodeArray[i];
        }
    }
}
```

### Validating Links with Hash Comparison

```qml
// Check if link already exists
function linkExists(portA, portB) {
    return Object.values(links).some(function(link) {
        return HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
               HashCompareString.compareStringModels(link.outputPort._qsUuid, portB);
    });
}
```

### Custom Grid Configuration

```qml
BackgroundGridsCPP {
    id: grid
    anchors.fill: parent
    spacing: 25
    
    onSpacingChanged: {
        console.log("Grid spacing:", spacing);
    }
}

// Change grid spacing dynamically
function setGridSpacing(newSpacing) {
    grid.spacing = newSpacing;
}
```

### Image Loading and Display

```qml
// Load and display image
function loadImage(imagePath) {
    var base64 = NLUtilsCPP.imageURLToImageString(imagePath);
    if (base64) {
        imageComponent.source = "data:image/png;base64," + base64;
    } else {
        console.error("Failed to load image:", imagePath);
    }
}
```

---

## Performance Considerations

### ObjectCreator

- **Component Caching**: Components are cached after first use, making subsequent creations much faster
- **Batch Operations**: Use `createItems()` instead of multiple `createItem()` calls for better performance
- **Asynchronous Loading**: Components are loaded asynchronously to avoid blocking the UI thread

### HashCompareStringCPP

- **MD5 Hashing**: Uses MD5 for efficient comparison, especially beneficial when comparing many strings
- **Use for UUIDs**: Optimized for comparing UUID strings and identifiers
- **Avoid for Short Strings**: For very short strings (< 10 characters), direct comparison may be faster

### BackgroundGridsCPP

- **GPU Acceleration**: Uses Qt Scene Graph for hardware-accelerated rendering
- **Efficient Geometry**: Only updates geometry when spacing or size changes
- **Large Scenes**: Handles thousands of grid points efficiently

### NLUtilsCPP

- **File I/O**: Image loading is synchronous, consider using async operations for large files
- **Base64 Encoding**: Base64 strings are larger than binary data (~33% overhead)

---

## Thread Safety

**Important**: All C++ classes in NodeLink are **not thread-safe**. All operations should be performed on the main UI thread (QML thread). Attempting to use these classes from background threads will result in undefined behavior.

---