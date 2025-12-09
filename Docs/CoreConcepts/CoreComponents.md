# Core Library (The Engine)

## Overview

The **Core Library** is the engine that powers NodeLink. It provides the fundamental data models, business logic, and core services for building node-based applications. The Core Library is completely independent of the View layer, making it possible to use NodeLink's engine with different UI implementations.

---

## Core Library Architecture

### Purpose

The Core Library provides:

- **Data Models**: Scene, Node, Link, Port, Container
- **Business Logic**: Scene management, node operations, linking
- **Core Services**: Factory functions, registry, selection, undo/redo
- **Serialization**: Integration with QtQuickStream
- **Type System**: Specifications, enums, interfaces

### Key Principles

1. **Data-Only**: Core components contain no UI/rendering logic
2. **Serializable**: All components inherit from `QSObject` for persistence
3. **Signal-Based**: Components emit signals for change notification
4. **Extensible**: Interface-based design allows customization
5. **Independent**: No dependencies on View layer

### Directory Structure

```
resources/Core/
├── NLCore.qml              # Engine singleton
├── NLSpec.qml              # Specifications and enums
├── NLNodeRegistry.qml      # Node type registry
├── NLUtils.qml             # Utilities
│
├── I_Scene.qml             # Scene interface
├── Scene.qml               # Scene implementation
├── SceneGuiConfig.qml      # Scene GUI configuration
│
├── I_Node.qml              # Node interface
├── Node.qml                # Node implementation
├── NodeGuiConfig.qml       # Node GUI configuration
├── I_NodeData.qml          # Node data interface
├── NodeData.qml            # Node data implementation
│
├── Link.qml                # Link model
├── LinkGUIConfig.qml       # Link GUI configuration
│
├── Port.qml                # Port model
│
├── Container.qml           # Container model
├── ContainerGuiConfig.qml  # Container GUI configuration
│
├── SelectionModel.qml      # Selection management
├── SelectionSpecificTool.qml
│
├── ImagesModel.qml         # Image management
│
└── Undo/                   # Undo/Redo system
    ├── UndoCore.qml
    ├── UndoStack.qml
    ├── CommandStack.qml
    └── Commands/
        ├── AddNodeCommand.qml
        ├── RemoveNodeCommand.qml
        ├── CreateLinkCommand.qml
        └── ...
```

---

## NLCore - The Engine Singleton

### Overview

`NLCore` is the central singleton that provides factory functions and core services for NodeLink.

**Location**: `resources/Core/NLCore.qml`

**Type**: QML Singleton (`pragma Singleton`)

### Properties

```qml
NLCore {
    // Default repository (QtQuickStream)
    property QSRepository defaultRepo: QSRepository { ... }
    
    // Copy/paste storage
    property var _copiedNodes: ({})
    property var _copiedLinks: ({})
    property var _copiedContainers: ({})
}
```

### Factory Functions

#### Create Scene

```qml
// Create a new scene
var scene = NLCore.createScene();
scene.title = "My Scene";
```

**Implementation**:
```qml
function createScene() {
    let obj = QSSerializer.createQSObject("Scene", ["NodeLink"], defaultRepo);
    obj._qsRepo = defaultRepo;
    return obj;
}
```

#### Create Node

```qml
// Create a new node
var node = NLCore.createNode();
node.type = 0;
node.title = "My Node";
```

**Implementation**:
```qml
function createNode() {
    let obj = QSSerializer.createQSObject("Node", ["NodeLink"], defaultRepo);
    obj._qsRepo = defaultRepo;
    return obj;
}
```

#### Create Port

```qml
// Create a new port
var port = NLCore.createPort();
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;
port.title = "input";
```

**Implementation**:
```qml
function createPort(qsRepo = null) {
    if (!qsRepo)
        qsRepo = defaultRepo;
    
    let obj = QSSerializer.createQSObject("Port", ["NodeLink"], qsRepo);
    obj._qsRepo = qsRepo;
    return obj;
}
```

#### Create Link

```qml
// Create a new link
var link = NLCore.createLink();
link.inputPort = inputPort;
link.outputPort = outputPort;
```

