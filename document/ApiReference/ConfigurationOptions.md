# API Reference: Configuration Options

## Overview

This document provides a comprehensive reference for all configuration options available in the NodeLink framework. These options allow you to customize the appearance, behavior, and styling of nodes, links, containers, and scenes.

---

## NLStyle - Global Style Settings

**Location**: `resources/View/NLStyle.qml`  
**Type**: Singleton (`pragma Singleton`)  
**Purpose**: Global style settings and theme configuration for the entire NodeLink application.

### Where to Use

**NLStyle** is used throughout NodeLink for consistent styling:

1. **View Components**: All view components reference NLStyle for colors, sizes, fonts
2. **Default Values**: GUI config objects use NLStyle for default values
3. **Theme Customization**: Modify NLStyle to change the entire application theme

**Example**:
```qml
// Accessing style properties
Rectangle {
    color: NLStyle.primaryBackgroundColor
    border.color: NLStyle.primaryBorderColor
    Text {
        color: NLStyle.primaryTextColor
        font.family: NLStyle.fontType.roboto
    }
}
```

### Color Properties

#### `primaryColor: string`
Primary accent color used throughout the application.

**Default**: `"#4890e2"` (Blue)

**Example**:
```qml
Rectangle {
    color: NLStyle.primaryColor
}
```

#### `primaryTextColor: string`
Primary text color for readable text on dark backgrounds.

**Default**: `"white"`

**Example**:
```qml
Text {
    color: NLStyle.primaryTextColor
}
```

#### `primaryBackgroundColor: string`
Primary background color for the application.

**Default**: `"#1e1e1e"` (Dark gray)

**Example**:
```qml
Window {
    color: NLStyle.primaryBackgroundColor
}
```

#### `primaryBorderColor: string`
Primary border color for UI elements.

**Default**: `"#363636"` (Medium gray)

**Example**:
```qml
Rectangle {
    border.color: NLStyle.primaryBorderColor
    border.width: 1
}
```

#### `backgroundGray: string`
Secondary background color for panels and containers.

**Default**: `"#2A2A2A"`

**Example**:
```qml
Rectangle {
    color: NLStyle.backgroundGray
}
```

#### `primaryRed: string`
Primary red color for errors and warnings.

**Default**: `"#8b0000"` (Dark red)

**Example**:
```qml
Rectangle {
    color: NLStyle.primaryRed  // Error indicator
}
```

### Node Style Properties

#### `node: QtObject`
Object containing default node styling properties.

**Properties**:
- `width: real` - Default node width (default: `200`)
- `height: real` - Default node height (default: `150`)
- `opacity: real` - Default node opacity (default: `1.0`)
- `defaultOpacity: real` - Opacity for unselected nodes (default: `0.8`)
- `selectedOpacity: real` - Opacity for selected nodes (default: `0.8`)
- `overviewFontSize: int` - Font size in overview mode (default: `60`)
- `borderWidth: int` - Node border width (default: `2`)
- `fontSizeTitle: int` - Font size for node title (default: `10`)
- `fontSize: int` - Font size for node content (default: `9`)
- `color: string` - Default node color (default: `"pink"`)
- `borderLockColor: string` - Border color for locked nodes (default: `"gray"`)

**Example**:
```qml
Node {
    guiConfig.width: NLStyle.node.width
    guiConfig.height: NLStyle.node.height
    guiConfig.color: NLStyle.node.color
}
```

### Port View Properties

#### `portView: QtObject`
Object containing port view styling properties.

**Properties**:
- `size: int` - Port size in pixels (default: `18`)
- `borderSize: int` - Port border width (default: `2`)
- `fontSize: double` - Port label font size (default: `10`)

**Example**:
```qml
Rectangle {
    width: NLStyle.portView.size
    height: NLStyle.portView.size
    border.width: NLStyle.portView.borderSize
}
```

### Scene Properties

