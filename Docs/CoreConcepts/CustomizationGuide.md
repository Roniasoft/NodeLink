# Styling Guide: Customizing Appearance

## Overview

This guide provides comprehensive instructions for customizing the appearance of NodeLink applications. You'll learn how to modify colors, fonts, sizes, and other visual properties to create a custom look and feel that matches your application's design requirements.

---

## Understanding the Styling System

NodeLink uses a hierarchical styling system:

1. **NLStyle** - Global style singleton with default values
2. **GUI Config Objects** - Per-object configuration (NodeGuiConfig, LinkGUIConfig, etc.)
3. **Node Registry** - Node type-specific colors and icons
4. **View Components** - QML components that render the visual elements

### Styling Layers

```
NLStyle (Global Defaults)
    ↓
Node Registry (Type-specific defaults)
    ↓
GUI Config (Per-object configuration)
    ↓
View Components (Rendering)
```

---

## Customizing Global Theme

### Modifying NLStyle

**Note**: NLStyle properties are `readonly`, so you have two options:

1. **Modify the source file** (`resources/View/NLStyle.qml`) for permanent changes
2. **Create a custom style object** for application-specific styling

### Option 1: Modifying NLStyle Source

Edit `resources/View/NLStyle.qml`:

```qml
QtObject {
    // Change primary color
    readonly property string primaryColor: "#FF5733"  // Orange theme
    
    // Change background colors
    readonly property string primaryBackgroundColor: "#0a0a0a"  // Darker background
    readonly property string primaryTextColor: "#ffffff"  // White text
    
    // Change node defaults
    readonly property QtObject node: QtObject {
        property real width: 250  // Larger default width
        property real height: 180  // Larger default height
        property string color: "#4A90E2"  // Blue default
    }
    
    // Change port view size
    readonly property QtObject portView: QtObject {
        property int size: 20  // Larger ports
        property int borderSize: 3
    }
}
```

### Option 2: Creating a Custom Style Object

Create a custom style object in your application:

```qml
// MyCustomStyle.qml
pragma Singleton
import QtQuick

QtObject {
    // Override or extend NLStyle
    property string customPrimaryColor: "#FF5733"
    property string customAccentColor: "#33C3F0"
    
    // Custom color palette
    readonly property var colorPalette: [
        "#FF5733",  // Orange
        "#33C3F0",  // Blue
        "#9B59B6",  // Purple
        "#2ECC71"   // Green
    ]
}
```

### Setting Window Theme

In your `main.qml`:

```qml
import QtQuick.Controls

Window {
    id: window
    
    // Set window background
    color: NLStyle.primaryBackgroundColor
    
    // Set Material theme (if using Material style)
    Material.theme: Material.Dark
    Material.accent: NLStyle.primaryColor
    
    // Or use custom colors
    Material.accent: "#FF5733"  // Custom accent
}
```

---

## Customizing Node Appearance

### Setting Node Colors

#### Method 1: In Node Definition

```qml
// SourceNode.qml
import QtQuick
import NodeLink

Node {
    type: 0
    
    // Set default appearance
    guiConfig.width: 200
    guiConfig.height: 150
    guiConfig.color: "#4A90E2"  // Blue
    guiConfig.opacity: 0.9
    
    Component.onCompleted: addPorts();
}
```

#### Method 2: In Node Registry

```qml
// main.qml
Component.onCompleted: {
    // Register node with custom color
    nodeRegistry.nodeTypes[0] = "SourceNode";
    nodeRegistry.nodeNames[0] = "Source";
    nodeRegistry.nodeIcons[0] = "\uf1c0";
    nodeRegistry.nodeColors[0] = "#4A90E2";  // Custom color
}
```

#### Method 3: Programmatically

```qml
// Create and style node
var node = NLCore.createNode();
node.type = 0;
node.guiConfig.color = "#FF5733";  // Orange
node.guiConfig.width = 250;
node.guiConfig.height = 180;
node.guiConfig.opacity = 0.95;
```

### Node Size Configuration

```qml
Node {
    // Fixed size
    guiConfig.width: 250
    guiConfig.height: 180
    guiConfig.autoSize: false
    
    // OR auto-sizing with constraints
    guiConfig.autoSize: true
    guiConfig.minWidth: 150
    guiConfig.minHeight: 100
    guiConfig.baseContentWidth: 120
}
```