**Implementation**:
```qml
function createLink() {
    let obj = QSSerializer.createQSObject("Link", ["NodeLink"], defaultRepo);
    obj._qsRepo = defaultRepo;
    return obj;
}
```

### Default Repository

`NLCore.defaultRepo` is the default QtQuickStream repository used for serialization:

```qml
// Initialize repository
NLCore.defaultRepo = NLCore.createDefaultRepo([
    "QtQuickStream", 
    "NodeLink", 
    "YourApp"
]);

// Initialize root object
NLCore.defaultRepo.initRootObject("Scene");
```

### Copy/Paste Storage

NLCore provides temporary storage for copy/paste operations:

```qml
// Copy nodes
NLCore._copiedNodes = selectedNodes;
NLCore._copiedNodesChanged();

// Paste nodes
var copiedNodes = NLCore._copiedNodes;
// ... create new nodes from copied data ...
```

---

## Core Components

### Scene

**Location**: `resources/Core/Scene.qml`

**Interface**: `I_Scene` (`resources/Core/I_Scene.qml`)

The Scene is the root model that manages all nodes, links, and containers in a graph.

#### Properties

```qml
Scene {
    // Collections
    property var nodes: ({})           // Map<UUID, Node>
    property var links: ({})           // Map<UUID, Link>
    property var containers: ({})      // Map<UUID, Container>
    
    // Metadata
    property string title: "<Untitled>"
    
    // Services
    property SelectionModel selectionModel: SelectionModel { ... }
    property NLNodeRegistry nodeRegistry: null
    property UndoCore _undoCore: UndoCore { ... }
    
    // Configuration
    property SceneGuiConfig sceneGuiConfig: SceneGuiConfig { ... }
}
```

#### Key Functions

```qml
// Node management
function addNode(node) { ... }
function deleteNode(uuid) { ... }
function addNodes(nodeArray, autoSelect = true) { ... }
function deleteNodes(nodeUUIds) { ... }
function cloneNode(uuid) { ... }

// Link management
function linkNodes(portA, portB) { ... }
function unlinkNodes(portA, portB) { ... }
function createLink(portA, portB) { ... }

// Container management
function addContainer(container) { ... }
function deleteContainer(uuid) { ... }
function createContainer() { ... }
function cloneContainer(uuid) { ... }

// Utilities
function findNode(uuid) { ... }
function findPort(uuid) { ... }
function canLinkNodes(portA, portB) { ... }
function createCustomizeNode(nodeType, xPos, yPos) { ... }
```

#### Signals

```qml
signal nodeAdded(Node node)
signal nodeRemoved(Node node)
signal nodesAdded(list<Node> nodes)
signal nodesRemoved(list<Node> nodes)

signal linkAdded(Link link)
signal linkRemoved(Link link)
signal linksAdded(list<Link> links)

signal containerAdded(Container container)
signal containerRemoved(Container container)
```

### Node

**Location**: `resources/Core/Node.qml`

**Interface**: `I_Node` (`resources/Core/I_Node.qml`)

A Node represents a single element in the graph with ports for connections.

#### Properties

```qml
Node {
    // Identity
    property string title: "<No Title>"
    property int type: 0
    property int objectType: NLSpec.ObjectType.Node
    
    // Structure
    property var ports: ({})           // Map<UUID, Port>
    property var children: ({})        // Map<UUID, Node>
    property var parents: ({})         // Map<UUID, Node>
    
    // Configuration
    property NodeGuiConfig guiConfig: NodeGuiConfig { ... }
    property I_NodeData nodeData: null
    property ImagesModel imagesModel: ImagesModel { ... }
}
```

#### Key Functions

```qml
// Port management
function addPort(port) { ... }
function deletePort(port) { ... }
function findPort(uuid) { ... }
function findPortByPortSide(side) { ... }
```

#### Signals

```qml
signal portAdded(var portId)
signal nodeCompleted()
```

### Link

**Location**: `resources/Core/Link.qml`

A Link represents a connection between two ports.

#### Properties

```qml
Link {
    // Connection
    property Port inputPort: null
    property Port outputPort: null
    
    // Geometry
    property var controlPoints: []     // Array of vector2d
    
    // Configuration
    property int direction: NLSpec.LinkDirection.LeftToRight
    property LinkGUIConfig guiConfig: LinkGUIConfig { ... }
}
```