#### `scene: QtObject`
Object containing scene dimension properties.

**Properties**:
- `maximumContentWidth: real` - Maximum scene width (default: `12000`)
- `maximumContentHeight: real` - Maximum scene height (default: `12000`)
- `defaultContentWidth: real` - Default scene width (default: `4000`)
- `defaultContentHeight: real` - Default scene height (default: `4000`)
- `defaultContentX: real` - Default scene X position (default: `1500`)
- `defaultContentY: real` - Default scene Y position (default: `1500`)

**Example**:
```qml
Flickable {
    contentWidth: NLStyle.scene.defaultContentWidth
    contentHeight: NLStyle.scene.defaultContentHeight
}
```

### Background Grid Properties

#### `backgroundGrid: QtObject`
Object containing background grid styling properties.

**Properties**:
- `spacing: int` - Grid spacing in pixels (default: `20`)
- `opacity: double` - Grid opacity (default: `0.65`)

**Example**:
```qml
BackgroundGridsCPP {
    spacing: NLStyle.backgroundGrid.spacing
    opacity: NLStyle.backgroundGrid.opacity
}
```

### Radius Properties

#### `radiusAmount: QtObject`
Object containing border radius values for different UI elements.

**Properties**:
- `nodeOverview: double` - Radius for node overview (default: `20`)
- `blockerNode: double` - Radius for blocker nodes (default: `10`)
- `confirmPopup: double` - Radius for confirmation popups (default: `10`)
- `nodeView: double` - Radius for node views (default: `10`)
- `linkView: double` - Radius for link views (default: `5`)
- `itemButton: double` - Radius for item buttons (default: `5`)
- `toolTip: double` - Radius for tooltips (default: `4`)

**Example**:
```qml
Rectangle {
    radius: NLStyle.radiusAmount.nodeView
}
```

### Font Properties

#### `fontType: QtObject`
Object containing font family names.

**Properties**:
- `roboto: string` - Roboto font family (default: `"Roboto"`)
- `font6Pro: string` - Font Awesome 6 Pro font family (default: `"Font Awesome 6 Pro"`)

**Example**:
```qml
Text {
    font.family: NLStyle.fontType.roboto
    text: "Hello"
}

Text {
    font.family: NLStyle.fontType.font6Pro
    text: "\uf04b"  // Font Awesome icon
}
```

### Icon Arrays

#### `nodeIcons: var`
Array of Font Awesome icon characters for different node types.

**Default**: `["\ue4e2", "\uf04b", "\uf54b", "\ue57f", "\uf2db", "\uf04b"]`

**Example**:
```qml
Text {
    font.family: NLStyle.fontType.font6Pro
    text: NLStyle.nodeIcons[0]  // General node icon
}
```

#### `nodeColors: var`
Array of color strings for different node types.

**Default**: `["#444", "#333", "#3D9798", "#625192", "#9D9E57", "#333"]`

**Example**:
```qml
Rectangle {
    color: NLStyle.nodeColors[0]  // General node color
}
```

#### `linkDirectionIcon: var`
Array of Font Awesome icons for link directions.

**Default**: `["\ue404", "\ue4c1", "\uf07e"]` (Nondirectional, Unidirectional, Bidirectional)

#### `linkStyleIcon: var`
Array of Font Awesome icons for link styles.

**Default**: `["\uf111", "\uf1ce", "\ue105"]` (Solid, Dash, Dot)

#### `linkTypeIcon: var`
Array of icons/characters for link types.

**Default**: `["\uf899", "L", "/"]` (Bezier, LLine, Straight)

### Global Settings

#### `snapEnabled: bool`
Global flag to enable/disable snap-to-grid functionality.

**Default**: `false`

**Access**: Read/Write

**Example**:
```qml
// Enable snap to grid
NLStyle.snapEnabled = true;

// Check if snap is enabled
if (NLStyle.snapEnabled) {
    // Snap node to grid
    node.guiConfig.position = snapToGrid(position);
}
```