### Node Opacity and Locking

```qml
Node {
    // Set opacity
    guiConfig.opacity: 0.8  // 80% opacity
    
    // Lock node (prevents movement)
    guiConfig.locked: true
}
```

### Custom Node Icons

```qml
// In node registry
nodeRegistry.nodeIcons[0] = "\uf1c0";  // Font Awesome file icon
nodeRegistry.nodeIcons[1] = "\uf0ad";  // Font Awesome cog icon
nodeRegistry.nodeIcons[2] = "\uf1b3";  // Font Awesome cube icon

// Or use custom image
Node {
    guiConfig.logoUrl: "qrc:/icons/my-custom-icon.png"
}
```

### Node Border Styling

Node borders are controlled by `NLStyle.node.borderWidth` and `NLStyle.node.borderLockColor`:

```qml
// In NLStyle.qml
readonly property QtObject node: QtObject {
    property int borderWidth: 3  // Thicker border
    property string borderLockColor: "#FF0000"  // Red for locked nodes
}
```

---

## Customizing Link Appearance

### Link Colors

```qml
// Create link with custom color
var link = scene.createLink(outputPortUuid, inputPortUuid);
link.guiConfig.color = "#4890e2";  // Blue link
```

### Link Styles

```qml
// Solid line
link.guiConfig.style = NLSpec.LinkStyle.Solid;

// Dashed line
link.guiConfig.style = NLSpec.LinkStyle.Dash;

// Dotted line
link.guiConfig.style = NLSpec.LinkStyle.Dot;
```

### Link Types

```qml
// Bezier curve (smooth, curved)
link.guiConfig.type = NLSpec.LinkType.Bezier;

// L-shaped line (with control point)
link.guiConfig.type = NLSpec.LinkType.LLine;

// Straight line
link.guiConfig.type = NLSpec.LinkType.Straight;
```

### Link Direction

```qml
// Unidirectional (one-way, default)
link.direction = NLSpec.LinkDirection.Unidirectional;

// Bidirectional (two-way)
link.direction = NLSpec.LinkDirection.Bidirectional;

// Nondirectional
link.direction = NLSpec.LinkDirection.Nondirectional;
```

### Complete Link Styling Example

```qml
// Create and style a link
var link = scene.createLink(outputPortUuid, inputPortUuid);
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Solid;
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.direction = NLSpec.LinkDirection.Unidirectional;
link.guiConfig.description = "Data flow connection";
```

---

## Customizing Container Appearance

### Container Colors and Sizes

```qml
// Create and style container
var container = scene.createContainer();
container.title = "My Container";
container.guiConfig.width = 600;
container.guiConfig.height = 400;
container.guiConfig.color = "#2d2d2d";  // Dark gray
container.guiConfig.position = Qt.vector2d(100, 100);
```

### Container Locking

```qml
// Lock container
container.guiConfig.locked = true;
```

### Container Text Height

```qml
// Adjust title area height
container.guiConfig.containerTextHeight = 40;
```

---

## Customizing Scene Appearance

### Scene Background

```qml
// In main.qml
Window {
    color: NLStyle.primaryBackgroundColor  // Dark background
    
    // Or custom color
    color: "#0a0a0a"  // Very dark
}
```

### Background Grid

```qml
// In SceneViewBackground.qml or custom component
BackgroundGridsCPP {
    spacing: 25  // Larger grid spacing
    opacity: 0.5  // More transparent
}

// Or use NLStyle defaults
BackgroundGridsCPP {
    spacing: NLStyle.backgroundGrid.spacing  // 20
    opacity: NLStyle.backgroundGrid.opacity  // 0.65
}
```

### Scene Dimensions

```qml
// Configure scene view size
scene.sceneGuiConfig.contentWidth = 6000;
scene.sceneGuiConfig.contentHeight = 6000;
scene.sceneGuiConfig.contentX = 2000;
scene.sceneGuiConfig.contentY = 2000;
```

### Snap to Grid

```qml
// Enable snap to grid globally
NLStyle.snapEnabled = true;

// Use in node positioning
if (NLStyle.snapEnabled) {
    var snappedPos = scene.snappedPosition(position);
    node.guiConfig.position = snappedPos;
}
```

