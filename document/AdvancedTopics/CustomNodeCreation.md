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
