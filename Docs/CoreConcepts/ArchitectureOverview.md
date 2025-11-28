# Architecture Overview

## MVC Pattern Explanation

NodeLink follows a **Model-View-Controller (MVC)** architecture pattern with some variations adapted for QML/Qt Quick. This document explains the architecture, separation of concerns, and how components interact.

---

## Architecture Overview

### High-Level Structure

```
┌─────────────────────────────────────────────────────────┐
│                    Application Layer                    │
│  (Your custom nodes, scenes, and application logic)     │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    View Layer (View)                    │
│  NLView → NodesScene → NodeView, LinkView, PortView     │
│  (Visual representation and user interaction)           │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│              Controller/Coordinator Layer               │
│  SceneSession, UndoCore, NLView                         │
│  (Coordinates between Model and View)                   │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    Model Layer (Core)                   │
│  Scene, Node, Link, Port, Container, SelectionModel     │
│  (Data models and business logic)                       │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  Persistence Layer                      │
│  QtQuickStream (QSRepository, QSSerializer)             │
│  (Serialization and storage)                            │
└─────────────────────────────────────────────────────────┘
```

### Directory Structure

```
resources/
├── Core/          # Model Layer
│   ├── Scene.qml
│   ├── Node.qml
│   ├── Link.qml
│   ├── Port.qml
│   ├── Container.qml
│   ├── SelectionModel.qml
│   └── ...
│
└── View/          # View Layer
    ├── NLView.qml
    ├── NodesScene.qml
    ├── NodeView.qml
    ├── LinkView.qml
    ├── PortView.qml
    ├── SceneSession.qml
    └── ...
```

---

## MVC Pattern in NodeLink

### Traditional MVC vs NodeLink MVC

**Traditional MVC**:
- **Model**: Data and business logic
- **View**: User interface
- **Controller**: Handles user input and updates Model/View

**NodeLink MVC**:
- **Model (Core)**: Data models, business logic, scene management
- **View (View)**: Visual components, rendering, user interaction
- **Controller/Coordinator**: SceneSession, UndoCore, NLView coordinate between Model and View

### Key Differences

1. **QML Property Binding**: Views automatically update when models change (declarative)
2. **Signal/Slot Communication**: Models emit signals, views react via Connections
3. **SceneSession**: Acts as a ViewModel/Controller hybrid managing view state
4. **Separation**: Clear separation between data (Core) and presentation (View)

---

## Model Layer (Core)

### Purpose

The Model layer contains all data structures, business logic, and scene management. Models are **data-only** and have no knowledge of how they're displayed.

### Core Components

#### Scene (`resources/Core/Scene.qml`)

The root model managing all nodes, links, and containers:

```qml
// resources/Core/Scene.qml
I_Scene {
    // Data properties
    property var nodes: ({})           // Map<UUID, Node>
    property var links: ({})           // Map<UUID, Link>
    property var containers: ({})      // Map<UUID, Container>
    
    // Business logic
    function addNode(node) { ... }
    function deleteNode(uuid) { ... }
    function linkNodes(portA, portB) { ... }
    function unlinkNodes(portA, portB) { ... }
    
    // Signals
    signal nodeAdded(Node node)
    signal nodeRemoved(Node node)
    signal linkAdded(Link link)
    signal linkRemoved(Link link)
}
```

**Responsibilities**:
- Manage collection of nodes, links, containers
- Provide business logic (add, delete, link, unlink)
- Emit signals when data changes
- No UI/rendering logic

#### Node (`resources/Core/Node.qml`)

Represents a single node in the graph:

```qml
// resources/Core/Node.qml
I_Node {
    // Data properties
    property string title: "<No Title>"
    property int type: 0
    property var ports: ({})           // Map<UUID, Port>
    property var children: ({})        // Map<UUID, Node>
    property var parents: ({})         // Map<UUID, Node>
    
    // Configuration
    property NodeGuiConfig guiConfig: NodeGuiConfig { ... }
    property I_NodeData nodeData: null
    
    // Business logic
    function addPort(port) { ... }
    function deletePort(port) { ... }
    
    // Signals
    signal portAdded(var portId)
    signal nodeCompleted()
}
```