---

## Customizing Port Appearance

### Port Colors

```qml
// Create port with custom color
var port = NLCore.createPort();
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;
port.title = "Input";
port.color = "#4A90E2";  // Blue port
```

### Port Size

Port size is controlled globally by `NLStyle.portView.size`:

```qml
// In NLStyle.qml
readonly property QtObject portView: QtObject {
    property int size: 20  // Larger ports (default: 18)
    property int borderSize: 3  // Thicker border (default: 2)
    property double fontSize: 12  // Larger font (default: 10)
}
```

### Port Enable/Disable

```qml
// Disable port (grayed out, cannot connect)
port.enable = false;

// Enable port
port.enable = true;
```

---

## Color Schemes and Themes

### Dark Theme (Default)

```qml
// Dark theme colors
readonly property string primaryBackgroundColor: "#1e1e1e"
readonly property string primaryTextColor: "white"
readonly property string primaryBorderColor: "#363636"
readonly property string backgroundGray: "#2A2A2A"
```

### Light Theme

```qml
// Light theme colors
readonly property string primaryBackgroundColor: "#f5f5f5"
readonly property string primaryTextColor: "#333333"
readonly property string primaryBorderColor: "#cccccc"
readonly property string backgroundGray: "#e0e0e0"
```

### Custom Color Palette

Create a color palette for your application:

```qml
// ColorPalette.qml
pragma Singleton
import QtQuick

QtObject {
    // Primary colors
    readonly property string primary: "#4890e2"
    readonly property string secondary: "#FF5733"
    readonly property string accent: "#33C3F0"
    
    // Semantic colors
    readonly property string success: "#2ECC71"
    readonly property string warning: "#F39C12"
    readonly property string error: "#E74C3C"
    readonly property string info: "#3498DB"
    
    // Neutral colors
    readonly property string dark: "#1e1e1e"
    readonly property string light: "#f5f5f5"
    readonly property string gray: "#95a5a6"
    
    // Node type colors
    readonly property var nodeColors: [
        "#4A90E2",  // Source nodes
        "#F5A623",  // Operation nodes
        "#7ED321",  // Result nodes
        "#BD10E0",  // Special nodes
        "#50E3C2"   // Utility nodes
    ]
}
```

### Using Color Palette

```qml
// In node definitions
Node {
    guiConfig.color: ColorPalette.nodeColors[0]  // Use palette color
}

// In links
link.guiConfig.color = ColorPalette.primary;

// In containers
container.guiConfig.color = ColorPalette.secondary;
```

### Color by Node Type

```qml
// Register nodes with type-specific colors
Component.onCompleted: {
    // Source nodes - Blue
    nodeRegistry.nodeColors[CSpecs.NodeType.Source] = "#4A90E2";
    
    // Operation nodes - Orange
    nodeRegistry.nodeColors[CSpecs.NodeType.Operation] = "#F5A623";
    
    // Result nodes - Green
    nodeRegistry.nodeColors[CSpecs.NodeType.Result] = "#7ED321";
}
```

---

## Font Customization

### Available Fonts

NodeLink uses two main font families:

1. **Roboto** - For text content
2. **Font Awesome 6 Pro** - For icons

### Using Fonts

```qml
// Text with Roboto
Text {
    font.family: NLStyle.fontType.roboto
    font.pointSize: 12
    text: "Node Title"
}

// Icon with Font Awesome
Text {
    font.family: NLStyle.fontType.font6Pro
    font.pointSize: 16
    text: "\uf04b"  // Font Awesome icon
}
```

### Font Sizes

Node font sizes are controlled by `NLStyle.node`:

```qml
// In NLStyle.qml
readonly property QtObject node: QtObject {
    property int fontSizeTitle: 12  // Title font size (default: 10)
    property int fontSize: 11  // Content font size (default: 9)
}
```

### Custom Fonts

To use custom fonts:

1. **Add font file** to your resources:
   ```qml
   // In main.qml
   FontLoader {
       source: "qrc:/fonts/MyCustomFont.ttf"
   }
   ```

