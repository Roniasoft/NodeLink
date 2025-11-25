# NodeLink

## Introduction
NodeLink is a qml node editor library that can be used for a wide range of applications. This library allows for the visualization and manipulation of complex graphs while also providing the flexibility for customization and integration with other software.

[![Made by ROMINA](https://img.shields.io/badge/Made%20by-ROMINA-blue)](https://github.com/Roniasoft/NodeLink)
![Version](https://img.shields.io/badge/Version-0.9.0-blue)

## Usage

The Nodelink library is a tool that can be used to connect different components within a system or application. To use this library, one can refer to the examples provided within the library and follow the instructions accordingly. The examples provided serve as a guide and demonstrate how to connect different nodes and manipulate data between them.

## What is NodeLink?

NodeLink is a Qt/QML-based framework for building node-based applications. It follows the Model-View-Controller (MVC) architecture, providing a clear separation of concerns and a modular design.

* **Model**: Represents the data and business logic of the application.
* **View**: Handles the UI rendering and user interactions.
* **Controller**: Manages the interactions between the Model and View.

This architecture allows for a high degree of customization and flexibility, making NodeLink suitable for a wide range of applications.

## Core Library

The NodeLink core library provides a robust framework for building node-based applications. It includes:

* A modular, MVC (Model-View-Controller) architecture
* A customizable node system with support for various data types
* A powerful signal-slot system for node interactions
* Extensive Qt/QML integration for seamless UI development

## Key Features

Here are some of the key features that make NodeLink a powerful tool for building node-based applications:

* **Modular Node System**: Create custom nodes with specific behaviors and interactions.
* **Signal-Slot System**: Enable complex node interactions using a powerful signal-slot system.
* **Qt/QML Integration**: Seamlessly integrate NodeLink with Qt/QML for UI development.
* **Customizable**: Highly customizable architecture and node system.
* **Extensive Documentation**: Comprehensive documentation and example projects.

---

## 🧩 3. Examples Showcase
Learn NodeLink through real examples.

- **🔢 Calculator** — A simple math node graph. [➡️ More details](Examples/Calculator.md)

  ![Calculator Example Overview](images/Calculator_Main.png)

- **⚡ Logic Circuits** — Visual logic gates and real-time signals. [➡️ More details](Examples/LogicCircuit.md)

    ![LogicCircuit Example Overview](images/LogicCircuit_Main.png)

- **💬 Chatbot** — Rule-based chatbot built visually using regex nodes. [➡️ More details](Examples/Chatbot.md)

![Chatbot Example Overview](images/Chatbot_Main.png)

- **🖼️ Vison Link** — Build visual pipelines for image operations. [➡️ More details][(More details)](Examples/VisionLink.md)

![VisonLink Example Overview](images/VisionLink_Main.png)

- **📊 PerformanceAnalyzer** — Stress-test NodeLink with large graphs. [➡️ More details](Examples/PerformanceAnalyzer.md)

![Performance Analyzer Example Overview](images/PerformanceAnalyzer_Main.png)

- **🌱 Simple NodeLink** — The most basic example for new users. [➡️ More details](Examples/SimpleNodeLink.md)

![SimpleNodeLink Example Overview](images/SimpleNodeLink_Main.png)
---




## Installation Guide - Create Your First Custom Node in 10 Minutes
### Overview

This guide will walk you through installing NodeLink and creating your first custom node in just 10 minutes. By the end of this tutorial, you'll have a working NodeLink application with a custom "HelloWorld" node that you can create, connect, and interact with.

[➡️ More details](InstallationGuide/InstallationGuide.md)

---

## Core Concepts & Components

### Architecture Overview

NodeLink follows a **Model-View-Controller (MVC)** architecture pattern with some variations adapted for QML/Qt Quick. This document explains the architecture, separation of concerns, and how components interact.

[➡️ More details](CoreConcepts/ArchitectureOverview.md)

---

### Core Components

This section explains the essential building blocks of NodeLink’s engine, including the Scene, Node, Port, Link, and Container models. It covers their responsibilities, data structure, signals, and how they interact with each other inside the graph model.

[➡️ More details](CoreConcepts/CoreComponents.md)

---

### Other Components

NodeLink includes several supporting components that extend the core architecture, such as the Selection Model, Undo/Redo system, GUI configuration objects, and utility classes. This section describes how these parts work together to provide a complete and flexible node-based framework.

[➡️ More details](CoreConcepts/OtherComponents.md)

---

## Customization Guide

This document explains how to customize NodeLink’s behavior and appearance, including creating new node types, overriding styles, modifying GUI configurations, and extending engine behavior. It is intended for developers building advanced or domain-specific features on top of NodeLink.

[➡️ More details](CoreConcepts/CustomizationGuide.md)


## API Reference

### QMLComponents

This document provides a comprehensive reference for all QML components, properties, functions, and signals available in the NodeLink framework. Use this reference to understand the API structure and how to interact with NodeLink components programmatically.

[➡️ More details](ApiReference/QmlComponents.md)

---

### C++ Classes

This document provides a comprehensive reference for all C++ classes available in the NodeLink framework. These classes are registered with the QML engine and can be used directly from QML code. They provide performance-critical operations, utility functions, and advanced features that benefit from C++ implementation.

[➡️ More details](ApiReference/CppClasses.md)

---

### Configuration Options

This document provides a comprehensive reference for all configuration options available in the NodeLink framework. These options allow you to customize the appearance, behavior, and styling of nodes, links, containers, and scenes.

[➡️ More details](ApiReference/ConfigurationOptions.md)

---

### NLStyle - Global Style Settings

**Location**: `resources/View/NLStyle.qml`  
**Type**: Singleton (`pragma Singleton`)  
**Purpose**: Global style settings and theme configuration for the entire NodeLink application.

#### Where to Use

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

#### Color Properties

##### `primaryColor: string`
Primary accent color used throughout the application.

**Default**: `"#4890e2"` (Blue)

**Example**:
```qml
Rectangle {
    color: NLStyle.primaryColor
}
```

##### `primaryTextColor: string`
Primary text color for readable text on dark backgrounds.

**Default**: `"white"`

**Example**:
```qml
Text {
    color: NLStyle.primaryTextColor
}
```

##### `primaryBackgroundColor: string`
Primary background color for the application.

**Default**: `"#1e1e1e"` (Dark gray)

**Example**:
```qml
Window {
    color: NLStyle.primaryBackgroundColor
}
```

##### `primaryBorderColor: string`
Primary border color for UI elements.

**Default**: `"#363636"` (Medium gray)

**Example**:
```qml
Rectangle {
    border.color: NLStyle.primaryBorderColor
    border.width: 1
}
```

##### `backgroundGray: string`
Secondary background color for panels and containers.

**Default**: `"#2A2A2A"`

**Example**:
```qml
Rectangle {
    color: NLStyle.backgroundGray
}
```

##### `primaryRed: string`
Primary red color for errors and warnings.

**Default**: `"#8b0000"` (Dark red)

**Example**:
```qml
Rectangle {
    color: NLStyle.primaryRed  // Error indicator
}
```

#### Node Style Properties

##### `node: QtObject`
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

#### Port View Properties

##### `portView: QtObject`
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

#### Scene Properties

##### `scene: QtObject`
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

#### Background Grid Properties

##### `backgroundGrid: QtObject`
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

#### Radius Properties

##### `radiusAmount: QtObject`
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

#### Font Properties

##### `fontType: QtObject`
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

#### Icon Arrays

##### `nodeIcons: var`
Array of Font Awesome icon characters for different node types.

**Default**: `["\ue4e2", "\uf04b", "\uf54b", "\ue57f", "\uf2db", "\uf04b"]`

**Example**:
```qml
Text {
    font.family: NLStyle.fontType.font6Pro
    text: NLStyle.nodeIcons[0]  // General node icon
}
```

##### `nodeColors: var`
Array of color strings for different node types.

**Default**: `["#444", "#333", "#3D9798", "#625192", "#9D9E57", "#333"]`

**Example**:
```qml
Rectangle {
    color: NLStyle.nodeColors[0]  // General node color
}
```

##### `linkDirectionIcon: var`
Array of Font Awesome icons for link directions.

**Default**: `["\ue404", "\ue4c1", "\uf07e"]` (Nondirectional, Unidirectional, Bidirectional)

##### `linkStyleIcon: var`
Array of Font Awesome icons for link styles.

**Default**: `["\uf111", "\uf1ce", "\ue105"]` (Solid, Dash, Dot)

##### `linkTypeIcon: var`
Array of icons/characters for link types.

**Default**: `["\uf899", "L", "/"]` (Bezier, LLine, Straight)

#### Global Settings

##### `snapEnabled: bool`
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

### NodeGuiConfig - Node Configuration

**Location**: `resources/Core/NodeGuiConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for individual nodes.

#### Where to Use

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

#### Properties

##### `description: string`
Description text for the node.

**Default**: `"<No Description>"`

**Example**:
```qml
node.guiConfig.description = "This node performs addition";
```

##### `logoUrl: string`
URL or path to the node's icon/logo image.

**Default**: `""`

**Example**:
```qml
node.guiConfig.logoUrl = "qrc:/icons/add-icon.png";
```

##### `position: vector2d`
Position of the node in scene coordinates.

**Default**: `Qt.vector2d(0.0, 0.0)`

**Example**:
```qml
node.guiConfig.position = Qt.vector2d(100, 200);
```

##### `width: int`
Width of the node in pixels.

**Default**: `NLStyle.node.width` (200)

**Example**:
```qml
node.guiConfig.width = 250;
```

##### `height: int`
Height of the node in pixels.

**Default**: `NLStyle.node.height` (150)

**Example**:
```qml
node.guiConfig.height = 180;
```

##### `color: string`
Background color of the node (hex format).

**Default**: `NLStyle.node.color` ("pink")

**Example**:
```qml
node.guiConfig.color = "#4A90E2";  // Blue
```

##### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1` (no color index)

**Example**:
```qml
node.guiConfig.colorIndex = 3;  // Use color from palette index 3
```

##### `opacity: real`
Opacity of the node (0.0 to 1.0).

**Default**: `NLStyle.node.opacity` (1.0)

**Example**:
```qml
node.guiConfig.opacity = 0.8;  // 80% opacity
```

##### `locked: bool`
Whether the node is locked (cannot be moved).

**Default**: `false`

**Example**:
```qml
node.guiConfig.locked = true;  // Lock node
```

##### `autoSize: bool`
Whether the node automatically sizes based on content and port titles.

**Default**: `true`

**Example**:
```qml
node.guiConfig.autoSize = false;  // Fixed size
```

##### `minWidth: int`
Minimum width when auto-sizing is enabled.

**Default**: `120`

**Example**:
```qml
node.guiConfig.minWidth = 150;
```

##### `minHeight: int`
Minimum height when auto-sizing is enabled.

**Default**: `80`

**Example**:
```qml
node.guiConfig.minHeight = 100;
```

##### `baseContentWidth: int`
Base content width for auto-sizing calculations (space for operation/image in the middle).

**Default**: `100`

**Example**:
```qml
node.guiConfig.baseContentWidth = 120;
```

#### Usage Example

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

### LinkGUIConfig - Link Configuration

**Location**: `resources/Core/LinkGUIConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for links.

#### Where to Use

**LinkGUIConfig** is accessed through `link.guiConfig`:

```qml
// Configure link appearance
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Dash;
link.guiConfig.type = NLSpec.LinkType.Bezier;
```

#### Properties

##### `description: string`
Description text for the link.

**Default**: `""`

**Example**:
```qml
link.guiConfig.description = "Data flow connection";
```

##### `color: string`
Color of the link (hex format).

**Default**: `"white"`

**Example**:
```qml
link.guiConfig.color = "#4890e2";  // Blue
```

##### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1` (no color index)

**Example**:
```qml
link.guiConfig.colorIndex = 2;
```

##### `style: int`
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

##### `type: int`
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

##### `_isEditableDescription: bool`
Internal flag for handling editable description (not typically used directly).

**Default**: `false`

#### Usage Example

```qml
// Create and configure a link
var link = scene.createLink(outputPortUuid, inputPortUuid);
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Solid;
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.guiConfig.description = "Connection from Source to Target";
```

---

### ContainerGuiConfig - Container Configuration

**Location**: `resources/Core/ContainerGuiConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for containers.

#### Where to Use

**ContainerGuiConfig** is accessed through `container.guiConfig`:

```qml
// Configure container appearance
container.guiConfig.width = 500;
container.guiConfig.height = 300;
container.guiConfig.color = "#2d2d2d";
```

#### Properties

##### `zoomFactor: real`
Zoom factor for the container (used for nested zooming).

**Default**: `1.0`

**Example**:
```qml
container.guiConfig.zoomFactor = 1.5;  // 150% zoom
```

##### `width: real`
Width of the container in pixels.

**Default**: `200`

**Example**:
```qml
container.guiConfig.width = 500;
```

##### `height: real`
Height of the container in pixels.

**Default**: `200`

**Example**:
```qml
container.guiConfig.height = 300;
```

##### `color: string`
Background color of the container (hex format).

**Default**: `NLStyle.primaryColor` ("#4890e2")

**Example**:
```qml
container.guiConfig.color = "#2d2d2d";  // Dark gray
```

##### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1` (no color index)

**Example**:
```qml
container.guiConfig.colorIndex = 1;
```

##### `position: vector2d`
Position of the container in scene coordinates.

**Default**: `Qt.vector2d(0.0, 0.0)`

**Example**:
```qml
container.guiConfig.position = Qt.vector2d(100, 100);
```

##### `locked: bool`
Whether the container is locked (cannot be moved).

**Default**: `false`

**Example**:
```qml
container.guiConfig.locked = true;
```

##### `containerTextHeight: int`
Height of the container title text area.

**Default**: `35`

**Example**:
```qml
container.guiConfig.containerTextHeight = 40;
```

#### Usage Example

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

### SceneGuiConfig - Scene Configuration

**Location**: `resources/Core/SceneGuiConfig.qml`  
**Type**: QSObject  
**Purpose**: Stores GUI-related properties for the scene view.

#### Where to Use

**SceneGuiConfig** is accessed through `scene.sceneGuiConfig`:

```qml
// Configure scene view
scene.sceneGuiConfig.contentWidth = 5000;
scene.sceneGuiConfig.contentHeight = 5000;
scene.sceneGuiConfig.zoomFactor = 1.0;
```

#### Properties

##### `zoomFactor: real`
Current zoom factor of the scene view.

**Default**: `1.0`

**Example**:
```qml
scene.sceneGuiConfig.zoomFactor = 1.5;  // 150% zoom
```

##### `contentWidth: real`
Width of the scrollable content area.

**Default**: `NLStyle.scene.defaultContentWidth` (4000)

**Example**:
```qml
scene.sceneGuiConfig.contentWidth = 5000;
```

##### `contentHeight: real`
Height of the scrollable content area.

**Default**: `NLStyle.scene.defaultContentHeight` (4000)

**Example**:
```qml
scene.sceneGuiConfig.contentHeight = 5000;
```

##### `contentX: real`
Horizontal scroll position of the scene view.

**Default**: `NLStyle.scene.defaultContentX` (1500)

**Example**:
```qml
scene.sceneGuiConfig.contentX = 2000;
```

##### `contentY: real`
Vertical scroll position of the scene view.

**Default**: `NLStyle.scene.defaultContentY` (1500)

**Example**:
```qml
scene.sceneGuiConfig.contentY = 2000;
```

##### `sceneViewWidth: real`
Width of the visible scene view area.

**Default**: `undefined` (set by view)

**Example**:
```qml
var viewWidth = scene.sceneGuiConfig.sceneViewWidth;
```

##### `sceneViewHeight: real`
Height of the visible scene view area.

**Default**: `undefined` (set by view)

**Example**:
```qml
var viewHeight = scene.sceneGuiConfig.sceneViewHeight;
```

##### `_mousePosition: vector2d`
Internal property storing mouse position in scene coordinates (used for paste operations).

**Default**: `Qt.vector2d(0.0, 0.0)`

**Note**: This is an internal property and typically not set directly.

#### Usage Example

```qml
// Configure scene view
scene.sceneGuiConfig.contentWidth = 6000;
scene.sceneGuiConfig.contentHeight = 6000;
scene.sceneGuiConfig.contentX = 2000;
scene.sceneGuiConfig.contentY = 2000;
scene.sceneGuiConfig.zoomFactor = 1.0;
```

---

### NLSpec - Enums and Constants

**Location**: `resources/Core/NLSpec.qml`  
**Type**: Singleton (`pragma Singleton`)  
**Purpose**: Contains enums and constants used throughout NodeLink.

#### Where to Use

**NLSpec** is used for type checking and configuration throughout NodeLink:

```qml
// Port configuration
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;

// Link configuration
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.direction = NLSpec.LinkDirection.Unidirectional;
```

#### Enums

##### `ObjectType`
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

##### `SelectionSpecificToolType`
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

##### `PortPositionSide`
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

##### `PortType`
Type of port (data flow direction).

**Values**:
- `Input` (0) - Can only receive connections
- `Output` (1) - Can only send connections
- `InAndOut` (2) - Can both send and receive

**Example**:
```qml
port.portType = NLSpec.PortType.Input;
```

##### `LinkType`
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

##### `LinkDirection`
Direction of data flow in the link.

**Values**:
- `Nondirectional` (0) - No specific direction
- `Unidirectional` (1) - One-way data flow (default)
- `Bidirectional` (2) - Two-way data flow

**Example**:
```qml
link.direction = NLSpec.LinkDirection.Unidirectional;
```

##### `LinkStyle`
Line style of the link.

**Values**:
- `Solid` (0) - Solid line
- `Dash` (1) - Dashed line
- `Dot` (2) - Dotted line

**Example**:
```qml
link.guiConfig.style = NLSpec.LinkStyle.Dash;
```

##### `NodeType`
Node type identifiers.

**Values**:
- `CustomNode` (98) - Custom node type
- `Unknown` (99) - Unknown node type

**Note**: Most node types are defined in application-specific spec files (e.g., `CSpecs.qml`).

#### Properties

##### `undo.blockObservers: bool`
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

### Common Configuration Patterns

#### Customizing Node Appearance

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

#### Customizing Link Appearance

```qml
// Configure link
link.guiConfig.color = "#4890e2";
link.guiConfig.style = NLSpec.LinkStyle.Solid;
link.guiConfig.type = NLSpec.LinkType.Bezier;
link.direction = NLSpec.LinkDirection.Unidirectional;
```

#### Customizing Container Appearance

```qml
// Configure container
container.guiConfig.width = 600;
container.guiConfig.height = 400;
container.guiConfig.color = "#2d2d2d";
container.guiConfig.position = Qt.vector2d(200, 200);
```

#### Theming the Application

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

#### Port Configuration

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

### Best Practices

1. **Use NLStyle for Defaults**: Always use NLStyle properties for default values to maintain consistency.

2. **Consistent Colors**: Use the color palette from NLStyle (`primaryColor`, `primaryTextColor`, etc.) for consistent theming.

3. **Auto-Sizing**: Enable `autoSize` for nodes that need to adapt to content, but set appropriate `minWidth` and `minHeight`.

4. **Link Styling**: Use Bezier curves for most links, L-lines for simple connections, and straight lines sparingly.

5. **Port Positioning**: Follow conventions: Input ports on the left, Output ports on the right, Top/Bottom for special cases.

6. **Scene Dimensions**: Use `NLStyle.scene` defaults for initial scene size, but allow users to expand as needed.


## Styling Guide: Customizing Appearance (Understanding the Styling System)

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

### Customizing Global Theme

#### Modifying NLStyle

**Note**: NLStyle properties are `readonly`, so you have two options:

1. **Modify the source file** (`resources/View/NLStyle.qml`) for permanent changes
2. **Create a custom style object** for application-specific styling

#### Option 1: Modifying NLStyle Source

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

#### Option 2: Creating a Custom Style Object

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

#### Setting Window Theme

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

### Customizing Node Appearance

#### Setting Node Colors

##### Method 1: In Node Definition

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

##### Method 2: In Node Registry

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

##### Method 3: Programmatically

```qml
// Create and style node
var node = NLCore.createNode();
node.type = 0;
node.guiConfig.color = "#FF5733";  // Orange
node.guiConfig.width = 250;
node.guiConfig.height = 180;
node.guiConfig.opacity = 0.95;
```

#### Node Size Configuration

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

#### Node Opacity and Locking

```qml
Node {
    // Set opacity
    guiConfig.opacity: 0.8  // 80% opacity
    
    // Lock node (prevents movement)
    guiConfig.locked: true
}
```

#### Custom Node Icons

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

#### Node Border Styling

Node borders are controlled by `NLStyle.node.borderWidth` and `NLStyle.node.borderLockColor`:

```qml
// In NLStyle.qml
readonly property QtObject node: QtObject {
    property int borderWidth: 3  // Thicker border
    property string borderLockColor: "#FF0000"  // Red for locked nodes
}
```

---

### Customizing Link Appearance

#### Link Colors

```qml
// Create link with custom color
var link = scene.createLink(outputPortUuid, inputPortUuid);
link.guiConfig.color = "#4890e2";  // Blue link
```

#### Link Styles

```qml
// Solid line
link.guiConfig.style = NLSpec.LinkStyle.Solid;

// Dashed line
link.guiConfig.style = NLSpec.LinkStyle.Dash;

// Dotted line
link.guiConfig.style = NLSpec.LinkStyle.Dot;
```

#### Link Types

```qml
// Bezier curve (smooth, curved)
link.guiConfig.type = NLSpec.LinkType.Bezier;

// L-shaped line (with control point)
link.guiConfig.type = NLSpec.LinkType.LLine;

// Straight line
link.guiConfig.type = NLSpec.LinkType.Straight;
```

#### Link Direction

```qml
// Unidirectional (one-way, default)
link.direction = NLSpec.LinkDirection.Unidirectional;

// Bidirectional (two-way)
link.direction = NLSpec.LinkDirection.Bidirectional;

// Nondirectional
link.direction = NLSpec.LinkDirection.Nondirectional;
```

#### Complete Link Styling Example

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

### Customizing Container Appearance

#### Container Colors and Sizes

```qml
// Create and style container
var container = scene.createContainer();
container.title = "My Container";
container.guiConfig.width = 600;
container.guiConfig.height = 400;
container.guiConfig.color = "#2d2d2d";  // Dark gray
container.guiConfig.position = Qt.vector2d(100, 100);
```

#### Container Locking

```qml
// Lock container
container.guiConfig.locked = true;
```

#### Container Text Height

```qml
// Adjust title area height
container.guiConfig.containerTextHeight = 40;
```

---

### Customizing Scene Appearance

#### Scene Background

```qml
// In main.qml
Window {
    color: NLStyle.primaryBackgroundColor  // Dark background
    
    // Or custom color
    color: "#0a0a0a"  // Very dark
}
```

#### Background Grid

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

#### Scene Dimensions

```qml
// Configure scene view size
scene.sceneGuiConfig.contentWidth = 6000;
scene.sceneGuiConfig.contentHeight = 6000;
scene.sceneGuiConfig.contentX = 2000;
scene.sceneGuiConfig.contentY = 2000;
```

#### Snap to Grid

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

### Customizing Port Appearance

#### Port Colors

```qml
// Create port with custom color
var port = NLCore.createPort();
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;
port.title = "Input";
port.color = "#4A90E2";  // Blue port
```

#### Port Size

Port size is controlled globally by `NLStyle.portView.size`:

```qml
// In NLStyle.qml
readonly property QtObject portView: QtObject {
    property int size: 20  // Larger ports (default: 18)
    property int borderSize: 3  // Thicker border (default: 2)
    property double fontSize: 12  // Larger font (default: 10)
}
```

#### Port Enable/Disable

```qml
// Disable port (grayed out, cannot connect)
port.enable = false;

// Enable port
port.enable = true;
```

---

### Color Schemes and Themes

#### Dark Theme (Default)

```qml
// Dark theme colors
readonly property string primaryBackgroundColor: "#1e1e1e"
readonly property string primaryTextColor: "white"
readonly property string primaryBorderColor: "#363636"
readonly property string backgroundGray: "#2A2A2A"
```

#### Light Theme

```qml
// Light theme colors
readonly property string primaryBackgroundColor: "#f5f5f5"
readonly property string primaryTextColor: "#333333"
readonly property string primaryBorderColor: "#cccccc"
readonly property string backgroundGray: "#e0e0e0"
```

#### Custom Color Palette

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

#### Using Color Palette

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

#### Color by Node Type

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

### Font Customization

#### Available Fonts

NodeLink uses two main font families:

1. **Roboto** - For text content
2. **Font Awesome 6 Pro** - For icons

#### Using Fonts

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

#### Font Sizes

Node font sizes are controlled by `NLStyle.node`:

```qml
// In NLStyle.qml
readonly property QtObject node: QtObject {
    property int fontSizeTitle: 12  // Title font size (default: 10)
    property int fontSize: 11  // Content font size (default: 9)
}
```

#### Custom Fonts

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

### Best Practices

#### 1. Consistency

- Use `NLStyle` properties for default values to maintain consistency
- Create a color palette and use it throughout your application
- Use consistent node colors for similar node types

#### 2. Accessibility

- Ensure sufficient contrast between text and background colors
- Use colors that are distinguishable for colorblind users
- Provide visual feedback for interactive elements

#### 3. Performance

- Avoid changing styles dynamically in loops
- Use `autoSize` for nodes that need to adapt, but set appropriate min/max constraints
- Cache style values if used frequently

### 4. Theming

- Create theme objects for different color schemes
- Allow users to switch themes if needed
- Store theme preferences in settings

#### 5. Customization Levels

- **Global**: Modify `NLStyle` for application-wide changes
- **Type-specific**: Use node registry colors for node type styling
- **Instance-specific**: Use `guiConfig` for individual object styling

#### 6. Color Selection

- Use a limited color palette (5-7 main colors)
- Use semantic colors (success, error, warning) consistently
- Test colors in both light and dark themes

---

### Complete Styling Example

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

### Troubleshooting

#### Colors Not Applying

- Check that you're setting `guiConfig.color` after the node is created
- Verify node registry colors are set in `Component.onCompleted`
- Ensure colors are in hex format: `"#RRGGBB"`

#### Fonts Not Loading

- Verify font files are included in resources (`.qrc` file)
- Check font family name matches the actual font name
- Use `FontLoader` to load fonts before using them

#### Styles Not Updating

- `NLStyle` properties are `readonly` - modify the source file or create custom style
- Some properties require view refresh - try restarting the application
- Check that you're modifying the correct config object (`guiConfig` vs `sceneGuiConfig`)

---


#Advanced Topics

# Custom Node Creation Guide

## Overview

NodeLink provides a flexible and extensible framework for creating custom node types. This guide covers everything you need to know to create, register, and use custom nodes in your NodeLink application. Custom nodes are the building blocks of your visual programming interface, allowing users to create complex workflows by connecting different node types together.

---

## Architecture Overview

The custom node creation system consists of several key components:

```
┌────────────────────────────────────────────────────────┐
│                    Node Registry                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  nodeTypes   │  │  nodeNames   │  │  nodeIcons   │  │
│  │  nodeColors  │  │  imports     │  │  defaultNode │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────┐
│                      Scene                      │
│  ┌──────────────────────────────────────────┐   │
│  │         createCustomizeNode()            │   │
│  │         createSpecificNode()             │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    Custom Node                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │     Node     │  │     Ports    │  │  NodeData    │       │
│  │  (Base)      │  │  (I/O)       │  │  (Data)      │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │  GuiConfig   │  │  Properties  │                         │
│  │  (UI)        │  │  (Custom)    │                         │
│  └──────────────┘  └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

1. **Node Registry (NLNodeRegistry)**: Central registry for all node types
2. **Scene**: Manages node creation and lifecycle
3. **Node**: Base class for all custom nodes
4. **Port**: Connection points for data flow
5. **NodeData**: Data storage and processing
6. **NodeGuiConfig**: Visual appearance configuration

---

## Node Hierarchy

### Class Hierarchy

```
QSObject (QtQuickStream)
    └── I_Node
        └── Node
            └── YourCustomNode
```

### Interface Classes

#### I_Node

**Location**: `resources/Core/I_Node.qml`

**Purpose**: Base interface for all node-like objects.

**Key Properties**:
- `objectType`: Type identifier (Node, Link, Container)
- `nodeData`: Reference to node data object

**Key Signals**:
- `cloneFrom(baseNode)`: Emitted when node is cloned

**Key Functions**:
- `onCloneFrom(baseNode)`: Handler for cloning operation

#### Node

**Location**: `resources/Core/Node.qml`

**Purpose**: Base implementation for all custom nodes.

**Key Properties**:
- `type`: Unique integer identifier for node type
- `title`: Display name of the node
- `guiConfig`: NodeGuiConfig object for UI properties
- `ports`: Map of port UUIDs to Port objects
- `children`: Map of child node UUIDs to Node objects
- `parents`: Map of parent node UUIDs to Node objects
- `imagesModel`: ImagesModel for managing node images

**Key Functions**:
- `addPort(port)`: Add a port to the node
- `deletePort(port)`: Remove a port from the node
- `findPort(portId)`: Find port by UUID
- `findPortByPortSide(portSide)`: Find port by side position

**Key Signals**:
- `portAdded(portId)`: Emitted when port is added
- `nodeCompleted()`: Emitted after Component.onCompleted

---

## Step-by-Step Guide

### Step 1: Create Node QML File

Create a new QML file for your custom node. The file should inherit from `Node`.

**Example**: `MyCustomNode.qml`

```qml
import QtQuick
import NodeLink

Node {
    // Set unique type identifier
    type: 1

    // Configure node data
    nodeData: I_NodeData {}

    // Configure GUI
    guiConfig.width: 200
    guiConfig.height: 150
    guiConfig.color: "#4A90E2"

    // Add ports when node is created
    Component.onCompleted: addPorts();

    // Handle cloning
    onCloneFrom: function(baseNode) {
        // Copy properties from base node
        // Customize as needed
    }

    // Add ports function
    function addPorts() {
        // Create and configure ports here
    }
}
```

### Step 2: Register Node in Registry

Register your node in the `NLNodeRegistry` in your main QML file.

**Example**: `main.qml`

```qml
import QtQuick
import NodeLink

Window {
    property NLNodeRegistry nodeRegistry: NLNodeRegistry {
        _qsRepo: NLCore.defaultRepo
        imports: ["MyApp", "NodeLink"]
        defaultNode: 0
    }

    Component.onCompleted: {
        // Register your custom node
        var nodeType = 1;
        nodeRegistry.nodeTypes[nodeType] = "MyCustomNode";
        nodeRegistry.nodeNames[nodeType] = "My Custom Node";
        nodeRegistry.nodeIcons[nodeType] = "\uf123";  // Font Awesome icon
        nodeRegistry.nodeColors[nodeType] = "#4A90E2";

        // Set registry to scene
        scene.nodeRegistry = nodeRegistry;
    }
}
```

### Step 3: Add to CMakeLists.txt

Add your node QML file to the CMake build configuration.

**Example**: `CMakeLists.txt`

```cmake
qt_add_qml_module(MyApp
    URI "MyApp"
    VERSION 1.0
    QML_FILES
        main.qml
        MyCustomNode.qml
        # ... other files
)
```

### Step 4: Override createCustomizeNode (Optional)

If you need custom node creation logic, override `createCustomizeNode` in your Scene.

**Example**: `MyScene.qml`

```qml
import QtQuick
import NodeLink

Scene {
    function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
        var qsType = nodeRegistry.nodeTypes[nodeType];
        if (!qsType) {
            console.error("Unknown node type:", nodeType);
            return null;
        }

        // Generate unique title
        var title = nodeRegistry.nodeNames[nodeType] + "_" + 
                   (Object.values(nodes).filter(node => node.type === nodeType).length + 1);

        // Apply snap if enabled
        if (NLStyle.snapEnabled) {
            var position = snappedPosition(Qt.vector2d(xPos, yPos));
            xPos = position.x;
            yPos = position.y;
        }

        // Create node
        return createSpecificNode(
            nodeRegistry.imports,
            nodeType,
            qsType,
            nodeRegistry.nodeColors[nodeType],
            title,
            xPos,
            yPos
        );
    }
}
```

---

## Node Registry

### NLNodeRegistry

**Location**: `resources/Core/NLNodeRegistry.qml`

**Purpose**: Central registry for managing all node types in the application.

### Properties

#### `imports: []`
Array of QML module imports required to create nodes.

**Example**:
```qml
imports: ["MyApp", "NodeLink", "QtQuickStream"]
```

#### `nodeTypes: {}`
Map of node type IDs to QML component names.

**Example**:
```qml
nodeTypes: {
    0: "SourceNode",
    1: "OperationNode",
    2: "ResultNode"
}
```

#### `nodeNames: {}`
Map of node type IDs to display names.

**Example**:
```qml
nodeNames: {
    0: "Source",
    1: "Operation",
    2: "Result"
}
```

#### `nodeIcons: {}`
Map of node type IDs to icon characters (Font Awesome Unicode).

**Example**:
```qml
nodeIcons: {
    0: "\uf1c0",  // fa-file
    1: "\uf0ad",  // fa-cog
    2: "\uf00c"   // fa-check
}
```

**Finding Font Awesome Icons**:
- Visit [Font Awesome Icons](https://fontawesome.com/icons)
- Copy the Unicode value (e.g., `\uf1c0`)
- Use in nodeIcons map

#### `nodeColors: {}`
Map of node type IDs to color strings (hex format).

**Example**:
```qml
nodeColors: {
    0: "#4A90E2",  // Blue
    1: "#F5A623",  // Orange
    2: "#7ED321"   // Green
}
```

#### `defaultNode: int`
Default node type to create when no type is specified.

**Example**:
```qml
defaultNode: 0  // Create SourceNode by default
```

#### `nodeView: string`
Path to custom node view component (optional).

**Example**:
```qml
nodeView: "qrc:/MyApp/NodeView.qml"
```

#### `linkView: string`
Path to custom link view component (optional).

**Example**:
```qml
linkView: "qrc:/MyApp/LinkView.qml"
```

#### `containerView: string`
Path to custom container view component (optional).

**Example**:
```qml
containerView: "qrc:/MyApp/ContainerView.qml"
```

### Complete Registry Example

```qml
property NLNodeRegistry nodeRegistry: NLNodeRegistry {
    _qsRepo: NLCore.defaultRepo
    imports: ["Calculator", "NodeLink"]
    defaultNode: 0

    Component.onCompleted: {
        // Source Node
        nodeRegistry.nodeTypes[0] = "SourceNode";
        nodeRegistry.nodeNames[0] = "Source";
        nodeRegistry.nodeIcons[0] = "\uf1c0";
        nodeRegistry.nodeColors[0] = "#4A90E2";

        // Operation Node
        nodeRegistry.nodeTypes[1] = "OperationNode";
        nodeRegistry.nodeNames[1] = "Operation";
        nodeRegistry.nodeIcons[1] = "\uf0ad";
        nodeRegistry.nodeColors[1] = "#F5A623";

        // Result Node
        nodeRegistry.nodeTypes[2] = "ResultNode";
        nodeRegistry.nodeNames[2] = "Result";
        nodeRegistry.nodeIcons[2] = "\uf00c";
        nodeRegistry.nodeColors[2] = "#7ED321";
    }
}
```

---

## Creating Custom Nodes

### Basic Node Structure

```qml
import QtQuick
import NodeLink

Node {
    // 1. Set unique type identifier
    type: 1

    // 2. Configure node data
    nodeData: I_NodeData {}

    // 3. Configure GUI properties
    guiConfig.width: 200
    guiConfig.height: 150
    guiConfig.color: "#4A90E2"

    // 4. Add ports on creation
    Component.onCompleted: addPorts();

    // 5. Handle cloning (optional)
    onCloneFrom: function(baseNode) {
        // Copy properties if needed
    }

    // 6. Define port creation
    function addPorts() {
        // Create ports here
    }

    // 7. Add custom properties (optional)
    property string myProperty: "value"

    // 8. Add custom functions (optional)
    function myFunction() {
        // Custom logic
    }
}
```

### Node Type Identifier

The `type` property is a unique integer that identifies your node type. It must match the key used in the node registry.

```qml
Node {
    type: 1  // Must match nodeRegistry.nodeTypes[1]
}
```

**Best Practices**:
- Use enum constants for type IDs (see examples)
- Start from 0 and increment sequentially
- Reserve 98 for CustomNode, 99 for Unknown
- Document your type IDs

**Example with Enum**:
```qml
// CSpecs.qml (Singleton)
pragma Singleton
import QtQuick

QtObject {
    enum NodeType {
        Source = 0,
        Operation = 1,
        Result = 2,
        CustomNode = 98,
        Unknown = 99
    }
}

// MyNode.qml
import QtQuick
import NodeLink
import MyApp

Node {
    type: CSpecs.NodeType.Operation
    // ...
}
```

### Node Title

The `title` property is automatically set when the node is created, but you can customize it:

```qml
Node {
    type: 1
    title: "My Custom Node"  // Override default title
}
```

**Default Title Format**:
```
{nodeName}_{count}
```

**Example**: `Source_1`, `Source_2`, `Operation_1`

### Node Data

Every node should have a `nodeData` property that stores the node's data.

#### Using I_NodeData

```qml
Node {
    nodeData: I_NodeData {}
}
```

#### Using Custom NodeData

```qml
// MyNodeData.qml
import QtQuick
import NodeLink

I_NodeData {
    property var input: null
    property var output: null
    property int count: 0
}

// MyNode.qml
Node {
    nodeData: MyNodeData {}
}
```

**Accessing Node Data**:
```qml
// In node
nodeData.data = "some value"
var value = nodeData.data

// In scene
node.nodeData.data = "some value"
```

---

## Ports

Ports are connection points that allow nodes to send and receive data. Each port can be configured with type, position, and other properties.

### Creating Ports

Use `NLCore.createPort()` to create new ports:

```qml
function addPorts() {
    let port = NLCore.createPort();
    port.portType = NLSpec.PortType.Output;
    port.portSide = NLSpec.PortPositionSide.Right;
    port.title = "Output";
    addPort(port);
}
```

### Port Types

#### `NLSpec.PortType.Input`
Port can only receive connections (input only).

```qml
port.portType = NLSpec.PortType.Input
```

#### `NLSpec.PortType.Output`
Port can only send connections (output only).

```qml
port.portType = NLSpec.PortType.Output
```

#### `NLSpec.PortType.InAndOut`
Port can both send and receive connections (bidirectional).

```qml
port.portType = NLSpec.PortType.InAndOut
```

### Port Positions

#### `NLSpec.PortPositionSide.Top`
Port appears on the top side of the node.

```qml
port.portSide = NLSpec.PortPositionSide.Top
```

#### `NLSpec.PortPositionSide.Bottom`
Port appears on the bottom side of the node.

```qml
port.portSide = NLSpec.PortPositionSide.Bottom
```

#### `NLSpec.PortPositionSide.Left`
Port appears on the left side of the node.

```qml
port.portSide = NLSpec.PortPositionSide.Left
```

#### `NLSpec.PortPositionSide.Right`
Port appears on the right side of the node.

```qml
port.portSide = NLSpec.PortPositionSide.Right
```

### Port Properties

#### `title: string`
Display name for the port.

```qml
port.title = "Input Value"
```

#### `color: string`
Color of the port (hex format).

```qml
port.color = "#FF5733"
```

#### `enable: bool`
Whether the port is enabled (can be connected).

```qml
port.enable = true  // Enabled (default)
port.enable = false // Disabled (grayed out)
```

### Complete Port Example

```qml
function addPorts() {
    // Input port (left side)
    let inputPort = NLCore.createPort();
    inputPort.portType = NLSpec.PortType.Input;
    inputPort.portSide = NLSpec.PortPositionSide.Left;
    inputPort.title = "Input";
    inputPort.color = "#4A90E2";
    addPort(inputPort);

    // Output port (right side)
    let outputPort = NLCore.createPort();
    outputPort.portType = NLSpec.PortType.Output;
    outputPort.portSide = NLSpec.PortPositionSide.Right;
    outputPort.title = "Output";
    outputPort.color = "#7ED321";
    addPort(outputPort);
}
```

### Finding Ports

#### By UUID
```qml
var port = node.findPort(portUuid);
```

#### By Side
```qml
var port = node.findPortByPortSide(NLSpec.PortPositionSide.Left);
```

### Port Management

#### Adding Ports
```qml
function addPorts() {
    let port = NLCore.createPort();
    // Configure port
    addPort(port);  // Add to node
}
```

#### Removing Ports
```qml
var port = node.findPort(portUuid);
if (port) {
    node.deletePort(port);
}
```

---

## Node Data

Node data is stored in the `nodeData` property, which is an instance of `I_NodeData` or a custom subclass.

### I_NodeData

**Location**: `resources/Core/I_NodeData.qml`

**Base Properties**:
- `data: var`: Generic data storage (can be any type)

**Basic Usage**:
```qml
Node {
    nodeData: I_NodeData {}

    function processData() {
        nodeData.data = "processed result";
    }
}
```

### Custom NodeData

Create custom node data classes for type-safe data handling:

```qml
// OperationNodeData.qml
import QtQuick
import NodeLink

I_NodeData {
    property var input1: null
    property var input2: null
    property var output: null
    property int operation: 0
}

// OperationNode.qml
Node {
    nodeData: OperationNodeData {}

    function calculate() {
        if (nodeData.input1 && nodeData.input2) {
            switch (nodeData.operation) {
                case 0: // Add
                    nodeData.output = nodeData.input1 + nodeData.input2;
                    break;
                case 1: // Subtract
                    nodeData.output = nodeData.input1 - nodeData.input2;
                    break;
            }
            nodeData.data = nodeData.output;
        }
    }
}
```

### Data Flow

Data flows through ports and is stored in node data:

```
Node A (Output) → Link → Node B (Input)
                      ↓
                 nodeData.input
                      ↓
              Process/Transform
                      ↓
                 nodeData.data
                      ↓
                 nodeData.output
                      ↓
Node B (Output) → Link → Node C (Input)
```

### Accessing Connected Node Data

```qml
// In scene updateData function
function updateData() {
    Object.values(nodes).forEach(node => {
        // Get input from connected nodes
        Object.values(node.ports).forEach(port => {
            if (port.portType === NLSpec.PortType.Input) {
                // Find links connected to this port
                var link = findLinkByInputPort(port._qsUuid);
                if (link) {
                    var sourceNode = findNode(link.outputPort._qsUuid);
                    if (sourceNode) {
                        // Copy data from source
                        node.nodeData.input = sourceNode.nodeData.data;
                    }
                }
            }
        });

        // Process node data
        if (node.processData) {
            node.processData();
        }
    });
}
```

---

## Node GUI Configuration

The `guiConfig` property controls the visual appearance and behavior of nodes.

### NodeGuiConfig Properties

#### `width: int` and `height: int`
Node dimensions in pixels.

```qml
guiConfig.width: 200
guiConfig.height: 150
```

#### `position: vector2d`
Node position in the scene.

```qml
guiConfig.position: Qt.vector2d(100, 200)
```

#### `color: string`
Node background color (hex format).

```qml
guiConfig.color: "#4A90E2"
```

#### `opacity: real`
Node opacity (0.0 to 1.0).

```qml
guiConfig.opacity: 1.0
```

#### `locked: bool`
Whether the node is locked (cannot be moved).

```qml
guiConfig.locked: false
```

#### `autoSize: bool`
Automatically size node based on content and port titles.

```qml
guiConfig.autoSize: true  // Auto-size enabled (default)
guiConfig.autoSize: false // Fixed size
```

#### `minWidth: int` and `minHeight: int`
Minimum node dimensions when auto-sizing.

```qml
guiConfig.minWidth: 120
guiConfig.minHeight: 80
```

#### `baseContentWidth: int`
Base width for content area (for auto-sizing calculations).

```qml
guiConfig.baseContentWidth: 100
```

#### `description: string`
Node description text.

```qml
guiConfig.description: "This node performs calculations"
```

#### `logoUrl: string`
URL or path to node icon/logo.

```qml
guiConfig.logoUrl: "qrc:/icons/my-node-icon.png"
```

### Complete GUI Config Example

```qml
Node {
    guiConfig.width: 250
    guiConfig.height: 200
    guiConfig.color: "#4A90E2"
    guiConfig.opacity: 1.0
    guiConfig.autoSize: false
    guiConfig.minWidth: 200
    guiConfig.minHeight: 150
    guiConfig.description: "Performs mathematical operations"
    guiConfig.logoUrl: "qrc:/icons/operation.png"
}
```

---

## Advanced Topics

### Cloning Nodes

Nodes can be cloned (copied) using the `cloneFrom` signal handler.

#### Basic Cloning

```qml
Node {
    onCloneFrom: function(baseNode) {
        // Base properties are copied automatically
        // Customize additional properties here
        myProperty = baseNode.myProperty;
    }
}
```

#### Advanced Cloning

```qml
Node {
    property var myData: null

    onCloneFrom: function(baseNode) {
        // Copy base properties
        title = baseNode.title;
        type = baseNode.type;

        // Copy custom properties
        if (baseNode.myData) {
            myData = JSON.parse(JSON.stringify(baseNode.myData));  // Deep copy
        }

        // Reset node data
        nodeData.data = null;
    }
}
```

### Custom Properties

Add custom properties to your nodes:

```qml
Node {
    // Simple properties
    property string myString: "default"
    property int myNumber: 0
    property bool myBool: false

    // Complex properties
    property var myObject: ({})
    property var myArray: []

    // Custom objects
    property MyCustomObject myObject: MyCustomObject {}
}
```

### Custom Functions

Add custom functions to your nodes:

```qml
Node {
    function processData() {
        // Custom processing logic
        if (nodeData.input) {
            nodeData.data = nodeData.input * 2;
        }
    }

    function validateInput() {
        return nodeData.input !== null && nodeData.input !== undefined;
    }

    function reset() {
        nodeData.data = null;
        nodeData.input = null;
    }
}
```

### Dynamic Ports

Create ports dynamically based on conditions:

```qml
Node {
    property int inputCount: 2

    Component.onCompleted: {
        addPorts();
        updatePorts();
    }

    function addPorts() {
        // Create base ports
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        addPort(outputPort);
    }

    function updatePorts() {
        // Remove old input ports
        Object.values(ports).forEach(port => {
            if (port.portType === NLSpec.PortType.Input) {
                deletePort(port);
            }
        });

        // Create new input ports
        for (var i = 0; i < inputCount; i++) {
            let inputPort = NLCore.createPort();
            inputPort.portType = NLSpec.PortType.Input;
            inputPort.portSide = NLSpec.PortPositionSide.Left;
            inputPort.title = "Input " + (i + 1);
            addPort(inputPort);
        }
    }

    onInputCountChanged: {
        updatePorts();
    }
}
```

### Node Inheritance

Create base node classes and inherit from them:

```qml
// BaseOperationNode.qml
import QtQuick
import NodeLink

Node {
    property int operationType: 0
    nodeData: OperationNodeData {}

    function addPorts() {
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input;
        inputPort.portSide = NLSpec.PortPositionSide.Left;
        addPort(inputPort);

        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        addPort(outputPort);
    }
}

// AddNode.qml
BaseOperationNode {
    operationType: 0  // Add

    function calculate() {
        if (nodeData.input1 && nodeData.input2) {
            nodeData.data = nodeData.input1 + nodeData.input2;
        }
    }
}

// MultiplyNode.qml
BaseOperationNode {
    operationType: 1  // Multiply

    function calculate() {
        if (nodeData.input1 && nodeData.input2) {
            nodeData.data = nodeData.input1 * nodeData.input2;
        }
    }
}
```

### Scene Integration

Override scene functions for custom node behavior:

```qml
// MyScene.qml
Scene {
    function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
        // Custom creation logic
        var nodeId = createSpecificNode(
            nodeRegistry.imports,
            nodeType,
            nodeRegistry.nodeTypes[nodeType],
            nodeRegistry.nodeColors[nodeType],
            generateTitle(nodeType),
            xPos,
            yPos
        );

        // Post-creation setup
        var node = nodes[nodeId];
        if (node && node.initialize) {
            node.initialize();
        }

        return nodeId;
    }

    function generateTitle(nodeType: int): string {
        var baseName = nodeRegistry.nodeNames[nodeType];
        var count = Object.values(nodes).filter(n => n.type === nodeType).length;
        return baseName + "_" + (count + 1);
    }
}
```

---

## Examples

### Example 1: Simple Source Node

```qml
// SourceNode.qml
import QtQuick
import NodeLink

Node {
    type: 0
    nodeData: I_NodeData {}

    guiConfig.width: 150
    guiConfig.height: 100
    guiConfig.color: "#4A90E2"

    property real value: 0.0

    Component.onCompleted: addPorts();

    function addPorts() {
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "value";
        addPort(outputPort);
    }

    onValueChanged: {
        nodeData.data = value;
    }
}
```

### Example 2: Operation Node

```qml
// OperationNode.qml
import QtQuick
import NodeLink

Node {
    type: 1
    nodeData: OperationNodeData {}

    guiConfig.width: 200
    guiConfig.height: 120
    guiConfig.color: "#F5A623"

    property int operationType: 0  // 0=Add, 1=Subtract, 2=Multiply, 3=Divide

    Component.onCompleted: addPorts();

    function addPorts() {
        let input1Port = NLCore.createPort();
        input1Port.portType = NLSpec.PortType.Input;
        input1Port.portSide = NLSpec.PortPositionSide.Left;
        input1Port.title = "input 1";
        addPort(input1Port);

        let input2Port = NLCore.createPort();
        input2Port.portType = NLSpec.PortType.Input;
        input2Port.portSide = NLSpec.PortPositionSide.Left;
        input2Port.title = "input 2";
        addPort(input2Port);

        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "result";
        addPort(outputPort);
    }

    function calculate() {
        if (nodeData.input1 !== null && nodeData.input2 !== null) {
            switch (operationType) {
                case 0: nodeData.data = nodeData.input1 + nodeData.input2; break;
                case 1: nodeData.data = nodeData.input1 - nodeData.input2; break;
                case 2: nodeData.data = nodeData.input1 * nodeData.input2; break;
                case 3: nodeData.data = nodeData.input2 !== 0 ? nodeData.input1 / nodeData.input2 : 0; break;
            }
        } else {
            nodeData.data = null;
        }
    }
}

// OperationNodeData.qml
import QtQuick
import NodeLink

I_NodeData {
    property var input1: null
    property var input2: null
}
```

### Example 3: Image Processing Node

```qml
// BlurNode.qml
import QtQuick
import NodeLink
import VisionLink

Node {
    type: 2
    nodeData: OperationNodeData {}

    guiConfig.width: 250
    guiConfig.height: 150
    guiConfig.color: "#9013FE"

    property real blurRadius: 5.0

    Component.onCompleted: addPorts();

    function addPorts() {
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input;
        inputPort.portSide = NLSpec.PortPositionSide.Left;
        inputPort.title = "image";
        addPort(inputPort);

        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "blurred";
        addPort(outputPort);
    }

    function processImage() {
        if (!nodeData.input) {
            nodeData.data = null;
            return;
        }

        var inputImage = nodeData.input;
        if (typeof inputImage === "string") {
            inputImage = ImageProcessor.loadImage(inputImage);
        }

        if (ImageProcessor.isValidImage(inputImage)) {
            nodeData.data = ImageProcessor.applyBlur(inputImage, blurRadius);
        } else {
            nodeData.data = null;
        }
    }

    onBlurRadiusChanged: {
        processImage();
    }
}
```

---

## Best Practices

### 1. Use Enums for Type IDs

```qml
// CSpecs.qml
pragma Singleton
import QtQuick

QtObject {
    enum NodeType {
        Source = 0,
        Operation = 1,
        Result = 2
    }
}

// MyNode.qml
Node {
    type: CSpecs.NodeType.Operation
}
```

### 2. Initialize Ports in Component.onCompleted

```qml
Node {
    Component.onCompleted: addPorts();  // Always initialize ports here
}
```

### 3. Handle Cloning Properly

```qml
Node {
    onCloneFrom: function(baseNode) {
        // Reset node-specific data
        nodeData.data = null;
        // Copy only necessary properties
    }
}
```

### 4. Use Descriptive Port Titles

```qml
port.title = "Input Value"  // Good
port.title = "in"           // Bad
```

### 5. Set Appropriate Node Sizes

```qml
guiConfig.width: 200   // Reasonable default
guiConfig.height: 150
guiConfig.autoSize: true  // Let it adjust if needed
```

### 6. Validate Data Before Processing

```qml
function processData() {
    if (!nodeData.input || nodeData.input === null) {
        nodeData.data = null;
        return;
    }
    // Process data
}
```

### 7. Use Custom NodeData for Complex Data

```qml
// Instead of storing everything in nodeData.data
nodeData: MyCustomNodeData {
    property var input1: null
    property var input2: null
    property var output: null
}
```

### 8. Document Your Nodes

```qml
/*! ***********************************************************************************************
 * OperationNode performs mathematical operations on two inputs
 * 
 * Properties:
 *   - operationType: Type of operation (0=Add, 1=Subtract, 2=Multiply, 3=Divide)
 * 
 * Ports:
 *   - Input 1: Left side, receives first operand
 *   - Input 2: Left side, receives second operand
 *   - Output: Right side, outputs result
 * ************************************************************************************************/
Node {
    // ...
}
```

### 9. Use Consistent Naming

```qml
// Good
SourceNode.qml
OperationNode.qml
ResultNode.qml

// Bad
node1.qml
myNode.qml
test.qml
```

### 10. Register All Required Imports

```qml
nodeRegistry.imports: ["MyApp", "NodeLink", "QtQuickStream"]
```

---

## Troubleshooting

### Node Not Appearing

**Problem**: Node doesn't appear in the scene after creation.

**Solutions**:
1. Check node registry registration:
   ```qml
   nodeRegistry.nodeTypes[nodeType] = "MyNode";  // Must match QML file name
   ```

2. Verify imports:
   ```qml
   nodeRegistry.imports: ["MyApp", "NodeLink"];  // Must include your module
   ```

3. Check CMakeLists.txt:
   ```cmake
   QML_FILES
       MyNode.qml  # Must be included
   ```

4. Verify QML file location matches import path.

### Ports Not Showing

**Problem**: Ports don't appear on the node.

**Solutions**:
1. Ensure `addPorts()` is called:
   ```qml
   Component.onCompleted: addPorts();
   ```

2. Check port configuration:
   ```qml
   port.portType = NLSpec.PortType.Input;  // Must be set
   port.portSide = NLSpec.PortPositionSide.Left;  // Must be set
   ```

3. Verify port is added:
   ```qml
   addPort(port);  // Must call addPort
   ```

### Data Not Flowing

**Problem**: Data doesn't flow between connected nodes.

**Solutions**:
1. Check scene's `updateData()` function is called:
   ```qml
   onLinkAdded: updateData();
   onLinkRemoved: updateData();
   ```

2. Verify data is set in source node:
   ```qml
   nodeData.data = value;  // Must set data property
   ```

3. Check port types match:
   ```qml
   // Source: Output port
   // Destination: Input port
   ```

### Node Not Cloning

**Problem**: Cloned node doesn't copy properties correctly.

**Solutions**:
1. Implement `onCloneFrom`:
   ```qml
   onCloneFrom: function(baseNode) {
       // Copy properties
   }
   ```

2. Reset node-specific data:
   ```qml
   onCloneFrom: function(baseNode) {
       nodeData.data = null;  // Reset data
   }
   ```

### Type Mismatch Errors

**Problem**: "Unknown node type" or type errors.

**Solutions**:
1. Verify type ID matches registry:
   ```qml
   // Node
   type: 1
   
   // Registry
   nodeRegistry.nodeTypes[1] = "MyNode";
   ```

2. Check type is registered before use:
   ```qml
   Component.onCompleted: {
       // Register types first
       nodeRegistry.nodeTypes[1] = "MyNode";
       // Then create scene
   }
   ```

### Import Errors

**Problem**: "module not found" or import errors.

**Solutions**:
1. Check CMakeLists.txt URI matches:
   ```cmake
   qt_add_qml_module(MyApp
       URI "MyApp"  # Must match import
   )
   ```

2. Verify imports in registry:
   ```qml
   nodeRegistry.imports: ["MyApp", "NodeLink"];
   ```

3. Check QML file import statements:
   ```qml
   import MyApp  // Must match URI
   import NodeLink
   ```

---

## Conclusion

Creating custom nodes in NodeLink is a straightforward process that involves:

1. **Creating the Node QML File**: Define your node structure, ports, and behavior
2. **Registering in Node Registry**: Add node type, name, icon, and color
3. **Configuring Build System**: Add QML files to CMakeLists.txt
4. **Implementing Data Flow**: Handle data input, processing, and output

The framework provides all the necessary tools and infrastructure to create powerful, reusable node types for your visual programming applications.


# Data Type Propagation

## Overview

Data Type Propagation in NodeLink refers to the mechanism by which data flows through the node graph, from source nodes through processing nodes to result nodes. This document explains how data propagation works, different propagation algorithms, and how to implement custom data flow logic for your application.

---

## Understanding Data Flow

### Basic Concepts

**Data Flow** in NodeLink follows these principles:

1. **Source Nodes**: Generate initial data (e.g., user input, file loading)
2. **Processing Nodes**: Transform data from input to output
3. **Result Nodes**: Display or consume final data
4. **Links**: Connect nodes and define data flow direction

### Data Flow Direction

```
Source Node → Processing Node → Result Node
     ↓              ↓                ↓
  Output        Input/Output      Input
```

### Key Terms

- **Upstream Node**: The node that provides data (source)
- **Downstream Node**: The node that receives data (destination)
- **Data Propagation**: The process of transferring data from upstream to downstream nodes
- **Node Data**: The data stored in `node.nodeData.data` property

---

## Data Flow Architecture

### Node Data Storage

All nodes store their data in the `nodeData` property, which is an instance of `I_NodeData` or a custom subclass:

```qml
// Base node data structure
I_NodeData {
    property var data: null  // Main data storage
}
```

### Custom Node Data

You can create custom node data classes for type-safe data handling:

```qml
// OperationNodeData.qml
I_NodeData {
    property var inputFirst: null
    property var inputSecond: null
    property var output: null
    property var data: null  // Final result
}
```

### Data Flow Triggers

Data propagation is triggered by:

1. **Link Added**: When a new connection is created
2. **Link Removed**: When a connection is deleted
3. **Node Removed**: When a node is deleted
4. **Manual Update**: When `updateData()` is called explicitly
5. **Parameter Change**: When node parameters change (e.g., slider value)

---

## Propagation Algorithms

NodeLink supports different propagation algorithms depending on your use case:

### 1. Sequential Propagation (Calculator Example)

**Use Case**: Simple data flow where nodes process data in order.

**Algorithm**:
1. Initialize all node data to `null`
2. Process links where upstream node has data
3. Update downstream nodes
4. Repeat until all nodes are processed

**Example**:
```qml
function updateData() {
    // Initialize node data
    Object.values(nodes).forEach(node => {
        if (node.type === CSpecs.NodeType.Operation) {
            node.nodeData.data = null;
            node.nodeData.inputFirst = null;
            node.nodeData.inputSecond = null;
        }
    });

    // Process links
    Object.values(links).forEach(link => {
        var upstreamNode = findNode(link.inputPort._qsUuid);
        var downstreamNode = findNode(link.outputPort._qsUuid);

        if (upstreamNode.nodeData.data) {
            upadateNodeData(upstreamNode, downstreamNode);
        }
    });

    // Handle nodes waiting for multiple inputs
    while (notReadyLinks.length > 0) {
        // Process remaining links
    }
}
```

### 2. Iterative Propagation (Logic Circuit Example)

**Use Case**: Circuits where signals propagate through gates until stable.

**Algorithm**:
1. Reset all node outputs
2. Iterate through links multiple times
3. Update nodes when all inputs are available
4. Continue until no more changes occur

**Example**:
```qml
function updateLogic() {
    // Reset all operation nodes
    Object.values(nodes).forEach(node => {
        if (node.type === LSpecs.NodeType.AND ||
            node.type === LSpecs.NodeType.OR ||
            node.type === LSpecs.NodeType.NOT) {
            node.nodeData.inputA = null;
            node.nodeData.inputB = null;
            node.nodeData.output = null;
        }
    });

    // Propagate values through the circuit
    var maxIterations = 999;
    var changed = true;

    for (var i = 0; i < maxIterations && changed; i++) {
        changed = false;

        Object.values(links).forEach(link => {
            var upstreamNode = findNode(link.inputPort._qsUuid);
            var downstreamNode = findNode(link.outputPort._qsUuid);

            if (upstreamNode && downstreamNode && 
                upstreamNode.nodeData.output !== null) {
                // Update downstream node
                if (downstreamNode.nodeData.inputA === null) {
                    downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                    changed = true;
                }

                // Update node if all inputs are ready
                if (canUpdateNode(downstreamNode)) {
                    downstreamNode.updateData();
                }
            }
        });
    }
}
```

### 3. Topological Propagation (VisionLink Example)

**Use Case**: Processing pipelines where order matters and dependencies must be resolved.

**Algorithm**:
1. Build dependency graph
2. Process nodes in topological order
3. Update downstream nodes only when upstream has data
4. Handle circular dependencies

**Example**:
```qml
function updateData() {
    var allLinks = Object.values(links);
    var processedLinks = [];
    var remainingLinks = allLinks.slice();
    var maxIterations = 100;
    var iteration = 0;

    while (remainingLinks.length > 0 && iteration < maxIterations) {
        iteration++;
        var linksProcessedThisIteration = [];
        var linksStillWaiting = [];

        remainingLinks.forEach(function(link) {
            var upstreamNode = findNode(link.inputPort._qsUuid);
            var downstreamNode = findNode(link.outputPort._qsUuid);

            // Check if upstream node has data
            var upstreamHasData = upstreamNode.nodeData.data !== null && 
                                 upstreamNode.nodeData.data !== undefined;

            if (upstreamHasData) {
                // Process this link now
                upadateNodeData(upstreamNode, downstreamNode);
                linksProcessedThisIteration.push(link);
            } else {
                // Can't process yet, upstream doesn't have data
                linksStillWaiting.push(link);
            }
        });

        // Update remaining links for next iteration
        remainingLinks = linksStillWaiting;
        processedLinks = processedLinks.concat(linksProcessedThisIteration);
    }
}
```

### 4. Incremental Propagation

**Use Case**: When only a specific node changes and you want to update only affected downstream nodes.

**Algorithm**:
1. Start from changed node
2. Find all downstream nodes
3. Update them in order
4. Stop when no more updates needed

**Example**:
```qml
function updateDataFromNode(startingNode) {
    // First, update the starting node itself
    if (startingNode.type === CSpecs.NodeType.Operation) {
        startingNode.updataData();
    }

    // Find all downstream nodes and update them
    var nodesToUpdate = [startingNode];
    var processedNodes = [];
    var maxIterations = 100;
    var iteration = 0;

    while (nodesToUpdate.length > 0 && iteration < maxIterations) {
        iteration++;
        var currentNode = nodesToUpdate.shift();
        processedNodes.push(currentNode._qsUuid);

        // Find all links where this node is upstream
        var downstreamLinks = Object.values(links).filter(function(link) {
            var upstreamNodeId = findNodeId(link.inputPort._qsUuid);
            return upstreamNodeId === currentNode._qsUuid;
        });

        // Process each downstream link
        downstreamLinks.forEach(function(link) {
            var downstreamNode = findNode(link.outputPort._qsUuid);
            upadateNodeData(currentNode, downstreamNode);

            // Add to queue if not already processed
            if (processedNodes.indexOf(downstreamNode._qsUuid) === -1) {
                nodesToUpdate.push(downstreamNode);
            }
        });
    }
}
```

---

## Node Data Structure

### Base Node Data

```qml
// I_NodeData.qml
QSObject {
    property var data: null  // Main data storage (can be any type)
}
```

### Custom Node Data Examples

#### Calculator Node Data

```qml
// OperationNodeData.qml
I_NodeData {
    property var inputFirst: null   // First input value
    property var inputSecond: null  // Second input value
    property var data: null         // Calculated result
}
```

#### Logic Circuit Node Data

```qml
// LogicGateNodeData.qml
I_NodeData {
    property bool inputA: null      // First input (boolean)
    property bool inputB: null      // Second input (boolean, optional)
    property bool output: null      // Gate output (boolean)
}
```

#### Image Processing Node Data

```qml
// ImageNodeData.qml
I_NodeData {
    property var input: null        // Input image (QImage)
    property var data: null         // Processed image (QImage)
}
```

### Data Type Examples

NodeLink supports any data type:

```qml
// Numbers
node.nodeData.data = 42;
node.nodeData.data = 3.14;

// Strings
node.nodeData.data = "Hello World";

// Booleans
node.nodeData.data = true;

// Objects
node.nodeData.data = {
    value: 100,
    name: "test",
    timestamp: Date.now()
};

// Arrays
node.nodeData.data = [1, 2, 3, 4, 5];

// QML Objects (e.g., QImage)
node.nodeData.data = imageObject;
```

---

## Implementation Patterns

### Pattern 1: Simple Data Transfer

For nodes that simply pass data through:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    // Direct data transfer
    downstreamNode.nodeData.data = upstreamNode.nodeData.data;
}
```

### Pattern 2: Single Input Processing

For nodes that process one input:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    // Set input
    downstreamNode.nodeData.input = upstreamNode.nodeData.data;
    
    // Process
    downstreamNode.updataData();
}
```

### Pattern 3: Multiple Input Processing

For nodes that need multiple inputs:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    // Assign to first available input
    if (!downstreamNode.nodeData.inputFirst) {
        downstreamNode.nodeData.inputFirst = upstreamNode.nodeData.data;
    } else if (!downstreamNode.nodeData.inputSecond) {
        downstreamNode.nodeData.inputSecond = upstreamNode.nodeData.data;
    }

    // Update if all inputs are ready
    if (downstreamNode.nodeData.inputFirst && 
        downstreamNode.nodeData.inputSecond) {
        downstreamNode.updataData();
    }
}
```