---

## NodeGuiConfig - Node Configuration

**Location**: `resources/Core/NodeGuiConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for individual nodes.

### Where to Use

**NodeGuiConfig** is accessed through `node.guiConfig`:

```qml
// In node definition
Node {
    guiConfig.width: 200
    guiConfig.height: 150
    guiConfig.color: "#4A90E2"
}

// Programmatically
node.guiConfig.position = Qt.vector2d(100, 200);
node.guiConfig.width = 300;
```

### Properties

#### `description: string`
Description text for the node.

**Default**: `"<No Description>"`

**Example**:
```qml
node.guiConfig.description = "This node performs addition";
```

#### `logoUrl: string`
URL or path to the node's icon/logo image.

**Default**: `""`

**Example**:
```qml
node.guiConfig.logoUrl = "qrc:/icons/add-icon.png";
```

#### `position: vector2d`
Position of the node in scene coordinates.

**Default**: `Qt.vector2d(0.0, 0.0)`

**Example**:
```qml
node.guiConfig.position = Qt.vector2d(100, 200);
```

#### `width: int`
Width of the node in pixels.

**Default**: `NLStyle.node.width` (200)

**Example**:
```qml
node.guiConfig.width = 250;
```

#### `height: int`
Height of the node in pixels.

**Default**: `NLStyle.node.height` (150)

**Example**:
```qml
node.guiConfig.height = 180;
```

#### `color: string`
Background color of the node (hex format).

**Default**: `NLStyle.node.color` ("pink")

**Example**:
```qml
node.guiConfig.color = "#4A90E2";  // Blue
```

#### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1` (no color index)

**Example**:
```qml
node.guiConfig.colorIndex = 3;  // Use color from palette index 3
```

#### `opacity: real`
Opacity of the node (0.0 to 1.0).

**Default**: `NLStyle.node.opacity` (1.0)

**Example**:
```qml
node.guiConfig.opacity = 0.8;  // 80% opacity
```

#### `locked: bool`
Whether the node is locked (cannot be moved).

**Default**: `false`

**Example**:
```qml
node.guiConfig.locked = true;  // Lock node
```

#### `autoSize: bool`
Whether the node automatically sizes based on content and port titles.

**Default**: `true`

**Example**:
```qml
node.guiConfig.autoSize = false;  // Fixed size
```

#### `minWidth: int`
Minimum width when auto-sizing is enabled.

**Default**: `120`

**Example**:
```qml
node.guiConfig.minWidth = 150;
```

#### `minHeight: int`
Minimum height when auto-sizing is enabled.

**Default**: `80`

**Example**:
```qml
node.guiConfig.minHeight = 100;
```

#### `baseContentWidth: int`
Base content width for auto-sizing calculations (space for operation/image in the middle).

**Default**: `100`

**Example**:
```qml
node.guiConfig.baseContentWidth = 120;
```

### Usage Example

```qml
// Create and configure a node
var node = NLCore.createNode();
node.title = "My Node";
node.guiConfig.position = Qt.vector2d(100, 200);
node.guiConfig.width = 200;
node.guiConfig.height = 150;
node.guiConfig.color = "#4A90E2";
node.guiConfig.opacity = 0.9;
node.guiConfig.autoSize = true;
node.guiConfig.minWidth = 150;
node.guiConfig.minHeight = 100;
node.guiConfig.locked = false;
```

---

## LinkGUIConfig - Link Configuration

**Location**: `resources/Core/LinkGUIConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for links.

### Where to Use

**LinkGUIConfig** is accessed through `link.guiConfig`:

```qml
// Configure link appearance
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Dash;
link.guiConfig.type = NLSpec.LinkType.Bezier;
```

### Properties

#### `description: string`
Description text for the link.

**Default**: `""`

**Example**:
```qml
link.guiConfig.description = "Data flow connection";
```

#### `color: string`
Color of the link (hex format).

**Default**: `"white"`

**Example**:
```qml
link.guiConfig.color = "#4890e2";  // Blue
```

#### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1` (no color index)

