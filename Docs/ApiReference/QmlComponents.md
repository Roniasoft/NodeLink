# API Reference

## Overview

This document provides a comprehensive reference for all QML components, properties, functions, and signals available in the NodeLink framework. Use this reference to understand the API structure and how to interact with NodeLink components programmatically.

---

## QML Components Reference

### Scene

**Location**: `resources/Core/Scene.qml`  
**Inherits**: `I_Scene`  
**Purpose**: The main scene component that manages all nodes, links, and containers in the visual programming environment.

#### Where to Use

**Scene** is used in the following contexts:

1. **Main Application Window** (`main.qml`):
   - Declare as a property in your main Window
   - Initialize with QtQuickStream repository
   - Connect to NLView for rendering

   ```qml
   // examples/simpleNodeLink/main.qml
   Window {
       property Scene scene: Scene { }
       
       Component.onCompleted: {
           NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "MyApp"])
           NLCore.defaultRepo.initRootObject("Scene");
           window.scene = Qt.binding(function() { 
               return NLCore.defaultRepo.qsRootObject;
           });
       }
   }
   ```

2. **Custom Scene Classes**:
   - Inherit from `Scene` or `I_Scene` for custom behavior
   - Override `createCustomizeNode()` for custom node creation
   - Override `linkNodes()` and `canLinkNodes()` for custom validation
   - Implement data flow logic (e.g., `updateData()`)

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   I_Scene {
       function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
           // Custom node creation logic
       }
       
       function updateData() {
           // Data flow calculation logic
       }
   }
   ```

3. **Event Handlers**:
   - Connect to signals (`nodeAdded`, `linkAdded`, etc.) for UI updates
   - Handle data flow when connections change
   - Manage undo/redo operations

   ```qml
   Connections {
       target: scene
       function onLinkAdded(link) {
           updateData();  // Recalculate data flow
       }
   }
   ```

4. **Node Management**:
   - Create, delete, and clone nodes programmatically
   - Manage node selection
   - Organize nodes with containers

**Use Cases**:
- **Calculator Example**: Manages mathematical operations and data flow
- **Logic Circuit Example**: Handles signal propagation through logic gates
- **VisionLink Example**: Manages image processing pipeline
- **Chatbot Example**: Manages conversation flow with regex matching
- **Simple NodeLink Example**: Basic node creation and connection management

#### Properties

##### `title: string`
Scene title/name.

**Default**: `"<Untitled>"`

**Example**:
```qml
scene.title = "My Calculator Scene"
```

##### `nodes: var`
Map of all nodes in the scene. Key is node UUID, value is Node object.

**Type**: `map<UUID, Node>`

**Example**:
```qml
// Iterate over all nodes
Object.values(scene.nodes).forEach(function(node) {
    console.log("Node:", node.title);
});

// Get node by UUID
var myNode = scene.nodes[nodeUuid];
```

##### `links: var`
Map of all links in the scene. Key is link UUID, value is Link object.

**Type**: `map<UUID, Link>`

**Example**:
```qml
// Iterate over all links
Object.values(scene.links).forEach(function(link) {
    console.log("Link from", link.inputPort.title, "to", link.outputPort.title);
});
```

##### `containers: var`
Map of all containers in the scene. Key is container UUID, value is Container object.

**Type**: `map<UUID, Container>`

**Example**:
```qml
// Get all containers
Object.values(scene.containers).forEach(function(container) {
    console.log("Container:", container.title);
});
```

##### `selectionModel: SelectionModel`
Selection model for managing selected objects in the scene.

**Example**:
```qml
// Select a node
scene.selectionModel.selectNode(node);

// Clear selection
scene.selectionModel.clear();

// Get selected objects
var selected = scene.selectionModel.selectedModel;
```

##### `nodeRegistry: NLNodeRegistry`
Registry containing all registered node types, names, icons, and colors.

**Example**:
```qml
// Access node registry
var nodeType = scene.nodeRegistry.nodeTypes[0];
var nodeName = scene.nodeRegistry.nodeNames[0];
```

##### `sceneGuiConfig: SceneGuiConfig`
GUI configuration for the scene (background, grid, etc.).

**Example**:
```qml
scene.sceneGuiConfig.backgroundColor = "#1e1e1e";
```

#### Signals

##### `nodeAdded(Node node)`
Emitted when a node is added to the scene.

**Example**:
```qml
Connections {
    target: scene
    function onNodeAdded(node) {
        console.log("Node added:", node.title);
    }
}
```

##### `nodesAdded(var nodes)`
Emitted when multiple nodes are added at once.

**Parameter**: Array of Node objects

##### `nodeRemoved(Node node)`
Emitted when a node is removed from the scene.

##### `linkAdded(Link link)`
Emitted when a link is created between two ports.

**Example**:
```qml
Connections {
    target: scene
    function onLinkAdded(link) {
        console.log("Link created from", link.inputPort.title, "to", link.outputPort.title);
        // Update node data
        updateData();
    }
}
```

##### `linksAdded(var links)`
Emitted when multiple links are added at once.

##### `linkRemoved(Link link)`
Emitted when a link is removed from the scene.

##### `containerAdded(Container container)`
Emitted when a container is added to the scene.

##### `containerRemoved(Container container)`
Emitted when a container is removed from the scene.

##### `copyCalled()`
Emitted when copy operation is triggered (e.g., Ctrl+C).

##### `pasteCalled()`
Emitted when paste operation is triggered (e.g., Ctrl+V).

#### Functions

##### `createCustomizeNode(nodeType: int, xPos: real, yPos: real): string`
Creates a new node of the specified type at the given position.

**Parameters**:
- `nodeType`: Integer identifier for the node type (must be registered in nodeRegistry)
- `xPos`: X coordinate in scene space
- `yPos`: Y coordinate in scene space

**Returns**: UUID string of the created node, or `null` if creation failed

**Example**:
```qml
// Create a Source node at position (100, 200)
var nodeUuid = scene.createCustomizeNode(CSpecs.NodeType.Source, 100, 200);
```

**Note**: This function should be overridden in custom Scene implementations to customize node creation logic.

##### `addNode(node: Node, autoSelect: bool): Node`
Adds an existing node to the scene.

**Parameters**:
- `node`: Node object to add
- `autoSelect`: If `true`, automatically selects the node after adding

**Returns**: The added Node object

**Example**:
```qml
var newNode = NLCore.createNode();
newNode.title = "My Node";
newNode.type = 0;
scene.addNode(newNode, true);  // Add and select
```

##### `addNodes(nodeArray: list<Node>, autoSelect: bool)`
Adds multiple nodes to the scene at once.

**Parameters**:
- `nodeArray`: Array of Node objects
- `autoSelect`: If `true`, selects the last added node

**Example**:
```qml
var nodes = [node1, node2, node3];
scene.addNodes(nodes, false);
```

##### `deleteNode(nodeUUId: string)`
Deletes a node from the scene by UUID.

**Parameters**:
- `nodeUUId`: UUID string of the node to delete

**Example**:
```qml
scene.deleteNode(node._qsUuid);
```

**Note**: This also removes all links connected to the node.

##### `deleteNodes(nodeUUIds: list<string>)`
Deletes multiple nodes from the scene.

**Parameters**:
- `nodeUUIds`: Array of node UUID strings

##### `createLink(portA: string, portB: string): Link`
Creates a link between two ports.

**Parameters**:
- `portA`: UUID of the output port (source)
- `portB`: UUID of the input port (destination)

**Returns**: Created Link object

**Example**:
```qml
// Get ports from nodes
var outputPort = sourceNode.findPortByPortSide(NLSpec.PortPositionSide.Right);
var inputPort = targetNode.findPortByPortSide(NLSpec.PortPositionSide.Left);