### Pattern 4: Type-Specific Processing

For nodes that handle different data types:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    switch (downstreamNode.type) {
        case CSpecs.NodeType.Operation: {
            downstreamNode.nodeData.input = upstreamNode.nodeData.data;
            downstreamNode.updataData();
        } break;

        case CSpecs.NodeType.Result: {
            // Direct transfer for result nodes
            downstreamNode.nodeData.data = upstreamNode.nodeData.data;
        } break;

        default: {
            // Default behavior
        }
    }
}
```

---

## Examples

### Example 1: Calculator Data Flow

**Source**: `examples/calculator/resources/Core/CalculatorScene.qml`

```qml
I_Scene {
    // Update data when connections change
    onLinkRemoved: _upateDataTimer.start();
    onNodeRemoved: _upateDataTimer.start();
    onLinkAdded: updateData();

    function updateData() {
        var notReadyLinks = [];

        // Initialize node data
        Object.values(nodes).forEach(node => {
            switch (node.type) {
                case CSpecs.NodeType.Additive:
                case CSpecs.NodeType.Multiplier:
                case CSpecs.NodeType.Subtraction:
                case CSpecs.NodeType.Division: {
                    node.nodeData.data = null;
                    node.nodeData.inputFirst = null;
                    node.nodeData.inputSecond = null;
                } break;
                case CSpecs.NodeType.Result: {
                    node.nodeData.data = null;
                } break;
            }
        });

        // Process links
        Object.values(links).forEach(link => {
            var upstreamNode = findNode(link.inputPort._qsUuid);
            var downstreamNode = findNode(link.outputPort._qsUuid);

            if (!upstreamNode.nodeData.data && 
                upstreamNode.type !== CSpecs.NodeType.Source) {
                // Check if upstream needs multiple inputs
                var upstreamNodeLinks = Object.values(links).filter(linkObj => 
                    findNodeId(linkObj.outputPort._qsUuid) === upstreamNode._qsUuid);
                
                if (upstreamNodeLinks.length > 1) {
                    notReadyLinks.push(link);
                    return;
                }
            }

            upadateNodeData(upstreamNode, downstreamNode);
        });

        // Process remaining links
        while (notReadyLinks.length > 0) {
            notReadyLinks.forEach((link, index) => {
                var upstreamNode = findNode(link.inputPort._qsUuid);
                var downstreamNode = findNode(link.outputPort._qsUuid);

                if (upstreamNode.nodeData.data) {
                    notReadyLinks.splice(index, 1);
                    upadateNodeData(upstreamNode, downstreamNode);
                }
            });
        }
    }

    function upadateNodeData(upstreamNode, downstreamNode) {
        switch (downstreamNode.type) {
            case CSpecs.NodeType.Additive:
            case CSpecs.NodeType.Multiplier:
            case CSpecs.NodeType.Subtraction:
            case CSpecs.NodeType.Division: {
                // Assign to first available input
                if (!downstreamNode.nodeData.inputFirst) {
                    downstreamNode.nodeData.inputFirst = upstreamNode.nodeData.data;
                } else if (!downstreamNode.nodeData.inputSecond) {
                    downstreamNode.nodeData.inputSecond = upstreamNode.nodeData.data;
                }

                // Update if both inputs are ready
                downstreamNode.updataData();
            } break;

            case CSpecs.NodeType.Result: {
                // Direct transfer
                downstreamNode.nodeData.data = upstreamNode.nodeData.data;
            } break;
        }
    }
}
```

### Example 2: Logic Circuit Signal Propagation

**Source**: `examples/logicCircuit/resources/Core/LogicCircuitScene.qml`

```qml
I_Scene {
    function updateLogic() {
        // Reset all operation nodes
        Object.values(nodes).forEach(node => {
            if (node.type === LSpecs.NodeType.AND ||
                node.type === LSpecs.NodeType.OR ||
                node.type === LSpecs.NodeType.NOT) {
                node.nodeData.inputA = null;
                node.nodeData.inputB = null;
                node.nodeData.output = null;
            }
            if (node.type === LSpecs.NodeType.Output) {
                node.nodeData.inputA = null;
                node.nodeData.displayValue = "UNDEFINED";
            }
        });

        // Track connections to prevent duplicate inputs
        var connectionMap = {};
        var maxIterations = 999;
        var changed = true;

        // Iterate until stable
        for (var i = 0; i < maxIterations && changed; i++) {
            changed = false;

            Object.values(links).forEach(link => {
                var upstreamNode = findNode(link.inputPort._qsUuid);
                var downstreamNode = findNode(link.outputPort._qsUuid);

                if (upstreamNode && downstreamNode && 
                    upstreamNode.nodeData.output !== null) {
                    
                    var connectionKey = downstreamNode._qsUuid + "_" + 
                                       upstreamNode._qsUuid;

                    // Handle 2-input gates (AND, OR)
                    if (downstreamNode.type === LSpecs.NodeType.AND ||
                        downstreamNode.type === LSpecs.NodeType.OR) {
                        
                        if (downstreamNode.nodeData.inputA === null && 
                            !connectionMap[connectionKey + "_A"]) {
                            downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                            connectionMap[connectionKey + "_A"] = true;
                            changed = true;
                        } else if (downstreamNode.nodeData.inputB === null && 
                                   !connectionMap[connectionKey + "_B"]) {
                            // Ensure different upstream nodes for A and B
                            var inputAUpstream = null;
                            Object.keys(connectionMap).forEach(key => {
                                if (key.startsWith(downstreamNode._qsUuid) && 
                                    key.endsWith("_A")) {
                                    inputAUpstream = key.split("_")[1];
                                }
                            });

                            if (inputAUpstream !== upstreamNode._qsUuid) {
                                downstreamNode.nodeData.inputB = upstreamNode.nodeData.output;
                                connectionMap[connectionKey + "_B"] = true;
                                changed = true;
                            }
                        }
                    }
                    // Handle single-input gates (NOT, Output)
                    else if (downstreamNode.type === LSpecs.NodeType.NOT ||
                             downstreamNode.type === LSpecs.NodeType.Output) {
                        if (downstreamNode.nodeData.inputA === null) {
                            downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                            changed = true;
                        }
                    }

                    // Update node if all inputs are ready
                    if (downstreamNode.updateData) {
                        var canUpdate = false;
                        switch(downstreamNode.type) {
                            case LSpecs.NodeType.AND:
                            case LSpecs.NodeType.OR:
                                canUpdate = (downstreamNode.nodeData.inputA !== null &&
                                           downstreamNode.nodeData.inputB !== null);
                                break;
                            case LSpecs.NodeType.NOT:
                            case LSpecs.NodeType.Output:
                                canUpdate = (downstreamNode.nodeData.inputA !== null);
                                break;
                        }

                        if (canUpdate) {
                            downstreamNode.updateData();
                        }
                    }
                }
            });
        }
    }
}
```

### Example 3: Image Processing Pipeline

**Source**: `examples/visionLink/resources/Core/VisionLinkScene.qml`

```qml
I_Scene {
    function updateData() {
        // Process links in topological order
        var allLinks = Object.values(links);
        var remainingLinks = allLinks.slice();
        var maxIterations = 100;
        var iteration = 0;

        while (remainingLinks.length > 0 && iteration < maxIterations) {
            iteration++;
            var linksProcessedThisIteration = [];
            var linksStillWaiting = [];

            remainingLinks.forEach(function(link) {
                var upstreamNode = findNode(link.inputPort._qsUuid);
                var downstreamNode = findNode(link.outputPort._qsUuid);

                // Check if upstream node has data
                var upstreamHasData = upstreamNode.nodeData.data !== null && 
                                     upstreamNode.nodeData.data !== undefined;

                // ImageInput always has data
                if (upstreamNode.type === CSpecs.NodeType.ImageInput) {
                    upstreamHasData = true;
                }

                if (upstreamHasData) {
                    // Process this link now
                    upadateNodeData(upstreamNode, downstreamNode);
                    linksProcessedThisIteration.push(link);
                } else {
                    // Can't process yet
                    linksStillWaiting.push(link);
                }
            });

            remainingLinks = linksStillWaiting;
        }
    }

    function updateDataFromNode(startingNode) {
        // Update starting node first
        if (startingNode.type === CSpecs.NodeType.Blur ||
            startingNode.type === CSpecs.NodeType.Brightness ||
            startingNode.type === CSpecs.NodeType.Contrast) {
            startingNode.updataData();
        }

        // Propagate to downstream nodes
        var nodesToUpdate = [startingNode];
        var processedNodes = [];
        var maxIterations = 100;
        var iteration = 0;

        while (nodesToUpdate.length > 0 && iteration < maxIterations) {
            iteration++;
            var currentNode = nodesToUpdate.shift();
            processedNodes.push(currentNode._qsUuid);

            // Find downstream links
            var downstreamLinks = Object.values(links).filter(function(link) {
                var upstreamNodeId = findNodeId(link.inputPort._qsUuid);
                return upstreamNodeId === currentNode._qsUuid;
            });

            // Process each downstream link
            downstreamLinks.forEach(function(link) {
                var downstreamNode = findNode(link.outputPort._qsUuid);
                upadateNodeData(currentNode, downstreamNode);

                if (processedNodes.indexOf(downstreamNode._qsUuid) === -1) {
                    nodesToUpdate.push(downstreamNode);
                }
            });
        }
    }

    function upadateNodeData(upstreamNode, downstreamNode) {
        switch (downstreamNode.type) {
            case CSpecs.NodeType.Blur:
            case CSpecs.NodeType.Brightness:
            case CSpecs.NodeType.Contrast: {
                downstreamNode.nodeData.input = upstreamNode.nodeData.data;
                downstreamNode.updataData();
            } break;

            case CSpecs.NodeType.ImageResult: {
                downstreamNode.nodeData.data = upstreamNode.nodeData.data;
            } break;
        }
    }
}
```

---

## Best Practices

### 1. Initialize Node Data

Always initialize node data before processing:

```qml
function updateData() {
    // Reset all node data first
    Object.values(nodes).forEach(node => {
        if (node.type === CSpecs.NodeType.Operation) {
            node.nodeData.data = null;
            node.nodeData.inputFirst = null;
            node.nodeData.inputSecond = null;
        }
    });
    
    // Then process links
}
```

### 2. Handle Null/Undefined Data

Always check for null/undefined before processing:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    if (!upstreamNode || !downstreamNode) {
        return;
    }
    
    if (upstreamNode.nodeData.data === null || 
        upstreamNode.nodeData.data === undefined) {
        return;
    }
    
    // Process data
}
```