### Port

**Location**: `resources/Core/Port.qml`

A Port represents a connection point on a node.

#### Properties

```qml
Port {
    // Parent
    property Node node: null           // Parent node
    
    // Type and position
    property int portType: NLSpec.PortType.Input
    property int portSide: NLSpec.PortPositionSide.Left
    
    // Appearance
    property string title: ""
    property string color: "white"
    property bool enable: true
    
    // Position (set by view)
    property vector2d _position: Qt.vector2d(0, 0)
    property real _measuredTitleWidth: 0
}
```

### Container

**Location**: `resources/Core/Container.qml`

**Interface**: `I_Node` (inherits from)

A Container groups nodes and other containers together.

#### Properties

```qml
Container {
    // Identity
    property string title: "Untitled"
    property int objectType: NLSpec.ObjectType.Container
    
    // Contents
    property var nodes: ({})           // Map<UUID, Node>
    property var containersInside: ({}) // Map<UUID, Container>
    
    // Configuration
    property ContainerGuiConfig guiConfig: ContainerGuiConfig { ... }
}
```

#### Key Functions

```qml
function addNode(node) { ... }
function removeNode(node) { ... }
function addContainerInside(container) { ... }
function removeContainerInside(container) { ... }
```

---

## Interfaces

### I_Node

**Location**: `resources/Core/I_Node.qml`

Base interface for all objects in the scene (Node, Container).

```qml
I_Node {
    property int objectType: NLSpec.ObjectType.Unknown
    property I_NodeData nodeData: null
    
    signal cloneFrom(baseNode: I_Node)
    
    onCloneFrom: function (baseNode) {
        objectType = baseNode.objectType;
        nodeData?.setProperties(baseNode.nodeData);
    }
}
```

**Purpose**:
- Provides common interface for Node and Container
- Enables polymorphic operations
- Supports cloning mechanism

### I_Scene

**Location**: `resources/Core/I_Scene.qml`

Base interface for Scene.

```qml
I_Scene {
    property string title: "<Untitled>"
    property var nodes: ({})
    property var links: ({})
    property var containers: ({})
    property SelectionModel selectionModel: null
    property NLNodeRegistry nodeRegistry: null
    property SceneGuiConfig sceneGuiConfig: SceneGuiConfig { ... }
    
    signal nodeAdded(Node node)
    signal nodeRemoved(Node node)
    // ... more signals ...
}
```

**Purpose**:
- Defines Scene contract
- Enables custom Scene implementations
- Provides type safety

### I_NodeData

**Location**: `resources/Core/I_NodeData.qml`

Base interface for node-specific data.

```qml
I_NodeData {
    property var data: null
}
```

**Purpose**:
- Stores node-specific data
- Enables type-safe data access
- Supports serialization

**Usage**:
```qml
// Custom node data
NodeData {
    property real value: 0.0
    property string text: ""
}
```

---

## Configuration Objects

### NodeGuiConfig

**Location**: `resources/Core/NodeGuiConfig.qml`

Stores GUI-related properties for nodes.

```qml
NodeGuiConfig {
    property string description: ""
    property string logoUrl: ""
    property vector2d position: Qt.vector2d(0, 0)
    property real width: 200
    property real height: 150
    property string color: "#4A90E2"
    property int colorIndex: 0
    property real opacity: 1.0
    property bool locked: false
    property bool autoSize: true
    property real minWidth: 120
    property real minHeight: 80
    property real baseContentWidth: 0
}
```

### LinkGUIConfig

**Location**: `resources/Core/LinkGUIConfig.qml`

Stores GUI-related properties for links.

```qml
LinkGUIConfig {
    property string description: ""
    property string color: "#FFFFFF"
    property int colorIndex: 0
    property int style: NLSpec.LinkStyle.Solid
    property int type: NLSpec.LinkType.Bezier
    property bool _isEditableDescription: true
}
```

### ContainerGuiConfig

**Location**: `resources/Core/ContainerGuiConfig.qml`

Stores GUI-related properties for containers.

```qml
ContainerGuiConfig {
    property real width: 400
    property real height: 300
    property string color: "#4A90E2"
    property int colorIndex: 0
    property vector2d position: Qt.vector2d(0, 0)
    property bool locked: false
    property real containerTextHeight: 30
}
```