**Example**:
```qml
link.guiConfig.colorIndex = 2;
```

#### `style: int`
Line style of the link (see `NLSpec.LinkStyle` enum).

**Default**: `NLSpec.LinkStyle.Solid` (0)

**Values**:
- `NLSpec.LinkStyle.Solid` (0) - Solid line
- `NLSpec.LinkStyle.Dash` (1) - Dashed line
- `NLSpec.LinkStyle.Dot` (2) - Dotted line

**Example**:
```qml
link.guiConfig.style = NLSpec.LinkStyle.Dash;
```

#### `type: int`
Visual type of the link (see `NLSpec.LinkType` enum).

**Default**: `NLSpec.LinkType.Bezier` (0)

**Values**:
- `NLSpec.LinkType.Bezier` (0) - Bezier curve
- `NLSpec.LinkType.LLine` (1) - L-shaped line
- `NLSpec.LinkType.Straight` (2) - Straight line

**Example**:
```qml
link.guiConfig.type = NLSpec.LinkType.Bezier;
```

#### `_isEditableDescription: bool`
Internal flag for handling editable description (not typically used directly).

**Default**: `false`

### Usage Example

```qml
// Create and configure a link
var link = scene.createLink(outputPortUuid, inputPortUuid);
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Solid;
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.guiConfig.description = "Connection from Source to Target";
```

---

## ContainerGuiConfig - Container Configuration

**Location**: `resources/Core/ContainerGuiConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for containers.

### Where to Use

**ContainerGuiConfig** is accessed through `container.guiConfig`:

```qml
// Configure container appearance
container.guiConfig.width = 500;
container.guiConfig.height = 300;
container.guiConfig.color = "#2d2d2d";
```

### Properties

#### `zoomFactor: real`
Zoom factor for the container (used for nested zooming).

**Default**: `1.0`

**Example**:
```qml
container.guiConfig.zoomFactor = 1.5;  // 150% zoom
```

#### `width: real`
Width of the container in pixels.

**Default**: `200`

**Example**:
```qml
container.guiConfig.width = 500;
```

#### `height: real`
Height of the container in pixels.

**Default**: `200`

**Example**:
```qml
container.guiConfig.height = 300;
```

#### `color: string`
Background color of the container (hex format).

**Default**: `NLStyle.primaryColor` ("#4890e2")

**Example**:
```qml
container.guiConfig.color = "#2d2d2d";  // Dark gray
```

#### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1` (no color index)

**Example**:
```qml
container.guiConfig.colorIndex = 1;
```

#### `position: vector2d`
Position of the container in scene coordinates.

**Default**: `Qt.vector2d(0.0, 0.0)`

**Example**:
```qml
container.guiConfig.position = Qt.vector2d(100, 100);
```

#### `locked: bool`
Whether the container is locked (cannot be moved).

**Default**: `false`

**Example**:
```qml
container.guiConfig.locked = true;
```

#### `containerTextHeight: int`
Height of the container title text area.

**Default**: `35`

**Example**:
```qml
container.guiConfig.containerTextHeight = 40;
```

### Usage Example

```qml
// Create and configure a container
var container = scene.createContainer();
container.title = "My Container";
container.guiConfig.position = Qt.vector2d(100, 100);
container.guiConfig.width = 500;
container.guiConfig.height = 300;
container.guiConfig.color = "#2d2d2d";
container.guiConfig.locked = false;
```

---

## SceneGuiConfig - Scene Configuration

