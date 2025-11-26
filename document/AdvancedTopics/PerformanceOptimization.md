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