### SceneGuiConfig

**Location**: `resources/Core/SceneGuiConfig.qml`

Stores GUI-related properties for scenes.

```qml
SceneGuiConfig {
    property real zoomFactor: 1.0
    property real contentWidth: 10000
    property real contentHeight: 10000
    property real contentX: 0
    property real contentY: 0
    property real sceneViewWidth: 1280
    property real sceneViewHeight: 960
    property vector2d _mousePosition: Qt.vector2d(0, 0)
}
```

---

## Registry System

### NLNodeRegistry

**Location**: `resources/Core/NLNodeRegistry.qml`

Maps node type IDs to QML component names, display names, icons, and colors.

#### Properties

```qml
NLNodeRegistry {
    // Imports for creating nodes
    property var imports: []
    
    // Type mappings
    property var nodeTypes: ({})       // Map<id, "ComponentName">
    property var nodeNames: ({})       // Map<id, "Display Name">
    property var nodeIcons: ({})       // Map<id, "\uf123">
    property var nodeColors: ({})      // Map<id, "#4A90E2">
    
    // Default node type
    property int defaultNode: 0
    
    // View component URLs
    property string nodeView: "NodeView.qml"
    property string linkView: "LinkView.qml"
    property string containerView: "ContainerView.qml"
}
```

#### Usage

```qml
// Register node types
nodeRegistry.imports = ["NodeLink", "MyApp"];

nodeRegistry.nodeTypes[0] = "SourceNode";
nodeRegistry.nodeNames[0] = "Source";
nodeRegistry.nodeIcons[0] = "\uf04b";
nodeRegistry.nodeColors[0] = "#4A90E2";

nodeRegistry.nodeTypes[1] = "AdditiveNode";
nodeRegistry.nodeNames[1] = "Add";
nodeRegistry.nodeIcons[1] = "\uf067";
nodeRegistry.nodeColors[1] = "#9C27B0";
```

---

## Selection Management

### SelectionModel

**Location**: `resources/Core/SelectionModel.qml`

Manages selected objects in the scene.

#### Properties

```qml
SelectionModel {
    property var selectedModel: ({})   // Map<UUID, Object>
    property var existObjects: []      // All object UUIDs
    property bool notifySelectedObject: true
}
```

#### Key Functions

```qml
// Selection operations
function selectNode(node) { ... }
function selectLink(link) { ... }
function selectContainer(container) { ... }
function selectAll(nodes, links, containers) { ... }

// Deselection
function clear() { ... }
function clearAllExcept(uuid) { ... }
function remove(uuid) { ... }

// Queries
function isSelected(uuid): bool { ... }
function lastSelectedObject(objType) { ... }
```

#### Signals

```qml
signal selectedObjectChanged()
```

#### Usage

```qml
// Select a node
scene.selectionModel.selectNode(node);

// Check if selected
if (scene.selectionModel.isSelected(node._qsUuid)) {
    // Node is selected
}

// Clear selection
scene.selectionModel.clear();

// Select all
scene.selectionModel.selectAll(scene.nodes, scene.links, scene.containers);
```

---

## Undo/Redo System

### UndoCore

**Location**: `resources/Core/Undo/UndoCore.qml`

Manages undo/redo operations for the scene.

```qml
UndoCore {
    required property I_Scene scene
    property CommandStack undoStack: CommandStack { }
    
    // Observers track changes
    property UndoSceneObserver undoSceneObserver: UndoSceneObserver { ... }
    property UndoNodeObserver undoNodeObserver: UndoNodeObserver { ... }
    property UndoLinkObserver undoLinkObserver: UndoLinkObserver { ... }
}
```

### CommandStack

**Location**: `resources/Core/Undo/CommandStack.qml`

Manages undo/redo command stacks.

```qml
CommandStack {
    property var undoStack: []
    property var redoStack: []
    readonly property bool isValidUndo: undoStack.length > 0
    readonly property bool isValidRedo: redoStack.length > 0
    property bool isReplaying: false
    
    function push(cmd, appliedAlready = true) { ... }
    function undo() { ... }
    function redo() { ... }
    function clear() { ... }
}
```