**Location**: `resources/Core/SceneGuiConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for the scene view.

### Where to Use

**SceneGuiConfig** is accessed through `scene.sceneGuiConfig`:

```qml
// Configure scene view
scene.sceneGuiConfig.contentWidth = 5000;
scene.sceneGuiConfig.contentHeight = 5000;
scene.sceneGuiConfig.zoomFactor = 1.0;
```

### Properties

#### `zoomFactor: real`
Current zoom factor of the scene view.

**Default**: `1.0`

**Example**:
```qml
scene.sceneGuiConfig.zoomFactor = 1.5;  // 150% zoom
```

#### `contentWidth: real`
Width of the scrollable content area.

**Default**: `NLStyle.scene.defaultContentWidth` (4000)

**Example**:
```qml
scene.sceneGuiConfig.contentWidth = 5000;
```

#### `contentHeight: real`
Height of the scrollable content area.

**Default**: `NLStyle.scene.defaultContentHeight` (4000)

**Example**:
```qml
scene.sceneGuiConfig.contentHeight = 5000;
```

#### `contentX: real`
Horizontal scroll position of the scene view.

**Default**: `NLStyle.scene.defaultContentX` (1500)

**Example**:
```qml
scene.sceneGuiConfig.contentX = 2000;
```

#### `contentY: real`
Vertical scroll position of the scene view.

**Default**: `NLStyle.scene.defaultContentY` (1500)

**Example**:
```qml
scene.sceneGuiConfig.contentY = 2000;
```

#### `sceneViewWidth: real`
Width of the visible scene view area.

**Default**: `undefined` (set by view)

**Example**:
```qml
var viewWidth = scene.sceneGuiConfig.sceneViewWidth;
```

#### `sceneViewHeight: real`
Height of the visible scene view area.

**Default**: `undefined` (set by view)

**Example**:
```qml
var viewHeight = scene.sceneGuiConfig.sceneViewHeight;
```

#### `_mousePosition: vector2d`
Internal property storing mouse position in scene coordinates (used for paste operations).

**Default**: `Qt.vector2d(0.0, 0.0)`

**Note**: This is an internal property and typically not set directly.

### Usage Example

```qml
// Configure scene view
scene.sceneGuiConfig.contentWidth = 6000;
scene.sceneGuiConfig.contentHeight = 6000;
scene.sceneGuiConfig.contentX = 2000;
scene.sceneGuiConfig.contentY = 2000;
scene.sceneGuiConfig.zoomFactor = 1.0;
```

---

## NLSpec - Enums and Constants

**Location**: `resources/Core/NLSpec.qml`  
**Type**: Singleton (`pragma Singleton`)  
**Purpose**: Contains enums and constants used throughout NodeLink.

### Where to Use

**NLSpec** is used for type checking and configuration throughout NodeLink:

```qml
// Port configuration
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;