**Responsibilities**:
- Store node data (title, type, ports)
- Manage parent/child relationships
- Provide node-specific logic
- No visual representation

#### Link (`resources/Core/Link.qml`)

Represents a connection between two ports:

```qml
// resources/Core/Link.qml
QSObject {
    // Data properties
    property Port inputPort: null
    property Port outputPort: null
    property var controlPoints: []
    property int direction: NLSpec.LinkDirection.LeftToRight
    
    // Configuration
    property LinkGUIConfig guiConfig: LinkGUIConfig { ... }
}
```

**Responsibilities**:
- Store connection data (ports, control points)
- Manage link properties
- No visual representation

#### Port (`resources/Core/Port.qml`)

Represents a connection point on a node:

```qml
// resources/Core/Port.qml
QSObject {
    // Data properties
    property Node node: null           // Parent node
    property int portType: NLSpec.PortType.Input
    property int portSide: NLSpec.PortPositionSide.Left
    property string title: ""
    property string color: "white"
    property bool enable: true
    
    // Computed position (set by view)
    property vector2d _position: Qt.vector2d(0, 0)
}
```

**Responsibilities**:
- Store port data (type, side, title)
- Reference parent node
- No visual representation

#### SelectionModel (`resources/Core/SelectionModel.qml`)

Manages selected objects:

```qml
// resources/Core/SelectionModel.qml
QtObject {
    // Data properties
    property var selectedModel: ({})   // Map<UUID, Object>
    property var existObjects: []      // All object UUIDs
    
    // Business logic
    function selectNode(node) { ... }
    function clear() { ... }
    function isSelected(uuid) { ... }
    
    // Signals
    signal selectedObjectChanged()
}
```

**Responsibilities**:
- Track selected nodes, links, containers
- Provide selection logic
- Emit signals when selection changes
- No visual representation

### Model Characteristics

1. **Data-Only**: Models contain no QML visual elements (Rectangle, Item, etc.)
2. **Business Logic**: Models contain functions for manipulating data
3. **Signals**: Models emit signals when data changes
4. **Serializable**: Models inherit from `QSObject` for serialization
5. **No View Dependencies**: Models don't import or reference View components

---

## View Layer (View)

### Purpose

The View layer contains all visual components that render the models. Views are **presentation-only** and react to model changes.

### View Components

#### NLView (`resources/View/NLView.qml`)

The main view component that coordinates the entire UI:

```qml
// resources/View/NLView.qml
Item {
    property Scene scene
    property SceneSession sceneSession: SceneSession {}
    
    // Main scene view
    Loader {
        sourceComponent: nodesScene
    }
    
    // Overview
    NodesOverview {
        scene: view.scene
        sceneSession: view.sceneSession
    }
    
    // Side menu
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
    }
}
```

**Responsibilities**:
- Compose main UI (scene, overview, menu)
- Coordinate between components
- Handle copy/paste operations

#### NodesScene (`resources/View/NodesScene.qml`)

The main canvas showing nodes and links:

```qml
// resources/View/NodesScene.qml
I_NodesScene {
    property Scene scene
    property SceneSession sceneSession
    
    // Background
    background: SceneViewBackground {}
    
    // Nodes and links container
    NodesRect {
        scene: flickable.scene
        sceneSession: flickable.sceneSession
    }
    
    // Handle keyboard events
    Keys.onDeletePressed: {
        scene.deleteSelectedObjects()
    }
}
```

**Responsibilities**:
- Provide scrollable canvas
- Handle keyboard input
- Manage zoom/pan
- Contain NodesRect for nodes/links

#### NodeView (`resources/View/NodeView.qml`)

Visual representation of a Node:

```qml
// resources/View/NodeView.qml
InteractiveNodeView {
    property var node              // Model reference
    property I_Scene scene
    property SceneSession sceneSession
    
    // Visual properties bound to model
    x: node.guiConfig.position.x
    y: node.guiConfig.position.y
    width: node.guiConfig.width
    height: node.guiConfig.height
    color: node.guiConfig.color
    
    // Selection state bound to model
    property bool isSelected: scene.selectionModel.isSelected(node._qsUuid)
    
    // User interaction
    MouseArea {
        onClicked: {
            scene.selectionModel.selectNode(node)
        }
        onPositionChanged: {
            // Update model position
            node.guiConfig.position.x += deltaX
            node.guiConfig.position.y += deltaY
        }
    }
}
```