### 3. Prevent Infinite Loops

Use iteration limits:

```qml
var maxIterations = 100;
var iteration = 0;

while (remainingLinks.length > 0 && iteration < maxIterations) {
    iteration++;
    // Process links
}
```

### 4. Track Processed Nodes

Prevent processing the same node multiple times:

```qml
var processedNodes = [];

if (processedNodes.indexOf(node._qsUuid) === -1) {
    processedNodes.push(node._qsUuid);
    // Process node
}
```

### 5. Handle Multiple Inputs

For nodes with multiple inputs, check all inputs before processing:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    // Assign to first available input
    if (!downstreamNode.nodeData.inputFirst) {
        downstreamNode.nodeData.inputFirst = upstreamNode.nodeData.data;
    } else if (!downstreamNode.nodeData.inputSecond) {
        downstreamNode.nodeData.inputSecond = upstreamNode.nodeData.data;
    }

    // Only process when all inputs are ready
    if (downstreamNode.nodeData.inputFirst && 
        downstreamNode.nodeData.inputSecond) {
        downstreamNode.updataData();
    }
}
```

### 6. Use Incremental Updates

For performance, update only affected nodes:

```qml
// Instead of updating all nodes
function updateDataFromNode(startingNode) {
    // Only update downstream nodes from startingNode
    // More efficient for large graphs
}
```

### 7. Validate Data Types

Check data types before processing:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    var data = upstreamNode.nodeData.data;
    
    // Type validation
    if (typeof data !== 'number') {
        console.warn("Expected number, got:", typeof data);
        return;
    }
    
    // Process data
}
```

