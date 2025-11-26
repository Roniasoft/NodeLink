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