**Responsibilities**:
- Render node visually (Rectangle, text, etc.)
- Handle user interaction (click, drag)
- Update model when user interacts
- React to model changes (property binding)

#### LinkView (`resources/View/LinkView.qml`)

Visual representation of a Link:

```qml
// resources/View/LinkView.qml
Canvas {
    property var link              // Model reference
    property I_Scene scene
    property SceneSession sceneSession
    
    // Visual properties bound to model
    property vector2d inputPos: link.inputPort._position
    property vector2d outputPos: link.outputPort._position
    property bool isSelected: scene.selectionModel.isSelected(link._qsUuid)
    
    // Paint link
    onPaint: {
        var context = getContext("2d")
        LinkPainter.createLink(context, inputPos, outputPos, ...)
    }
}
```

**Responsibilities**:
- Render link visually (Canvas, Bezier curves)
- React to model changes (port positions, selection)
- Handle link-specific rendering

#### PortView (`resources/View/PortView.qml`)

Visual representation of a Port:

```qml
// resources/View/PortView.qml
Rectangle {
    property Port port             // Model reference
    property var node              // Parent node view
    
    // Visual properties bound to model
    color: port.color
    visible: port.enable
    
    // Update model position
    Component.onCompleted: {
        port._position = Qt.vector2d(x, y)
    }
}
```

**Responsibilities**:
- Render port visually (circle, rectangle)
- Update model position when moved
- Handle port interaction (hover, click)

### View Characteristics

1. **Visual Only**: Views contain QML visual elements (Rectangle, Canvas, etc.)
2. **Property Binding**: Views bind to model properties for automatic updates
3. **User Interaction**: Views handle mouse/keyboard events
4. **Model Updates**: Views update models when user interacts
5. **Reactive**: Views automatically update when models change

---

## Controller/Coordinator Layer

### Purpose

The Controller/Coordinator layer bridges the Model and View layers, managing state, coordinating operations, and handling complex interactions.

### Controller Components

#### SceneSession (`resources/View/SceneSession.qml`)

Manages view state and coordinates between model and view:

```qml
// resources/View/SceneSession.qml
QtObject {
    // View state (not saved)
    property bool connectingMode: false
    property bool isShiftModifierPressed: false
    property bool isCtrlPressed: false
    property bool isRubberBandMoving: false
    property bool isSceneEditable: true
    
    // View configuration
    property ZoomManager zoomManager: ZoomManager {}
    property var portsVisibility: ({})
    property var linkColorOverrideMap: ({})
    
    // Signals
    signal sceneForceFocus
    signal marqueeSelectionStart(var mouse)
    signal updateMarqueeSelection(var mouse)
}
```

**Responsibilities**:
- Manage view state (selection mode, connecting mode, etc.)
- Coordinate zoom/pan operations
- Handle view-specific settings (port visibility, link colors)
- Provide signals for view coordination
- **Not serialized** (temporary state)

#### UndoCore (`resources/Core/Undo/UndoCore.qml`)

Manages undo/redo operations:

```qml
// resources/Core/Undo/UndoCore.qml
QtObject {
    property Scene scene
    property UndoStack undoStack: UndoStack {}
    
    // Observer pattern
    property UndoNodeObserver nodeObserver: UndoNodeObserver {}
    property UndoLinkObserver linkObserver: UndoLinkObserver {}
    property UndoSceneObserver sceneObserver: UndoSceneObserver {}
}
```

**Responsibilities**:
- Track model changes via observers
- Create commands for undo/redo
- Execute undo/redo operations
- Coordinate between model and view during undo/redo

#### NLView (`resources/View/NLView.qml`)

Main coordinator component:

```qml
// resources/View/NLView.qml
Item {
    property Scene scene
    property SceneSession sceneSession: SceneSession {}
    
    // Coordinate copy/paste
    function copyNodes() {
        // Copy from model
        var selectedNodes = Object.values(scene.selectionModel.selectedModel)
        // Store in NLCore
        NLCore._copiedNodes = selectedNodes
    }
    
    function pasteNodes() {
        // Create new nodes from copied data
        // Add to scene
        scene.addNodes(newNodes, false)
    }
}
```