### 8. Error Handling

Handle errors gracefully:

```qml
function upadateNodeData(upstreamNode, downstreamNode) {
    try {
        downstreamNode.nodeData.input = upstreamNode.nodeData.data;
        downstreamNode.updataData();
    } catch (error) {
        console.error("Error updating node data:", error);
        downstreamNode.nodeData.data = null;
    }
}
```

---

## Common Patterns

### Pattern: Source → Operation → Result

```qml
Source Node (data = 10)
    ↓
Operation Node (inputFirst = 10, inputSecond = 5, data = 15)
    ↓
Result Node (data = 15)
```

### Pattern: Multiple Inputs

```qml
Source1 (data = 10) ──┐
                      ├─→ Operation (inputFirst = 10, inputSecond = 5)
Source2 (data = 5)  ──┘
```

### Pattern: Processing Chain

```qml
Source → Blur → Brightness → Contrast → Result
```

### Pattern: Branching

```qml
Source ──┬─→ Operation1 → Result1
         └─→ Operation2 → Result2
```

---

## Troubleshooting

### Data Not Propagating

- Check that `updateData()` is called when links are added/removed
- Verify upstream node has data before processing
- Ensure node data is initialized correctly

### Infinite Loops

- Add iteration limits (`maxIterations`)
- Track processed nodes/links
- Check for circular dependencies