// Create link
var link = scene.createLink(outputPort._qsUuid, inputPort._qsUuid);
```

##### `linkNodes(portA: string, portB: string)`
Links two nodes via their ports with validation.

**Parameters**:
- `portA`: UUID of the output port (upstream)
- `portB`: UUID of the input port (downstream)

**Example**:
```qml
scene.linkNodes(outputPortUuid, inputPortUuid);
```

**Note**: This function validates the link using `canLinkNodes()` before creating it. Override this function in custom Scene implementations to add custom validation logic.

##### `canLinkNodes(portA: string, portB: string): bool`
Checks if two ports can be linked.

**Parameters**:
- `portA`: UUID of the first port
- `portB`: UUID of the second port

**Returns**: `true` if the ports can be linked, `false` otherwise

**Validation Rules**:
- Ports must exist
- PortA must be an output port (or InAndOut)
- PortB must be an input port (or InAndOut)
- Ports must belong to different nodes
- Link must not already exist
- Input port can only have one connection

**Example**:
```qml
if (scene.canLinkNodes(portA, portB)) {
    scene.linkNodes(portA, portB);
} else {
    console.error("Cannot link these ports");
}
```

##### `unlinkNodes(portA: string, portB: string)`
Removes a link between two ports.

**Parameters**:
- `portA`: UUID of the output port
- `portB`: UUID of the input port

**Example**:
```qml
scene.unlinkNodes(outputPortUuid, inputPortUuid);
```

##### `findNode(portId: string): Node`
Finds the node that contains the specified port.

**Parameters**:
- `portId`: UUID of the port

**Returns**: Node object, or `null` if not found

**Example**:
```qml
var node = scene.findNode(portUuid);
if (node) {
    console.log("Found node:", node.title);
}
```

##### `findNodeId(portId: string): string`
Finds the UUID of the node that contains the specified port.

**Parameters**:
- `portId`: UUID of the port

**Returns**: Node UUID string, or empty string if not found

##### `findNodeByItsId(nodeId: string): Node`
Finds a node by its UUID.

**Parameters**:
- `nodeId`: UUID of the node

**Returns**: Node object, or `undefined` if not found

**Example**:
```qml
var node = scene.findNodeByItsId(nodeUuid);
```

##### `findPort(portId: string): Port`
Finds a port object by its UUID.

**Parameters**:
- `portId`: UUID of the port

**Returns**: Port object, or `null` if not found

**Example**:
```qml
var port = scene.findPort(portUuid);
if (port) {
    console.log("Port title:", port.title);
}
```

##### `cloneNode(nodeUuid: string): Node`
Clones (duplicates) a node.

**Parameters**:
- `nodeUuid`: UUID of the node to clone

**Returns**: Cloned Node object

**Example**:
```qml
var clonedNode = scene.cloneNode(originalNode._qsUuid);
// Cloned node is positioned 50 pixels to the right and down
```

**Note**: The cloned node is automatically positioned 50 pixels offset from the original.

##### `createContainer(): Container`
Creates a new empty container.

**Returns**: New Container object

**Example**:
```qml
var container = scene.createContainer();
container.title = "My Container";
scene.addContainer(container);
```

##### `addContainer(container: Container): Container`
Adds a container to the scene.

**Parameters**:
- `container`: Container object to add

**Returns**: The added Container object

##### `deleteContainer(containerUUId: string)`
Deletes a container from the scene.

**Parameters**:
- `containerUUId`: UUID of the container to delete

##### `deleteSelectedObjects()`
Deletes all currently selected objects (nodes, links, containers).

**Example**:
```qml
// Select some objects
scene.selectionModel.selectNode(node1);
scene.selectionModel.selectNode(node2);

// Delete all selected
scene.deleteSelectedObjects();
```

##### `isSceneEmpty(): bool`
Checks if the scene is empty (no nodes, links, or containers).

**Returns**: `true` if scene is empty, `false` otherwise

**Example**:
```qml
if (scene.isSceneEmpty()) {
    console.log("Scene is empty");
}
```

##### `snappedPosition(position: vector2d): vector2d`
Calculates a snapped position based on grid spacing.

**Parameters**:
- `position`: Original position vector

**Returns**: Snapped position vector

**Example**:
```qml
var snapped = scene.snappedPosition(Qt.vector2d(123, 456));
// Returns position snapped to grid
```

##### `snapAllNodesToGrid()`
Snaps all nodes and containers to the grid.

**Example**:
```qml
scene.snapAllNodesToGrid();
```

##### `automaticNodeReorder(nodes: var, rootId: string, keepRootPosition: bool)`
Automatically reorders nodes based on their connections.

**Parameters**:
- `nodes`: Map of nodes to reorder (subset of scene.nodes)
- `rootId`: UUID of the root node (starting point)
- `keepRootPosition`: If `true`, keeps the root node at its current position

**Example**:
```qml
// Reorder selected nodes
var selectedNodes = {};
Object.keys(scene.selectionModel.selectedModel).forEach(function(uuid) {
    if (scene.nodes[uuid]) {
        selectedNodes[uuid] = scene.nodes[uuid];
    }
});

var rootId = Object.keys(selectedNodes)[0];
scene.automaticNodeReorder(selectedNodes, rootId, true);
```

##### `copyScene(): Scene`
Creates a copy of the entire scene with all nodes, links, and containers.

**Returns**: New Scene object with copied content

**Example**:
```qml
var copiedScene = scene.copyScene();
// Use copiedScene for paste operation
```

##### `findNodesInContainerItem(containerItem): var`
Finds all nodes and containers that are inside a container's bounds.

**Parameters**:
- `containerItem`: Container item with x, y, width, height properties

**Returns**: Array of Node and Container objects

**Example**:
```qml
var items = scene.findNodesInContainerItem({
    x: 100,
    y: 100,
    width: 300,
    height: 200
});
```

---

### Node

**Location**: `resources/Core/Node.qml`  
**Inherits**: `I_Node`  
**Purpose**: Represents a node in the visual programming scene. Nodes are the main building blocks that can be connected via ports.

#### Where to Use

**Node** is used in the following contexts:

1. **Custom Node Definitions** (`.qml` files):
   - Create custom node types by inheriting from `Node`
   - Define node-specific properties and behavior
   - Add ports in `Component.onCompleted`

   ```qml
   // examples/calculator/resources/Core/SourceNode.qml
   Node {
       type: CSpecs.NodeType.Source
       nodeData: I_NodeData {}
       
       Component.onCompleted: addPorts();
       
       function addPorts() {
           let port = NLCore.createPort();
           port.portType = NLSpec.PortType.Output;
           port.portSide = NLSpec.PortPositionSide.Right;
           addPort(port);
       }
   }
   ```

2. **Scene Node Management**:
   - Access nodes through `scene.nodes` map
   - Iterate over nodes for data processing
   - Find nodes by UUID or port

   ```qml
   // In Scene or custom logic
   Object.values(scene.nodes).forEach(function(node) {
       if (node.type === CSpecs.NodeType.Source) {
           // Process source nodes
       }
   });
   ```

3. **Data Flow Processing**:
   - Access node data through `node.nodeData`
   - Read from parent nodes via `node.parents`
   - Write to child nodes via `node.children`

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   function updateData() {
       Object.values(scene.nodes).forEach(function(node) {
           // Get data from parent nodes
           Object.values(node.parents).forEach(function(parent) {
               node.nodeData.input = parent.nodeData.data;
           });
           // Process node data
           node.calculate();
       });
   }
   ```