**Responsibilities**:
- Coordinate between scene (model) and views
- Handle complex operations (copy/paste, clone)
- Manage component lifecycle
- Bridge model and view layers

### Controller Characteristics

1. **State Management**: Controllers manage view state and temporary data
2. **Coordination**: Controllers coordinate between models and views
3. **Complex Operations**: Controllers handle multi-step operations
4. **No Direct Rendering**: Controllers don't render UI directly
5. **Business Logic**: Controllers contain coordination logic

---

## Data Flow

### Model → View Flow

**Property Binding** (Automatic):

```qml
// View automatically updates when model changes
NodeView {
    x: node.guiConfig.position.x      // Bound to model
    y: node.guiConfig.position.y      // Bound to model
    color: node.guiConfig.color       // Bound to model
}
```

**Signal/Slot** (Reactive):

```qml
// View reacts to model signals
Connections {
    target: scene
    function onNodeAdded(node) {
        // Create view for new node
        createNodeView(node)
    }
}
```

### View → Model Flow

**Direct Property Updates**:

```qml
// View updates model when user interacts
MouseArea {
    onPositionChanged: {
        // Update model position
        node.guiConfig.position.x += deltaX
        node.guiConfig.position.y += deltaY
    }
}
```

**Function Calls**:

```qml
// View calls model functions
MouseArea {
    onClicked: {
        // Call model function
        scene.selectionModel.selectNode(node)
    }
}
```

### Controller Coordination

**SceneSession Coordinates State**:

```qml
// Controller manages view state
SceneSession {
    property bool connectingMode: false
}

// View reads controller state
NodeView {
    enabled: !sceneSession.connectingMode
}

// Model operation updates controller
Scene {
    function linkNodes(portA, portB) {
        // ... link logic ...
        sceneSession.connectingMode = false  // Update controller
    }
}
```

### Complete Data Flow Example

**User Drags Node**:

```
1. User drags NodeView (View)
   ↓
2. NodeView.MouseArea.onPositionChanged (View)
   ↓
3. node.guiConfig.position.x += deltaX (Model update)
   ↓
4. NodeView.x property binding updates (View auto-update)
   ↓
5. PortView positions update (View auto-update)
   ↓
6. LinkView repaints (View auto-update)
   ↓
7. UndoCore observer detects change (Controller)
   ↓
8. UndoCore creates command (Controller)
```

---

## Component Hierarchy

### Model Hierarchy

```
Scene (I_Scene)
├── Node (I_Node)
│   ├── Port
│   ├── NodeGuiConfig
│   └── I_NodeData
├── Link
│   ├── Port (inputPort)
│   ├── Port (outputPort)
│   └── LinkGUIConfig
├── Container
│   ├── Node (contained)
│   └── ContainerGuiConfig
├── SelectionModel
└── SceneGuiConfig
```

### View Hierarchy

```
NLView
├── NodesScene (I_NodesScene)
│   ├── NodesRect (I_NodesRect)
│   │   ├── NodeView (I_NodeView)
│   │   │   ├── PortView
│   │   │   └── ContentItem (custom)
│   │   ├── LinkView (I_LinkView)
│   │   └── ContainerView
│   └── SceneViewBackground
├── NodesOverview
└── SideMenu
```

### Controller Hierarchy

```
NLView (Coordinator)
├── SceneSession (View State)
│   └── ZoomManager
└── UndoCore (Undo/Redo)
    ├── UndoStack
    └── Observers
        ├── UndoNodeObserver
        ├── UndoLinkObserver
        └── UndoSceneObserver
```

---

## Separation of Concerns

### Model Layer Responsibilities

✅ **DO**:
- Store data (properties)
- Provide business logic (functions)
- Emit signals on changes
- Validate operations
- Manage relationships (parent/child)

❌ **DON'T**:
- Render UI
- Handle mouse/keyboard events
- Know about views
- Manage view state
- Import View components

### View Layer Responsibilities

✅ **DO**:
- Render visual representation
- Handle user interaction
- Update models on user action
- React to model changes
- Manage visual state

❌ **DON'T**:
- Store business data
- Contain business logic
- Know about other views
- Manage undo/redo directly
- Serialize data