### Wrong Data Values

- Verify data types match expected types
- Check that all inputs are assigned before processing
- Ensure node's `updataData()` function is correct

### Performance Issues

- Use incremental updates (`updateDataFromNode`) instead of full updates
- Limit iteration counts
- Cache processed nodes/links


# Undo/Redo System

## Overview

The Undo/Redo system in NodeLink is a comprehensive command-based architecture that allows users to undo and redo operations performed on the node graph. This system tracks all changes to nodes, links, containers, and their properties, providing a seamless way to revert or replay actions. The implementation uses the **Command Pattern** combined with **Observer Pattern** to automatically capture and record all modifications.

![Undo/Redo System Overview](images/undo-redo-overview_23426.png) <!-- TODO: Insert overview diagram -->

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Core Components](#core-components)
3. [How It Works](#how-it-works)
4. [Command Pattern Implementation](#command-pattern-implementation)
5. [Observer System](#observer-system)
6. [Command Stack Management](#command-stack-management)
7. [Implementation Details](#implementation-details)
8. [Usage Guide](#usage-guide)
9. [Advanced Topics](#advanced-topics)
10. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

The Undo/Redo system consists of several key components working together:

```
┌─────────────────────────────────────────────────────────────┐
│                      UndoCore                                │
│  ┌──────────────────────────────────────────────────────┐   │
│  │            CommandStack                               │   │
│  │  ┌──────────────┐         ┌──────────────┐          │   │
│  │  │  Undo Stack  │         │  Redo Stack  │          │   │
│  │  │  [Commands]  │         │  [Commands]  │          │   │
│  │  └──────────────┘         └──────────────┘          │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │        UndoSceneObserver                              │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────┐  │   │
│  │  │Node Observers│  │Link Observers│  │Container │  │   │
│  │  │              │  │              │  │Observers │  │   │
│  │  └──────────────┘  └──────────────┘  └──────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
                    Scene Operations
              (Node/Link/Container Changes)
```

### Key Design Principles

1. **Command Pattern**: Each operation is encapsulated as a command object with `undo()` and `redo()` methods
2. **Observer Pattern**: Automatic tracking of property changes through observers
3. **Batch Aggregation**: Multiple rapid changes are grouped into single undo/redo operations
4. **Memory Management**: Automatic cleanup of old commands to prevent memory leaks
5. **Observer Blocking**: Prevents infinite loops during undo/redo execution

---

## Core Components

### 1. UndoCore

**Location**: `resources/Core/Undo/UndoCore.qml`

**Purpose**: The central coordinator for the undo/redo system.

**Responsibilities**:
- Manages the CommandStack
- Creates and manages UndoSceneObserver
- Provides access point for undo/redo operations

**Properties**:
- `scene`: The I_Scene instance to track
- `undoStack`: CommandStack instance managing all commands

**Code Structure**:
```qml
QtObject {
    required property I_Scene scene
    property CommandStack undoStack: CommandStack { }
    property UndoSceneObserver undoSceneObserver: UndoSceneObserver {
        scene: root.scene
        undoStack: root.undoStack
    }
}
```

---

### 2. CommandStack

**Location**: `resources/Core/Undo/CommandStack.qml`

**Purpose**: Manages the undo and redo stacks, handles command execution, and provides batch aggregation.

**Key Features**:
- **Dual Stack Architecture**: Separate stacks for undo and redo
- **Batch Aggregation**: Groups rapid changes (e.g., dragging multiple nodes) into single commands
- **Memory Management**: Limits stack size and cleans up old commands
- **Observer Blocking**: Prevents observers from creating commands during undo/redo

**Properties**:
- `undoStack`: Array of command objects (most recent first)
- `redoStack`: Array of command objects (most recent first)
- `isValidUndo`: Boolean indicating if undo is possible
- `isValidRedo`: Boolean indicating if redo is possible
- `isReplaying`: Boolean flag set during undo/redo execution
- `maxStackSize`: Maximum number of commands to keep (default: 30)

**Key Functions**:

#### `push(cmd, appliedAlready = true)`
Adds a command to the undo stack. Commands are batched together if they arrive within 200ms.

```qml
function push(cmd, appliedAlready = true) {
    if (!cmd || typeof cmd.redo !== "function" || typeof cmd.undo !== "function")
        return

    if (!appliedAlready) {
        // Execute the command if not already applied
        isReplaying = true
        NLSpec.undo.blockObservers = true
        try {
            cmd.redo()
        } finally {
            NLSpec.undo.blockObservers = false
            isReplaying = false
        }
    }

    // Add to pending batch
    _pendingCommands.push(cmd)
    _batchTimer.restart()  // 200ms delay for batching
}
```

#### `undo()`
Executes the most recent command's undo function and moves it to the redo stack.

```qml
function undo() {
    if (!isValidUndo)
        return

    const cmd = undoStack.shift()  // Get most recent command
    undoStackChanged()

    // Block observers to prevent creating new commands
    isReplaying = true
    NLSpec.undo.blockObservers = true
    try {
        cmd.undo()  // Execute undo
    } finally {
        NLSpec.undo.blockObservers = false
        isReplaying = false
    }

    redoStack.unshift(cmd)  // Move to redo stack
    redoStackChanged()
    undoRedoDone()
    stacksUpdated()
}
```

#### `redo()`
Executes the most recent redo command and moves it back to the undo stack.

```qml
function redo() {
    if (!isValidRedo)
        return

    const cmd = redoStack.shift()  // Get most recent redo command
    redoStackChanged()

    // Block observers to prevent creating new commands
    isReplaying = true
    NLSpec.undo.blockObservers = true
    try {
        cmd.redo()  // Execute redo
    } finally {
        NLSpec.undo.blockObservers = false
        isReplaying = false
    }

    undoStack.unshift(cmd)  // Move back to undo stack
    undoStackChanged()
    undoRedoDone()
    stacksUpdated()
}
```

#### Batch Aggregation

Commands arriving within 200ms are grouped into a macro command:

```qml
function _finalizePending() {
    if (_pendingCommands.length === 0)
        return

    const cmds = _pendingCommands.slice()
    _pendingCommands = []

    // Create macro command
    var macro = {
        subCommands: cmds,
        undo: function() {
            // Undo in reverse order
            for (var i = cmds.length - 1; i >= 0; --i) {
                cmds[i].undo()
            }
        },
        redo: function() {
            // Redo in forward order
            for (var i = 0; i < cmds.length; ++i) {
                cmds[i].redo()
            }
        }
    }

    undoStack.unshift(macro)
    _enforceStackLimit()
    clearRedo()  // Clear redo stack when new action occurs
    stacksUpdated()
}
```

**Benefits of Batching**:
- Dragging a node creates many position updates, but they're grouped into one undo operation
- Multi-select operations are treated as single undoable actions
- Reduces stack size and improves performance

---

### 3. UndoSceneObserver

**Location**: `resources/Core/Undo/UndoSceneObserver.qml`

**Purpose**: Creates and manages observers for all nodes, links, and containers in the scene.

**Structure**:
```qml
Item {
    required property I_Scene scene
    required property CommandStack undoStack

    // Node Observers
    Repeater {
        model: Object.values(root.scene.nodes)
        delegate: UndoNodeObserver {
            node: modelData
            undoStack: root.undoStack
        }
    }

    // Link Observers
    Repeater {
        model: Object.values(root.scene.links)
        delegate: UndoLinkObserver {
            link: modelData
            undoStack: root.undoStack
        }
    }

    // Container Observers
    Repeater {
        model: Object.values(root.scene.containers)
        delegate: UndoContainerObserver {
            container: modelData
            undoStack: root.undoStack
        }
    }
}
```

**How It Works**:
- Automatically creates observers for each node, link, and container
- Observers are recreated when objects are added/removed (via Repeater)
- Each observer tracks property changes and creates commands

---

### 4. Property Observers

#### UndoNodeObserver

**Location**: `resources/Core/Undo/UndoNodeObserver.qml`

**Purpose**: Tracks changes to Node properties (title, type).

**Monitored Properties**:
- `title`: Node title changes
- `type`: Node type changes

**How It Works**:
1. Caches initial property values on creation
2. Listens to property change signals
3. Creates PropertyCommand when values change
4. Pushes command to CommandStack

**Code Example**:
```qml
Connections {
    target: node
    enabled: !NLSpec.undo.blockObservers

    function onTitleChanged() {
        _ensureCache()
        let oldV = _cache.title
        let newV = node.title
        pushProp(node, "title", oldV, newV)
        _cache.title = newV
    }
}
```

**Also Includes**: `UndoNodeGuiObserver` for tracking GUI properties (position, size, color, etc.)

---

#### UndoLinkObserver

**Location**: `resources/Core/Undo/UndoLinkObserver.qml`

**Purpose**: Tracks changes to Link properties.

**Monitored Properties**:
- `inputPort`: Input port changes
- `outputPort`: Output port changes
- `title`: Link title changes
- `type`: Link type changes

**Also Includes**: `UndoLinkGuiObserver` for tracking GUI properties

---

#### UndoContainerObserver

**Location**: `resources/Core/Undo/UndoContainerObserver.qml`

**Purpose**: Tracks changes to Container properties.

**Monitored Properties**:
- `title`: Container title changes

**Also Includes**: `UndoContainerGuiObserver` for tracking GUI properties

---

#### GUI Observers

**UndoNodeGuiObserver**, **UndoLinkGuiObserver**, **UndoContainerGuiObserver**

**Purpose**: Track changes to GUI configuration properties.

**Monitored Properties**:
- `position`: Object position (x, y)
- `width`: Object width
- `height`: Object height
- `color`: Object color
- `logoUrl`: Logo/icon URL
- `description`: Description text

**Special Handling**:
- Position uses vector2d type, requires special comparison
- Values are cached to detect changes
- Changes are batched automatically by CommandStack

---

## How It Works

### Operation Flow

#### 1. User Action (e.g., Move Node)

```
User drags node
    ↓
NodeGuiConfig.position changes
    ↓
UndoNodeGuiObserver detects change
    ↓
Creates PropertyCommand with old/new position
    ↓
CommandStack.push(command)
    ↓
Command added to pending batch
    ↓
After 200ms: Batch finalized
    ↓
Macro command added to undoStack
    ↓
Redo stack cleared
```

#### 2. Undo Operation

```
User presses Ctrl+Z
    ↓
CommandStack.undo() called
    ↓
Most recent command removed from undoStack
    ↓
NLSpec.undo.blockObservers = true
    ↓
Command.undo() executed
    ↓
Property restored to old value
    ↓
Observers blocked, so no new command created
    ↓
Command moved to redoStack
    ↓
NLSpec.undo.blockObservers = false
    ↓
undoRedoDone() signal emitted
```

#### 3. Redo Operation

```
User presses Ctrl+Y
    ↓
CommandStack.redo() called
    ↓
Most recent command removed from redoStack
    ↓
NLSpec.undo.blockObservers = true
    ↓
Command.redo() executed
    ↓
Property restored to new value
    ↓
Observers blocked, so no new command created
    ↓
Command moved back to undoStack
    ↓
NLSpec.undo.blockObservers = false
    ↓
undoRedoDone() signal emitted
```

---

## Command Pattern Implementation

### Command Interface

All commands implement the `I_Command` interface:

**Location**: `resources/Core/Undo/Commands/I_Command.qml`

```qml
QtObject {
    property var scene: null

    function redo() {
        // Apply the command
    }

    function undo() {
        // Reverse the command
    }
}
```

### Available Commands

#### 1. AddNodeCommand

**Purpose**: Tracks node addition to the scene.

**Properties**:
- `node`: The node being added

**Implementation**:
```qml
function redo() {
    if (isValidScene() && isValidNode(node))
        scene.addNode(node)
}

function undo() {
    if (isValidScene() && isValidNode(node)) {
        scene.selectionModel.remove(node._qsUuid)
        scene.nodeRemoved(node)
        delete scene.nodes[node._qsUuid]
        scene.nodesChanged()
    }
}
```

**Usage**: Created automatically when `scene.addNode()` is called.

---

#### 2. RemoveNodeCommand

**Purpose**: Tracks node removal from the scene.

**Properties**:
- `node`: The node being removed
- `links`: Array of link objects connected to the node

**Implementation**:
```qml
function redo() {
    if (isValidScene() && isValidNode(node))
        scene.deleteNode(node._qsUuid)
}

function undo() {
    if (isValidScene() && isValidNode(node)) {
        scene.addNode(node)
        // Restore connected links
        if (links && links.length) {
            scene.restoreLinks(links)
        }
    }
}
```

**Key Feature**: Preserves link objects for restoration during undo.

---

#### 3. AddNodesCommand

**Purpose**: Tracks batch node addition (multiple nodes at once).

**Properties**:
- `nodes`: Array of nodes being added

**Implementation**: Similar to AddNodeCommand but handles multiple nodes.

**Usage**: Created when `scene.addNodes()` is called with multiple nodes.

---

#### 4. RemoveNodesCommand

**Purpose**: Tracks batch node removal.

**Properties**:
- `nodes`: Array of nodes being removed
- `links`: Array of link objects connected to removed nodes

**Implementation**: Handles multiple nodes and their links.

---

#### 5. CreateLinkCommand

**Purpose**: Tracks link creation between two ports.

**Properties**:
- `inputPortUuid`: UUID of input port
- `outputPortUuid`: UUID of output port
- `createdLink`: The link object (set after creation)

**Implementation**:
```qml
function redo() {
    if (!isValidScene() || !isValidUuid(inputPortUuid) || !isValidUuid(outputPortUuid))
        return

    if (createdLink) {
        // Restore existing link
        scene.restoreLinks([createdLink])
    } else {
        // Create new link
        createdLink = scene.createLink(inputPortUuid, outputPortUuid)
    }
}

function undo() {
    if (!isValidScene() || !isValidLink(createdLink))
        return

    // Remove parent/children relationships
    // Remove link from scene (but don't destroy it)
    scene.linkRemoved(createdLink)
    scene.selectionModel.remove(createdLink._qsUuid)
    delete scene.links[createdLink._qsUuid]
    scene.linksChanged()
}
```

**Key Feature**: Preserves link object for redo (doesn't destroy it).

---

#### 6. UnlinkCommand

**Purpose**: Tracks link removal.

**Properties**:
- `inputPortUuid`: UUID of input port
- `outputPortUuid`: UUID of output port
- `removedLink`: The link object that was removed

**Implementation**:
```qml
function redo() {
    if (!isValidScene() || !isValidUuid(inputPortUuid) || !isValidUuid(outputPortUuid))
        return
    scene.unlinkNodes(inputPortUuid, outputPortUuid)
}

function undo() {
    if (!isValidScene() || !isValidLink(removedLink))
        return
    scene.restoreLinks([removedLink])
}
```

---

#### 7. AddContainerCommand

**Purpose**: Tracks container addition.

**Properties**:
- `container`: The container being added

---

#### 8. RemoveContainerCommand

**Purpose**: Tracks container removal.

**Properties**:
- `container`: The container being removed

---

#### 9. PropertyCommand

**Purpose**: Generic command for property changes.

**Properties**:
- `target`: The object whose property changed
- `key`: Property name
- `oldValue`: Previous value
- `newValue`: New value
- `apply`: Optional custom setter function

**Implementation**:
```qml
function undo() {
    setProp(oldValue)
}

function redo() {
    setProp(newValue)
}

function setProp(value) {
    if (!target)
        return
    if (apply) {
        apply(target, value)
    } else {
        target[key] = value
    }
}
```

**Usage**: Created automatically by observers when properties change.

---

## Observer System

### How Observers Work

Observers use Qt's `Connections` component to listen to property change signals:

```qml
Connections {
    target: node
    enabled: !NLSpec.undo.blockObservers  // Disabled during undo/redo

    function onTitleChanged() {
        // Create command for this change
        pushProp(node, "title", oldValue, newValue)
    }
}
```

### Observer Blocking

**Why Block Observers?**
- During undo/redo, properties are changed programmatically
- Without blocking, these changes would create new commands
- This would cause infinite loops or incorrect stack state

**How It Works**:
```qml
// In CommandStack.undo()
NLSpec.undo.blockObservers = true  // Block all observers
try {
    cmd.undo()  // Change properties
} finally {
    NLSpec.undo.blockObservers = false  // Unblock
}
```

**In Observers**:
```qml
Connections {
    enabled: !NLSpec.undo.blockObservers  // Only active when not blocked
    // ...
}
```

### Cache System

Observers cache previous values to detect changes:

```qml
property var _cache: ({})

Component.onCompleted: {
    _cache.title = node.title
    _cache._init = true
}

function onTitleChanged() {
    _ensureCache()
    let oldV = _cache.title  // Get cached value
    let newV = node.title     // Get new value
    pushProp(node, "title", oldV, newV)
    _cache.title = newV  // Update cache
}
```

**Why Cache?**
- Property change signals don't provide old values
- Cache stores previous state for comparison
- Prevents duplicate commands for same value

---

## Command Stack Management

### Stack Structure

```
Undo Stack (most recent first):
[Command3] ← Most recent
[Command2]
[Command1] ← Oldest

Redo Stack (most recent first):
[RedoCommand2]
[RedoCommand1]
```

### Stack Operations

#### Adding Commands

1. Command arrives via `push()`
2. Added to `_pendingCommands` array
3. Timer restarts (200ms delay)
4. If no new commands arrive, batch is finalized
5. Macro command created and added to undo stack
6. Redo stack is cleared (new action invalidates redo)

#### Undo Operation

1. Check if undo is valid (`isValidUndo`)
2. Remove command from undo stack (`shift()`)
3. Block observers
4. Execute `command.undo()`
5. Move command to redo stack (`unshift()`)
6. Unblock observers
7. Emit signals

#### Redo Operation

1. Check if redo is valid (`isValidRedo`)
2. Remove command from redo stack (`shift()`)
3. Block observers
4. Execute `command.redo()`
5. Move command back to undo stack (`unshift()`)
6. Unblock observers
7. Emit signals

### Memory Management

#### Stack Size Limiting

```qml
property int maxStackSize: 30

function _enforceStackLimit() {
    if (maxStackSize <= 0)
        return // Unlimited

    while (undoStack.length > maxStackSize) {
        var oldCmd = undoStack.pop()  // Remove oldest
        _cleanupCommand(oldCmd)       // Clean up resources
    }
}
```

#### Command Cleanup

```qml
function _cleanupCommand(cmd) {
    if (!cmd)
        return

    // If macro command, cleanup sub-commands
    if (cmd.subCommands && Array.isArray(cmd.subCommands)) {
        for (var i = 0; i < cmd.subCommands.length; i++) {
            _cleanupCommand(cmd.subCommands[i])
        }
        cmd.subCommands = []
    }

    // Cleanup QML objects
    if (cmd.destroy && typeof cmd.destroy === "function") {
        // Destroy objects no longer in scene
        if (cmd.node && !cmd.scene.nodes[cmd.node._qsUuid]) {
            cmd.node.destroy()
        }
        // ... cleanup other objects
        cmd.destroy()
    }

    // Clear references
    cmd.node = null
    cmd.scene = null
    // ...
}
```

**Cleanup Strategy**:
- Only cleanup commands removed from stack
- Preserve objects still in scene
- Clear all references to prevent memory leaks
- Destroy QML objects when safe

---

## Implementation Details

### Integration with Scene

The undo system is integrated into `I_Scene`:

```qml
I_Scene {
    property UndoCore _undoCore: UndoCore {
        scene: scene
    }

    function addNode(node) {
        // ... add node logic ...
        
        // Create undo command
        if (!_undoCore.undoStack.isReplaying) {
            var cmdAddNode = Qt.createQmlObject(
                'import QtQuick; import NodeLink; import "Undo/Commands"; AddNodeCommand { }',
                _undoCore.undoStack
            )
            cmdAddNode.scene = scene
            cmdAddNode.node = node
            _undoCore.undoStack.push(cmdAddNode)
        }
    }
}
```

**Key Points**:
- Commands are only created when `!isReplaying`
- Commands are pushed after the operation completes
- Scene reference is set on command

### Keyboard Shortcuts

Undo/Redo can be triggered via keyboard shortcuts:

```qml
Shortcut {
    sequence: "Ctrl+Z"
    onActivated: {
        if (scene?._undoCore?.undoStack?.isValidUndo) {
            scene._undoCore.undoStack.undo()
        }
    }
}

Shortcut {
    sequence: "Ctrl+Y"
    onActivated: {
        if (scene?._undoCore?.undoStack?.isValidRedo) {
            scene._undoCore.undoStack.redo()
        }
    }
}
```

### Signal Flow

```
Property Change
    ↓
Observer Detects Change
    ↓
Creates PropertyCommand
    ↓
CommandStack.push(command)
    ↓
Command Batched (200ms delay)
    ↓
Macro Command Created
    ↓
Added to Undo Stack
    ↓
stacksUpdated() Signal Emitted
    ↓
UI Updates (enable/disable undo/redo buttons)
```

---

## Usage Guide

### Basic Usage

#### Enabling Undo/Redo

Undo/Redo is automatically enabled when you create a scene:

```qml
I_Scene {
    property UndoCore _undoCore: UndoCore {
        scene: scene
    }
}
```

#### Performing Undo

```qml
// Method 1: Direct call
scene._undoCore.undoStack.undo()

// Method 2: Check validity first
if (scene._undoCore.undoStack.isValidUndo) {
    scene._undoCore.undoStack.undo()
}
```

#### Performing Redo

```qml
// Method 1: Direct call
scene._undoCore.undoStack.redo()

// Method 2: Check validity first
if (scene._undoCore.undoStack.isValidRedo) {
    scene._undoCore.undoStack.redo()
}
```

### Creating Custom Commands

To create a custom command for your application:

1. **Create Command File**:
```qml
// MyCustomCommand.qml
import QtQuick
import NodeLink

I_Command {
    id: root

    property var myData: null

    function redo() {
        if (isValidScene()) {
            // Apply your operation
            scene.doSomething(myData)
        }
    }

    function undo() {
        if (isValidScene()) {
            // Reverse your operation
            scene.undoSomething(myData)
        }
    }
}
```

2. **Use in Scene**:
```qml
function doSomething(data) {
    // ... perform operation ...
    
    // Create undo command
    if (!_undoCore.undoStack.isReplaying) {
        var cmd = Qt.createQmlObject(
            'import QtQuick; import NodeLink; import "Undo/Commands"; MyCustomCommand { }',
            _undoCore.undoStack
        )
        cmd.scene = scene
        cmd.myData = data
        _undoCore.undoStack.push(cmd)
    }
}
```

### Monitoring Stack State

Listen to stack update signals:

```qml
Connections {
    target: scene._undoCore.undoStack
    function onStacksUpdated() {
        // Update UI (enable/disable buttons)
        undoButton.enabled = scene._undoCore.undoStack.isValidUndo
        redoButton.enabled = scene._undoCore.undoStack.isValidRedo
    }
}
```

### Clearing Stacks

Reset undo/redo history:

```qml
scene._undoCore.undoStack.resetStacks()
```

**When to Clear**:
- After loading a new file
- After major scene reset
- When starting a new project

---

## Advanced Topics

### Batch Aggregation Details

**Why Batch?**
- User drags node → many position updates
- Without batching: 100 undo steps for one drag
- With batching: 1 undo step for entire drag

**How It Works**:
1. Commands arrive rapidly (< 200ms apart)
2. Added to `_pendingCommands` array
3. Timer restarts on each new command
4. When timer expires, all pending commands are grouped
5. Macro command created with all sub-commands
6. Single undo operation reverses all changes

**Example**:
```
User drags node from (100, 100) to (200, 200)
    ↓
50 position updates in 500ms
    ↓
All updates batched into one macro command
    ↓
One undo restores node to (100, 100)
```

### Memory Optimization

#### Stack Size Management

```qml
// Default: 30 commands
property int maxStackSize: 30

// Unlimited (not recommended)
maxStackSize: 0

// Conservative (saves memory)
maxStackSize: 10
```

#### Command Cleanup

Commands are automatically cleaned up when:
- Removed from stack (exceeds maxStackSize)
- Stack is reset
- Objects are no longer in scene

**Cleanup Process**:
1. Check if command holds scene objects
2. Verify objects are not in scene
3. Destroy QML objects
4. Clear all references
5. Destroy command object

### Observer Performance

**Optimization Strategies**:

1. **Conditional Observation**: Only observe properties that need undo
2. **Value Comparison**: Skip commands if values haven't actually changed
3. **Batch Updates**: Group related property changes
4. **Observer Blocking**: Prevent unnecessary command creation

**Performance Considerations**:
- Observers are lightweight (just Connections)
- Commands are created only on actual changes
- Batching reduces command count significantly
- Cleanup prevents memory leaks

### Custom Property Tracking

To track custom properties:

1. **Create Observer**:
```qml
// MyCustomObserver.qml
Item {
    property MyObject target
    property CommandStack undoStack
    property var _cache: ({})

    Component.onCompleted: {
        _cache.myProperty = target.myProperty
        _cache._init = true
    }

    Connections {
        target: target
        enabled: !NLSpec.undo.blockObservers

        function onMyPropertyChanged() {
            _ensureCache()
            let oldV = _cache.myProperty
            let newV = target.myProperty
            pushProp(target, "myProperty", oldV, newV)
            _cache.myProperty = newV
        }
    }

    function pushProp(targetObj, key, oldV, newV) {
        if (!undoStack || undoStack.isReplaying)
            return
        if (oldV === undefined || newV === undefined)
            return
        if (JSON.stringify(oldV) === JSON.stringify(newV))
            return

        var cmd = {
            undo: function() { targetObj[key] = oldV },
            redo: function() { targetObj[key] = newV }
        }
        undoStack.push(cmd)
    }
}
```

2. **Use in Scene Observer**:
```qml
Repeater {
    model: Object.values(scene.myObjects)
    delegate: MyCustomObserver {
        target: modelData
        undoStack: root.undoStack
    }
}
```

---

## Troubleshooting

### Common Issues

#### 1. Undo/Redo Not Working

**Symptoms**: Commands not being created or executed.

**Possible Causes**:
- `isReplaying` flag not being checked
- Observers blocked incorrectly
- Scene reference not set on commands

**Solutions**:
```qml
// Always check isReplaying before creating commands
if (!scene._undoCore.undoStack.isReplaying) {
    // Create command
}

// Ensure observers are enabled
Connections {
    enabled: !NLSpec.undo.blockObservers
    // ...
}
```

#### 2. Infinite Loop During Undo/Redo

**Symptoms**: Application freezes or crashes during undo/redo.

**Possible Causes**:
- Observers not blocked during undo/redo
- Property changes triggering new commands
- Circular dependencies in commands

**Solutions**:
```qml
// Always block observers
NLSpec.undo.blockObservers = true
try {
    cmd.undo()
} finally {
    NLSpec.undo.blockObservers = false
}

// Check isReplaying in observers
if (undoStack.isReplaying)
    return
```

#### 3. Memory Leaks

**Symptoms**: Memory usage increases over time.

**Possible Causes**:
- Commands not being cleaned up
- Objects not destroyed
- Circular references

**Solutions**:
- Set `maxStackSize` to reasonable value
- Ensure `_cleanupCommand()` is called
- Clear all references in cleanup

#### 4. Commands Not Batched

**Symptoms**: Too many undo steps for single operation.

**Possible Causes**:
- Batch timer too short
- Commands created too far apart
- Manual command creation bypassing batching

**Solutions**:
```qml
// Adjust batch timer interval (default: 200ms)
_batchTimer.interval: 300  // Increase for slower operations

// Ensure commands use push() method
undoStack.push(cmd)  // Will be batched
```

#### 5. Properties Not Tracked

**Symptoms**: Property changes not undoable.

**Possible Causes**:
- No observer for the property
- Observer not connected
- Property not emitting change signal

**Solutions**:
- Create observer for the property
- Ensure Connections target is correct
- Verify property emits change signal

### Debug Tips

#### Enable Logging

```qml
// In CommandStack
function push(cmd) {
    console.log("[Undo] Pushing command:", cmd)
    // ... rest of code
}

function undo() {
    console.log("[Undo] Undoing command:", undoStack[0])
    // ... rest of code
}
```

#### Monitor Stack State

```qml
Connections {
    target: scene._undoCore.undoStack
    function onStacksUpdated() {
        console.log("Undo stack size:", scene._undoCore.undoStack.undoStack.length)
        console.log("Redo stack size:", scene._undoCore.undoStack.redoStack.length)
    }
}
```

#### Check Observer State

```qml
// Check if observers are blocked
console.log("Observers blocked:", NLSpec.undo.blockObservers)
console.log("Is replaying:", scene._undoCore.undoStack.isReplaying)
```

---

## Best Practices

### 1. Always Check isReplaying

```qml
// Good
if (!scene._undoCore.undoStack.isReplaying) {
    var cmd = createCommand()
    scene._undoCore.undoStack.push(cmd)
}

// Bad - creates commands during undo/redo
var cmd = createCommand()
scene._undoCore.undoStack.push(cmd)
```

### 2. Block Observers During Operations

```qml
// Good
NLSpec.undo.blockObservers = true
try {
    // Perform operation
} finally {
    NLSpec.undo.blockObservers = false
}

// Bad - observers create commands during operation
// Perform operation
```

### 3. Preserve Objects for Redo

```qml
// Good - preserve link object
function undo() {
    // Remove from scene but don't destroy
    delete scene.links[link._qsUuid]
    // link object still exists for redo
}

// Bad - destroys object
function undo() {
    link.destroy()  // Can't redo!
}
```

### 4. Use Batch Commands for Related Operations

```qml
// Good - single command for multiple nodes
var cmd = AddNodesCommand {
    nodes: [node1, node2, node3]
}

// Bad - separate commands
var cmd1 = AddNodeCommand { node: node1 }
var cmd2 = AddNodeCommand { node: node2 }
var cmd3 = AddNodeCommand { node: node3 }
```

### 5. Clean Up Properly

```qml
// Good - cleanup in command
function _cleanupCommand(cmd) {
    if (cmd.node && !cmd.scene.nodes[cmd.node._qsUuid]) {
        cmd.node.destroy()
    }
    cmd.node = null
    cmd.scene = null
}

// Bad - leave references
// Objects never destroyed, memory leak
```

---

## Performance Considerations

### Stack Size Impact

- **Small Stack (10 commands)**: Lower memory, limited history
- **Medium Stack (30 commands)**: Balanced (default)
- **Large Stack (100+ commands)**: Higher memory, extensive history
- **Unlimited (0)**: Memory grows unbounded (not recommended)

### Batch Aggregation Impact

- **Without Batching**: 100 undo steps for dragging one node
- **With Batching**: 1 undo step for entire drag operation
- **Performance Gain**: ~100x reduction in stack operations

### Observer Overhead

- **Per Object**: ~1KB memory per observer
- **1000 Nodes**: ~1MB for observers
- **Impact**: Minimal, observers are lightweight

### Command Creation Cost

- **Property Command**: ~100 bytes
- **Node Command**: ~500 bytes
- **Link Command**: ~300 bytes
- **Batch Impact**: Single macro command vs. many individual commands

---

## Architecture Diagrams

### Command Flow

```
User Action
    ↓
Scene Operation
    ↓
Command Created
    ↓
CommandStack.push()
    ↓
Batch Timer (200ms)
    ↓
Macro Command
    ↓
Undo Stack
    ↓
[Ready for Undo]
```

### Undo Flow

```
User: Ctrl+Z
    ↓
CommandStack.undo()
    ↓
Get Command from Undo Stack
    ↓
Block Observers
    ↓
Execute command.undo()
    ↓
Properties Restored
    ↓
Unblock Observers
    ↓
Move to Redo Stack
    ↓
[Ready for Redo]
```

### Observer Flow

```
Property Changes
    ↓
Observer Detects
    ↓
Check: !blockObservers && !isReplaying
    ↓
Create PropertyCommand
    ↓
CommandStack.push()
    ↓
[Added to Batch]
```

---

## Conclusion

The NodeLink Undo/Redo system provides a robust, efficient, and extensible solution for tracking and reversing operations. Key features:

- **Command Pattern**: Clean separation of operations
- **Observer Pattern**: Automatic change tracking
- **Batch Aggregation**: Efficient handling of rapid changes
- **Memory Management**: Automatic cleanup and size limiting
- **Extensibility**: Easy to add custom commands

The system is designed to be:
- **Transparent**: Works automatically without manual intervention
- **Efficient**: Batches operations and manages memory
- **Reliable**: Prevents infinite loops and memory leaks
- **Extensible**: Easy to add new command types

For more information, see the source code in `resources/Core/Undo/` directory.

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

# Performance Optimization

## Overview

NodeLink is designed to handle large scenes with thousands of nodes efficiently. This document covers performance optimization techniques, best practices, and patterns used throughout the framework to ensure smooth operation even with complex node graphs.

---

## Performance Principles

### Key Principles

1. **Batch Operations**: Group multiple operations together to reduce overhead
2. **Lazy Evaluation**: Defer expensive operations until necessary
3. **Incremental Updates**: Update only what changed, not everything
4. **Caching**: Cache expensive computations and component creation
5. **Efficient Lookups**: Use maps/objects for O(1) lookups instead of arrays
6. **GPU Acceleration**: Use hardware-accelerated rendering where possible

---

## Batch Operations

### Creating Multiple Nodes

Instead of creating nodes one by one, use batch creation:

```qml
// ❌ SLOW: Creating nodes individually
for (var i = 0; i < 100; i++) {
    var node = NLCore.createNode();
    node.type = nodeType;
    scene.addNode(node);
}

// ✅ FAST: Batch creation
var nodesToAdd = [];
for (var i = 0; i < 100; i++) {
    var node = NLCore.createNode();
    node.type = nodeType;
    nodesToAdd.push(node);
}
scene.addNodes(nodesToAdd, false);
```

### Pre-allocating Arrays

Pre-allocate arrays when you know the size:

```qml
// ✅ Pre-allocate for better performance
var nodesToAdd = [];
nodesToAdd.length = pairs.length * 2;  // Pre-allocate
var nodeIndex = 0;

for (var i = 0; i < pairs.length; i++) {
    nodesToAdd[nodeIndex++] = startNode;
    nodesToAdd[nodeIndex++] = endNode;
}
```

### Batch Link Creation

Create multiple links at once:

```qml
// examples/PerformanceAnalyzer/resources/Core/PerformanceScene.qml
function createLinks(linkDataArray) {
    if (!linkDataArray || linkDataArray.length === 0) {
        return;
    }

    var addedLinks = [];

    for (var i = 0; i < linkDataArray.length; i++) {
        var linkData = linkDataArray[i];
        
        // Validate and create link
        if (!canLinkNodes(linkData.portA, linkData.portB)) {
            continue;
        }

        var obj = NLCore.createLink();
        obj.inputPort = findPort(linkData.portA);
        obj.outputPort = findPort(linkData.portB);
        links[obj._qsUuid] = obj;
        addedLinks.push(obj);
    }

    // Emit signals once after all links are created
    if (addedLinks.length > 0) {
        linksChanged();
        linksAdded(addedLinks);
    }
}
```

### Complete Batch Example

```qml
// examples/PerformanceAnalyzer/resources/Core/PerformanceScene.qml
function createPairNodes(pairs) {
    var nodesToAdd = [];
    var linksToCreate = [];
    
    if (!pairs || pairs.length === 0) return;

    // Pre-allocate arrays
    nodesToAdd.length = pairs.length * 2;
    linksToCreate.length = pairs.length;

    var nodeIndex = 0;

    for (var i = 0; i < pairs.length; i++) {
        var pair = pairs[i];

        // Create start node
        var startNode = NLCore.createNode();
        startNode.type = CSpecs.NodeType.StartNode;
        startNode.title = pair.nodeName + "_start";
        // ... configure node ...

        // Create end node
        var endNode = NLCore.createNode();
        endNode.type = CSpecs.NodeType.EndNode;
        endNode.title = pair.nodeName + "_end";
        // ... configure node ...

        nodesToAdd[nodeIndex++] = startNode;
        nodesToAdd[nodeIndex++] = endNode;

        linksToCreate[i] = {
            nodeA: startNode,
            nodeB: endNode,
            portA: outputPort._qsUuid,
            portB: inputPort._qsUuid,
        };
    }

    // Add all nodes at once
    addNodes(nodesToAdd, false);

    // Create all links at once
    createLinks(linksToCreate);
}
```

---

## Component Caching

### ObjectCreator

NodeLink uses `ObjectCreator` (C++) to cache QML components for faster creation:

```qml
// resources/View/I_NodesRect.qml
function onNodesAdded(nodeArray: list<Node>) {
    var jsArray = [];
    for (var i = 0; i < nodeArray.length; i++) {
        jsArray.push(nodeArray[i]);
    }
    
    // ObjectCreator caches the component internally
    var result = ObjectCreator.createItems(
        "node",
        jsArray,
        root,
        nodeViewComponent.url,
        {
            "scene": root.scene,
            "sceneSession": root.sceneSession,
            "viewProperties": root.viewProperties
        }
    );
    
    // Set properties if needed
    if (result.needsPropertySet) {
        for (var i = 0; i < result.items.length; i++) {
            result.items[i].node = nodeArray[i];
        }
    }
}
```

### How It Works

`ObjectCreator` caches `QQmlComponent` instances:

```cpp
// Source/Core/objectcreator.cpp
QQmlComponent* ObjectCreator::getOrCreateComponent(const QString &componentUrl)
{
    if (m_componentCache.contains(componentUrl)) {
        return m_componentCache[componentUrl];
    }
    
    QQmlComponent *component = new QQmlComponent(m_engine, QUrl(componentUrl));
    m_componentCache[componentUrl] = component;
    return component;
}
```

**Benefits**:
- Component parsing happens only once
- Subsequent creations are much faster
- Reduces memory allocations

---

## Efficient Data Structures

### Use Maps for Lookups

Use objects/maps for O(1) lookups instead of arrays:

```qml
// ❌ SLOW: Array lookup O(n)
var nodes = [];
function findNode(uuid) {
    for (var i = 0; i < nodes.length; i++) {
        if (nodes[i]._qsUuid === uuid) {
            return nodes[i];
        }
    }
}

// ✅ FAST: Map lookup O(1)
var nodes = {};  // Object/map
function findNode(uuid) {
    return nodes[uuid];
}
```

### Scene Node Storage

```qml
// resources/Core/Scene.qml
property var nodes: ({})  // Object map, not array
property var links: ({})  // Object map, not array
property var containers: ({})  // Object map, not array

function findNode(uuid) {
    return nodes[uuid];  // O(1) lookup
}
```

### View Maps

```qml
// resources/View/I_NodesRect.qml
property var _nodeViewMap: ({})  // UUID -> View mapping
property var _linkViewMap: ({})  // UUID -> View mapping

function onNodeAdded(nodeObj: Node) {
    // Fast lookup
    if (Object.keys(_nodeViewMap).includes(nodeObj._qsUuid)) {
        return;  // Already exists
    }
    
    // Create and store
    var view = createNodeView(nodeObj);
    _nodeViewMap[nodeObj._qsUuid] = view;
}
```

---

## Rendering Optimizations

### GPU-Accelerated Background Grid

NodeLink uses C++ Scene Graph for high-performance grid rendering:

```cpp
// Source/View/BackgroundGridsCPP.cpp
QSGNode *BackgroundGridsCPP::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    QSGGeometryNode *node = static_cast<QSGGeometryNode *>(oldNode);
    
    // Reuse existing node if possible
    if (!node) {
        node = new QSGGeometryNode();
        // ... setup geometry and material ...
    }
    
    // Update geometry efficiently
    const int verticesCount = cols * rows * 6;
    QSGGeometry *geometry = node->geometry();
    geometry->allocate(verticesCount);
    
    // Fill vertices
    QSGGeometry::Point2D *v = geometry->vertexDataAsPoint2D();
    // ... fill vertices ...
    
    node->markDirty(QSGNode::DirtyGeometry);
    return node;
}
```

**Benefits**:
- Rendered on GPU
- Minimal CPU overhead
- Smooth scrolling even with large grids

### Canvas Optimization

Links use Canvas with efficient repainting:

```qml
// resources/View/I_LinkView.qml
Canvas {
    id: canvas
    
    // Only repaint when necessary
    onOutputPosChanged: preparePainter();
    onInputPosChanged: preparePainter();
    onIsSelectedChanged: preparePainter();
    onLinkColorChanged: preparePainter();
    
    onPaint: {
        // Efficient painting logic
        var context = canvas.getContext("2d");
        LinkPainter.createLink(context, ...);
    }
}
```

---

## Update Strategies

### Incremental Updates

Update only affected nodes, not the entire graph:

```qml
// examples/visionLink/resources/Core/VisionLinkScene.qml
function updateDataFromNode(startingNode: Node) {
    // Update only the starting node
    if (startingNode.type === CSpecs.NodeType.Blur ||
        startingNode.type === CSpecs.NodeType.Brightness ||
        startingNode.type === CSpecs.NodeType.Contrast) {
        startingNode.updataData();
    }
    
    // Find and update only downstream nodes
    var nodesToUpdate = [startingNode];
    var processedNodes = [];
    var maxIterations = 100;
    var iteration = 0;
    
    while (nodesToUpdate.length > 0 && iteration < maxIterations) {
        iteration++;
        var currentNode = nodesToUpdate.shift();
        processedNodes.push(currentNode._qsUuid);
        
        // Find downstream links
        var downstreamLinks = Object.values(links).filter(function(link) {
            var upstreamNodeId = findNodeId(link.inputPort._qsUuid);
            return upstreamNodeId === currentNode._qsUuid;
        });
        
        // Update downstream nodes
        downstreamLinks.forEach(function(link) {
            var downStreamNode = findNode(link.outputPort._qsUuid);
            upadateNodeData(currentNode, downStreamNode);
            
            // Add to queue if not processed
            if (processedNodes.indexOf(downStreamNode._qsUuid) === -1) {
                nodesToUpdate.push(downStreamNode);
            }
        });
    }
}
```

### Iterative Propagation

Use iterative algorithms for data propagation:

```qml
// examples/logicCircuit/resources/Core/LogicCircuitScene.qml
function updateLogic() {
    // Reset all operation nodes
    Object.values(nodes).forEach(node => {
        if (node.type === LSpecs.NodeType.AND ||
            node.type === LSpecs.NodeType.OR ||
            node.type === LSpecs.NodeType.NOT) {
            node.nodeData.inputA = null;
            node.nodeData.inputB = null;
            node.nodeData.output = null;
        }
    });

    // Iterative propagation with max iterations
    var maxIterations = 999;
    var changed = true;

    for (var i = 0; i < maxIterations && changed; i++) {
        changed = false;
        // ... propagation logic ...
    }
}
```

### Topological Processing

Process nodes in topological order:

```qml
// examples/visionLink/resources/Core/VisionLinkScene.qml
function updateData() {
    var allLinks = Object.values(links);
    var processedLinks = [];
    var remainingLinks = allLinks.slice();
    
    var maxIterations = 100;
    var iteration = 0;
    
    // Process in iterations until all links are processed
    while (remainingLinks.length > 0 && iteration < maxIterations) {
        iteration++;
        
        var linksProcessedThisIteration = [];
        var linksStillWaiting = [];
        
        remainingLinks.forEach(function(link) {
            var upstreamNode = findNode(link.inputPort._qsUuid);
            var downStreamNode = findNode(link.outputPort._qsUuid);
            
            // Check if upstream has data
            var upstreamHasData = upstreamNode.nodeData.data !== null && 
                                 upstreamNode.nodeData.data !== undefined;
            
            if (upstreamHasData) {
                // Process now
                upadateNodeData(upstreamNode, downStreamNode);
                linksProcessedThisIteration.push(link);
            } else {
                // Wait for next iteration
                linksStillWaiting.push(link);
            }
        });
        
        remainingLinks = linksStillWaiting;
        processedLinks = processedLinks.concat(linksProcessedThisIteration);
    }
}
```

---

## Memory Management

### Garbage Collection

Explicitly trigger GC when clearing large scenes:

```qml
// examples/PerformanceAnalyzer/resources/Core/PerformanceScene.qml
function clearScene() {
    console.time("Scene_clear");
    gc();  // Trigger garbage collection
    scene.selectionModel.clear();
    var nodeIds = Object.keys(nodes);
    scene.deleteNodes(nodeIds);
    links = [];
    console.timeEnd("Scene_clear");
}
```

### Object Destruction

Properly destroy objects to free memory:

```qml
// resources/View/I_NodesRect.qml
function onNodesRemoved(nodeArray: list<Node>) {
    for (var i = 0; i < nodeArray.length; i++) {
        var nodeObj = nodeArray[i];
        var nodeObjId = nodeObj._qsUuid;
        
        // Delete ports
        let nodePorts = nodeObj.ports;
        Object.entries(nodePorts).forEach(([portId, port]) => {
            nodeObj.deletePort(port);
        });
        
        // Destroy node
        nodeObj.destroy();
        
        // Destroy and remove view
        if (_nodeViewMap[nodeObjId]) {
            _nodeViewMap[nodeObjId].destroy();
            delete _nodeViewMap[nodeObjId];
        }
    }
}
```

---

## String Comparison Optimization

### HashCompareString

Use MD5 hashing for efficient string comparison:

```qml
// resources/Core/Scene.qml
function canLinkNodes(portA, portB) {
    // Use hash comparison for efficiency
    if (HashCompareString.compareStringModels(nodeA, nodeB)) {
        return false;  // Same node
    }
    // ... rest of logic ...
}
```

**How It Works**:

```cpp
// Source/Core/HashCompareStringCPP.cpp
bool HashCompareStringCPP::compareStringModels(QString strModelFirst, QString strModelSecound)
{
    // Compare MD5 hashes instead of full strings
    QByteArray hash1 = QCryptographicHash::hash(
        strModelFirst.toUtf8(), 
        QCryptographicHash::Md5
    );
    QByteArray hash2 = QCryptographicHash::hash(
        strModelSecound.toUtf8(), 
        QCryptographicHash::Md5
    );
    return hash1 == hash2;
}
```

**Benefits**:
- Fast comparison of long strings
- Useful for UUID comparisons
- Reduces string allocation overhead

---

## Timer-Based Operations

### Debouncing Updates

Use timers to debounce frequent updates:

```qml
// examples/logicCircuit/resources/Core/LogicCircuitScene.qml
property Timer _upateDataTimer: Timer {
    repeat: false
    running: false
    interval: 1  // 1ms delay
    onTriggered: scene.updateLogic();
}

// Trigger update with debounce
onLinkRemoved: _upateDataTimer.restart();
onNodeRemoved: _upateDataTimer.restart();
onLinkAdded: _upateDataTimer.restart();
```

### Async Operations

Use `Qt.callLater` for async operations:

```qml
// examples/PerformanceAnalyzer/Main.qml
function selectAll() {
    busyIndicator.running = true;
    statusText.text = "Selecting...";
    
    // Defer to next event loop
    Qt.callLater(function () {
        const startTime = Date.now();
        scene.selectionModel.selectAll(scene.nodes, [], scene.containers);
        const elapsed = Date.now() - startTime;
        statusText.text = "Selected all items (" + elapsed + "ms)";
        busyIndicator.running = false;
    });
}
```

### Selection Timer

Debounce selection events:

```qml
// resources/View/NodeView.qml
Timer {
    id: _selectionTimer
    interval: 200  // 200ms delay
    repeat: false
    onTriggered: {
        // Handle selection after delay
    }
}

MouseArea {
    onPressed: _selectionTimer.start();
    onClicked: _selectionTimer.start();
}
```

---

## Best Practices

### 1. Batch Operations

Always batch operations when possible:

```qml
// ✅ Good
scene.addNodes([node1, node2, node3], false);
scene.createLinks([link1, link2, link3]);

// ❌ Bad
scene.addNode(node1);
scene.addNode(node2);
scene.addNode(node3);
```

### 2. Minimize Signal Emissions

Emit signals after batch operations:

```qml
// ✅ Good
var addedNodes = [];
for (var i = 0; i < 100; i++) {
    addedNodes.push(createNode(i));
}
nodesChanged();  // Emit once
nodesAdded(addedNodes);  // Emit once

// ❌ Bad
for (var i = 0; i < 100; i++) {
    var node = createNode(i);
    nodesChanged();  // Emit 100 times!
    nodesAdded([node]);  // Emit 100 times!
}
```

### 3. Use Efficient Lookups

Prefer maps over arrays for lookups:

```qml
// ✅ Good
var nodeMap = {};
nodeMap[uuid] = node;
var found = nodeMap[uuid];  // O(1)

// ❌ Bad
var nodeArray = [];
nodeArray.push(node);
var found = nodeArray.find(n => n._qsUuid === uuid);  // O(n)
```

### 4. Limit Iterations

Always set max iterations for loops:

```qml
// ✅ Good
var maxIterations = 100;
var iteration = 0;
while (condition && iteration < maxIterations) {
    iteration++;
    // ... logic ...
}

// ❌ Bad
while (condition) {  // Could loop forever
    // ... logic ...
}
```

### 5. Cache Expensive Computations

Cache results of expensive operations:

```qml
// ✅ Good
property var _cachedResult: null;

function expensiveOperation() {
    if (_cachedResult !== null) {
        return _cachedResult;
    }
    _cachedResult = computeExpensiveResult();
    return _cachedResult;
}
```

### 6. Use ObjectCreator for Views

Always use `ObjectCreator` for creating views:

```qml
// ✅ Good
var result = ObjectCreator.createItems("node", nodes, parent, componentUrl, props);

// ❌ Bad
for (var i = 0; i < nodes.length; i++) {
    var view = Qt.createQmlObject(componentUrl, parent);
    // ... setup ...
}
```

### 7. Incremental Updates

Update only what changed:

```qml
// ✅ Good
function updateDataFromNode(startingNode) {
    // Update only downstream nodes
    var nodesToUpdate = [startingNode];
    // ... process incrementally ...
}

// ❌ Bad
function updateAllData() {
    // Update everything
    Object.values(nodes).forEach(node => {
        updateNode(node);
    });
}
```

### 8. Pre-allocate Arrays

Pre-allocate when size is known:

```qml
// ✅ Good
var array = [];
array.length = 1000;  // Pre-allocate
for (var i = 0; i < 1000; i++) {
    array[i] = createItem(i);
}

// ❌ Bad
var array = [];
for (var i = 0; i < 1000; i++) {
    array.push(createItem(i));  // Reallocates multiple times
}
```

---

## Performance Testing

### Performance Analyzer Example

NodeLink includes a Performance Analyzer example for testing:

```qml
// examples/PerformanceAnalyzer/Main.qml
function selectAll() {
    const startTime = Date.now();
    scene.selectionModel.selectAll(scene.nodes, [], scene.containers);
    const elapsed = Date.now() - startTime;
    console.log("Time elapsed:", elapsed, "ms");
}

Timer {
    id: timer
    onTriggered: {
        const startTime = Date.now();
        scene.createPairNodes(pairs);
        const elapsed = Date.now() - startTime;
        console.log("Elapsed time:", elapsed, "ms");
    }
}
```

### Benchmarking Tips

1. **Use `console.time()` and `console.timeEnd()`**:
   ```qml
   console.time("Operation");
   // ... operation ...
   console.timeEnd("Operation");
   ```

2. **Measure in milliseconds**:
   ```qml
   const start = Date.now();
   // ... operation ...
   const elapsed = Date.now() - start;
   ```

3. **Test with realistic data sizes**:
   - Small: 10-100 nodes
   - Medium: 100-1000 nodes
   - Large: 1000-10000 nodes

4. **Profile memory usage**:
   ```qml
   function clearScene() {
       console.time("Scene_clear");
       gc();
       // ... clear operations ...
       console.timeEnd("Scene_clear");
   }
   ```

### Performance Targets

- **Node Creation**: < 1ms per node (batch)
- **Link Creation**: < 0.5ms per link (batch)
- **Selection**: < 10ms for 1000 nodes
- **Data Propagation**: < 50ms for 100 nodes
- **Rendering**: 60 FPS with 1000 visible nodes

---

## Common Performance Issues

### Issue: Slow Node Creation

**Symptoms**: Creating nodes one by one is slow

**Solution**: Use batch creation
```qml
scene.addNodes(nodeArray, false);
```

### Issue: Frequent Signal Emissions

**Symptoms**: UI freezes during operations

**Solution**: Batch operations and emit signals once
```qml
// Create all nodes first
var nodes = [];
for (var i = 0; i < count; i++) {
    nodes.push(createNode(i));
}
// Then add all at once
scene.addNodes(nodes, false);
```

### Issue: Slow Lookups

**Symptoms**: Finding nodes/links is slow

**Solution**: Use maps instead of arrays
```qml
var nodeMap = {};  // Not []
nodeMap[uuid] = node;
var found = nodeMap[uuid];
```

### Issue: Memory Leaks

**Symptoms**: Memory usage grows over time

**Solution**: Properly destroy objects
```qml
node.destroy();
delete _viewMap[uuid];
gc();  // Trigger GC if needed
```

### Issue: Slow Rendering

**Symptoms**: Low FPS with many nodes

**Solution**: 
- Use GPU-accelerated components (BackgroundGridsCPP)
- Limit visible nodes (viewport culling)
- Reduce repaints (debounce updates)

---

## Advanced Optimizations

### Viewport Culling

Only render visible nodes:

```qml
function isNodeVisible(node, viewport) {
    var nodeRect = Qt.rect(
        node.guiConfig.position.x,
        node.guiConfig.position.y,
        node.guiConfig.width,
        node.guiConfig.height
    );
    return nodeRect.intersects(viewport);
}

function updateVisibleNodes() {
    var viewport = getViewport();
    Object.values(nodes).forEach(node => {
        var view = _nodeViewMap[node._qsUuid];
        view.visible = isNodeVisible(node, viewport);
    });
}
```

### Lazy Loading

Load nodes on demand:

```qml
function loadNodesInViewport() {
    var viewport = getViewport();
    var nodesToLoad = Object.values(nodes).filter(node => {
        return isNodeVisible(node, viewport) && 
               !_nodeViewMap[node._qsUuid];
    });
    
    if (nodesToLoad.length > 0) {
        createNodeViews(nodesToLoad);
    }
}
```

### Connection Graph Caching

Cache connection graphs:

```qml
property var _connectionGraphCache: null;

function buildConnectionGraph(nodes) {
    if (_connectionGraphCache !== null) {
        return _connectionGraphCache;
    }
    
    var graph = {};
    // ... build graph ...
    _connectionGraphCache = graph;
    return graph;
}

function invalidateConnectionGraph() {
    _connectionGraphCache = null;
}
```