4. **Node Creation**:
   - Create nodes programmatically using `NLCore.createNode()`
   - Create nodes via scene's `createCustomizeNode()`
   - Clone existing nodes

   ```qml
   // Programmatic node creation
   var node = NLCore.createNode();
   node.type = 0;
   node.title = "My Node";
   scene.addNode(node, true);
   ```

**Use Cases**:
- **SourceNode** (Calculator): Provides input values
- **OperationNode** (Calculator): Performs mathematical operations
- **InputNode/OutputNode** (Logic Circuit): Handles signal input/output
- **ImageInputNode** (VisionLink): Loads and provides image data
- **RegexNode** (Chatbot): Matches patterns in text

#### Properties

##### `type: int`
Unique integer identifier for the node type. Must match a type registered in `nodeRegistry`.

**Example**:
```qml
Node {
    type: CSpecs.NodeType.Source  // 0
}
```

##### `title: string`
Display name of the node.

**Default**: `"<No Title>"`

**Example**:
```qml
node.title = "Source Node 1"
```

##### `guiConfig: NodeGuiConfig`
GUI configuration object containing visual properties (position, size, color, etc.).

**See**: [NodeGuiConfig](#nodeguiconfig)

**Example**:
```qml
node.guiConfig.position = Qt.vector2d(100, 200);
node.guiConfig.width = 200;
node.guiConfig.height = 150;
node.guiConfig.color = "#4A90E2";
```

##### `nodeData: I_NodeData`
Data storage object for the node. Can be `I_NodeData` or a custom subclass.

**See**: [NodeData](#nodedata)

**Example**:
```qml
node.nodeData = I_NodeData {}
node.nodeData.data = "some value"
```

##### `ports: var`
Map of all ports belonging to this node. Key is port UUID, value is Port object.

**Type**: `map<UUID, Port>`

**Example**:
```qml
// Iterate over ports
Object.values(node.ports).forEach(function(port) {
    console.log("Port:", port.title, "Type:", port.portType);
});

// Get port by UUID
var port = node.ports[portUuid];
```

##### `children: var`
Map of child nodes (nodes connected to this node's output ports). Key is node UUID, value is Node object.

**Type**: `map<UUID, Node>`

**Example**:
```qml
// Iterate over children
Object.values(node.children).forEach(function(child) {
    console.log("Child node:", child.title);
});
```

##### `parents: var`
Map of parent nodes (nodes connected to this node's input ports). Key is node UUID, value is Node object.

**Type**: `map<UUID, Node>`

**Example**:
```qml
// Check if node has parents
if (Object.keys(node.parents).length > 0) {
    console.log("Node has", Object.keys(node.parents).length, "parents");
}
```

##### `imagesModel: ImagesModel`
Model for managing node images/icons.

**Example**:
```qml
node.imagesModel.addImage("qrc:/icons/my-icon.png");
```

#### Signals

##### `portAdded(var portId)`
Emitted when a port is added to the node.

**Parameter**: UUID string of the added port

**Example**:
```qml
Connections {
    target: node
    function onPortAdded(portId) {
        console.log("Port added:", portId);
    }
}
```

##### `nodeCompleted()`
Emitted after the node's `Component.onCompleted` signal. Indicates that all node properties have been set.

**Example**:
```qml
Connections {
    target: node
    function onNodeCompleted() {
        console.log("Node setup complete:", node.title);
        // Perform initialization tasks
    }
}
```

##### `cloneFrom(baseNode: I_Node)`
Signal emitted when the node is being cloned. Handle this signal to customize cloning behavior.

**Example**:
```qml
Node {
    onCloneFrom: function(baseNode) {
        // Copy base properties (done automatically)
        title = baseNode.title;
        type = baseNode.type;
        
        // Custom cloning logic
        myCustomProperty = baseNode.myCustomProperty;
        
        // Reset node-specific data
        nodeData.data = null;
    }
}
```

#### Functions

##### `addPort(port: Port)`
Adds a port to the node.

**Parameters**:
- `port`: Port object to add

**Example**:
```qml
function addPorts() {
    let inputPort = NLCore.createPort();
    inputPort.portType = NLSpec.PortType.Input;
    inputPort.portSide = NLSpec.PortPositionSide.Left;
    inputPort.title = "Input";
    addPort(inputPort);
    
    let outputPort = NLCore.createPort();
    outputPort.portType = NLSpec.PortType.Output;
    outputPort.portSide = NLSpec.PortPositionSide.Right;
    outputPort.title = "Output";
    addPort(outputPort);
}
```

##### `deletePort(port: Port)`
Removes a port from the node.

**Parameters**:
- `port`: Port object to remove

**Example**:
```qml
var port = node.findPort(portUuid);
if (port) {
    node.deletePort(port);
}
```

##### `findPort(portId: string): Port`
Finds a port by its UUID.

**Parameters**:
- `portId`: UUID string of the port

**Returns**: Port object, or `null` if not found

**Example**:
```qml
var port = node.findPort(portUuid);
if (port) {
    console.log("Found port:", port.title);
}
```

##### `findPortByPortSide(portSide: int): Port`
Finds a port by its side position.

**Parameters**:
- `portSide`: Port side constant (see `NLSpec.PortPositionSide`)

**Returns**: Port object, or `null` if not found

**Example**:
```qml
// Find left input port
var inputPort = node.findPortByPortSide(NLSpec.PortPositionSide.Left);

// Find right output port
var outputPort = node.findPortByPortSide(NLSpec.PortPositionSide.Right);
```

---

### Port

**Location**: `resources/Core/Port.qml`  
**Inherits**: `QSObject`  
**Purpose**: Represents a connection point on a node. Ports allow nodes to send and receive data through links.

#### Where to Use

**Port** is used in the following contexts:

1. **Node Port Definition** (`addPorts()` function):
   - Create ports when node is initialized
   - Define port types (Input, Output, InAndOut)
   - Set port positions (Top, Bottom, Left, Right)
   - Configure port appearance (title, color)

   ```qml
   // examples/simpleNodeLink/NodeExample.qml
   Node {
       Component.onCompleted: addPorts();
       
       function addPorts() {
           let inputPort = NLCore.createPort();
           inputPort.portType = NLSpec.PortType.Input;
           inputPort.portSide = NLSpec.PortPositionSide.Left;
           inputPort.title = "Input";
           addPort(inputPort);
       }
   }
   ```

2. **Link Creation**:
   - Get ports from nodes to create links
   - Validate port compatibility before linking
   - Access port UUIDs for link creation

   ```qml
   // Create link between two ports
   var sourcePort = sourceNode.findPortByPortSide(NLSpec.PortPositionSide.Right);
   var targetPort = targetNode.findPortByPortSide(NLSpec.PortPositionSide.Left);
   scene.createLink(sourcePort._qsUuid, targetPort._qsUuid);
   ```

3. **Data Flow**:
   - Identify which ports are connected
   - Determine data flow direction
   - Access connected nodes through ports

   ```qml
   // Find connected nodes through ports
   Object.values(node.ports).forEach(function(port) {
       if (port.portType === NLSpec.PortType.Input) {
           // Find links connected to this input port
           var link = findLinkByInputPort(port._qsUuid);
           if (link) {
               var sourceNode = scene.findNode(link.inputPort._qsUuid);
               // Get data from source node
           }
       }
   });
   ```

4. **Port Validation**:
   - Check port types before linking
   - Validate port compatibility
   - Ensure proper data flow direction

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   function canLinkNodes(portA: string, portB: string): bool {
       var portAObj = findPort(portA);
       var portBObj = findPort(portB);
       
       // Input port cannot be source
       if (portAObj.portType === NLSpec.PortType.Input)
           return false;
       // Output port cannot be destination
       if (portBObj.portType === NLSpec.PortType.Output)
           return false;
       
       return true;
   }
   ```

**Use Cases**:
- **Input Ports**: Receive data from other nodes (e.g., OperationNode inputs)
- **Output Ports**: Send data to other nodes (e.g., SourceNode output)
- **Bidirectional Ports**: Can both send and receive (e.g., NodeExample ports)
- **Port Validation**: Ensure correct connections in calculator, logic circuit examples

#### Properties

##### `node: var`
Reference to the parent node that owns this port.

**Example**:
```qml
var parentNode = port.node;
console.log("Port belongs to:", parentNode.title);
```

##### `portType: int`
Type of the port (Input, Output, or InAndOut).

**Values**:
- `NLSpec.PortType.Input` (0): Can only receive connections
- `NLSpec.PortType.Output` (1): Can only send connections
- `NLSpec.PortType.InAndOut` (2): Can both send and receive

**Example**:
```qml
port.portType = NLSpec.PortType.Input;
```

##### `portSide: int`
Position of the port on the node (Top, Bottom, Left, Right).

**Values**:
- `NLSpec.PortPositionSide.Top` (0)
- `NLSpec.PortPositionSide.Bottom` (1)
- `NLSpec.PortPositionSide.Left` (2)
- `NLSpec.PortPositionSide.Right` (3)

**Example**:
```qml
port.portSide = NLSpec.PortPositionSide.Left;  // Left side
```

##### `title: string`
Display name of the port.

**Default**: `""`

**Example**:
```qml
port.title = "Input Value";
```

##### `color: string`
Color of the port (hex format).

**Default**: `"white"`

**Example**:
```qml
port.color = "#4A90E2";  // Blue
```

##### `enable: bool`
Whether the port is enabled (can be connected).

**Default**: `true`

**Example**:
```qml
port.enable = false;  // Disable port (grayed out)
```

##### `_position: vector2d`
Cached global position of the port in the UI. Set by the view layer.

**Default**: `Qt.vector2d(-1, -1)`

**Note**: This is an internal property used by the view for rendering. Do not set manually.

##### `_measuredTitleWidth: real`
Measured width of the port title for auto-sizing. Set by the view layer.

**Default**: `-1`

**Note**: Internal property used for layout calculations.

#### Usage Example

```qml
// Create and configure a port
function addPorts() {
    let inputPort = NLCore.createPort();
    inputPort.portType = NLSpec.PortType.Input;
    inputPort.portSide = NLSpec.PortPositionSide.Left;
    inputPort.title = "Input";
    inputPort.color = "#4A90E2";
    inputPort.enable = true;
    addPort(inputPort);
    
    let outputPort = NLCore.createPort();
    outputPort.portType = NLSpec.PortType.Output;
    outputPort.portSide = NLSpec.PortPositionSide.Right;
    outputPort.title = "Output";
    outputPort.color = "#7ED321";
    addPort(outputPort);
}
```

---

### Link

**Location**: `resources/Core/Link.qml`  
**Inherits**: `I_Node`  
**Purpose**: Represents a connection between two ports, allowing data to flow from one node to another.

#### Where to Use

**Link** is used in the following contexts:

1. **Link Creation** (via Scene):
   - Create links between nodes programmatically
   - Handle link creation in custom scenes
   - Validate links before creation

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   function linkNodes(portA: string, portB: string) {
       if (!canLinkNodes(portA, portB)) {
           return;
       }
       createLink(portA, portB);
   }
   ```

2. **Data Flow Processing**:
   - Iterate over links to process data flow
   - Access source and target nodes through links
   - Update node data based on connections

   ```qml
   // Process data through links
   Object.values(scene.links).forEach(function(link) {
       var sourceNode = scene.findNode(link.inputPort._qsUuid);
       var targetNode = scene.findNode(link.outputPort._qsUuid);
       
       // Transfer data from source to target
       targetNode.nodeData.input = sourceNode.nodeData.data;
   });
   ```

3. **Link Management**:
   - Remove links when nodes are deleted
   - Clone links when copying nodes
   - Validate link existence

   ```qml
   // Remove link
   scene.unlinkNodes(outputPortUuid, inputPortUuid);
   
   // Check if link exists
   var existingLink = Object.values(scene.links).find(function(link) {
       return link.inputPort._qsUuid === portA && 
              link.outputPort._qsUuid === portB;
   });
   ```

4. **Link Visualization**:
   - Configure link appearance (color, style, type)
   - Set link direction (unidirectional, bidirectional)
   - Customize link path (Bezier, L-shape, straight)

   ```qml
   // Configure link appearance
   link.guiConfig.color = "#4890e2";
   link.guiConfig.linkType = NLSpec.LinkType.Bezier;
   link.direction = NLSpec.LinkDirection.Unidirectional;
   ```

**Use Cases**:
- **Calculator Example**: Connects Source → Operation → Result nodes for data flow
- **Logic Circuit Example**: Connects logic gates for signal propagation
- **VisionLink Example**: Connects image processing nodes in pipeline
- **Chatbot Example**: Connects Regex nodes for pattern matching flow

#### Properties

##### `inputPort: Port`
The input port (destination) of the link. This is the port that receives data.

**Note**: Despite the name, `inputPort` in a Link actually refers to the **output port** (source) of the source node. This is a naming convention from the link's perspective.

**Example**:
```qml
var sourcePort = link.inputPort;  // Actually the output port of source node
console.log("Source port:", sourcePort.title);
```

##### `outputPort: Port`
The output port (source) of the link. This is the port that sends data.

**Note**: Despite the name, `outputPort` in a Link actually refers to the **input port** (destination) of the target node.

**Example**:
```qml
var targetPort = link.outputPort;  // Actually the input port of target node
console.log("Target port:", targetPort.title);
```

**Important**: The naming can be confusing. In practice:
- `link.inputPort` = source node's output port (where data comes from)
- `link.outputPort` = target node's input port (where data goes to)

##### `controlPoints: var`
Array of control points for the link's path (for Bezier curves, L-shapes, etc.).

**Type**: `array<vector2d>`

**Example**:
```qml
link.controlPoints = [
    Qt.vector2d(100, 100),
    Qt.vector2d(200, 150),
    Qt.vector2d(300, 100)
];
```

##### `direction: int`
Direction of the link (Unidirectional, Bidirectional, Nondirectional).

**Values**:
- `NLSpec.LinkDirection.Nondirectional` (0)
- `NLSpec.LinkDirection.Unidirectional` (1): One-way data flow (default)
- `NLSpec.LinkDirection.Bidirectional` (2): Two-way data flow

**Default**: `NLSpec.LinkDirection.Unidirectional`

**Example**:
```qml
link.direction = NLSpec.LinkDirection.Unidirectional;
```

##### `guiConfig: LinkGUIConfig`
GUI configuration for the link (color, style, width, etc.).

**Example**:
```qml
link.guiConfig.color = "#4890e2";
link.guiConfig.width = 2;
link.guiConfig.linkType = NLSpec.LinkType.Bezier;
```

#### Signals

##### `cloneFrom(baseLink: I_Node)`
Signal emitted when the link is being cloned.

**Example**:
```qml
Link {
    onCloneFrom: function(baseLink) {
        // Copy GUI config
        guiConfig.setProperties(baseLink.guiConfig);
    }
}
```

#### Usage Example

```qml
// Create a link between two ports
var link = scene.createLink(outputPortUuid, inputPortUuid);

// Configure link appearance
link.guiConfig.color = "#4890e2";
link.guiConfig.width = 2;
link.guiConfig.linkType = NLSpec.LinkType.Bezier;
link.direction = NLSpec.LinkDirection.Unidirectional;
```

---

### Container

**Location**: `resources/Core/Container.qml`  
**Inherits**: `I_Node`  
**Purpose**: A container that can group multiple nodes and containers together visually.

#### Where to Use

**Container** is used in the following contexts:

1. **Node Organization**:
   - Group related nodes together visually
   - Organize complex scenes into logical sections
   - Create hierarchical structures with nested containers

   ```qml
   // Create container for grouping nodes
   var container = scene.createContainer();
   container.title = "Math Operations";
   container.guiConfig.position = Qt.vector2d(100, 100);
   container.guiConfig.width = 500;
   container.guiConfig.height = 300;
   scene.addContainer(container);
   ```

2. **Scene Management**:
   - Add nodes to containers for organization
   - Find nodes within container bounds
   - Manage container hierarchy

   ```qml
   // Find nodes inside container
   var items = scene.findNodesInContainerItem({
       x: container.guiConfig.position.x,
       y: container.guiConfig.position.y,
       width: container.guiConfig.width,
       height: container.guiConfig.height
   });
   
   // Add nodes to container
   items.forEach(function(node) {
       container.addNode(node);
   });
   ```

3. **UI Organization**:
   - Visually group related functionality
   - Create collapsible sections
   - Organize large node graphs

   ```qml
   // examples/simpleNodeLink/main.qml
   // Container is registered as a node type
   nodeRegistry.nodeTypes[1] = "Container";
   nodeRegistry.nodeNames[1] = "Container";
   ```

4. **Nested Structures**:
   - Create containers inside containers
   - Build hierarchical organization
   - Manage complex scene structures

   ```qml
   // Add nested container
   var parentContainer = scene.createContainer();
   var childContainer = scene.createContainer();
   parentContainer.addContainerInside(childContainer);
   ```

**Use Cases**:
- **Simple NodeLink Example**: Basic container support for node grouping
- **Complex Scenes**: Organize large numbers of nodes into logical groups
- **Modular Design**: Group related functionality together
- **Visual Organization**: Improve scene readability and navigation

#### Properties

##### `title: string`
Display name of the container.

**Default**: `"Untitled"`

**Example**:
```qml
container.title = "My Container Group";
```

##### `nodes: var`
Map of nodes inside this container.

**Type**: `map<UUID, Node>`

**Example**:
```qml
// Add node to container
container.addNode(node);

// Iterate over nodes in container
Object.values(container.nodes).forEach(function(node) {
    console.log("Node in container:", node.title);
});
```

##### `containersInside: var`
Map of containers inside this container (nested containers).

**Type**: `map<UUID, Container>`

**Example**:
```qml
// Add nested container
container.addContainerInside(nestedContainer);
```

##### `guiConfig: ContainerGuiConfig`
GUI configuration for the container (position, size, color, etc.).

**Example**:
```qml
container.guiConfig.position = Qt.vector2d(100, 100);
container.guiConfig.width = 500;
container.guiConfig.height = 300;
container.guiConfig.color = "#2d2d2d";
```

#### Functions

##### `addNode(node: Node)`
Adds a node to the container.

**Parameters**:
- `node`: Node object to add

**Example**:
```qml
container.addNode(node);
```

##### `removeNode(node: Node)`
Removes a node from the container.

**Parameters**:
- `node`: Node object to remove

##### `addContainerInside(container: Container)`
Adds a nested container inside this container.

**Parameters**:
- `container`: Container object to add

##### `removeContainerInside(container: Container)`
Removes a nested container from this container.

#### Usage Example

```qml
// Create container
var container = scene.createContainer();
container.title = "Math Operations";
container.guiConfig.position = Qt.vector2d(100, 100);
container.guiConfig.width = 400;
container.guiConfig.height = 300;

// Add nodes to container
container.addNode(addNode);
container.addNode(multiplyNode);
container.addNode(subtractNode);

// Add to scene
scene.addContainer(container);
```

---

## Core Utilities

### NLCore

**Location**: `resources/Core/NLCore.qml`  
**Type**: Singleton (`pragma Singleton`)  
**Purpose**: Factory functions for creating NodeLink objects and managing the default repository.

#### Where to Use

**NLCore** is used in the following contexts:

1. **Object Creation** (Factory Functions):
   - Create nodes, ports, and links programmatically
   - Use in custom node definitions
   - Create objects for testing or batch operations

   ```qml
   // examples/calculator/resources/Core/SourceNode.qml
   function addPorts() {
       let port = NLCore.createPort();  // Create port
       port.portType = NLSpec.PortType.Output;
       addPort(port);
   }
   
   // examples/PerformanceAnalyzer - Batch node creation
   var startNode = NLCore.createNode();
   startNode.type = CSpecs.NodeType.StartNode;
   ```

2. **Repository Initialization** (`main.qml`):
   - Initialize QtQuickStream repository
   - Set up default repository for serialization
   - Configure repository with required imports

   ```qml
   // examples/simpleNodeLink/main.qml
   Component.onCompleted: {
       NLCore.defaultRepo = NLCore.createDefaultRepo([
           "QtQuickStream", 
           "NodeLink", 
           "SimpleNodeLink"
       ]);
       NLCore.defaultRepo.initRootObject("Scene");
   }
   ```

3. **Scene Creation**:
   - Create new scenes programmatically
   - Initialize scene objects
   - Set up scene hierarchy

   ```qml
   // Create scene
   var newScene = NLCore.createScene();
   newScene.title = "New Scene";
   ```

4. **Link Creation**:
   - Create links between ports
   - Programmatically connect nodes

   ```qml
   // Create link object
   var link = NLCore.createLink();
   link.inputPort = sourcePort;
   link.outputPort = targetPort;
   ```

**Use Cases**:
- **Node Definitions**: Create ports in `addPorts()` functions
- **Main Application**: Initialize repository in `Component.onCompleted`
- **Batch Operations**: Create multiple nodes/links programmatically
- **Testing**: Create test objects for unit testing
- **Performance Testing**: Create large numbers of nodes for benchmarks

#### Properties

##### `defaultRepo: QSRepo`
Default QtQuickStream repository used for serialization/deserialization.

**Example**:
```qml
// Initialize default repo
NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "MyApp"]);
NLCore.defaultRepo.initRootObject("Scene");
```

#### Functions

##### `createScene(): Scene`
Creates a new Scene object.

**Returns**: New Scene object

**Example**:
```qml
var scene = NLCore.createScene();
scene.title = "My Scene";
```

##### `createNode(): Node`
Creates a new Node object.

**Returns**: New Node object

**Example**:
```qml
var node = NLCore.createNode();
node.title = "My Node";
node.type = 0;
```

##### `createPort(qsRepo: QSRepo = null): Port`
Creates a new Port object.

**Parameters**:
- `qsRepo`: Optional repository. If not provided, uses `defaultRepo`

**Returns**: New Port object

**Example**:
```qml
var port = NLCore.createPort();
port.portType = NLSpec.PortType.Input;
port.portSide = NLSpec.PortPositionSide.Left;
port.title = "Input";
```

##### `createLink(): Link`
Creates a new Link object.

**Returns**: New Link object

**Example**:
```qml
var link = NLCore.createLink();
link.inputPort = sourcePort;
link.outputPort = targetPort;
```

---

### NLSpec

**Location**: `resources/Core/NLSpec.qml`  
**Type**: Singleton (`pragma Singleton`)  
**Purpose**: Contains enums and constants used throughout NodeLink.

#### Where to Use

**NLSpec** is used throughout NodeLink for type checking and configuration:

1. **Port Configuration**:
   - Set port types (Input, Output, InAndOut)
   - Set port positions (Top, Bottom, Left, Right)

   ```qml
   // examples/simpleNodeLink/NodeExample.qml
   port.portType = NLSpec.PortType.InAndOut;
   port.portSide = NLSpec.PortPositionSide.Left;
   ```

2. **Link Configuration**:
   - Set link types (Bezier, LLine, Straight)
   - Set link directions (Unidirectional, Bidirectional)
   - Set link styles (Solid, Dash, Dot)

   ```qml
   link.guiConfig.linkType = NLSpec.LinkType.Bezier;
   link.direction = NLSpec.LinkDirection.Unidirectional;
   link.guiConfig.linkStyle = NLSpec.LinkStyle.Solid;
   ```

3. **Object Type Checking**:
   - Identify object types (Node, Link, Container)
   - Filter objects by type
   - Validate object types

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   if (item.objectType === NLSpec.ObjectType.Node) {
       // Handle node
   } else if (item.objectType === NLSpec.ObjectType.Link) {
       // Handle link
   }
   ```

4. **Undo/Redo Control**:
   - Block observers during undo/redo operations
   - Prevent re-recording of changes

   ```qml
   // Block observers during undo
   NLSpec.undo.blockObservers = true;
   // Perform undo operation
   undoStack.undo();
   NLSpec.undo.blockObservers = false;
   ```

5. **Selection Tool Configuration**:
   - Configure selection behavior
   - Set selection tool types

   ```qml
   selectionTool.toolType = NLSpec.SelectionSpecificToolType.Node;
   ```

**Use Cases**:
- **All Node Definitions**: Port type and position configuration
- **Link Creation**: Link type and direction configuration
- **Scene Management**: Object type identification and filtering
- **Undo/Redo System**: Observer blocking during replay
- **Selection System**: Tool type configuration

#### Enums

##### `ObjectType`
Type of object in the scene.

- `Node` (0)
- `Link` (1)
- `Container` (2)
- `Unknown` (99)

**Example**:
```qml
if (item.objectType === NLSpec.ObjectType.Node) {
    console.log("This is a node");
}
```

##### `PortPositionSide`
Position of a port on a node.

- `Top` (0)
- `Bottom` (1)
- `Left` (2)
- `Right` (3)
- `Unknown` (99)

**Example**:
```qml
port.portSide = NLSpec.PortPositionSide.Left;
```

##### `PortType`
Type of port (data flow direction).

- `Input` (0): Can only receive connections
- `Output` (1): Can only send connections
- `InAndOut` (2): Can both send and receive

**Example**:
```qml
port.portType = NLSpec.PortType.Input;
```

##### `LinkType`
Visual style of the link.

- `Bezier` (0): Bezier curve
- `LLine` (1): L-shaped line with one control point
- `Straight` (2): Straight line
- `Unknown` (99)

**Example**:
```qml
link.guiConfig.linkType = NLSpec.LinkType.Bezier;
```

##### `LinkDirection`
Direction of data flow in the link.

- `Nondirectional` (0)
- `Unidirectional` (1): One-way (default)
- `Bidirectional` (2): Two-way

**Example**:
```qml
link.direction = NLSpec.LinkDirection.Unidirectional;
```

##### `LinkStyle`
Line style of the link.

- `Solid` (0)
- `Dash` (1)
- `Dot` (2)

**Example**:
```qml
link.guiConfig.linkStyle = NLSpec.LinkStyle.Dash;
```

##### `SelectionSpecificToolType`
Type of selection tool.

- `Node` (0): Select single node
- `Link` (1): Select single link
- `Any` (2): Select single object of any type
- `All` (3): Select multiple objects of any type
- `Unknown` (99)

#### Properties

##### `undo.blockObservers: bool`
Flag to block observers during undo/redo operations.

**Default**: `false`

**Example**:
```qml
// Block observers during undo
NLSpec.undo.blockObservers = true;
// Perform undo operation
NLSpec.undo.blockObservers = false;
```

---

## Supporting Components

### NodeGuiConfig

**Location**: `resources/Core/NodeGuiConfig.qml`  
**Purpose**: Stores GUI-related properties for nodes.

#### Where to Use

**NodeGuiConfig** is used in the following contexts:

1. **Node Definition** (Custom Node `.qml` files):
   - Set initial node size and position
   - Configure node appearance (color, opacity)
   - Enable/disable auto-sizing

   ```qml
   // examples/calculator/resources/Core/SourceNode.qml
   Node {
       guiConfig.width: 150
       guiConfig.height: 100
       guiConfig.color: "#4A90E2"
       guiConfig.autoSize: true
   }
   ```

2. **Node Creation** (Programmatic):
   - Set node position when creating
   - Configure appearance
   - Set locked state

   ```qml
   // examples/PerformanceAnalyzer
   var node = NLCore.createNode();
   node.guiConfig.position = Qt.vector2d(100, 200);
   node.guiConfig.width = 200;
   node.guiConfig.height = 150;
   node.guiConfig.color = "#444444";
   ```

3. **Node Manipulation**:
   - Move nodes programmatically
   - Resize nodes
   - Change appearance dynamically

   ```qml
   // Move node
   node.guiConfig.position = Qt.vector2d(newX, newY);
   
   // Resize node
   node.guiConfig.width = 300;
   node.guiConfig.height = 200;
   
   // Change color
   node.guiConfig.color = "#FF5733";
   ```

4. **Auto-Sizing Configuration**:
   - Enable automatic sizing based on content
   - Set minimum dimensions
   - Configure base content width

   ```qml
   // examples/calculator/resources/Core/OperationNode.qml
   guiConfig.autoSize: false
   guiConfig.minWidth: 150
   guiConfig.minHeight: 80
   guiConfig.baseContentWidth: 120
   ```

5. **Node Locking**:
   - Lock nodes to prevent movement
   - Protect important nodes from accidental changes

   ```qml
   // Lock node
   node.guiConfig.locked = true;
   ```

**Use Cases**:
- **All Custom Nodes**: Initial size and appearance configuration
- **Node Creation**: Position and appearance setup
- **Layout Management**: Programmatic node positioning
- **Auto-Sizing**: Dynamic node sizing based on content
- **Node Protection**: Locking critical nodes

#### Properties

##### `position: vector2d`
Position of the node in scene coordinates.

**Default**: `Qt.vector2d(0.0, 0.0)`

**Example**:
```qml
node.guiConfig.position = Qt.vector2d(100, 200);
```

##### `width: int`
Width of the node in pixels.

**Default**: `NLStyle.node.width`

**Example**:
```qml
node.guiConfig.width = 200;
```

##### `height: int`
Height of the node in pixels.

**Default**: `NLStyle.node.height`

**Example**:
```qml
node.guiConfig.height = 150;
```

##### `color: string`
Background color of the node (hex format).

**Default**: `NLStyle.node.color`

**Example**:
```qml
node.guiConfig.color = "#4A90E2";
```

##### `opacity: real`
Opacity of the node (0.0 to 1.0).

**Default**: `NLStyle.node.opacity`

**Example**:
```qml
node.guiConfig.opacity = 0.8;
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
Minimum width when auto-sizing.

**Default**: `120`

##### `minHeight: int`
Minimum height when auto-sizing.

**Default**: `80`

##### `baseContentWidth: int`
Base content width for auto-sizing calculations.

**Default**: `100`

##### `description: string`
Description text for the node.

**Default**: `"<No Description>"`

**Example**:
```qml
node.guiConfig.description = "This node performs addition";
```

##### `logoUrl: string`
URL or path to the node's icon/logo.

**Default**: `""`

**Example**:
```qml
node.guiConfig.logoUrl = "qrc:/icons/add-icon.png";
```

##### `colorIndex: int`
Index for color selection (used with color palettes).

**Default**: `-1`

---

### NodeData

**Location**: `resources/Core/NodeData.qml`  
**Inherits**: `I_NodeData`  
**Purpose**: Base class for storing node data.

#### Where to Use

**NodeData** is used in the following contexts:

1. **Node Definition** (Custom Node `.qml` files):
   - Assign nodeData to nodes
   - Use base `I_NodeData` or create custom subclasses
   - Store node-specific data

   ```qml
   // examples/calculator/resources/Core/SourceNode.qml
   Node {
       nodeData: I_NodeData {}
       
       property real value: 0.0
       onValueChanged: {
           nodeData.data = value;
       }
   }
   ```

2. **Custom NodeData Classes**:
   - Create type-safe data storage
   - Define specific properties for node types
   - Implement data validation

   ```qml
   // examples/calculator/resources/Core/OperationNodeData.qml
   I_NodeData {
       property var input1: null
       property var input2: null
       property var output: null
   }
   
   // Usage in OperationNode
   Node {
       nodeData: OperationNodeData {}
       
       function calculate() {
           if (nodeData.input1 && nodeData.input2) {
               nodeData.output = nodeData.input1 + nodeData.input2;
               nodeData.data = nodeData.output;
           }
       }
   }
   ```

3. **Data Flow Processing** (Scene):
   - Read data from source nodes
   - Write data to target nodes
   - Process data through node graph

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   function updateData() {
       Object.values(scene.nodes).forEach(function(node) {
           // Get input from connected nodes
           Object.values(node.parents).forEach(function(parent) {
               node.nodeData.input = parent.nodeData.data;
           });
           // Process node
           if (node.calculate) {
               node.calculate();
           }
       });
   }
   ```

4. **Data Storage**:
   - Store calculation results
   - Store input values
   - Store intermediate processing data

   ```qml
   // Store data
   node.nodeData.data = "result";
   
   // Store complex objects
   node.nodeData.data = {
       value: 100,
       timestamp: Date.now()
   };
   ```

**Use Cases**:
- **Calculator Example**: Store numeric values and calculation results
- **Logic Circuit Example**: Store boolean signal states
- **VisionLink Example**: Store image data and processing results
- **Chatbot Example**: Store text data and pattern matching results
- **All Custom Nodes**: Store node-specific data and state

#### Properties

##### `data: var`
Generic data storage property. Can hold any type of data.

**Default**: `null`

**Example**:
```qml
// Store simple value
node.nodeData.data = 42;

// Store object
node.nodeData.data = {
    value: 100,
    name: "test"
};

// Store array
node.nodeData.data = [1, 2, 3];
```

#### Custom NodeData

You can create custom NodeData classes for type-safe data handling:

```qml
// MyNodeData.qml
import QtQuick
import NodeLink

I_NodeData {
    property var input1: null
    property var input2: null
    property var output: null
    property int operation: 0
}

// Usage in Node
Node {
    nodeData: MyNodeData {}
    
    function calculate() {
        if (nodeData.input1 && nodeData.input2) {
            nodeData.output = nodeData.input1 + nodeData.input2;
            nodeData.data = nodeData.output;
        }
    }
}
```

---

### NLNodeRegistry

**Location**: `resources/Core/NLNodeRegistry.qml`  
**Purpose**: Registry for managing all available node types in the application.

#### Where to Use

**NLNodeRegistry** is used in the following contexts:

1. **Main Application Initialization** (`main.qml`):
   - Declare as a property in main Window
   - Register all node types in `Component.onCompleted`
   - Assign to scene after initialization

   ```qml
   // examples/simpleNodeLink/main.qml
   Window {
       property NLNodeRegistry nodeRegistry: NLNodeRegistry {
           _qsRepo: NLCore.defaultRepo
           imports: ["SimpleNodeLink", "NodeLink"]
           defaultNode: 0
       }
       
       Component.onCompleted: {
           // Register node types
           nodeRegistry.nodeTypes[0] = "NodeExample";
           nodeRegistry.nodeNames[0] = "NodeExample";
           nodeRegistry.nodeIcons[0] = "\ue4e2";
           nodeRegistry.nodeColors[0] = "#444";
           
           // Assign to scene
           scene.nodeRegistry = nodeRegistry;
       }
   }
   ```

2. **Custom Scene Classes**:
   - Define registry as part of scene
   - Register node types specific to the scene
   - Configure default node type

   ```qml
   // examples/calculator/resources/Core/CalculatorScene.qml
   I_Scene {
       nodeRegistry: NLNodeRegistry {
           _qsRepo: scene._qsRepo
           imports: ["Calculator"]
           defaultNode: CSpecs.NodeType.Source
           
           nodeTypes: [
               CSpecs.NodeType.Source = "SourceNode",
               CSpecs.NodeType.Operation = "OperationNode"
           ];
           // ... nodeNames, nodeIcons, nodeColors
       }
   }
   ```

3. **Node Creation**:
   - Scene uses registry to create nodes
   - Registry maps node type IDs to QML component names
   - Registry provides metadata (name, icon, color)

   ```qml
   // Scene uses registry to create nodes
   function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
       var qsType = nodeRegistry.nodeTypes[nodeType];  // Get component name
       var nodeColor = nodeRegistry.nodeColors[nodeType];  // Get color
       // Create node using registry information
   }
   ```

4. **UI Display**:
   - Side menu uses registry to show available node types
   - Context menu uses registry for node creation
   - Node palette displays registered nodes

   ```qml
   // Side menu iterates over registry
   Object.keys(nodeRegistry.nodeTypes).forEach(function(typeId) {
       var nodeName = nodeRegistry.nodeNames[typeId];
       var nodeIcon = nodeRegistry.nodeIcons[typeId];
       // Display in menu
   });
   ```

**Use Cases**:
- **All Examples**: Register node types in main.qml or custom Scene
- **Calculator Example**: Registers Source, Operation, Result nodes
- **Logic Circuit Example**: Registers Input, AND, OR, NOT, Output nodes
- **VisionLink Example**: Registers ImageInput, Blur, Brightness, Contrast, ImageResult nodes
- **Chatbot Example**: Registers Source, Regex, ResultTrue, ResultFalse nodes
- **Simple NodeLink Example**: Registers NodeExample and Container

#### Properties

##### `imports: var`
Array of QML module imports required to create nodes.

**Type**: `array<string>`

**Example**:
```qml
nodeRegistry.imports = ["MyApp", "NodeLink"];
```

##### `nodeTypes: var`
Map of node type IDs to QML component names.

**Type**: `map<int, string>`

**Example**:
```qml
nodeRegistry.nodeTypes[0] = "SourceNode";
nodeRegistry.nodeTypes[1] = "OperationNode";
```

##### `nodeNames: var`
Map of node type IDs to display names.

**Type**: `map<int, string>`

**Example**:
```qml
nodeRegistry.nodeNames[0] = "Source";
nodeRegistry.nodeNames[1] = "Operation";
```

##### `nodeIcons: var`
Map of node type IDs to icon characters (Font Awesome Unicode).

**Type**: `map<int, string>`

**Example**:
```qml
nodeRegistry.nodeIcons[0] = "\uf1c0";  // Font Awesome file icon
nodeRegistry.nodeIcons[1] = "\uf0ad";  // Font Awesome cog icon
```

##### `nodeColors: var`
Map of node type IDs to color strings (hex format).

**Type**: `map<int, string>`

**Example**:
```qml
nodeRegistry.nodeColors[0] = "#4A90E2";  // Blue
nodeRegistry.nodeColors[1] = "#F5A623";  // Orange
```

##### `defaultNode: int`
Default node type to create when no type is specified.

**Default**: `0`

**Example**:
```qml
nodeRegistry.defaultNode = CSpecs.NodeType.Source;
```

##### `nodeView: string`
Path to custom node view component (optional).

**Default**: `"NodeView.qml"`

##### `linkView: string`
Path to custom link view component (optional).

**Default**: `"LinkView.qml"`

##### `containerView: string`
Path to custom container view component (optional).

**Default**: `"ContainerView.qml"`

#### Usage Example

```qml
property NLNodeRegistry nodeRegistry: NLNodeRegistry {
    _qsRepo: NLCore.defaultRepo
    imports: ["MyApp", "NodeLink"]
    defaultNode: 0
}

Component.onCompleted: {
    // Register Source Node
    nodeRegistry.nodeTypes[0] = "SourceNode";
    nodeRegistry.nodeNames[0] = "Source";
    nodeRegistry.nodeIcons[0] = "\uf1c0";
    nodeRegistry.nodeColors[0] = "#4A90E2";
    
    // Register Operation Node
    nodeRegistry.nodeTypes[1] = "OperationNode";
    nodeRegistry.nodeNames[1] = "Operation";
    nodeRegistry.nodeIcons[1] = "\uf0ad";
    nodeRegistry.nodeColors[1] = "#F5A623";
    
    // Assign to scene
    scene.nodeRegistry = nodeRegistry;
}
```

---

## Common Usage Patterns

### Creating and Adding a Node

```qml
// 1. Create node
var node = NLCore.createNode();
node.title = "My Node";
node.type = 0;
node.guiConfig.position = Qt.vector2d(100, 200);
node.guiConfig.width = 200;
node.guiConfig.height = 150;
node.guiConfig.color = "#4A90E2";

// 2. Add ports
let inputPort = NLCore.createPort();
inputPort.portType = NLSpec.PortType.Input;
inputPort.portSide = NLSpec.PortPositionSide.Left;
inputPort.title = "Input";
node.addPort(inputPort);

let outputPort = NLCore.createPort();
outputPort.portType = NLSpec.PortType.Output;
outputPort.portSide = NLSpec.PortPositionSide.Right;
outputPort.title = "Output";
node.addPort(outputPort);

// 3. Add to scene
scene.addNode(node, true);  // true = auto-select
```

### Creating a Link Between Nodes

```qml
// Get ports
var sourceNode = scene.nodes[sourceNodeUuid];
var targetNode = scene.nodes[targetNodeUuid];

var outputPort = sourceNode.findPortByPortSide(NLSpec.PortPositionSide.Right);
var inputPort = targetNode.findPortByPortSide(NLSpec.PortPositionSide.Left);

// Validate and create link
if (scene.canLinkNodes(outputPort._qsUuid, inputPort._qsUuid)) {
    scene.linkNodes(outputPort._qsUuid, inputPort._qsUuid);
}
```

### Iterating Over Scene Objects

```qml
// Iterate over all nodes
Object.values(scene.nodes).forEach(function(node) {
    console.log("Node:", node.title, "Type:", node.type);
    
    // Iterate over node's ports
    Object.values(node.ports).forEach(function(port) {
        console.log("  Port:", port.title, "Type:", port.portType);
    });
    
    // Check children
    if (Object.keys(node.children).length > 0) {
        console.log("  Has", Object.keys(node.children).length, "children");
    }
});

// Iterate over all links
Object.values(scene.links).forEach(function(link) {
    var sourceNode = scene.findNode(link.inputPort._qsUuid);
    var targetNode = scene.findNode(link.outputPort._qsUuid);
    console.log("Link:", sourceNode.title, "->", targetNode.title);
});
```

### Handling Scene Events

```qml
Connections {
    target: scene
    
    function onNodeAdded(node) {
        console.log("Node added:", node.title);
        // Update UI, validate, etc.
    }
    
    function onLinkAdded(link) {
        console.log("Link created");
        // Update data flow, recalculate, etc.
        updateData();
    }
    
    function onNodeRemoved(node) {
        console.log("Node removed:", node.title);
        // Cleanup, update UI, etc.
    }
}
```

---

## Type Definitions

### UUID
String identifier used throughout NodeLink for uniquely identifying objects.

**Format**: Generated by QtQuickStream (QSObject)

**Example**: `"550e8400-e29b-41d4-a716-446655440000"`

### vector2d
Qt vector2d type representing 2D coordinates.

**Example**: `Qt.vector2d(100, 200)`

---

## Notes

1. **UUIDs**: All objects in NodeLink have a `_qsUuid` property (from QtQuickStream) that uniquely identifies them.

2. **Repository**: NodeLink uses QtQuickStream for serialization. Objects must be created with a repository (`_qsRepo`) to be serializable.

3. **Signals**: Most operations emit signals that can be connected to for UI updates and data flow management.

4. **Undo/Redo**: NodeLink has built-in undo/redo support. Operations are automatically recorded when not in replay mode.

5. **Thread Safety**: NodeLink components are not thread-safe. All operations should be performed on the main UI thread.

---