### Controller Layer Responsibilities

✅ **DO**:
- Coordinate between model and view
- Manage view state
- Handle complex operations
- Track changes for undo/redo
- Provide coordination signals

❌ **DON'T**:
- Store business data (use Model)
- Render UI (use View)
- Contain business logic (use Model)
- Directly manipulate views

---

## Key Design Patterns

### 1. Observer Pattern

Models emit signals, views observe:

```qml
// Model emits signal
Scene {
    signal nodeAdded(Node node)
    
    function addNode(node) {
        nodes[node._qsUuid] = node
        nodeAdded(node)  // Emit signal
    }
}

// View observes
Connections {
    target: scene
    function onNodeAdded(node) {
        createNodeView(node)  // React
    }
}
```

### 2. Property Binding

Views automatically update when models change:

```qml
// View binds to model
NodeView {
    x: node.guiConfig.position.x  // Auto-updates
    y: node.guiConfig.position.y  // Auto-updates
}
```

### 3. Factory Pattern

NLCore provides factory functions:

```qml
// Factory creates models
var node = NLCore.createNode()
var port = NLCore.createPort()
var link = NLCore.createLink()
```

### 4. Command Pattern

Undo/Redo uses commands:

```qml
// Command encapsulates operation
AddNodeCommand {
    node: newNode
    scene: scene
    
    function execute() {
        scene.addNode(node)
    }
    
    function undo() {
        scene.deleteNode(node._qsUuid)
    }
}
```

### 5. Registry Pattern

NLNodeRegistry maps types to components:

```qml
// Registry maps type to component
NLNodeRegistry {
    nodeTypes: {
        0: "SourceNode",
        1: "AdditiveNode"
    }
    nodeView: "NodeView.qml"
    linkView: "LinkView.qml"
}
```

---

## Example: Adding a Node

### Step-by-Step Flow

1. **User Action** (View):
   ```qml
   SideMenu {
       Button {
           onClicked: {
               scene.createCustomizeNode(nodeType, x, y)
           }
       }
   }
   ```

2. **Model Operation** (Model):
   ```qml
   Scene {
       function createCustomizeNode(nodeType, xPos, yPos) {
           var node = NLCore.createNode()
           node.type = nodeType
           node.guiConfig.position = Qt.vector2d(xPos, yPos)
           addNode(node)  // Adds to model
       }
   }
   ```

3. **Model Signal** (Model):
   ```qml
   Scene {
       function addNode(node) {
           nodes[node._qsUuid] = node
           nodesChanged()        // Property change signal
           nodeAdded(node)       // Custom signal
       }
   }
   ```

4. **View Reaction** (View):
   ```qml
   I_NodesRect {
       Connections {
           target: scene
           function onNodeAdded(node) {
               // Create view for node
               var view = ObjectCreator.createItem(...)
               _nodeViewMap[node._qsUuid] = view
           }
       }
   }
   ```

5. **View Rendering** (View):
   ```qml
   NodeView {
       node: nodeModel  // Bound to model
       x: node.guiConfig.position.x  // Auto-updates
       y: node.guiConfig.position.y  // Auto-updates
   }
   ```

6. **Controller Tracking** (Controller):
   ```qml
   UndoCore {
       // Observer detects change
       UndoNodeObserver {
           onNodeAdded: {
               // Create command
               var command = AddNodeCommand { ... }
               undoStack.push(command)
           }
       }
   }
   ```

---

## Best Practices

### Model Layer

1. **Keep Models Pure**: No UI dependencies
2. **Emit Signals**: Notify views of changes
3. **Validate Operations**: Check conditions before modifying
4. **Use Interfaces**: I_Node, I_Scene for extensibility

### View Layer

1. **Bind to Models**: Use property binding for automatic updates
2. **React to Signals**: Use Connections for event handling
3. **Update Models**: Modify models when user interacts
4. **Keep Views Simple**: Delegate complex logic to controllers

### Controller Layer

1. **Coordinate, Don't Control**: Guide, don't dictate
2. **Manage State**: Keep view state in controllers
3. **Handle Complexity**: Complex operations belong in controllers
4. **Separate Concerns**: Don't mix model and view logic

---