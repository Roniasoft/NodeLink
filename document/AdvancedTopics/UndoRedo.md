# Undo/Redo System Documentation

## Overview

The Undo/Redo system in NodeLink is a comprehensive command-based architecture that allows users to undo and redo operations performed on the node graph. This system tracks all changes to nodes, links, containers, and their properties, providing a seamless way to revert or replay actions. The implementation uses the **Command Pattern** combined with **Observer Pattern** to automatically capture and record all modifications.

![Undo/Redo System Overview](images/undo-redo-overview.png) <!-- TODO: Insert overview diagram -->

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