// Link configuration
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.direction = NLSpec.LinkDirection.Unidirectional;
```

### Enums

#### `ObjectType`
Type of object in the scene.

**Values**:
- `Node` (0) - Node object
- `Link` (1) - Link object
- `Container` (2) - Container object
- `Unknown` (99) - Unknown object type

**Example**:
```qml
if (item.objectType === NLSpec.ObjectType.Node) {
    console.log("This is a node");
}
```

#### `SelectionSpecificToolType`
Type of selection tool.

**Values**:
- `Node` (0) - Select single node
- `Link` (1) - Select single link
- `Any` (2) - Select single object of any type
- `All` (3) - Select multiple objects of any type
- `Unknown` (99) - Unknown tool type

**Example**:
```qml
selectionTool.toolType = NLSpec.SelectionSpecificToolType.Node;
```

#### `PortPositionSide`
Position of a port on a node.

**Values**:
- `Top` (0) - Top side
- `Bottom` (1) - Bottom side
- `Left` (2) - Left side
- `Right` (3) - Right side
- `Unknown` (99) - Unknown position

**Example**:
```qml
port.portSide = NLSpec.PortPositionSide.Left;
```

#### `PortType`
Type of port (data flow direction).

**Values**:
- `Input` (0) - Can only receive connections
- `Output` (1) - Can only send connections
- `InAndOut` (2) - Can both send and receive

**Example**:
```qml
port.portType = NLSpec.PortType.Input;
```

#### `LinkType`
Visual style of the link.

**Values**:
- `Bezier` (0) - Bezier curve
- `LLine` (1) - L-shaped line with one control point
- `Straight` (2) - Straight line
- `Unknown` (99) - Unknown link type

**Example**:
```qml
link.guiConfig.type = NLSpec.LinkType.Bezier;
```

#### `LinkDirection`
Direction of data flow in the link.

**Values**:
- `Nondirectional` (0) - No specific direction
- `Unidirectional` (1) - One-way data flow (default)
- `Bidirectional` (2) - Two-way data flow

**Example**:
```qml
link.direction = NLSpec.LinkDirection.Unidirectional;
```

#### `LinkStyle`
Line style of the link.

**Values**:
- `Solid` (0) - Solid line
- `Dash` (1) - Dashed line
- `Dot` (2) - Dotted line

**Example**:
```qml
link.guiConfig.style = NLSpec.LinkStyle.Dash;
```

#### `NodeType`
Node type identifiers.

**Values**:
- `CustomNode` (98) - Custom node type
- `Unknown` (99) - Unknown node type

**Note**: Most node types are defined in application-specific spec files (e.g., `CSpecs.qml`).

### Properties

#### `undo.blockObservers: bool`
Flag to block observers during undo/redo operations.

**Default**: `false`

**Access**: Read/Write

**Example**:
```qml
// Block observers during undo
NLSpec.undo.blockObservers = true;
// Perform undo operation
undoStack.undo();
// Unblock observers
NLSpec.undo.blockObservers = false;
```

---

## Common Configuration Patterns

### Customizing Node Appearance

```qml
// In node definition
Node {
    guiConfig.width: 250
    guiConfig.height: 180
    guiConfig.color: "#4A90E2"
    guiConfig.opacity: 0.9
    guiConfig.autoSize: true
    guiConfig.minWidth: 150
    guiConfig.minHeight: 100
}
```

### Customizing Link Appearance

```qml
// Configure link
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Solid;
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.direction = NLSpec.LinkDirection.Unidirectional;
```

### Customizing Container Appearance

```qml
// Configure container
container.guiConfig.width = 600;
container.guiConfig.height = 400;
container.guiConfig.color = "#2d2d2d";
container.guiConfig.position = Qt.vector2d(200, 200);
```

### Theming the Application

```qml
// Modify NLStyle for custom theme
// Note: NLStyle properties are readonly, so you would need to modify the source file
// or create a custom style object

// Access style properties
Rectangle {
    color: NLStyle.primaryBackgroundColor
    border.color: NLStyle.primaryBorderColor
    Text {
        color: NLStyle.primaryTextColor
        font.family: NLStyle.fontType.roboto
    }
}
```

### Port Configuration

```qml
// Create and configure port
var port = NLCore.createPort();
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;
port.title = "Input Value";
port.color = "#4A90E2";
port.enable = true;
```

---

## Best Practices

1. **Use NLStyle for Defaults**: Always use NLStyle properties for default values to maintain consistency.

2. **Consistent Colors**: Use the color palette from NLStyle (`primaryColor`, `primaryTextColor`, etc.) for consistent theming.

3. **Auto-Sizing**: Enable `autoSize` for nodes that need to adapt to content, but set appropriate `minWidth` and `minHeight`.

4. **Link Styling**: Use Bezier curves for most links, L-lines for simple connections, and straight lines sparingly.

5. **Port Positioning**: Follow conventions: Input ports on the left, Output ports on the right, Top/Bottom for special cases.

6. **Scene Dimensions**: Use `NLStyle.scene` defaults for initial scene size, but allow users to expand as needed.