2. **Use in NLStyle**:
   ```qml
   readonly property QtObject fontType: QtObject {
       readonly property string roboto: "Roboto"
       readonly property string font6Pro: "Font Awesome 6 Pro"
       readonly property string custom: "MyCustomFont"  // Your font
   }
   ```

3. **Use in components**:
   ```qml
   Text {
       font.family: NLStyle.fontType.custom
       text: "Custom Font Text"
   }
   ```

---

## Best Practices

### 1. Consistency

- Use `NLStyle` properties for default values to maintain consistency
- Create a color palette and use it throughout your application
- Use consistent node colors for similar node types

### 2. Accessibility

- Ensure sufficient contrast between text and background colors
- Use colors that are distinguishable for colorblind users
- Provide visual feedback for interactive elements

### 3. Performance

- Avoid changing styles dynamically in loops
- Use `autoSize` for nodes that need to adapt, but set appropriate min/max constraints
- Cache style values if used frequently

### 4. Theming

- Create theme objects for different color schemes
- Allow users to switch themes if needed
- Store theme preferences in settings

### 5. Customization Levels

- **Global**: Modify `NLStyle` for application-wide changes
- **Type-specific**: Use node registry colors for node type styling
- **Instance-specific**: Use `guiConfig` for individual object styling

### 6. Color Selection

- Use a limited color palette (5-7 main colors)
- Use semantic colors (success, error, warning) consistently
- Test colors in both light and dark themes

---

## Complete Styling Example

Here's a complete example of a styled NodeLink application:

```qml
// main.qml
import QtQuick
import QtQuick.Controls
import NodeLink

Window {
    id: window
    
    // Window styling
    width: 1280
    height: 960
    color: "#1e1e1e"  // Dark background
    Material.theme: Material.Dark
    Material.accent: "#4890e2"
    
    property Scene scene: Scene { }
    property NLNodeRegistry nodeRegistry: NLNodeRegistry {
        _qsRepo: NLCore.defaultRepo
        imports: ["MyApp", "NodeLink"]
        defaultNode: 0
    }
    
    Component.onCompleted: {
        // Register nodes with custom colors
        nodeRegistry.nodeTypes[0] = "SourceNode";
        nodeRegistry.nodeNames[0] = "Source";
        nodeRegistry.nodeIcons[0] = "\uf1c0";
        nodeRegistry.nodeColors[0] = "#4A90E2";  // Blue
        
        nodeRegistry.nodeTypes[1] = "OperationNode";
        nodeRegistry.nodeNames[1] = "Operation";
        nodeRegistry.nodeIcons[1] = "\uf0ad";
        nodeRegistry.nodeColors[1] = "#F5A623";  // Orange
        
        // Initialize scene
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "MyApp"])
        NLCore.defaultRepo.initRootObject("Scene");
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });
        window.scene.nodeRegistry = nodeRegistry;
    }
    
    // Main view
    NLView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
```

```qml
// SourceNode.qml
import QtQuick
import NodeLink

Node {
    type: 0
    
    // Custom styling
    guiConfig.width: 200
    guiConfig.height: 150
    guiConfig.color: "#4A90E2"  // Blue
    guiConfig.opacity: 0.9
    guiConfig.autoSize: true
    guiConfig.minWidth: 150
    guiConfig.minHeight: 100
    
    Component.onCompleted: addPorts();
    
    function addPorts() {
        let port = NLCore.createPort();
        port.portType = NLSpec.PortType.Output;
        port.portSide = NLSpec.PortPositionSide.Right;
        port.title = "Output";
        port.color = "#4A90E2";  // Match node color
        addPort(port);
    }
}
```

---

## Troubleshooting

### Colors Not Applying

- Check that you're setting `guiConfig.color` after the node is created
- Verify node registry colors are set in `Component.onCompleted`
- Ensure colors are in hex format: `"#RRGGBB"`

### Fonts Not Loading

- Verify font files are included in resources (`.qrc` file)
- Check font family name matches the actual font name
- Use `FontLoader` to load fonts before using them

### Styles Not Updating

- `NLStyle` properties are `readonly` - modify the source file or create custom style
- Some properties require view refresh - try restarting the application
- Check that you're modifying the correct config object (`guiConfig` vs `sceneGuiConfig`)

---