### Commands

Commands encapsulate operations for undo/redo:

- `AddNodeCommand`: Add node operation
- `RemoveNodeCommand`: Remove node operation
- `CreateLinkCommand`: Create link operation
- `UnlinkCommand`: Remove link operation
- `PropertyCommand`: Property change operation
- `AddContainerCommand`: Add container operation
- `RemoveContainerCommand`: Remove container operation

**See**: [Undo/Redo System Documentation](../AdvancedTopics/UndoRedo.md)

---

## Specifications and Enums

### NLSpec

**Location**: `resources/Core/NLSpec.qml`

**Type**: QML Singleton

Defines all enums and specifications used throughout NodeLink.

#### Object Types

```qml
enum ObjectType {
    Node = 0,
    Link = 1,
    Container = 2,
    Unknown = 99
}
```

#### Port Types

```qml
enum PortType {
    Input = 0,
    Output = 1,
    InAndOut = 2
}
```

#### Port Positions

```qml
enum PortPositionSide {
    Top = 0,
    Bottom = 1,
    Left = 2,
    Right = 3,
    Unknown = 99
}
```

#### Link Types

```qml
enum LinkType {
    Bezier = 0,      // Bezier curve
    LLine = 1,       // L-shaped line
    Straight = 2,    // Straight line
    Unknown = 99
}
```

#### Link Directions

```qml
enum LinkDirection {
    Nondirectional = 0,
    Unidirectional = 1,
    Bidirectional = 2
}
```

#### Link Styles

```qml
enum LinkStyle {
    Solid = 0,
    Dash = 1,
    Dot = 2
}
```

#### Selection Tool Types

```qml
enum SelectionSpecificToolType {
    Node = 0,        // Single node selection
    Link = 1,        // Single link selection
    Any = 2,         // Single selection (any type)
    All = 3,         // Multiple selection (any types)
    Unknown = 99
}
```

#### Undo Configuration

```qml
property QtObject undo: QtObject {
    property bool blockObservers: false
}
```

---

## Utilities

### NLUtils

**Location**: `resources/Core/NLUtils.qml`

Wrapper for C++ utility functions.

```qml
NLUtilsCPP {
    // Image conversion
    function imageURLToImageString(url): string { ... }
    
    // Key sequence formatting
    function keySequenceToString(keySequence): string { ... }
}
```

**See**: [API Reference: C++ Classes](../ApiReference/CppClasses.md)

---

## Repository Management

### QtQuickStream Integration

NodeLink uses QtQuickStream for serialization. All Core components inherit from `QSObject`:

```qml
// All core components inherit from QSObject
QSObject {
    property string _qsUuid: ""        // Unique identifier
    property QSRepository _qsRepo: null // Repository reference
    property QSObject _qsParent: null   // Parent object
}
```

### Repository Lifecycle

```qml
// 1. Create repository
NLCore.defaultRepo = NLCore.createDefaultRepo([
    "QtQuickStream",
    "NodeLink",
    "YourApp"
]);

// 2. Initialize root object
NLCore.defaultRepo.initRootObject("Scene");

// 3. Get scene
var scene = NLCore.defaultRepo.qsRootObject;

// 4. Save
NLCore.defaultRepo.saveToFile("scene.QQS.json");

// 5. Load
NLCore.defaultRepo.loadFromFile("scene.QQS.json");
```

**See**: [Serialization Format Documentation](../AdvancedTopics/Serialization.md)

---

## Factory Functions

### Creating Objects

All Core objects should be created using factory functions:

```qml
// ✅ Correct: Use factory functions
var node = NLCore.createNode();
var port = NLCore.createPort();
var link = NLCore.createLink();
var scene = NLCore.createScene();

// ❌ Incorrect: Don't create directly
var node = Qt.createQmlObject("Node {}", parent);  // Wrong!
```

### Why Factory Functions?

1. **Repository Assignment**: Automatically assigns `_qsRepo`
2. **Serialization**: Ensures objects are registered for serialization
3. **Type Safety**: Validates component types
4. **Consistency**: Ensures all objects follow same creation pattern

### Custom Node Creation

For custom nodes, use `QSSerializer.createQSObject`:

```qml
// Create custom node
var node = QSSerializer.createQSObject(
    "MyCustomNode",           // Component name
    ["NodeLink", "MyApp"],    // Imports
    scene._qsRepo             // Repository
);
node._qsRepo = scene._qsRepo;
node.type = 0;
```

---

## Core Library Usage

### Basic Setup

```qml
import QtQuick
import NodeLink
import QtQuickStream

ApplicationWindow {
    Component.onCompleted: {
        // 1. Initialize repository
        NLCore.defaultRepo = NLCore.createDefaultRepo([
            "QtQuickStream",
            "NodeLink"
        ]);
        
        // 2. Initialize scene
        NLCore.defaultRepo.initRootObject("Scene");
        var scene = NLCore.defaultRepo.qsRootObject;
        
        // 3. Setup registry
        scene.nodeRegistry = NLNodeRegistry {
            imports: ["NodeLink"]
            // ... register node types ...
        };
        
        // 4. Create nodes
        var node = NLCore.createNode();
        node.type = 0;
        node.title = "My Node";
        scene.addNode(node);
    }
}
```

### Working with Nodes

```qml
// Create node
var node = NLCore.createNode();
node.type = 0;
node.title = "Source";
node.guiConfig.position = Qt.vector2d(100, 100);
node.guiConfig.color = "#4A90E2";

// Add ports
var inputPort = NLCore.createPort();
inputPort.portType = NLSpec.PortType.Input;
inputPort.portSide = NLSpec.PortPositionSide.Left;
inputPort.title = "input";
node.addPort(inputPort);

var outputPort = NLCore.createPort();
outputPort.portType = NLSpec.PortType.Output;
outputPort.portSide = NLSpec.PortPositionSide.Right;
outputPort.title = "output";
node.addPort(outputPort);

// Add to scene
scene.addNode(node);
```

### Working with Links

```qml
// Create link between two ports
var link = scene.createLink(
    outputPort._qsUuid,  // From port
    inputPort._qsUuid    // To port
);

// Or manually
var link = NLCore.createLink();
link.inputPort = inputPort;
link.outputPort = outputPort;
link.guiConfig.color = "#FFFFFF";
scene.links[link._qsUuid] = link;
scene.linksChanged();
```

### Selection Management

```qml
// Select node
scene.selectionModel.selectNode(node);

// Check selection
if (scene.selectionModel.isSelected(node._qsUuid)) {
    console.log("Node is selected");
}

// Get selected nodes
var selectedNodes = Object.values(scene.selectionModel.selectedModel)
    .filter(obj => obj.objectType === NLSpec.ObjectType.Node);

// Clear selection
scene.selectionModel.clear();
```

---

## Best Practices

### 1. Always Use Factory Functions

```qml
// ✅ Good
var node = NLCore.createNode();

// ❌ Bad
var node = Qt.createQmlObject("Node {}", parent);
```

### 2. Set Repository

```qml
// ✅ Good
var node = NLCore.createNode();
node._qsRepo = scene._qsRepo;

// ❌ Bad
var node = NLCore.createNode();
// Missing _qsRepo assignment
```

### 3. Use Signals for Notifications

```qml
// ✅ Good: Listen to signals
Connections {
    target: scene
    function onNodeAdded(node) {
        console.log("Node added:", node.title);
    }
}

// ❌ Bad: Poll for changes
Timer {
    interval: 100
    onTriggered: {
        // Check if nodes changed
    }
}
```

### 4. Validate Operations

```qml
// ✅ Good: Check before linking
if (scene.canLinkNodes(portA, portB)) {
    scene.linkNodes(portA, portB);
} else {
    console.warn("Cannot link these ports");
}

// ❌ Bad: Link without validation
scene.linkNodes(portA, portB);  // May fail silently
```

### 5. Use Interfaces for Extensibility

```qml
// ✅ Good: Use interface
function processNode(node: I_Node) {
    if (node.objectType === NLSpec.ObjectType.Node) {
        // Handle node
    } else if (node.objectType === NLSpec.ObjectType.Container) {
        // Handle container
    }
}

// ❌ Bad: Check concrete type
function processNode(node) {
    if (node instanceof Node) {  // Not extensible
        // ...
    }
}
```
