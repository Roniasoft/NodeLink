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

---
# Examples

## Calculator Example

### Overview

The Calculator Example is a visual node-based calculator application built with NodeLink and Qt Quick. It demonstrates how to create a functional node graph system where users can connect different types of nodes to perform mathematical calculations. This example serves as an excellent introduction to building custom node-based applications using the NodeLink framework.

![Calculator Example Overview](images/frame1.png)

![Calculator Example in Action](images/frame2.png)

---

### a. Purpose and Use Cases

#### Purpose

The Calculator Example demonstrates:

1. **Node-Based Data Flow**: Shows how data flows through a network of connected nodes, where each node performs a specific operation or holds a value.

2. **Custom Node Types**: Illustrates how to define and implement custom node types with specific behaviors, ports, and data handling.

3. **Real-Time Updates**: Demonstrates automatic data propagation through the node graph when connections are made, modified, or removed.

4. **Visual Programming**: Provides a visual interface for building mathematical expressions without writing code.

5. **Scene Management**: Shows how to manage a scene with multiple nodes, links, and their relationships.

#### Use Cases

- **Educational Tool**: Learn how to build node-based applications with NodeLink
- **Prototyping**: Quickly prototype mathematical workflows or data processing pipelines
- **Visual Expression Builder**: Create complex mathematical expressions visually
- **Framework Demonstration**: Showcase NodeLink capabilities to potential users or developers
- **Custom Application Foundation**: Use as a starting point for building more complex node-based applications

#### Example Scenarios

- **Simple Calculations**: Connect Source nodes to operation nodes to perform basic arithmetic
- **Complex Expressions**: Build multi-step calculations like `(a + b) * (c - d) / e`
- **Data Flow Visualization**: Understand how data propagates through a node network
- **Interactive Learning**: Experiment with different node connections and observe results in real-time

---

### b. Node Types Explained

The Calculator Example implements six distinct node types, each serving a specific role in the calculation pipeline.

#### 1. Source Node (`SourceNode`)

**Purpose**: Provides input values for calculations.

**Type ID**: `CSpecs.NodeType.Source` (0)

**Properties**:
- Contains a single output port named "value"
- Users can directly edit the numeric value in the node
- Acts as the starting point for data flow

**Ports**:
- **Output Port**: "value" (Right side) - Emits the numeric value entered by the user

**Usage**: 
- Place Source nodes to input numbers into your calculation
- Connect the output port to operation nodes or Result nodes
- Edit the value by clicking on the node and typing a number

**Example**: A Source node with value `5` outputs `5` through its output port.

---

#### 2. Additive Node (`AdditiveNode`)

**Purpose**: Performs addition of two input values.

**Type ID**: `CSpecs.NodeType.Additive` (1)

**Properties**:
- Inherits from `OperationNode`
- Has two input ports and one output port
- Performs: `output = input1 + input2`

**Ports**:
- **Input Port 1**: "input 1" (Left side)
- **Input Port 2**: "input 2" (Left side)
- **Output Port**: "value" (Right side) - Emits the sum of the two inputs

**Behavior**:
- Waits for both inputs to be connected and have valid data
- Automatically calculates the result when both inputs are available
- Outputs `null` if either input is missing

**Example**: 
- Input 1: `3`, Input 2: `7` → Output: `10`

---

#### 3. Multiplier Node (`MultiplierNode`)

**Purpose**: Performs multiplication of two input values.

**Type ID**: `CSpecs.NodeType.Multiplier` (2)

**Properties**:
- Inherits from `OperationNode`
- Has two input ports and one output port
- Performs: `output = input1 * input2`

**Ports**:
- **Input Port 1**: "input 1" (Left side)
- **Input Port 2**: "input 2" (Left side)
- **Output Port**: "value" (Right side) - Emits the product of the two inputs

**Behavior**:
- Requires both inputs to be connected and have valid data
- Calculates result automatically when both inputs are available

**Example**:
- Input 1: `4`, Input 2: `6` → Output: `24`

---

#### 4. Subtraction Node (`SubtractionNode`)

**Purpose**: Performs subtraction of two input values.

**Type ID**: `CSpecs.NodeType.Subtraction` (3)

**Properties**:
- Inherits from `OperationNode`
- Has two input ports and one output port
- Performs: `output = input1 - input2`

**Ports**:
- **Input Port 1**: "input 1" (Left side)
- **Input Port 2**: "input 2" (Left side)
- **Output Port**: "value" (Right side) - Emits the difference of the two inputs

**Behavior**:
- Subtracts the second input from the first input
- Requires both inputs to be connected

**Example**:
- Input 1: `10`, Input 2: `3` → Output: `7`

---

#### 5. Division Node (`DivisionNode`)

**Purpose**: Performs division of two input values.

**Type ID**: `CSpecs.NodeType.Division` (4)

**Properties**:
- Inherits from `OperationNode`
- Has two input ports and one output port
- Performs: `output = input1 / input2`

**Ports**:
- **Input Port 1**: "input 1" (Left side)
- **Input Port 2**: "input 2" (Left side)
- **Output Port**: "value" (Right side) - Emits the quotient of the two inputs

**Behavior**:
- Divides the first input by the second input
- Handles division by zero: outputs `"undefined (Divide by zero)"` if the second input is `0`
- Requires both inputs to be connected

**Example**:
- Input 1: `20`, Input 2: `4` → Output: `5`
- Input 1: `10`, Input 2: `0` → Output: `"undefined (Divide by zero)"`

---

#### 6. Result Node (`ResultNode`)

**Purpose**: Displays the final result of a calculation.

**Type ID**: `CSpecs.NodeType.Result` (5)

**Properties**:
- Contains a single input port
- Displays the value received from connected nodes
- Read-only (cannot be edited directly)

**Ports**:
- **Input Port**: "value" (Left side) - Receives the calculated result

**Behavior**:
- Displays whatever value is connected to its input port
- Updates automatically when the input value changes
- Resets to `null` when cloned or when the input connection is removed

**Usage**:
- Connect the output of any node (Source or Operation) to a Result node to view the final value
- Useful for displaying intermediate or final results in complex calculations

**Example**: 
- Connect a Source node with value `42` → Result displays `42`
- Connect an Additive node output → Result displays the sum

---

#### Node Type Summary Table

| Node Type | Type ID | Input Ports | Output Ports | Operation |
|-----------|---------|-------------|--------------|-----------|
| Source | 0 | 0 | 1 | Provides input value |
| Additive | 1 | 2 | 1 | Addition (+) |
| Multiplier | 2 | 2 | 1 | Multiplication (×) |
| Subtraction | 3 | 2 | 1 | Subtraction (-) |
| Division | 4 | 2 | 1 | Division (/) |
| Result | 5 | 1 | 0 | Displays result |

---

### c. Step-by-Step Building Guide

This guide will walk you through building the Calculator Example from scratch, explaining each component and how they work together.

#### Prerequisites

- Qt 6.2.4 or later (Qt 6.10.0 recommended)
- CMake 3.1.0 or later
- C++ compiler with C++14 support (MSVC 2019/2022 on Windows)
- NodeLink framework built and installed
- QtQuickStream module built and installed

#### Step 1: Project Setup

##### 1.1 Create Project Structure

Create the following directory structure:

```
calculator/
├── CMakeLists.txt
├── main.cpp
├── main.qml
└── resources/
    ├── Core/
    └── View/
    └── fonts/
```

##### 1.2 Configure CMakeLists.txt

Create `CMakeLists.txt` with the following configuration:

```cmake
cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Create executable
qt_add_executable(Calculator main.cpp)

# Set CSpecs as singleton
set_source_files_properties(
    resources/Core/CSpecs.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# Define QML module
qt_add_qml_module(Calculator
    URI "Calculator"
    VERSION 1.0
    QML_FILES
        main.qml
        resources/Core/CSpecs.qml
        resources/Core/SourceNode.qml
        resources/Core/OperationNode.qml
        resources/Core/ResultNode.qml
        resources/Core/AdditiveNode.qml
        resources/Core/MultiplierNode.qml
        resources/Core/SubtractionNode.qml
        resources/Core/DivisionNode.qml
        resources/Core/CalculatorScene.qml
        resources/Core/OperationNodeData.qml
        resources/View/CalculatorView.qml
        resources/View/CalculatorNodeView.qml
    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
)

target_include_directories(Calculator PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_link_libraries(Calculator PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
```

**Key Points**:
- Links to `NodeLinkplugin` and `QtQuickStreamplugin`
- Sets `CSpecs.qml` as a singleton for global access
- Includes Font Awesome fonts for icons

---

#### Step 2: Create Specifications (CSpecs.qml)

Create `resources/Core/CSpecs.qml` - a singleton that defines node type constants:

```qml
pragma Singleton

import QtQuick

QtObject {
    enum NodeType {
        Source      = 0,
        Additive    = 1,
        Multiplier  = 2,
        Subtraction = 3,
        Division    = 4,
        Result      = 5,
        Operation   = 6,
        Unknown     = 99
    }

    enum OperationType {
        Additive     = 0,
        Multiplier   = 1,
        Subtraction  = 2,
        Division     = 3,
        Unknown = 99
    }
}
```

**Purpose**: Provides type-safe constants for node types used throughout the application.

---

#### Step 3: Create Node Data Models

##### 3.1 OperationNodeData.qml

Create `resources/Core/OperationNodeData.qml` - data model for operation nodes:

```qml
import QtQuick
import NodeLink

I_NodeData {
    property var inputFirst:  null
    property var inputSecond: null
}
```

**Purpose**: Extends `I_NodeData` to store two input values for binary operations.

---

#### Step 4: Create Base Node Types

##### 4.1 SourceNode.qml

Create `resources/Core/SourceNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.Source
    nodeData: I_NodeData {}
    
    guiConfig.autoSize: true
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right
        _port1.title    = "value";
        addPort(_port1);
    }
}
```

**Key Features**:
- Single output port on the right side
- Auto-sized node with fixed dimensions
- Users can edit the value directly in the node view

---

##### 4.2 OperationNode.qml (Base Class)

Create `resources/Core/OperationNode.qml` - base class for all operation nodes:

```qml
import QtQuick
import NodeLink

Node {
    property int operationType: CSpecs.OperationType.Additive
    
    type: CSpecs.NodeType.Operation
    nodeData: OperationNodeData {}
    
    guiConfig.autoSize: false
    guiConfig.minWidth: 150
    guiConfig.minHeight: 80
    guiConfig.baseContentWidth: 120

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "input 1";

        _port2.portType = NLSpec.PortType.Input
        _port2.portSide = NLSpec.PortPositionSide.Left
        _port2.enable   = false;
        _port2.title    = "input 2";

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right
        _port3.title    = "value";

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }
}
```

**Key Features**:
- Two input ports (left side) and one output port (right side)
- Uses `OperationNodeData` to store input values
- Base class for all arithmetic operations

---

##### 4.3 ResultNode.qml

Create `resources/Core/ResultNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.Result
    nodeData: I_NodeData {}
    
    guiConfig.autoSize: true
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "value";
        addPort(_port1);
    }
}
```

**Key Features**:
- Single input port (left side)
- Resets data when cloned
- Read-only display of results

---

#### Step 5: Create Specific Operation Nodes

##### 5.1 AdditiveNode.qml

Create `resources/Core/AdditiveNode.qml`:

```qml
import QtQuick
import Calculator

OperationNode {
    operationType: CSpecs.OperationType.Additive

    function updataData() {
        if (!nodeData.inputFirst || !nodeData.inputSecond) {
            nodeData.data = null;
            return;
        }
        var input1 = parseFloat(nodeData.inputFirst);
        var input2 = parseFloat(nodeData.inputSecond)
        nodeData.data = input1 + input2;
    }
}
```

**Key Features**:
- Inherits from `OperationNode`
- Implements `updataData()` to perform addition
- Validates inputs before calculation

---

##### 5.2 MultiplierNode.qml

Create `resources/Core/MultiplierNode.qml`:

```qml
import QtQuick
import Calculator

OperationNode {
    operationType: CSpecs.OperationType.Multiplier

    function updataData() {
        if (!nodeData.inputFirst || !nodeData.inputSecond) {
            nodeData.data = null;
            return;
        }
        var input1 = parseFloat(nodeData.inputFirst);
        var input2 = parseFloat(nodeData.inputSecond)
        nodeData.data = input1 * input2;
    }
}
```

---

##### 5.3 SubtractionNode.qml

Create `resources/Core/SubtractionNode.qml`:

```qml
import QtQuick
import Calculator

OperationNode {
    operationType: CSpecs.OperationType.Subtraction

    function updataData() {
        if (!nodeData.inputFirst || !nodeData.inputSecond) {
            nodeData.data = null;
            return;
        }
        var input1 = parseFloat(nodeData.inputFirst);
        var input2 = parseFloat(nodeData.inputSecond)
        nodeData.data = input1 - input2;
    }
}
```

---

##### 5.4 DivisionNode.qml

Create `resources/Core/DivisionNode.qml`:

```qml
import QtQuick
import Calculator

OperationNode {
    operationType: CSpecs.OperationType.Division

    function updataData() {
        if (!nodeData.inputFirst || !nodeData.inputSecond) {
            nodeData.data = null;
            return;
        }
        var input1 = parseFloat(nodeData.inputFirst);
        var input2 = parseFloat(nodeData.inputSecond)
        if (input2 !== 0)
            nodeData.data = input1 / input2;
        else
            nodeData.data = "undefined (Divide by zero)"
    }
}
```

**Key Features**:
- Includes division-by-zero handling
- Returns error message for invalid operations

---

#### Step 6: Create the Scene

##### 6.1 CalculatorScene.qml

Create `resources/Core/CalculatorScene.qml` - the main scene that manages nodes and links:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import Calculator

I_Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["Calculator"]
        defaultNode: CSpecs.NodeType.Source
        
        nodeTypes: [
            CSpecs.NodeType.Source      = "SourceNode",
            CSpecs.NodeType.Additive    = "AdditiveNode",
            CSpecs.NodeType.Multiplier  = "MultiplierNode",
            CSpecs.NodeType.Subtraction = "SubtractionNode",
            CSpecs.NodeType.Division    = "DivisionNode",
            CSpecs.NodeType.Result      = "ResultNode"
        ];
        
        nodeNames: [
            CSpecs.NodeType.Source      = "Source",
            CSpecs.NodeType.Additive    = "Additive",
            CSpecs.NodeType.Multiplier  = "Multiplier",
            CSpecs.NodeType.Subtraction = "Subtraction",
            CSpecs.NodeType.Division    = "Division",
            CSpecs.NodeType.Result      = "Result"
        ];
        
        nodeIcons: [
            CSpecs.NodeType.Source      = "\ue4e2",
            CSpecs.NodeType.Additive    = "+",
            CSpecs.NodeType.Multiplier  = "\uf00d",
            CSpecs.NodeType.Subtraction = "-",
            CSpecs.NodeType.Division    = "/",
            CSpecs.NodeType.Result      = "\uf11b",
        ];
        
        nodeColors: [
            CSpecs.NodeType.Source     = "#444",
            CSpecs.NodeType.Additive    = "#444",
            CSpecs.NodeType.Multiplier  = "#444",
            CSpecs.NodeType.Subtraction = "#444",
            CSpecs.NodeType.Division    = "#444",
            CSpecs.NodeType.Result      = "#444",
        ];
    }

    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    property UndoCore _undoCore: UndoCore {
        scene: scene
    }

    // Update node data when links/nodes change
    onLinkRemoved: _upateDataTimer.start();
    onNodeRemoved: _upateDataTimer.start();
    onLinkAdded:   updateData();

    property Timer _upateDataTimer: Timer {
        repeat: false
        running: false
        interval: 1
        onTriggered: scene.updateData();
    }

    // Create a node with specific type and position
    function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
        var title = nodeRegistry.nodeNames[nodeType] + "_" + 
                   (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(nodeRegistry.imports, nodeType,
                                 nodeRegistry.nodeTypes[nodeType],
                                 nodeRegistry.nodeColors[nodeType],
                                 title, xPos, yPos);
    }

    // Link validation and creation
    function linkNodes(portA: string, portB: string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes");
            return;
        }
        let link = Object.values(links).find(conObj =>
            conObj.inputPort._qsUuid === portA &&
            conObj.outputPort._qsUuid === portB);
        if (link === undefined)
            createLink(portA, portB);
    }

    // Validation rules for linking
    function canLinkNodes(portA: string, portB: string): bool {
        // ... (validation logic - see source file)
        return true;
    }

    // Update all node data based on connections
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

        // Process links and update data
        Object.values(links).forEach(link => {
            // ... (data propagation logic)
        });

        // Handle nodes waiting for multiple inputs
        while (notReadyLinks.length > 0) {
            // ... (process remaining links)
        }
    }

    // Update specific node data
    function upadateNodeData(upstreamNode: Node, downStreamNode: Node) {
        switch (downStreamNode.type) {
            case CSpecs.NodeType.Additive:
            case CSpecs.NodeType.Multiplier:
            case CSpecs.NodeType.Subtraction:
            case CSpecs.NodeType.Division: {
                if (!downStreamNode.nodeData.inputFirst)
                    downStreamNode.nodeData.inputFirst = upstreamNode.nodeData.data;
                else if (!downStreamNode.nodeData.inputSecond)
                    downStreamNode.nodeData.inputSecond = upstreamNode.nodeData.data;
                downStreamNode.updataData();
            } break;
            case CSpecs.NodeType.Result: {
                downStreamNode.nodeData.data = upstreamNode.nodeData.data;
            } break;
        }
    }
}
```

**Key Features**:
- **Node Registry**: Defines all available node types, names, icons, and colors
- **Link Validation**: Ensures valid connections (no cycles, single input per port, etc.)
- **Data Propagation**: Automatically updates node values when connections change
- **Undo Support**: Integrated undo/redo functionality

**Data Flow Logic**:
1. When a link is added/removed, `updateData()` is called
2. All operation nodes are reset
3. Data flows from Source nodes through operation nodes
4. Operation nodes wait for both inputs before calculating
5. Results propagate to connected nodes

---

#### Step 7: Create Views

##### 7.1 CalculatorNodeView.qml

Create `resources/View/CalculatorNodeView.qml` - custom view for displaying nodes:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import Calculator

NodeView {
    id: nodeView

    contentItem: Item {
        id: mainContentItem
        property bool iconOnly: ((node?.operationType ?? -1) > -1) ||
                                nodeView.isNodeMinimal
        
        // Header with icon and title
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            visible: !mainContentItem.iconOnly
            height: 20

            Text {
                id: iconText
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
            }

            NLTextArea {
                id: titleTextArea
                anchors.right: parent.right
                anchors.left: iconText.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                height: 40
                readOnly: !nodeView.edit
                placeholderText: qsTr("Enter title")
                color: NLStyle.primaryTextColor
                text: node.title
                onTextChanged: {
                    if (node && node.title !== text)
                        node.title = text;
                }
            }
        }

        // Value display/input field
        NLTextField {
            id: textArea
            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5
            visible: !mainContentItem.iconOnly
            placeholderText: qsTr("Number")
            color: NLStyle.primaryTextColor
            text: node?.nodeData?.data
            readOnly: !nodeView.edit || (node.type === CSpecs.NodeType.Result)
            validator: DoubleValidator {}
            onTextChanged: {
                if (node && (node.nodeData?.data ?? "") !== text) {
                    if (node.type === CSpecs.NodeType.Source) {
                        node.nodeData.data = text;
                        scene.updateData();
                    }
                }
            }
        }

        // Minimal view (icon only at low zoom)
        Rectangle {
            id: minimalRectangle
            anchors.fill: parent
            anchors.margins: 10
            color: mainContentItem.iconOnly ? "#282828" : "transparent"
            radius: NLStyle.radiusAmount.nodeView

            Text {
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 60
                anchors.centerIn: parent
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
                visible: mainContentItem.iconOnly
            }
        }
    }
}
```

**Key Features**:
- **Editable Title**: Users can rename nodes
- **Value Display**: Shows node data (read-only for Result, editable for Source)
- **Minimal Mode**: Shows icon only when zoomed out
- **Validation**: Uses `DoubleValidator` for numeric input

---

##### 7.2 CalculatorView.qml

Create `resources/View/CalculatorView.qml` - main view container:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream
import Calculator

Item {
    id: view
    property CalculatorScene scene

    property SceneSession sceneSession: SceneSession {
        enabledOverview: false;
        doNodesNeedImage: false
    }

    // Nodes Scene (flickable canvas)
    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("CalculatorNodeView.qml")
        }
    }

    // Side menu for adding nodes
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }
}
```

**Key Features**:
- **NodesScene**: Provides the scrollable canvas for nodes
- **SideMenu**: Allows users to add new nodes to the scene
- **SceneSession**: Manages view state and interactions

---

#### Step 8: Create Main Application

##### 8.1 main.cpp

Create `main.cpp`:

```cpp
#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Set Material style
    QQuickStyle::setStyle("Material");

    // Import all items into QML engine
    engine.addImportPath(":/");

    const QUrl url(u"qrc:/Calculator/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

**Key Features**:
- Uses Material design style
- Loads QML resources from the Calculator module
- Standard Qt Quick application setup

---

##### 8.2 main.qml

Create `main.qml`:

```qml
import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls

import QtQuickStream
import NodeLink
import Calculator

Window {
    id: window
    property CalculatorScene scene: null

    width: 1280
    height: 960
    visible: true
    title: qsTr("Calculator Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        // Create root object
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "Calculator"])
        NLCore.defaultRepo.initRootObject("CalculatorScene");
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });
    }

    // Load Font Awesome fonts
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }

    // Main view
    CalculatorView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
```

**Key Features**:
- **Dark Theme**: Material Dark theme with custom accent color
- **Scene Initialization**: Creates the CalculatorScene using QtQuickStream
- **Font Loading**: Loads Font Awesome icons
- **Full-Screen View**: CalculatorView fills the window

---

#### Step 9: Build and Run

##### 9.1 Configure Build

1. Create a build directory:
   ```bash
   mkdir build
   cd build
   ```

2. Configure with CMake:
   ```bash
   cmake .. -DCMAKE_PREFIX_PATH=<Qt_Install_Path>
   ```

3. Build the project:
   ```bash
   cmake --build .
   ```

##### 9.2 Run the Application

Run the executable:
```bash
./Calculator  # Linux/Mac
Calculator.exe  # Windows
```

---

#### Step 10: Using the Calculator

##### Basic Usage

1. **Add Nodes**: Click the side menu to add nodes (Source, Additive, Multiplier, etc.)

2. **Set Values**: 
   - Click on a Source node
   - Type a number in the value field
   - Press Enter or click outside

3. **Connect Nodes**:
   - Click and drag from an output port (right side)
   - Release on an input port (left side)
   - A link will be created if the connection is valid

4. **View Results**:
   - Connect operation nodes to a Result node
   - The Result node displays the calculated value
   - Values update automatically when inputs change

##### Example Calculation: (5 + 3) × 2

1. Add two Source nodes, set values to `5` and `3`
2. Add an Additive node
3. Connect Source (5) → Additive input 1
4. Connect Source (3) → Additive input 2
5. Add a Source node with value `2`
6. Add a Multiplier node
7. Connect Additive output → Multiplier input 1
8. Connect Source (2) → Multiplier input 2
9. Add a Result node
10. Connect Multiplier output → Result input
11. Result displays `16`

---

### Architecture Overview

#### Data Flow

```
Source Node → Operation Node → Result Node
     ↓              ↓
  (value)    (input1, input2)
              ↓ (calculate)
            (result)
```

#### Component Hierarchy

```
CalculatorScene (I_Scene)
├── NodeRegistry (defines node types)
├── SelectionModel (manages selection)
├── UndoCore (undo/redo support)
└── Nodes & Links
    ├── SourceNode
    ├── OperationNodes (Additive, Multiplier, etc.)
    └── ResultNode

CalculatorView
├── NodesScene (canvas)
│   └── NodesRect (renders nodes)
│       └── CalculatorNodeView (custom node UI)
└── SideMenu (add nodes)
```

---

### Key Concepts

#### Ports

- **Input Ports**: Receive data from other nodes (left side)
- **Output Ports**: Send data to other nodes (right side)
- **Port Rules**: 
  - Each input port can only have one connection
  - Output ports can connect to multiple inputs
  - Cannot create cycles in the graph

#### Data Propagation

1. **Source nodes** provide initial values
2. **Operation nodes** wait for both inputs before calculating
3. **Results** propagate downstream automatically
4. **Updates** trigger when:
   - Links are added/removed
   - Source node values change
   - Nodes are deleted

#### Node Lifecycle

1. **Creation**: Node created via `createCustomizeNode()`
2. **Initialization**: Ports added in `Component.onCompleted`
3. **Connection**: Links established via `linkNodes()`
4. **Update**: Data calculated in `updataData()`
5. **Deletion**: Cleanup handled by scene

---

### Extending the Calculator

#### Adding New Operations

To add a new operation (e.g., Power/Exponentiation):

1. **Add to CSpecs.qml**:
   ```qml
   enum NodeType {
       // ... existing types
       Power = 6
   }
   ```

2. **Create PowerNode.qml**:
   ```qml
   import QtQuick
   import Calculator

   OperationNode {
       operationType: CSpecs.OperationType.Power
       function updataData() {
           if (!nodeData.inputFirst || !nodeData.inputSecond) {
               nodeData.data = null;
               return;
           }
           var base = parseFloat(nodeData.inputFirst);
           var exponent = parseFloat(nodeData.inputSecond);
           nodeData.data = Math.pow(base, exponent);
       }
   }
   ```

3. **Register in CalculatorScene.qml**:
   ```qml
   nodeTypes: [
       // ... existing
       CSpecs.NodeType.Power = "PowerNode"
   ]
   ```

#### Customizing Appearance

- **Node Colors**: Modify `nodeColors` in `CalculatorScene.qml`
- **Node Icons**: Change `nodeIcons` (Font Awesome codes)
- **Node Sizes**: Adjust `guiConfig` properties in node definitions
- **View Styling**: Modify `CalculatorNodeView.qml` for custom UI

---

### Troubleshooting

#### Common Issues

1. **Nodes not updating**: Check that `updateData()` is called after link changes
2. **Invalid connections**: Verify `canLinkNodes()` validation logic
3. **Division by zero**: Handled in `DivisionNode.qml` - displays error message
4. **Missing fonts**: Ensure Font Awesome fonts are in `resources/fonts/`

#### Debug Tips

- Enable console logging in `CalculatorScene.qml`
- Check node data with: `console.log(node.nodeData.data)`
- Verify port connections: `console.log(link.inputPort, link.outputPort)`

---

### Conclusion

The Calculator Example demonstrates the core concepts of building node-based applications with NodeLink:

- **Custom Node Types**: Define specialized nodes for your domain
- **Data Flow**: Implement automatic data propagation
- **Visual Interface**: Create intuitive node views
- **Scene Management**: Handle nodes, links, and their relationships

Use this example as a foundation for building more complex node-based applications such as:
- Visual programming languages
- Data processing pipelines
- Workflow builders
- Shader editors
- Logic circuit simulators

For more examples, see the other examples in the NodeLink repository.

## Chatbot Example

### Overview

The Chatbot Example demonstrates how to build an interactive chatbot application using NodeLink's visual node-based programming system. Unlike traditional chatbots that rely on hardcoded logic, this example shows how to create a rule-based chatbot using regular expressions (Regex) and visual node connections. Users can define conversation patterns visually by connecting nodes, making it easy to design and modify chatbot behavior without writing complex code.

![Chatbot Example Overview](images/ChatBot_Example.png)

---

### a. Purpose and Use Cases

#### Purpose

The Chatbot Example demonstrates:

1. **Visual Rule-Based Chatbots**: Shows how to create chatbots using visual node graphs instead of traditional programming approaches.

2. **Pattern Matching with Regex**: Illustrates how to use regular expressions to match user input and trigger appropriate responses.

3. **Conditional Response Logic**: Demonstrates branching logic where different responses are triggered based on pattern matching results.

4. **Interactive User Interface**: Combines a node-based editor with a real-time chat interface, allowing users to see their chatbot in action.

5. **Real-Time Data Flow**: Shows how user input flows through the node graph, gets processed, and generates responses in real-time.

6. **Dual Output Nodes**: Demonstrates nodes with multiple output ports for conditional branching (true/false paths).

#### Use Cases

- **Educational Tool**: Learn how to build rule-based chatbots and understand pattern matching concepts
- **Prototyping**: Quickly prototype chatbot logic and test conversation flows
- **Visual Bot Builder**: Create chatbots without writing code, ideal for non-programmers
- **Pattern Testing**: Test regular expressions and see their effects immediately
- **Framework Demonstration**: Showcase NodeLink's capabilities for building interactive applications
- **Custom Application Foundation**: Use as a starting point for building more complex conversational interfaces

#### Example Scenarios

- **Simple Greeting Bot**: Respond to greetings like "hello", "hi", "hey" with friendly messages
- **Keyword-Based Responses**: Trigger responses based on specific keywords in user messages
- **Pattern Recognition**: Match complex patterns like email addresses, phone numbers, or custom formats
- **Multi-Path Conversations**: Create branching conversations that respond differently based on input patterns
- **Interactive Testing**: Test chatbot behavior in real-time while building the node graph

#### Real-World Applications

- **Customer Support Bots**: Create simple rule-based support chatbots
- **FAQ Systems**: Build question-answering systems based on pattern matching
- **Form Validation**: Use regex patterns to validate user input
- **Content Filtering**: Filter or categorize messages based on patterns
- **Educational Games**: Create interactive learning experiences with pattern-based responses

![Use Case Diagram](images/ChatBot_9394.png) <!-- TODO: Insert diagram showing different use cases -->

---

### b. Node Types Explained

The Chatbot Example implements four distinct node types, each serving a specific role in the chatbot's decision-making process.

#### 1. Source Node (`SourceNode`)

**Purpose**: Receives and stores user input messages from the chat interface.

**Type ID**: `CSpecs.NodeType.Source` (0)

**Properties**:
- Contains a single output port named "value"
- Receives text input from the chat interface
- Acts as the entry point for all user messages
- Can be manually edited for testing purposes

**Ports**:
- **Output Port**: "value" (Right side) - Emits the user's message text

**Behavior**:
- Automatically receives messages when users type in the chat box
- The message text is stored in `nodeData.data`
- When data changes, it triggers the scene's `updateData()` function
- Can be manually edited by clicking on the node and typing

**Visual Appearance**:
- Icon: Document/Text icon (Font Awesome)
- Color: Gray (#444)
- Size: 150x100 pixels

**Usage Example**:
- User types "hello world" in chat → Source node receives "hello world"
- Source node outputs "hello world" to connected nodes

![Source Node](images/ChatBot_9432.png) <!-- TODO: Insert screenshot of Source node -->

---

#### 2. Regex Node (`RegexNode`)

**Purpose**: Matches user input against a regular expression pattern and routes the result through two different output ports.

**Type ID**: `CSpecs.NodeType.Regex` (1)

**Properties**:
- Has one input port and two output ports
- Contains a regular expression pattern in `nodeData.data`
- Performs case-insensitive pattern matching
- Routes results through "output 1" (match found) or "output 2" (no match)

**Ports**:
- **Input Port**: "input" (Left side) - Receives text to match against the pattern
- **Output Port 1**: "output 1" (Right side) - Emits when pattern matches (FOUND)
- **Output Port 2**: "output 2" (Right side) - Emits when pattern doesn't match (NOT_FOUND)

**Properties**:
- `inputFirst`: Stores the input text to match
- `matchedPattern`: Contains "FOUND" or "NOT_FOUND" based on match result
- `nodeData.data`: Contains the regular expression pattern (e.g., "hello|hi|hey")

**Behavior**:
1. Receives input text from the connected upstream node
2. Creates a case-insensitive RegExp from `nodeData.data`
3. Tests the input against the pattern
4. Sets `matchedPattern` to "FOUND" or "NOT_FOUND"
5. Routes the result through the appropriate output port

**Regular Expression Examples**:
- `"hello|hi|hey"` - Matches any of these greetings
- `"\\d+"` - Matches one or more digits
- `"[a-zA-Z]+"` - Matches one or more letters
- `"^hello"` - Matches "hello" at the start of the string
- `"world$"` - Matches "world" at the end of the string

**Visual Appearance**:
- Icon: Search icon (Font Awesome \uf002)
- Color: Brown/Tan (#C69C6D)
- Size: 150x100 pixels

**Usage Example**:
- Pattern: `"hello|hi"`
- Input: "hello world" → Matches → `matchedPattern = "FOUND"` → Routes to output 1
- Input: "goodbye" → No match → `matchedPattern = "NOT_FOUND"` → Routes to output 2

![Regex Node](images/ChatBot_9482) <!-- TODO: Insert screenshot of Regex node with pattern and connections -->

**Code Implementation**:
```qml
function updataData() {
    if (!inputFirst) {
        return
    }
    var re = new RegExp(nodeData.data, "i")  // 'i' flag for case-insensitive
    var found = re.test(inputFirst)
    matchedPattern = found ? "FOUND" : "NOT_FOUND"
}
```

---

#### 3. Result True Node (`ResultTrueNode`)

**Purpose**: Displays a response message when a pattern match is found (FOUND).

**Type ID**: `CSpecs.NodeType.ResultTrue` (2)

**Properties**:
- Contains a single input port
- Displays response text when triggered
- Automatically sends the response to the chat interface
- Read-only (cannot be edited directly)

**Ports**:
- **Input Port**: "value" (Left side) - Receives data from Regex node's output 1

**Behavior**:
- Should be connected to Regex node's "output 1" port
- When triggered, checks if the upstream Regex node has `matchedPattern === "FOUND"`
- If true, sets `nodeData.data` to "HI ..." (or custom response)
- Emits `botResponse` signal to display the message in the chat box
- If the pattern didn't match, sets data to empty string

**Visual Appearance**:
- Icon: Checkmark/Circle icon (Font Awesome \uf058)
- Color: Green (#4caf50) - indicates positive/successful match
- Size: 150x100 pixels

**Usage Example**:
- Regex node matches "hello" → Routes to ResultTrue node
- ResultTrue node displays "HI ..." in chat
- User sees the bot's response

![Result True Node](images/ChatBot_9530.png) <!-- TODO: Insert screenshot of ResultTrue node -->

**Code Implementation**:
```qml
// In ChatbotScene.qml
case CSpecs.NodeType.ResultTrue: {
    downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "FOUND") ? "HI ..." : "";
    botResponse(downStreamNode.nodeData.data)
} break;
```

---

#### 4. Result False Node (`ResultFalseNode`)

**Purpose**: Displays a response message when a pattern match is not found (NOT_FOUND).

**Type ID**: `CSpecs.NodeType.ResultFalse` (3)

**Properties**:
- Contains a single input port
- Displays response text when no pattern matches
- Automatically sends the response to the chat interface
- Read-only (cannot be edited directly)

**Ports**:
- **Input Port**: "value" (Left side) - Receives data from Regex node's output 2

**Behavior**:
- Should be connected to Regex node's "output 2" port
- When triggered, checks if the upstream Regex node has `matchedPattern === "NOT_FOUND"`
- If true, sets `nodeData.data` to " :( " (or custom response)
- Emits `botResponse` signal to display the message in the chat box
- If the pattern matched, sets data to empty string

**Visual Appearance**:
- Icon: X-mark/Circle icon (Font Awesome \uf057)
- Color: Red (#f44336) - indicates no match/failure
- Size: 150x100 pixels

**Usage Example**:
- Regex node doesn't match user input → Routes to ResultFalse node
- ResultFalse node displays " :( " in chat
- User sees the bot's "I don't understand" response

![Result False Node](images/ChatBot_9575.png) <!-- TODO: Insert screenshot of ResultFalse node -->

**Code Implementation**:
```qml
// In ChatbotScene.qml
case CSpecs.NodeType.ResultFalse: {
    downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "NOT_FOUND") ? " :( " : "";
    botResponse(downStreamNode.nodeData.data)
} break;
```

---

#### Node Type Summary Table

| Node Type | Type ID | Input Ports | Output Ports | Purpose | Color |
|-----------|---------|-------------|--------------|---------|-------|
| Source | 0 | 0 | 1 | Receives user input | Gray (#444) |
| Regex | 1 | 1 | 2 | Pattern matching | Brown (#C69C6D) |
| ResultTrue | 2 | 1 | 0 | Response on match | Green (#4caf50) |
| ResultFalse | 3 | 1 | 0 | Response on no match | Red (#f44336) |

---

#### Data Flow Architecture

The chatbot follows a simple but powerful data flow pattern:

```
User Input (Chat Box)
    ↓
Source Node (stores message)
    ↓
Regex Node (pattern matching)
    ├─→ [Match Found] → ResultTrue Node → Chat Response ("HI ...")
    └─→ [No Match] → ResultFalse Node → Chat Response (" :( ")
```

![Data Flow Diagram](images/ChatBot_9613.png) <!-- TODO: Insert diagram showing data flow through nodes -->

---

### c. Step-by-Step Building Guide

This guide will walk you through building the Chatbot Example from scratch, explaining each component and how they work together.

#### Prerequisites

- Qt 6.2.4 or later (Qt 6.10.0 recommended)
- CMake 3.1.0 or later
- C++ compiler with C++14 support (MSVC 2019/2022 on Windows)
- NodeLink framework built and installed
- QtQuickStream module built and installed
- Basic understanding of regular expressions (helpful but not required)

#### Step 1: Project Setup

##### 1.1 Create Project Structure

Create the following directory structure:

```
chatbot/
├── CMakeLists.txt
├── main.cpp
├── main.qml
└── resources/
    ├── Core/
    ├── View/
    └── fonts/
```

##### 1.2 Configure CMakeLists.txt

Create `CMakeLists.txt` with the following configuration:

```cmake
cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Create executable
qt_add_executable(Chatbot main.cpp)

# Set CSpecs as singleton
set_source_files_properties(
    resources/Core/CSpecs.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# Define QML module
qt_add_qml_module(Chatbot
    URI "Chatbot"
    VERSION 1.0
    QML_FILES
        main.qml
        resources/Core/CSpecs.qml
        resources/Core/ChatbotScene.qml
        resources/Core/SourceNode.qml
        resources/Core/RegexNode.qml
        resources/Core/ResultTrueNode.qml
        resources/Core/ResultFalseNode.qml
        resources/Core/OperationNode.qml
        resources/Core/OperationNodeData.qml
        resources/Core/Chatbox.qml
        resources/View/ChatbotView.qml
        resources/View/ChatbotNodeView.qml
    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
)

target_include_directories(Chatbot PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_link_libraries(Chatbot PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
```

**Key Points**:
- Links to `NodeLinkplugin` and `QtQuickStreamplugin`
- Sets `CSpecs.qml` as a singleton for global access
- Includes Font Awesome fonts for icons
- Includes `Chatbox.qml` for the chat interface

---

#### Step 2: Create Specifications (CSpecs.qml)

Create `resources/Core/CSpecs.qml` - a singleton that defines node type constants:

```qml
pragma Singleton

import QtQuick

QtObject {
    enum NodeType {
        Source       = 0,
        Regex        = 1,
        ResultTrue   = 2,
        ResultFalse  = 3,
        Unknown      = 99
    }

    enum OperationType {
        Operation    = 0,
        Regex        = 1,
        Unknown      = 99
    }
}
```

**Purpose**: Provides type-safe constants for node types used throughout the application.

---

#### Step 3: Create Node Data Models

##### 3.1 OperationNodeData.qml

Create `resources/Core/OperationNodeData.qml` - data model for operation nodes:

```qml
import QtQuick
import NodeLink

I_NodeData {
    property var inputFirst: null
}
```

**Purpose**: Extends `I_NodeData` to store input value for regex operations.

---

#### Step 4: Create Base Node Types

##### 4.1 SourceNode.qml

Create `resources/Core/SourceNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.Source
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right
        _port1.title    = "value";
        addPort(_port1);
    }
}
```

**Key Features**:
- Single output port on the right side
- Receives user messages from the chat interface
- Fixed size node (150x100)

---

##### 4.2 RegexNode.qml

Create `resources/Core/RegexNode.qml` - the core pattern matching node:

```qml
import QtQuick
import NodeLink
import Chatbot

Node {
    type: CSpecs.NodeType.Regex
    nodeData: I_NodeData {}
    property var inputFirst: null
    property var matchedPattern: null
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "input";

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Right
        _port2.title    = "output 1";

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right
        _port3.title    = "output 2";

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }

    function updataData() {
        if (!inputFirst) {
            return
        }

        var re = new RegExp(nodeData.data, "i")  // Case-insensitive
        var found = re.test(inputFirst)
        matchedPattern = found ? "FOUND" : "NOT_FOUND"
    }
}
```

**Key Features**:
- One input port (left) and two output ports (right)
- Stores regex pattern in `nodeData.data`
- Performs case-insensitive matching
- Sets `matchedPattern` property for downstream nodes to check

---

##### 4.3 ResultTrueNode.qml

Create `resources/Core/ResultTrueNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.ResultTrue
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "value";
        addPort(_port1);
    }
}
```

**Key Features**:
- Single input port (left side)
- Connected to Regex node's "output 1"
- Resets data when cloned

---

##### 4.4 ResultFalseNode.qml

Create `resources/Core/ResultFalseNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.ResultFalse
    nodeData: I_NodeData {}
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "value";
        addPort(_port1);
    }
}
```

**Key Features**:
- Single input port (left side)
- Connected to Regex node's "output 2"
- Resets data when cloned

---

#### Step 5: Create the Chat Interface

##### 5.1 Chatbox.qml

Create `resources/Core/Chatbox.qml` - the chat interface component:

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: chatBox
    width: parent ? parent.width : 400
    height: parent ? parent.height : 300

    signal userMessageSent(string message)

    ListModel {
        id: messagesModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Message list with scroll view
        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Column {
                id: messageList
                width: scrollView.width
                spacing: 10

                Repeater {
                    model: messagesModel

                    delegate: Item {
                        width: parent.width
                        implicitHeight: bubble.implicitHeight + dynamicSpacing
                        property int dynamicSpacing: Math.max(36, messageText.lineCount * 24)

                        Row {
                            width: parent.width
                            spacing: 6
                            anchors.margins: 8
                            layoutDirection: model.isUser ? Qt.RightToLeft : Qt.LeftToRight

                            // Avatar
                            Rectangle {
                                width: 28
                                height: 28
                                radius: 14
                                color: model.isUser ? "#3A7AFE" : "#C69C6D"
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: model.isUser ? "U" : "B"
                                    color: "white"
                                    font.bold: true
                                    font.pointSize: 10
                                }
                            }

                            // Message bubble
                            Rectangle {
                                id: bubble
                                color: model.isUser ? "#3A7AFE" : "#C69C6D"
                                radius: 12
                                width: Math.min(parent.width * 0.7, messageText.implicitWidth + 24)
                                height: messageText.paintedHeight + 20

                                Text {
                                    id: messageText
                                    text: model.text
                                    color: "white"
                                    wrapMode: Text.WordWrap
                                    font.pointSize: 11
                                    anchors.margins: 10
                                    anchors.fill: parent
                                    width: bubble.width - 20
                                }
                            }
                        }
                    }
                }
            }
        }

        // Input field and send button
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Type your message..."
                font.pointSize: 10
                onAccepted: sendMessage()
            }

            Button {
                text: "Send"
                onClicked: sendMessage()
            }
        }
    }

    Component.onCompleted: {
        // Welcome messages
        messagesModel.append({ text: "Hello there! I'm a chatbot based on visual programming and built using the NodeLink.", isUser: false })
        messagesModel.append({ text: "You can send me any message, and I'll check it using Regex nodes.", isUser: false })
        messagesModel.append({ text: "Type something like:   hello world :)   ", isUser: false })
        Qt.callLater(scrollToBottom)
    }

    function scrollToBottom() {
        if (scrollView.flickableItem) {
            scrollView.flickableItem.contentY =
                Math.max(0, scrollView.flickableItem.contentHeight - scrollView.flickableItem.height);
        }
    }

    function sendMessage() {
        if (inputField.text.trim().length === 0)
            return

        let msg = inputField.text.trim()
        inputField.text = ""

        messagesModel.append({ text: msg, isUser: true })
        chatBox.userMessageSent(msg)
        Qt.callLater(scrollToBottom)
    }

    function addMessage(text, fromUser) {
        if (text && text.trim() !== "") {
            messagesModel.append({ text: text, isUser: fromUser })
            Qt.callLater(scrollToBottom)
        }
    }
}
```

**Key Features**:
- **Message List**: Displays chat history with user and bot messages
- **Scroll View**: Auto-scrolls to bottom when new messages arrive
- **Input Field**: Text field for user input with Enter key support
- **Send Button**: Button to send messages
- **Welcome Messages**: Shows introductory messages on startup
- **Signal**: Emits `userMessageSent` signal when user sends a message

![Chat Interface](images/ChatBot_10097.png) <!-- TODO: Insert screenshot of the chat interface -->

---

#### Step 6: Create the Scene

##### 6.1 ChatbotScene.qml

Create `resources/Core/ChatbotScene.qml` - the main scene that manages nodes, links, and bot responses:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import Chatbot

I_Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["Chatbot"]
        defaultNode: CSpecs.NodeType.Source
        
        nodeTypes: [
            CSpecs.NodeType.Source      = "SourceNode",
            CSpecs.NodeType.Regex       = "RegexNode",
            CSpecs.NodeType.ResultTrue  = "ResultTrueNode",
            CSpecs.NodeType.ResultFalse = "ResultFalseNode"
        ];
        
        nodeNames: [
            CSpecs.NodeType.Source      = "Source",
            CSpecs.NodeType.Regex       = "Regex",
            CSpecs.NodeType.ResultTrue  = "ResultTrue",
            CSpecs.NodeType.ResultFalse = "ResultFalse"
        ];
        
        nodeIcons: [
            CSpecs.NodeType.Source      = "\ue4e2",
            CSpecs.NodeType.Regex       = "\uf002",
            CSpecs.NodeType.ResultTrue  = "\uf058",
            CSpecs.NodeType.ResultFalse = "\uf057"
        ];
        
        nodeColors: [
            CSpecs.NodeType.Source      = "#444",
            CSpecs.NodeType.Regex       = "#C69C6D",
            CSpecs.NodeType.ResultTrue  = "#4caf50",
            CSpecs.NodeType.ResultFalse = "#f44336"
        ];
    }

    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    property UndoCore _undoCore: UndoCore {
        scene: scene
    }

    // Update node data when links/nodes change
    onLinkRemoved: _upateDataTimer.start();
    onNodeRemoved: _upateDataTimer.start();
    onLinkAdded:   updateData();

    property Timer _upateDataTimer: Timer {
        repeat: false
        running: false
        interval: 1
        onTriggered: scene.updateData();
    }

    // Signal to send bot response to chat
    signal botResponse(string text)

    // Create a node with specific type and position
    function createCustomizeNode(nodeType: int, xPos: real, yPos: real): string {
        var title = nodeRegistry.nodeNames[nodeType] + "_" + 
                   (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(nodeRegistry.imports, nodeType,
                                 nodeRegistry.nodeTypes[nodeType],
                                 nodeRegistry.nodeColors[nodeType],
                                 title, xPos, yPos);
    }

    // Link validation and creation (similar to Calculator example)
    function linkNodes(portA: string, portB: string) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes");
            return;
        }
        let link = Object.values(links).find(conObj =>
            conObj.inputPort._qsUuid === portA &&
            conObj.outputPort._qsUuid === portB);
        if (link === undefined)
            createLink(portA, portB);
    }

    function canLinkNodes(portA: string, portB: string): bool {
        // Validation logic (same as Calculator example)
        // ... (see source file for full implementation)
        return true;
    }

    // Update all node data based on connections
    function updateData() {
        var notReadyLinks = [];
        
        // Initialize result nodes
        Object.values(nodes).forEach(node => {
            switch (node.type) {
                case CSpecs.NodeType.ResultTrue:
                case CSpecs.NodeType.ResultFalse: {
                    node.nodeData.data = null;
                } break;
            }
        });

        // Process links and update data
        Object.values(links).forEach(link => {
            var portA = link.inputPort._qsUuid;
            var portB = link.outputPort._qsUuid;

            var upstreamNode   = findNode(portA);
            var downStreamNode = findNode(portB);

            // Find nodes with valid data that connected to upstreamNode
            var upstreamNodeLinks = Object.values(links).filter(linkObj => {
                var node = findNode(linkObj.outputPort._qsUuid);
                var inputNode = findNode(linkObj.inputPort._qsUuid);
                if (node._qsUuid === upstreamNode._qsUuid) {
                    if(inputNode.nodeData.data) {
                        return linkObj
                    }
                }
            });

            if (!upstreamNode.nodeData.data &&
                upstreamNode.type !== CSpecs.NodeType.Source) {
                if (upstreamNodeLinks.length > 1)
                    notReadyLinks.push(link);
                return;
            }

            upadateNodeData(upstreamNode, downStreamNode);
        });

        // Handle nodes waiting for multiple inputs
        while (notReadyLinks.length > 0) {
            notReadyLinks.forEach((link, index) => {
                var portA = link.inputPort._qsUuid;
                var portB = link.outputPort._qsUuid;

                var upstreamNode   = findNode(portA);
                var downStreamNode = findNode(portB);

                var upstreamNodeLinks = Object.values(links).filter(linkObj => 
                    findNodeId(linkObj.outputPort._qsUuid) === upstreamNode._qsUuid);

                if (upstreamNode.nodeData.data) {
                    notReadyLinks.splice(index, 1);
                }

                upadateNodeData(upstreamNode, downStreamNode);
            });
        }
    }

    // Update specific node data
    function upadateNodeData(upstreamNode: Node, downStreamNode: Node) {
        switch (downStreamNode.type) {
            case CSpecs.NodeType.Regex: {
                downStreamNode.inputFirst = upstreamNode.nodeData.data;
                downStreamNode.updataData();
            } break;

            case CSpecs.NodeType.ResultTrue: {
                downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "FOUND") ? "HI ..." : "";
                botResponse(downStreamNode.nodeData.data)
            } break;
            
            case CSpecs.NodeType.ResultFalse: {
                downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "NOT_FOUND") ? " :( " : "";
                botResponse(downStreamNode.nodeData.data)
            } break;
        }
    }
}
```

**Key Features**:
- **Node Registry**: Defines all available node types with colors and icons
- **Link Validation**: Ensures valid connections
- **Data Propagation**: Automatically updates node values when connections change
- **Bot Response Signal**: Emits `botResponse` signal to send messages to chat
- **Conditional Logic**: Checks `matchedPattern` to determine which response to send

**Data Flow Logic**:
1. User sends message → Source node receives it
2. Source node outputs to Regex node
3. Regex node matches pattern and sets `matchedPattern`
4. ResultTrue/ResultFalse nodes check `matchedPattern`
5. Appropriate response is sent via `botResponse` signal
6. Chat interface displays the response

![Scene Architecture](images/ChatBot_10303.png) <!-- TODO: Insert diagram showing scene structure -->

---

#### Step 7: Create Views

##### 7.1 ChatbotNodeView.qml

Create `resources/View/ChatbotNodeView.qml` - custom view for displaying nodes:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import Chatbot

NodeView {
    id: nodeView

    contentItem: Item {
        id: mainContentItem
        property bool iconOnly: ((node?.operationType ?? -1) > -1) ||
                                nodeView.isNodeMinimal
        
        // Header with icon and title
        Item {
            id: titleItem
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            visible: !mainContentItem.iconOnly
            height: 20

            Text {
                id: iconText
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
            }

            NLTextArea {
                id: titleTextArea
                anchors.right: parent.right
                anchors.left: iconText.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                height: 40
                readOnly: !nodeView.edit
                placeholderText: qsTr("Enter title")
                color: NLStyle.primaryTextColor
                text: node.title
                onTextChanged: {
                    if (node && node.title !== text)
                        node.title = text;
                }
            }
        }

        // Value display/input field
        NLTextField {
            id: textArea
            anchors.top: titleItem.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 12
            anchors.topMargin: 5
            visible: !mainContentItem.iconOnly
            placeholderText: qsTr("String")
            color: NLStyle.primaryTextColor
            text: node?.nodeData?.data
            readOnly: !nodeView.edit || 
                     (node.type === CSpecs.NodeType.ResultTrue) || 
                     (node.type === CSpecs.NodeType.ResultFalse)
            wrapMode: TextEdit.WrapAnywhere
            onTextChanged: {
                if (node && (node.nodeData?.data ?? "") !== text) {
                    if (node.type === CSpecs.NodeType.Source || 
                        node.type === CSpecs.NodeType.Regex) {
                        node.nodeData.data = text;
                        scene.updateData();
                    }
                }
            }
        }

        // Minimal view (icon only at low zoom)
        Rectangle {
            id: minimalRectangle
            anchors.fill: parent
            anchors.margins: 10
            color: mainContentItem.iconOnly ? "#282828" : "transparent"
            radius: NLStyle.radiusAmount.nodeView

            Text {
                font.family: NLStyle.fontType.font6Pro
                font.pixelSize: 60
                anchors.centerIn: parent
                text: scene.nodeRegistry.nodeIcons[node.type]
                color: node.guiConfig.color
                visible: mainContentItem.iconOnly
            }
        }
    }
}
```

**Key Features**:
- **Editable Title**: Users can rename nodes
- **Value Display**: Shows node data (editable for Source/Regex, read-only for Results)
- **Minimal Mode**: Shows icon only when zoomed out
- **String Input**: Accepts text input for Source and Regex nodes

---

##### 7.2 ChatbotView.qml

Create `resources/View/ChatbotView.qml` - main view container:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream
import Chatbot

Item {
    id: view
    property ChatbotScene scene

    property SceneSession sceneSession: SceneSession {
        enabledOverview: false;
        doNodesNeedImage: false
    }

    // Nodes Scene (flickable canvas)
    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("ChatbotNodeView.qml")
        }
    }

    // Side menu for adding nodes
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }
}
```

**Key Features**:
- **NodesScene**: Provides the scrollable canvas for nodes
- **SideMenu**: Allows users to add new nodes to the scene
- **SceneSession**: Manages view state and interactions

---

#### Step 8: Create Main Application

##### 8.1 main.cpp

Create `main.cpp`:

```cpp
#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // Set Material style
    QQuickStyle::setStyle("Material");

    // Import all items into QML engine
    engine.addImportPath(":/");

    const QUrl url(u"qrc:/Chatbot/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

---

##### 8.2 main.qml

Create `main.qml`:

```qml
import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts

import QtQuickStream
import NodeLink
import Chatbot

Window {
    id: window
    property ChatbotScene scene: null

    width: 1280
    height: 960
    visible: true
    title: qsTr("Chatbot Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        // Create root object
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "Chatbot"])
        NLCore.defaultRepo.initRootObject("ChatbotScene");
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });

        // Connect bot response signal to chat box
        Qt.callLater(() => {
            if (window.scene) {
                window.scene.botResponse.connect(function(msg) {
                    chatBox.addMessage(msg, false)
                })
            }
        })
    }

    // Load Font Awesome fonts
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/Chatbot/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }

    // Main layout: Node view (left) and Chat box (right)
    RowLayout {
        anchors.fill: parent
        spacing: 4
        anchors.margins: 4

        // Node-based view (left)
        ChatbotView {
            id: view
            scene: window.scene
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Chat box (right)
        Chatbox {
            id: chatBox
            Layout.preferredWidth: 400
            Layout.fillHeight: true
            onUserMessageSent: {
                // Find Source node and update it with user message
                let sourceNode = Object.values(window.scene.nodes).find(n => n.type === 0)
                if (sourceNode) {
                    sourceNode.nodeData.data = message
                    window.scene.updateData()
                }
            }
        }
    }
}
```

**Key Features**:
- **Dark Theme**: Material Dark theme with custom accent color
- **Scene Initialization**: Creates the ChatbotScene using QtQuickStream
- **Signal Connection**: Connects bot response signal to chat box
- **Split Layout**: Node editor on left, chat interface on right
- **Message Handling**: Updates Source node when user sends a message

![Main Application Layout](images/frame1.png)

---

#### Step 9: Build and Run

##### 9.1 Configure Build

1. Create a build directory:
   ```bash
   mkdir build
   cd build
   ```

2. Configure with CMake:
   ```bash
   cmake .. -DCMAKE_PREFIX_PATH=<Qt_Install_Path>
   ```

3. Build the project:
   ```bash
   cmake --build .
   ```

##### 9.2 Run the Application

Run the executable:
```bash
./Chatbot  # Linux/Mac
Chatbot.exe  # Windows
```

---

#### Step 10: Using the Chatbot

##### Basic Usage

1. **Add Nodes**: 
   - Click the side menu to add nodes
   - You'll need at least: 1 Source, 1 Regex, 1 ResultTrue, 1 ResultFalse

2. **Configure Regex Node**:
   - Click on the Regex node
   - Type a regular expression pattern (e.g., `"hello|hi|hey"`)
   - Press Enter or click outside

3. **Connect Nodes**:
   - Connect Source output → Regex input
   - Connect Regex "output 1" → ResultTrue input
   - Connect Regex "output 2" → ResultFalse input

4. **Test the Chatbot**:
   - Type a message in the chat box (right side)
   - If the message matches the regex pattern, you'll see "HI ..."
   - If it doesn't match, you'll see " :( "

![Node Connection Example](images/ChatBot_10657.png) <!-- TODO: Insert screenshot showing connected nodes -->

##### Example: Greeting Bot

**Setup**:
1. Add a Source node
2. Add a Regex node, set pattern to: `"hello|hi|hey|greetings"`
3. Add a ResultTrue node
4. Add a ResultFalse node

**Connections**:
- Source → Regex (input)
- Regex (output 1) → ResultTrue
- Regex (output 2) → ResultFalse

**Test**:
- User: "hello" → Bot: "HI ..."
- User: "hi there" → Bot: "HI ..."
- User: "goodbye" → Bot: " :( "

##### Example: Number Detection

**Setup**:
1. Add a Source node
2. Add a Regex node, set pattern to: `"\\d+"` (matches one or more digits)
3. Add ResultTrue and ResultFalse nodes
4. Connect as above

**Test**:
- User: "123" → Bot: "HI ..."
- User: "abc" → Bot: " :( "
- User: "I have 5 apples" → Bot: "HI ..." (contains digits)

##### Example: Email Pattern

**Setup**:
1. Regex pattern: `"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"`

**Test**:
- User: "test@example.com" → Bot: "HI ..."
- User: "not an email" → Bot: " :( "

![Example Workflow](images/frame1.png)

---

### Architecture Overview

#### Component Hierarchy

```
ChatbotScene (I_Scene)
├── NodeRegistry (defines node types)
├── SelectionModel (manages selection)
├── UndoCore (undo/redo support)
└── Nodes & Links
    ├── SourceNode (user input)
    ├── RegexNode (pattern matching)
    ├── ResultTrueNode (match response)
    └── ResultFalseNode (no-match response)

Main Window
├── ChatbotView (left side)
│   ├── NodesScene (canvas)
│   │   └── NodesRect (renders nodes)
│   │       └── ChatbotNodeView (custom node UI)
│   └── SideMenu (add nodes)
└── Chatbox (right side)
    ├── Message List (scrollable)
    └── Input Field + Send Button
```

#### Data Flow

```
User Types Message
    ↓
Chatbox emits userMessageSent signal
    ↓
Source Node receives message (nodeData.data)
    ↓
Source Node outputs to Regex Node
    ↓
Regex Node matches pattern
    ├─→ [Match] → matchedPattern = "FOUND" → ResultTrue → "HI ..."
    └─→ [No Match] → matchedPattern = "NOT_FOUND" → ResultFalse → " :( "
    ↓
botResponse signal emitted
    ↓
Chatbox displays response
```

![Architecture Diagram](images/ChatBot_10749.png) <!-- TODO: Insert comprehensive architecture diagram -->

---

### Key Concepts

#### Regular Expressions (Regex)

Regular expressions are patterns used to match character combinations in strings. The chatbot uses JavaScript's RegExp object.

**Common Patterns**:
- `"hello"` - Exact match
- `"hello|hi"` - Matches "hello" OR "hi"
- `"\\d+"` - One or more digits
- `"[a-z]+"` - One or more lowercase letters
- `"^start"` - Starts with "start"
- `"end$"` - Ends with "end"
- `".*"` - Any characters (wildcard)

**Flags**:
- `"i"` - Case-insensitive (used in the chatbot)

#### Dual Output Ports

The Regex node has two output ports to enable conditional branching:
- **Output 1**: Triggered when pattern matches
- **Output 2**: Triggered when pattern doesn't match

This allows the chatbot to respond differently based on whether the pattern matched.

#### Signal-Based Communication

The chatbot uses Qt signals to communicate between components:
- `userMessageSent`: Chatbox → Source Node
- `botResponse`: Scene → Chatbox

This decouples the components and makes the system more flexible.

---

### Extending the Chatbot

#### Adding Custom Response Messages

Modify `ChatbotScene.qml` to change response messages:

```qml
case CSpecs.NodeType.ResultTrue: {
    downStreamNode.nodeData.data = (upstreamNode.matchedPattern === "FOUND") 
        ? "Great! I understood that!" : "";
    botResponse(downStreamNode.nodeData.data)
} break;
```

#### Adding Multiple Regex Patterns

You can chain multiple Regex nodes:

1. Source → Regex1 (pattern: "hello")
2. Regex1 (output 1) → Regex2 (pattern: "world")
3. Regex2 (output 1) → ResultTrue

This creates an AND condition: message must match both patterns.

#### Adding New Node Types

To add a new node type (e.g., "KeywordNode"):

1. **Add to CSpecs.qml**:
   ```qml
   enum NodeType {
       // ... existing
       Keyword = 4
   }
   ```

2. **Create KeywordNode.qml**:
   ```qml
   Node {
       type: CSpecs.NodeType.Keyword
       // ... implementation
   }
   ```

3. **Register in ChatbotScene.qml**:
   ```qml
   nodeTypes: [
       // ... existing
       CSpecs.NodeType.Keyword = "KeywordNode"
   ]
   ```

#### Customizing Chat Interface

Modify `Chatbox.qml` to:
- Change colors and styling
- Add emoji support
- Add message timestamps
- Add user avatars
- Add typing indicators

---

### Troubleshooting

#### Common Issues

1. **No Response from Bot**:
   - Check that nodes are properly connected
   - Verify Regex pattern is correct
   - Ensure Source node receives the message

2. **Regex Not Matching**:
   - Test your regex pattern in an online regex tester
   - Remember the pattern is case-insensitive
   - Check for special characters that need escaping

3. **Multiple Responses**:
   - Ensure only one Source node is connected
   - Check that Result nodes are connected to correct Regex outputs

4. **Chat Not Updating**:
   - Verify `botResponse` signal is connected
   - Check that `addMessage` function is called

#### Debug Tips

- Enable console logging in `ChatbotScene.qml`
- Check node data: `console.log(node.nodeData.data)`
- Verify pattern matching: `console.log(regexNode.matchedPattern)`
- Check signal connections: `console.log("Signal connected:", scene.botResponse)`

---

### Regular Expression Reference

#### Basic Patterns

| Pattern | Matches | Example |
|---------|---------|---------|
| `"hello"` | Exact string | "hello" |
| `"hello\|hi"` | Either string | "hello" or "hi" |
| `"\\d"` | Single digit | "5" |
| `"\\d+"` | One or more digits | "123" |
| `"[a-z]"` | Single lowercase letter | "a" |
| `"[A-Z]+"` | One or more uppercase letters | "HELLO" |
| `"."` | Any single character | "a", "1", "!" |
| `".*"` | Any characters | "anything" |

#### Special Characters

| Character | Meaning |
|-----------|---------|
| `^` | Start of string |
| `$` | End of string |
| `\|` | OR operator |
| `+` | One or more |
| `*` | Zero or more |
| `?` | Zero or one |
| `\\` | Escape character |

#### Common Use Cases

- **Email**: `"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"`
- **Phone**: `"\\d{3}-\\d{3}-\\d{4}"`
- **URL**: `"https?://[^\\s]+"`
- **Greeting**: `"hello\|hi\|hey\|greetings"`

---

### Conclusion

The Chatbot Example demonstrates how to build interactive, rule-based chatbots using NodeLink's visual programming system. Key takeaways:

- **Visual Rule Definition**: Create chatbot logic without writing complex code
- **Pattern Matching**: Use regular expressions for flexible input matching
- **Conditional Logic**: Branch responses based on pattern matching results
- **Real-Time Interaction**: See chatbot responses immediately as you build
- **Extensible Design**: Easy to add new node types and behaviors

This example serves as a foundation for building more sophisticated conversational interfaces, such as:
- Multi-turn conversations
- Context-aware responses
- Natural language processing integration
- Database-backed responses
- Multi-language support

For more examples, see the other examples in the NodeLink repository.

![Final Example](images/ChatBot_Example.png)


## Logic Circuit Example

### Overview

The Logic Circuit Example demonstrates how to build a visual digital logic circuit simulator using NodeLink. This example allows users to create, connect, and test digital logic gates (AND, OR, NOT) in a visual node-based interface. Users can toggle input switches and observe how signals propagate through the circuit in real-time, making it an excellent tool for learning digital logic, designing circuits, and understanding boolean algebra.

![Logic Circuit Overview](images/LogicCircuit_Example1.png)

![Logic Circuit Example](images/LogicCircuit_Example2.png)

---

### a. Purpose and Use Cases

#### Purpose

The Logic Circuit Example demonstrates:

1. **Visual Circuit Design**: Create digital logic circuits using a visual node-based interface without writing code.

2. **Real-Time Signal Propagation**: Observe how boolean signals (true/false) flow through gates and update outputs instantly.

3. **Standard Logic Gates**: Implement fundamental logic gates (AND, OR, NOT) with their standard symbols and truth tables.

4. **Interactive Input/Output**: Toggle input switches and see immediate results on output indicators.

5. **Educational Tool**: Learn digital logic concepts, boolean algebra, and circuit design principles visually.

6. **Gate Symbol Rendering**: Display logic gates using standard digital circuit symbols drawn with Canvas.

#### Use Cases

- **Educational Tool**: Teach digital logic, boolean algebra, and circuit design to students
- **Circuit Prototyping**: Quickly prototype and test logic circuits before implementation
- **Learning Tool**: Understand how logic gates work and how signals propagate
- **Truth Table Verification**: Test and verify truth tables for various gate combinations
- **Circuit Design**: Design and test combinational logic circuits
- **Framework Demonstration**: Showcase NodeLink's capabilities for building interactive simulators

#### Example Scenarios

- **Basic Gate Testing**: Test individual gates (AND, OR, NOT) with different input combinations
- **Combinational Circuits**: Build circuits like half-adders, full-adders, or multiplexers
- **Boolean Expression Implementation**: Convert boolean expressions into visual circuits
- **Signal Propagation**: Observe how signals flow through complex circuits
- **Interactive Learning**: Experiment with different circuit configurations and see results immediately

#### Real-World Applications

- **Digital Electronics Education**: Teach students about digital circuits and logic gates
- **Circuit Design Tools**: Prototype logic circuits before hardware implementation
- **Boolean Logic Visualization**: Visualize boolean expressions and their evaluation
- **Hardware Design**: Design and test logic for FPGAs, microcontrollers, or custom chips
- **Troubleshooting**: Debug logic circuits by visualizing signal flow

![Use Case Diagram](images/LogicCircuit_10996.png) <!-- TODO: Insert diagram showing different use cases -->

---

### b. Node Types Explained

The Logic Circuit Example implements five distinct node types, each representing a fundamental component of digital logic circuits.

#### 1. Input Node (`InputNode`)

**Purpose**: Provides boolean input values (ON/OFF) to the circuit through an interactive toggle switch.

**Type ID**: `LSpecs.NodeType.Input` (0)

**Properties**:
- Contains a single output port
- Has an interactive toggle switch that can be clicked
- Outputs `true` (ON) or `false` (OFF) boolean values
- Acts as the starting point for all signals in the circuit

**Ports**:
- **Output Port**: (Right side) - Emits the current state (true/false)

**Properties**:
- `nodeData.currentState`: Boolean value representing ON (true) or OFF (false)
- `nodeData.output`: Output value (same as currentState)
- `nodeData.displayValue`: String representation ("ON" or "OFF")

**Behavior**:
- Initializes to OFF (false) state
- Clicking the switch toggles between ON and OFF
- When toggled, updates the circuit by calling `scene.updateLogic()`
- Visual indicator shows green for ON, gray for OFF

**Visual Appearance**:
- Icon: Lightning bolt (⚡)
- Toggle Switch: Rounded rectangle with ON/OFF text
- Color: Green (#A6E3A1) when ON, Gray (#585B70) when OFF
- Interactive: Clickable to toggle state

**Usage Example**:
- Click Input node → Toggles from OFF to ON
- Output port emits `true`
- Connected gates receive the signal

![Input Node](images/LogicCircuit_11041.png) <!-- TODO: Insert screenshot of Input node with toggle switch -->

**Truth Table**:
| Input State | Output |
|-------------|--------|
| OFF | false |
| ON | true |

---

#### 2. AND Gate (`AndNode`)

**Purpose**: Performs logical AND operation - output is true only when both inputs are true.

**Type ID**: `LSpecs.NodeType.AND` (1)

**Properties**:
- Has two input ports and one output port
- Implements boolean AND logic: `output = inputA && inputB`
- Uses standard AND gate symbol (flat left side, curved right side)

**Ports**:
- **Input Port A**: (Left side, top)
- **Input Port B**: (Left side, bottom)
- **Output Port**: (Right side)

**Properties**:
- `nodeData.inputA`: First input value (boolean or null)
- `nodeData.inputB`: Second input value (boolean or null)
- `nodeData.output`: Result of AND operation (boolean or null)

**Behavior**:
- Waits for both inputs to be connected and have valid values
- Calculates: `output = inputA && inputB`
- Output is `null` if either input is missing
- Updates automatically when inputs change

**Visual Appearance**:
- Icon: AND symbol (∧)
- Gate Symbol: Standard AND gate shape (flat left, curved right)
- Drawn using Canvas with white fill and black border
- Color: Black border (#000000)

**Usage Example**:
- Input A: true, Input B: true → Output: true
- Input A: true, Input B: false → Output: false
- Input A: false, Input B: true → Output: false
- Input A: false, Input B: false → Output: false

![AND Gate](images/LogicCircuit_11090.png) <!-- TODO: Insert screenshot of AND gate with connections -->

**Truth Table**:
| Input A | Input B | Output |
|---------|---------|--------|
| false | false | false |
| false | true | false |
| true | false | false |
| true | true | true |

**Code Implementation**:
```qml
function updateData() {
    if (nodeData.inputA !== null && nodeData.inputB !== null) {
        nodeData.output = nodeData.inputA && nodeData.inputB;
    } else {
        nodeData.output = null;
    }
}
```

---

#### 3. OR Gate (`OrNode`)

**Purpose**: Performs logical OR operation - output is true when at least one input is true.

**Type ID**: `LSpecs.NodeType.OR` (2)

**Properties**:
- Has two input ports and one output port
- Implements boolean OR logic: `output = inputA || inputB`
- Uses standard OR gate symbol (curved shape on both sides)

**Ports**:
- **Input Port A**: (Left side, top)
- **Input Port B**: (Left side, bottom)
- **Output Port**: (Right side)

**Properties**:
- `nodeData.inputA`: First input value (boolean or null)
- `nodeData.inputB`: Second input value (boolean or null)
- `nodeData.output`: Result of OR operation (boolean or null)

**Behavior**:
- Waits for both inputs to be connected and have valid values
- Calculates: `output = inputA || inputB`
- Output is `null` if either input is missing
- Updates automatically when inputs change

**Visual Appearance**:
- Icon: OR symbol (∨)
- Gate Symbol: Standard OR gate shape (curved on both sides)
- Drawn using Canvas with white fill and black border
- Color: Black border (#000000)

**Usage Example**:
- Input A: true, Input B: true → Output: true
- Input A: true, Input B: false → Output: true
- Input A: false, Input B: true → Output: true
- Input A: false, Input B: false → Output: false

![OR Gate](images/LogicCircuit_11152.png) <!-- TODO: Insert screenshot of OR gate with connections -->

**Truth Table**:
| Input A | Input B | Output |
|---------|---------|--------|
| false | false | false |
| false | true | true |
| true | false | true |
| true | true | true |

**Code Implementation**:
```qml
function updateData() {
    if (nodeData.inputA !== null && nodeData.inputB !== null) {
        nodeData.output = nodeData.inputA || nodeData.inputB;
    } else {
        nodeData.output = null;
    }
}
```

---

#### 4. NOT Gate (`NotNode`)

**Purpose**: Performs logical NOT operation (inversion) - output is the opposite of the input.

**Type ID**: `LSpecs.NodeType.NOT` (3)

**Properties**:
- Has one input port and one output port
- Implements boolean NOT logic: `output = !inputA`
- Uses standard NOT gate symbol (triangle with bubble)

**Ports**:
- **Input Port**: (Left side)
- **Output Port**: (Right side)

**Properties**:
- `nodeData.inputA`: Input value (boolean or null)
- `nodeData.output`: Result of NOT operation (boolean or null)

**Behavior**:
- Waits for input to be connected and have a valid value
- Calculates: `output = !inputA`
- Output is `null` if input is missing
- Updates automatically when input changes

**Visual Appearance**:
- Icon: NOT symbol (~)
- Gate Symbol: Triangle pointing right with a bubble (circle) on the output
- Drawn using Canvas with white fill and black border
- Color: Black border (#000000)

**Usage Example**:
- Input: true → Output: false
- Input: false → Output: true

![NOT Gate](images/LogicCircuit_11210.png) <!-- TODO: Insert screenshot of NOT gate with connections -->

**Truth Table**:
| Input | Output |
|-------|--------|
| false | true |
| true | false |

**Code Implementation**:
```qml
function updateData() {
    if (nodeData.inputA !== null) {
        nodeData.output = !nodeData.inputA;
    } else {
        nodeData.output = null;
    }
}
```

---

#### 5. Output Node (`OutputNode`)

**Purpose**: Displays the final result of the logic circuit as a visual indicator (lamp).

**Type ID**: `LSpecs.NodeType.Output` (4)

**Properties**:
- Contains a single input port
- Displays the boolean value received from connected gates
- Shows visual indicator: Green (ON), Red (OFF), or Gray (UNDEFINED)

**Ports**:
- **Input Port**: (Left side) - Receives the calculated result

**Properties**:
- `nodeData.inputA`: Input value from connected gate (boolean or null)
- `nodeData.displayValue`: String representation ("ON", "OFF", or "UNDEFINED")
- `nodeData.statusColor`: Color for the indicator (green, red, or gray)

**Behavior**:
- Receives input from connected gate or node
- Displays "ON" (green) when input is `true`
- Displays "OFF" (red) when input is `false`
- Displays "UNDEFINED" (gray) when input is `null` or not connected
- Updates automatically when input changes

**Visual Appearance**:
- Icon: Circle (○)
- Indicator: Circular lamp with colored inner circle
- Colors:
  - Green (#4CAF50) for ON (true)
  - Red (#F44336) for OFF (false)
  - Gray (#9E9E9E) for UNDEFINED (null)
- Smooth color transitions when state changes

**Usage Example**:
- Connected to AND gate output → Shows result of AND operation
- Connected to OR gate output → Shows result of OR operation
- Not connected → Shows "UNDEFINED" (gray)

![Output Node](images/LogicCircuit_11271.png) <!-- TODO: Insert screenshot of Output node showing different states -->

**Display States**:
| Input Value | Display | Color |
|-------------|---------|-------|
| true | "ON" | Green (#4CAF50) |
| false | "OFF" | Red (#F44336) |
| null | "UNDEFINED" | Gray (#9E9E9E) |

**Code Implementation**:
```qml
function updateDisplay(value) {
    if (value === null) {
        nodeData.displayValue = "UNDEFINED";
    } else {
        nodeData.displayValue = value ? "ON" : "OFF";
    }
    nodeData.statusColor = getStatusColor(value);
}

function getStatusColor(value) {
    if (value === null) return "#9E9E9E"; // Gray
    return value ? "#4CAF50" : "#F44336"; // Green or Red
}
```

---

#### Node Type Summary Table

| Node Type | Type ID | Input Ports | Output Ports | Operation | Symbol |
|-----------|---------|-------------|--------------|-----------|--------|
| Input | 0 | 0 | 1 | Provides boolean input | ⚡ |
| AND | 1 | 2 | 1 | Logical AND (∧) | ∧ |
| OR | 2 | 2 | 1 | Logical OR (∨) | ∨ |
| NOT | 3 | 1 | 1 | Logical NOT (~) | ~ |
| Output | 4 | 1 | 0 | Displays result | ○ |

---

#### Data Flow Architecture

The logic circuit follows a signal propagation pattern:

```
Input Node (ON/OFF)
    ↓
Logic Gates (AND/OR/NOT)
    ↓
Output Node (Visual Indicator)
```

Signals propagate through the circuit in real-time, updating all downstream gates and outputs automatically.

![Data Flow Diagram](images/LogicCircuit_11325.png) <!-- TODO: Insert diagram showing signal propagation through gates -->

---

### c. Step-by-Step Building Guide

This guide will walk you through building the Logic Circuit Example from scratch, explaining each component and how they work together.

#### Prerequisites

- Qt 6.2.4 or later (Qt 6.10.0 recommended)
- CMake 3.1.0 or later
- C++ compiler with C++14 support (MSVC 2019/2022 on Windows)
- NodeLink framework built and installed
- QtQuickStream module built and installed
- Basic understanding of boolean logic (helpful but not required)

#### Step 1: Project Setup

##### 1.1 Create Project Structure

Create the following directory structure:

```
logicCircuit/
├── CMakeLists.txt
├── main.cpp
├── main.qml
└── resources/
    ├── Core/
    ├── View/
    └── fonts/
```

##### 1.2 Configure CMakeLists.txt

Create `CMakeLists.txt` with the following configuration:

```cmake
cmake_minimum_required(VERSION 3.1.0)

set(MODULE_NAME LogicCircuit)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Create executable
qt_add_executable(${MODULE_NAME} main.cpp)

# Set LSpecs as singleton
set_source_files_properties(
    resources/Core/LSpecs.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# Define QML module
qt_add_qml_module(${MODULE_NAME}
    URI "LogicCircuit"
    VERSION 1.0
    QML_FILES
        main.qml
        resources/Core/LSpecs.qml
        resources/Core/LogicCircuitScene.qml
        resources/Core/InputNode.qml
        resources/Core/LogicNode.qml
        resources/Core/AndNode.qml
        resources/Core/OrNode.qml
        resources/Core/NotNode.qml
        resources/Core/OutputNode.qml
        resources/Core/LogicNodeData.qml
        resources/View/LogicCircuitView.qml
        resources/View/LogicCircuitNodeView.qml
    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
)

target_include_directories(${MODULE_NAME} PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_link_libraries(${MODULE_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
```

**Key Points**:
- Links to `NodeLinkplugin` and `QtQuickStreamplugin`
- Sets `LSpecs.qml` as a singleton for global access
- Includes Font Awesome fonts for icons
- Includes `LogicNode.qml` as a base class

---

#### Step 2: Create Specifications (LSpecs.qml)

Create `resources/Core/LSpecs.qml` - a singleton that defines node type constants:

```qml
pragma Singleton
import QtQuick

QtObject {
    enum NodeType {
        Input   = 0,
        AND     = 1,
        OR      = 2,
        NOT     = 3,
        Output  = 4,
        Logic   = 5,
        Unknown = 99
    }

    enum OperationType {
        AND     = 0,
        OR      = 1,
        NOT     = 2,
        Unknown = 99
    }

    enum BooleanState {
        FALSE = 0,
        TRUE  = 1,
        UNDEFINED = 2
    }
}
```

**Purpose**: Provides type-safe constants for node types, operations, and boolean states.

---

#### Step 3: Create Node Data Models

##### 3.1 LogicNodeData.qml

Create `resources/Core/LogicNodeData.qml` - data model for logic nodes:

```qml
import QtQuick
import NodeLink

I_NodeData {
    // Input values for logic gates
    property var inputA: null
    property var inputB: null

    // Output value
    property var output: null

    // For InputNode: current state (true=ON, false=OFF)
    property bool currentState: false

    // For display purposes
    property string displayValue: "OFF"

    // Status color for visualization (used by OutputNode)
    property color statusColor: "#9E9E9E"
}
```

**Purpose**: Extends `I_NodeData` to store input/output values and display information for logic gates.

---

#### Step 4: Create Base Node Type

##### 4.1 LogicNode.qml

Create `resources/Core/LogicNode.qml` - base class for all logic nodes:

```qml
import QtQuick
import NodeLink
import LogicCircuit

Node {
    id: root
    property int nodeType: LSpecs.NodeType.AND

    type: LSpecs.NodeType.Logic
    nodeData: LogicNodeData {}

    property var logicScene: null

    guiConfig.autoSize: false
    guiConfig.minWidth: 20
    guiConfig.minHeight: 20

    Component.onCompleted: {
        addPorts();
    }

    function addPorts() {
        if (nodeType == LSpecs.NodeType.OR || nodeType == LSpecs.NodeType.AND) {
            addPortsInput();
            addPortsInput();
            addPortsOutput();
        } else if (nodeType == LSpecs.NodeType.Input) {
            addPortsOutput();
        } else if (nodeType == LSpecs.NodeType.Output) {
            addPortsInput();
        } else if (nodeType == LSpecs.NodeType.NOT) {
            addPortsInput();
            addPortsOutput();
        }
    }

    function addPortsInput() {
        let inputPort = NLCore.createPort();
        inputPort.portType = NLSpec.PortType.Input;
        inputPort.portSide = NLSpec.PortPositionSide.Left;
        inputPort.title = "";
        addPort(inputPort);
    }

    function addPortsOutput() {
        let outputPort = NLCore.createPort();
        outputPort.portType = NLSpec.PortType.Output;
        outputPort.portSide = NLSpec.PortPositionSide.Right;
        outputPort.title = "";
        addPort(outputPort);
    }
}
```

**Key Features**:
- Base class for all logic nodes
- Dynamically adds ports based on node type
- AND/OR gates: 2 inputs, 1 output
- NOT gate: 1 input, 1 output
- Input node: 1 output
- Output node: 1 input

---

#### Step 5: Create Specific Node Types

##### 5.1 InputNode.qml

Create `resources/Core/InputNode.qml`:

```qml
import QtQuick
import NodeLink
import LogicCircuit

LogicNode {
    nodeType: LSpecs.NodeType.Input

    Component.onCompleted: {
        nodeData.currentState = false;
        nodeData.output = false;
        nodeData.displayValue = "OFF";
    }

    function toggleState() {
        nodeData.currentState = !nodeData.currentState;
        nodeData.output = nodeData.currentState;
        nodeData.displayValue = nodeData.currentState ? "ON" : "OFF";

        // Update the entire circuit
        var mainScene = _qsRepo ? _qsRepo.qsRootObject : null;
        if (mainScene && mainScene.updateLogic) {
            mainScene.updateLogic();
        }
    }
}
```

**Key Features**:
- Toggleable switch for ON/OFF state
- Updates circuit when toggled
- Initializes to OFF state

---

##### 5.2 AndNode.qml

Create `resources/Core/AndNode.qml`:

```qml
import QtQuick
import NodeLink
import LogicCircuit

LogicNode {
    nodeType: LSpecs.NodeType.AND

    function updateData() {
        if (nodeData.inputA !== null && nodeData.inputB !== null) {
            nodeData.output = nodeData.inputA && nodeData.inputB;
        } else {
            nodeData.output = null;
        }
    }
}
```

**Key Features**:
- Implements AND logic: `output = inputA && inputB`
- Returns null if inputs are incomplete

---

##### 5.3 OrNode.qml

Create `resources/Core/OrNode.qml`:

```qml
import QtQuick
import NodeLink
import LogicCircuit

LogicNode {
    nodeType: LSpecs.NodeType.OR

    function updateData() {
        if (nodeData.inputA !== null && nodeData.inputB !== null) {
            nodeData.output = nodeData.inputA || nodeData.inputB;
        } else {
            nodeData.output = null;
        }
    }
}
```

**Key Features**:
- Implements OR logic: `output = inputA || inputB`
- Returns null if inputs are incomplete

---

##### 5.4 NotNode.qml

Create `resources/Core/NotNode.qml`:

```qml
import QtQuick
import NodeLink
import LogicCircuit

LogicNode {
    nodeType: LSpecs.NodeType.NOT

    function updateData() {
        if (nodeData.inputA !== null) {
            nodeData.output = !nodeData.inputA;
        } else {
            nodeData.output = null;
        }
    }
}
```

**Key Features**:
- Implements NOT logic: `output = !inputA`
- Returns null if input is missing

---

##### 5.5 OutputNode.qml

Create `resources/Core/OutputNode.qml`:

```qml
import QtQuick
import NodeLink
import LogicCircuit

LogicNode {
    nodeType: LSpecs.NodeType.Output

    property color undefinedColor: "#9E9E9E"
    property color offColor: "#F44336"
    property color onColor: "#4CAF50"

    Component.onCompleted: {
        guiConfig.color = "#2A2A2A";
        updateDisplay(nodeData.inputA);
    }

    function updateDisplay(value) {
        if (value === null) {
            nodeData.displayValue = "UNDEFINED";
        } else {
            nodeData.displayValue = value ? "ON" : "OFF";
        }
        nodeData.statusColor = getStatusColor(value);
    }

    function getStatusColor(value) {
        if (value === null) return undefinedColor;
        return value ? onColor : offColor;
    }

    function updateData() {
        updateDisplay(nodeData.inputA);
    }
}
```

**Key Features**:
- Displays input value as colored indicator
- Green for ON, Red for OFF, Gray for UNDEFINED
- Smooth color transitions

---

#### Step 6: Create the Scene

##### 6.1 LogicCircuitScene.qml

Create `resources/Core/LogicCircuitScene.qml` - the main scene that manages nodes, links, and signal propagation:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import LogicCircuit

I_Scene {
    id: scene

    property color borderColor: "#000000"

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["LogicCircuit"]
        defaultNode: LSpecs.NodeType.Input
        
        nodeTypes: [
            LSpecs.NodeType.Input   = "InputNode",
            LSpecs.NodeType.AND     = "AndNode",
            LSpecs.NodeType.OR      = "OrNode",
            LSpecs.NodeType.NOT     = "NotNode",
            LSpecs.NodeType.Output  = "OutputNode"
        ]
        
        nodeNames: [
            LSpecs.NodeType.Input   = "Input",
            LSpecs.NodeType.AND     = "AND Gate",
            LSpecs.NodeType.OR      = "OR Gate",
            LSpecs.NodeType.NOT     = "NOT Gate",
            LSpecs.NodeType.Output  = "Output"
        ]
        
        nodeIcons: [
            LSpecs.NodeType.Input   = "⚡",
            LSpecs.NodeType.AND     = "∧",
            LSpecs.NodeType.OR      = "∨",
            LSpecs.NodeType.NOT     = "~",
            LSpecs.NodeType.Output  = "○"
        ]
        
        nodeColors: [
            LSpecs.NodeType.Input   = borderColor,
            LSpecs.NodeType.AND     = borderColor,
            LSpecs.NodeType.OR      = borderColor,
            LSpecs.NodeType.NOT     = borderColor,
            LSpecs.NodeType.Output  = borderColor
        ]
    }

    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    property UndoCore _undoCore: UndoCore {
        scene: scene
    }

    // Update logic when connections change
    onLinkRemoved: updateLogic();
    onNodeRemoved: updateLogic();
    onLinkAdded: updateLogic();

    function createCustomizeNode(nodeType, xPos, yPos) {
        var title = nodeRegistry.nodeNames[nodeType] + "_" +
                   (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(nodeRegistry.imports, nodeType,
                                 nodeRegistry.nodeTypes[nodeType],
                                 nodeRegistry.nodeColors[nodeType],
                                 title, xPos, yPos);
    }

    // Update all logic in the circuit
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

        // Track connections to prevent same upstream node connecting to multiple inputs
        var connectionMap = {};

        // Propagate values through the circuit (iterative approach)
        var maxIterations = 999;
        var changed = true;

        for (var i = 0; i < maxIterations && changed; i++) {
            changed = false;

            Object.values(links).forEach(link => {
                var upstreamNode = findNode(link.inputPort._qsUuid);
                var downstreamNode = findNode(link.outputPort._qsUuid);

                if (upstreamNode && downstreamNode && upstreamNode.nodeData.output !== null) {
                    var connectionKey = downstreamNode._qsUuid + "_" + upstreamNode._qsUuid;

                    // Handle 2-input gates (AND, OR)
                    if (downstreamNode.type === LSpecs.NodeType.AND ||
                        downstreamNode.type === LSpecs.NodeType.OR) {
                        
                        if (downstreamNode.nodeData.inputA === null && !connectionMap[connectionKey + "_A"]) {
                            downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                            connectionMap[connectionKey + "_A"] = true;
                            changed = true;
                        } else if (downstreamNode.nodeData.inputB === null && !connectionMap[connectionKey + "_B"]) {
                            // Ensure inputB comes from a different node than inputA
                            var inputAUpstream = null;
                            Object.keys(connectionMap).forEach(key => {
                                if (key.startsWith(downstreamNode._qsUuid) && key.endsWith("_A")) {
                                    var upstreamId = key.split("_")[1];
                                    inputAUpstream = upstreamId;
                                }
                            });

                            if (inputAUpstream !== upstreamNode._qsUuid) {
                                downstreamNode.nodeData.inputB = upstreamNode.nodeData.output;
                                connectionMap[connectionKey + "_B"] = true;
                                changed = true;
                            }
                        }

                    // Handle single-input gates (NOT, Output)
                    } else if (downstreamNode.type === LSpecs.NodeType.NOT ||
                              downstreamNode.type === LSpecs.NodeType.Output) {
                        if (downstreamNode.nodeData.inputA === null) {
                            downstreamNode.nodeData.inputA = upstreamNode.nodeData.output;
                            changed = true;
                        }
                    }

                    // Update downstream node if it has all required inputs
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

    // Link validation
    function linkNodes(portA, portB) {
        if (canLinkNodes(portA, portB)) {
            createLink(portA, portB);
            updateLogic();
        }
    }

    function canLinkNodes(portA, portB) {
        if (portA.length === 0 || portB.length === 0) return false;

        var portAObj = findPort(portA);
        var portBObj = findPort(portB);

        if (portAObj.portType !== NLSpec.PortType.Output) return false;
        if (portBObj.portType !== NLSpec.PortType.Input) return false;

        // Prevent duplicate links
        var sameLinks = Object.values(links).filter(link =>
            link.inputPort._qsUuid === portA && link.outputPort._qsUuid === portB);
        if (sameLinks.length > 0) return false;

        // Input port can only have one connection
        var portBObjLinks = Object.values(links).filter(link =>
            link.outputPort._qsUuid === portB);
        if (portBObjLinks.length > 0) return false;

        // Prevent self-connection
        var nodeA = findNodeId(portA);
        var nodeB = findNodeId(portB);
        if (nodeA === nodeB) return false;

        return true;
    }
}
```

**Key Features**:
- **Node Registry**: Defines all gate types with symbols and colors
- **Signal Propagation**: Iterative algorithm that propagates signals through the circuit
- **Connection Management**: Prevents same upstream node from connecting to multiple inputs of same gate
- **Real-Time Updates**: Updates all gates when connections or inputs change

**Signal Propagation Algorithm**:
1. Reset all gate inputs/outputs
2. Iteratively propagate signals from inputs to outputs
3. For each link, if upstream has output, set downstream input
4. Update downstream gate if all inputs are ready
5. Repeat until no more changes occur (or max iterations)

![Scene Architecture](images/LogicCircuit_11965.png) <!-- TODO: Insert diagram showing scene structure and signal propagation -->

---

#### Step 7: Create Views

##### 7.1 LogicCircuitNodeView.qml

Create `resources/View/LogicCircuitNodeView.qml` - custom view that renders gate symbols:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import LogicCircuit

NodeView {
    id: nodeView

    // Remove default rectangle background
    color: "transparent"
    border.width: 0
    radius: 0
    isResizable: false

    contentItem: Item {
        // Input Node: Toggle switch
        Rectangle {
            anchors.centerIn: parent
            visible: node.type === LSpecs.NodeType.Input
            width: Math.min(44, parent.width * 0.8)
            height: Math.min(22, parent.height * 0.4)
            radius: height / 2
            color: node.nodeData.currentState ? "#A6E3A1" : "#585B70"
            border.color: Qt.darker(color, 1.2)
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: node.nodeData.currentState ? "ON" : "OFF"
                color: "#1E1E2E"
                font.bold: true
                font.pixelSize: Math.max(8, parent.height * 0.4)
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: node.toggleState && node.toggleState()
            }
        }

        // Output Node: Lamp indicator
        Rectangle {
            anchors.centerIn: parent
            visible: node.type === LSpecs.NodeType.Output
            width: Math.min(30, parent.width * 0.6)
            height: Math.min(30, parent.height * 0.6)
            radius: width / 2
            color: "white"
            border.color: "#2A2A2A"
            border.width: 2

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: parent.height * 0.6
                radius: width / 2
                color: node.nodeData ? node.nodeData.statusColor : "#9E9E9E"

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
        }

        // Gate symbols (AND, OR, NOT) using Canvas
        Loader {
            id: gateLoader
            anchors.fill: parent
            sourceComponent: {
                switch (node.type) {
                case LSpecs.NodeType.AND:  return andGate
                case LSpecs.NodeType.OR:   return orGate
                case LSpecs.NodeType.NOT:  return notGate
                default: return null
                }
            }
        }

        // AND Gate Component
        Component {
            id: andGate
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var centerY = height / 2;
                    var radius = (height - 2 * margin) / 2;
                    var flatRightX = width - margin - radius;

                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.lineTo(flatRightX, topY);
                    ctx.arc(flatRightX, centerY, radius, -Math.PI/2, Math.PI/2, false);
                    ctx.lineTo(leftX, bottomY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                }
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }
        }

        // OR Gate Component
        Component {
            id: orGate
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var rightX = width - margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var midY = height / 2;

                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.quadraticCurveTo(rightX, topY, rightX, midY);
                    ctx.quadraticCurveTo(rightX, bottomY, leftX, bottomY);
                    ctx.quadraticCurveTo(leftX + (width * 0.3), midY, leftX, topY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();
                }
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }
        }

        // NOT Gate Component
        Component {
            id: notGate
            Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    ctx.clearRect(0, 0, width, height);

                    ctx.fillStyle = "white";
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;

                    var margin = width * 0.05;
                    var leftX = margin;
                    var topY = margin;
                    var bottomY = height - margin;
                    var midY = height / 2;
                    var triangleRight = width - margin - (width * 0.2);
                    var bubbleRadius = Math.min(6, height * 0.1);

                    // Triangle
                    ctx.beginPath();
                    ctx.moveTo(leftX, topY);
                    ctx.lineTo(triangleRight, midY);
                    ctx.lineTo(leftX, bottomY);
                    ctx.closePath();
                    ctx.fill();
                    ctx.stroke();

                    // Bubble
                    ctx.beginPath();
                    ctx.arc(triangleRight + bubbleRadius * 1.5, midY, bubbleRadius, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.stroke();
                }
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()
            }
        }
    }
}
```

**Key Features**:
- **Gate Symbols**: Renders standard logic gate symbols using Canvas
- **Input Switch**: Interactive toggle switch for Input nodes
- **Output Lamp**: Colored indicator for Output nodes
- **No Background**: Transparent background to show only gate symbols

![Gate Symbols](images/LogicCircuit_12177.png) <!-- TODO: Insert screenshot showing all gate symbols -->

---

##### 7.2 LogicCircuitView.qml

Create `resources/View/LogicCircuitView.qml` - main view container:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream
import LogicCircuit

Item {
    id: view
    property LogicCircuitScene scene

    property SceneSession sceneSession: SceneSession {
        enabledOverview: false
        doNodesNeedImage: false
    }

    // Nodes Scene (flickable canvas)
    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("LogicCircuitNodeView.qml")
        }
    }

    // Side menu for adding nodes
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }
}
```

**Key Features**:
- **NodesScene**: Provides the scrollable canvas for gates
- **SideMenu**: Allows users to add new gates to the circuit
- **SceneSession**: Manages view state and interactions

---

#### Step 8: Create Main Application

##### 8.1 main.cpp

Create `main.cpp`:

```cpp
#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");
    engine.addImportPath(":/");

    const QUrl url(u"qrc:/LogicCircuit/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

---

##### 8.2 main.qml

Create `main.qml`:

```qml
import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls

import QtQuickStream
import NodeLink
import LogicCircuit

Window {
    id: window
    property LogicCircuitScene scene: null

    width: 1280
    height: 960
    visible: true
    title: qsTr("Logic Circuit Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "LogicCircuit"])
        NLCore.defaultRepo.initRootObject("LogicCircuitScene");
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });
    }

    // Load Font Awesome fonts
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/LogicCircuit/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }

    // Main view
    LogicCircuitView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
```

**Key Features**:
- **Dark Theme**: Material Dark theme with custom accent color
- **Scene Initialization**: Creates the LogicCircuitScene using QtQuickStream
- **Full-Screen View**: LogicCircuitView fills the window

![Main Application Layout](images/frame1.png)

---

#### Step 9: Build and Run

##### 9.1 Configure Build

1. Create a build directory:
   ```bash
   mkdir build
   cd build
   ```

2. Configure with CMake:
   ```bash
   cmake .. -DCMAKE_PREFIX_PATH=<Qt_Install_Path>
   ```

3. Build the project:
   ```bash
   cmake --build .
   ```

##### 9.2 Run the Application

Run the executable:
```bash
./LogicCircuit  # Linux/Mac
LogicCircuit.exe  # Windows
```

---

#### Step 10: Using the Logic Circuit

##### Basic Usage

1. **Add Nodes**: 
   - Click the side menu to add gates
   - You'll need: Input nodes, Logic gates (AND/OR/NOT), Output nodes

2. **Connect Gates**:
   - Click and drag from an output port (right side)
   - Release on an input port (left side)
   - A link will be created if the connection is valid

3. **Toggle Inputs**:
   - Click on Input nodes to toggle between ON and OFF
   - The circuit updates automatically

4. **Observe Outputs**:
   - Output nodes show the result:
     - Green = ON (true)
     - Red = OFF (false)
     - Gray = UNDEFINED (not connected or invalid)

![Node Connection Example](images/LogicCircuit_12377.png) <!-- TODO: Insert screenshot showing connected gates -->

##### Example: Simple AND Circuit

**Setup**:
1. Add two Input nodes
2. Add one AND gate
3. Add one Output node

**Connections**:
- Input 1 → AND (input A)
- Input 2 → AND (input B)
- AND → Output

**Test**:
- Both Inputs ON → Output: Green (ON)
- One Input OFF → Output: Red (OFF)
- Both Inputs OFF → Output: Red (OFF)

##### Example: OR Circuit

**Setup**:
1. Add two Input nodes
2. Add one OR gate
3. Add one Output node

**Connections**:
- Input 1 → OR (input A)
- Input 2 → OR (input B)
- OR → Output

**Test**:
- At least one Input ON → Output: Green (ON)
- Both Inputs OFF → Output: Red (OFF)

##### Example: NOT Circuit

**Setup**:
1. Add one Input node
2. Add one NOT gate
3. Add one Output node

**Connections**:
- Input → NOT
- NOT → Output

**Test**:
- Input ON → Output: Red (OFF) - inverted
- Input OFF → Output: Green (ON) - inverted

##### Example: Complex Circuit (A AND (B OR C))

**Setup**:
1. Add three Input nodes (A, B, C)
2. Add one OR gate
3. Add one AND gate
4. Add one Output node

**Connections**:
- Input B → OR (input A)
- Input C → OR (input B)
- Input A → AND (input A)
- OR → AND (input B)
- AND → Output

**Test**:
- A=ON, B=ON, C=OFF → Output: Green (ON)
- A=ON, B=OFF, C=ON → Output: Green (ON)
- A=OFF, B=ON, C=ON → Output: Red (OFF)
- A=ON, B=OFF, C=OFF → Output: Red (OFF)

![Example Workflow](images/frame2.png)

---

### Architecture Overview

#### Component Hierarchy

```
LogicCircuitScene (I_Scene)
├── NodeRegistry (defines gate types)
├── SelectionModel (manages selection)
├── UndoCore (undo/redo support)
└── Nodes & Links
    ├── InputNode (toggle switches)
    ├── Logic Gates (AND, OR, NOT)
    └── OutputNode (visual indicators)

LogicCircuitView
├── NodesScene (canvas)
│   └── NodesRect (renders gates)
│       └── LogicCircuitNodeView (custom gate UI)
└── SideMenu (add gates)
```

#### Signal Propagation

The circuit uses an iterative propagation algorithm:

1. **Reset Phase**: All gate inputs/outputs are reset to null
2. **Propagation Phase**: 
   - For each link, if upstream has output, set downstream input
   - Update downstream gate if all inputs are ready
   - Repeat until no more changes occur
3. **Update Phase**: All gates calculate their outputs based on inputs

This ensures signals propagate correctly through the circuit, even with complex topologies.

![Architecture Diagram](images/LogicCircuit_12486.png) <!-- TODO: Insert comprehensive architecture diagram -->

---

### Key Concepts

#### Boolean Logic

The circuit implements fundamental boolean operations:

- **AND**: Output is true only when both inputs are true
- **OR**: Output is true when at least one input is true
- **NOT**: Output is the inverse of the input

#### Signal Propagation

Signals flow from Input nodes through gates to Output nodes:
- Input nodes provide boolean values (true/false)
- Gates process inputs and produce outputs
- Output nodes display the final result

#### Gate Symbols

Gates are rendered using standard digital circuit symbols:
- **AND**: Flat left side, curved right side
- **OR**: Curved on both sides
- **NOT**: Triangle with bubble on output

#### Connection Rules

- Each input port can only have one connection
- Output ports can connect to multiple inputs
- Cannot create cycles (prevents infinite loops)
- Cannot connect a node to itself

---

### Extending the Logic Circuit

#### Adding New Gates

To add a new gate (e.g., NAND, NOR, XOR):

1. **Add to LSpecs.qml**:
   ```qml
   enum NodeType {
       // ... existing
       NAND = 5,
       NOR = 6,
       XOR = 7
   }
   ```

2. **Create NandNode.qml**:
   ```qml
   import QtQuick
   import NodeLink
   import LogicCircuit

   LogicNode {
       nodeType: LSpecs.NodeType.NAND

       function updateData() {
           if (nodeData.inputA !== null && nodeData.inputB !== null) {
               nodeData.output = !(nodeData.inputA && nodeData.inputB);
           } else {
               nodeData.output = null;
           }
       }
   }
   ```

3. **Add Canvas Component** in LogicCircuitNodeView.qml for the symbol

4. **Register in LogicCircuitScene.qml**

#### Customizing Gate Appearance

- Modify Canvas drawing code in `LogicCircuitNodeView.qml`
- Change colors in `OutputNode.qml`
- Adjust sizes in `LogicNode.qml` guiConfig

#### Adding Truth Table Display

Create a component that shows the truth table for selected gates:
- Display all input combinations
- Show corresponding outputs
- Update in real-time as inputs change

---

### Troubleshooting

#### Common Issues

1. **Output Shows UNDEFINED**:
   - Check that all inputs are connected
   - Verify gates have all required inputs
   - Ensure Input nodes are toggled ON/OFF

2. **Signals Not Propagating**:
   - Check for cycles in the circuit
   - Verify connections are valid
   - Ensure gates have all inputs connected

3. **Gate Not Updating**:
   - Toggle an Input node to trigger update
   - Check that connections are properly established
   - Verify gate has all required inputs

4. **Visual Issues**:
   - Gate symbols not rendering: Check Canvas code
   - Colors not updating: Verify statusColor property
   - Ports not visible: Check port creation code

#### Debug Tips

- Enable console logging in `LogicCircuitScene.qml`
- Check node data: `console.log(node.nodeData.output)`
- Verify connections: `console.log(link.inputPort, link.outputPort)`
- Monitor signal propagation: Add logs in `updateLogic()`

---

### Truth Tables Reference

#### AND Gate
| A | B | Output |
|---|---|--------|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

#### OR Gate
| A | B | Output |
|---|---|--------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

#### NOT Gate
| A | Output |
|---|--------|
| 0 | 1 |
| 1 | 0 |

#### Common Combinations

**NAND (NOT AND)**: `!(A && B)`
| A | B | Output |
|---|---|--------|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

**NOR (NOT OR)**: `!(A || B)`
| A | B | Output |
|---|---|--------|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |

**XOR (Exclusive OR)**: `(A && !B) || (!A && B)`
| A | B | Output |
|---|---|--------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

---

### Conclusion

The Logic Circuit Example demonstrates how to build an interactive digital logic simulator using NodeLink. Key takeaways:

- **Visual Circuit Design**: Create logic circuits without writing code
- **Real-Time Simulation**: See signal propagation instantly
- **Standard Symbols**: Use industry-standard gate symbols
- **Educational Value**: Learn digital logic concepts visually
- **Extensible Design**: Easy to add new gates and features

This example serves as a foundation for building more sophisticated circuit simulators, such as:
- Sequential logic circuits (flip-flops, registers)
- Arithmetic circuits (adders, multipliers)
- Memory circuits
- Complex digital systems

For more examples, see the other examples in the NodeLink repository.

![Final Example](images/LogicCircuit_Example2.png)


## Performance Analyzer Example

### Overview

The Performance Analyzer Example is a benchmarking and stress-testing tool designed to evaluate NodeLink's performance under various load conditions. This example allows you to create large numbers of nodes and links programmatically, measure operation times, and monitor system performance metrics. It's an essential tool for developers who want to understand NodeLink's scalability, optimize their applications, or test the framework's limits.

![Performance Analyzer Overview](images/PerformanceAnalyzer_Example1.png)

![Performance Analyzer in Action](images/PerformanceAnalyzer_Example2.png)

---

### a. Purpose and Use Cases

#### Purpose

The Performance Analyzer Example demonstrates:

1. **Performance Benchmarking**: Measure NodeLink's performance when handling large numbers of nodes and links.

2. **Stress Testing**: Test the framework's limits by creating thousands of nodes and connections.

3. **Batch Operations**: Create multiple nodes and links efficiently using batch creation methods.

4. **Performance Monitoring**: Real-time monitoring of scene statistics (node count, link count, selection count).

5. **Operation Timing**: Measure execution time for critical operations like node creation, selection, and scene clearing.

6. **Scalability Analysis**: Understand how NodeLink performs with different scene sizes and configurations.

#### Use Cases

- **Framework Development**: Test NodeLink's performance during development and optimization
- **Performance Optimization**: Identify bottlenecks and optimize node/link creation and management
- **Stress Testing**: Verify that NodeLink can handle large-scale scenes without performance degradation
- **Benchmarking**: Compare performance across different versions or configurations
- **Capacity Planning**: Determine maximum scene sizes for production applications
- **Debugging**: Identify performance issues in custom node-based applications

#### Example Scenarios

- **Mass Node Creation**: Create 100, 1000, or 10000 node pairs and measure creation time
- **Selection Performance**: Test selection/deselection performance with large scenes
- **Scene Clearing**: Measure time to clear large scenes
- **Viewport Testing**: Test performance when nodes are spawned inside vs. across the entire scene
- **Memory Profiling**: Monitor memory usage with different scene sizes

#### Real-World Applications

- **Large-Scale Visualizations**: Test performance for applications with many nodes (data visualization, network diagrams)
- **Complex Workflows**: Benchmark performance for workflow builders with hundreds of steps
- **Real-Time Applications**: Ensure smooth performance for applications requiring frequent updates
- **Production Planning**: Determine optimal scene sizes for production deployments

![Use Case Diagram](images/PerformanceAnalyzer_12737.png) <!-- TODO: Insert diagram showing different use cases -->

---

### b. Node Types Explained

The Performance Analyzer Example implements two simple node types designed for performance testing rather than functional complexity.

#### 1. Start Node (`StartNode`)

**Purpose**: A simple node with an output port, used as the starting point in node pairs for performance testing.

**Type ID**: `CSpecs.NodeType.StartNode` (0)

**Properties**:
- Contains a single output port
- Minimal implementation for performance testing
- Acts as the source node in test pairs

**Ports**:
- **Output Port**: (Right side) - Emits data to connected End nodes

**Properties**:
- `guiConfig.width`: 100 pixels
- `guiConfig.height`: 100 pixels
- `guiConfig.color`: Gray (#444444)

**Behavior**:
- Simple node with minimal overhead
- Designed for fast creation and rendering
- Used in pairs with End nodes for link testing

**Visual Appearance**:
- Icon: Play button (Font Awesome \uf04b)
- Color: Gray (#444)
- Size: 100x100 pixels (fixed)

**Usage**: Created programmatically in batches for performance testing.

![Start Node](images/PerformanceAnalyzer_12776.png) <!-- TODO: Insert screenshot of Start node -->

---

#### 2. End Node (`EndNode`)

**Purpose**: A simple node with an input port, used as the endpoint in node pairs for performance testing.

**Type ID**: `CSpecs.NodeType.EndNode` (1)

**Properties**:
- Contains a single input port
- Minimal implementation for performance testing
- Acts as the destination node in test pairs

**Ports**:
- **Input Port**: (Left side) - Receives data from connected Start nodes

**Properties**:
- `guiConfig.width`: 100 pixels
- `guiConfig.height`: 100 pixels
- `guiConfig.color`: Gray (#444444)

**Behavior**:
- Simple node with minimal overhead
- Designed for fast creation and rendering
- Used in pairs with Start nodes for link testing

**Visual Appearance**:
- Icon: Stop button (Font Awesome \uf11e)
- Color: Gray (#444)
- Size: 100x100 pixels (fixed)

**Usage**: Created programmatically in batches for performance testing.

![End Node](images/PerformanceAnalyzer_12811.png) <!-- TODO: Insert screenshot of End node -->

---

#### Node Pair Structure

For performance testing, nodes are created in pairs:
- **Start Node**: Output port on the right
- **End Node**: Input port on the left
- **Link**: Connects Start output to End input

This simple structure allows testing:
- Node creation performance
- Link creation performance
- Scene rendering performance
- Selection performance

![Node Pair](images/PerformanceAnalyzer_12828.png) <!-- TODO: Insert screenshot showing a Start-End node pair with link -->

---

#### Node Type Summary Table

| Node Type | Type ID | Input Ports | Output Ports | Purpose |
|-----------|---------|-------------|--------------|---------|
| Start | 0 | 0 | 1 | Source node for testing |
| End | 1 | 1 | 0 | Destination node for testing |

---

### c. Step-by-Step Building Guide

This guide will walk you through building the Performance Analyzer Example from scratch, explaining each component and how they work together.

#### Prerequisites

- Qt 6.2.4 or later (Qt 6.10.0 recommended)
- CMake 3.1.0 or later
- C++ compiler with C++14 support (MSVC 2019/2022 on Windows)
- NodeLink framework built and installed
- QtQuickStream module built and installed

#### Step 1: Project Setup

##### 1.1 Create Project Structure

Create the following directory structure:

```
performanceAnalyzer/
├── CMakeLists.txt
├── main.cpp
├── Main.qml
└── resources/
    ├── Core/
    ├── View/
    └── fonts/
```

##### 1.2 Configure CMakeLists.txt

Create `CMakeLists.txt` with the following configuration:

```cmake
cmake_minimum_required(VERSION 3.1.0)
set(MODULE_NAME PerformanceAnalyzer)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Create executable
qt_add_executable(${MODULE_NAME} main.cpp)

# Set CSpecs as singleton
set_source_files_properties(
    resources/Core/CSpecs.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# Define QML module
qt_add_qml_module(${MODULE_NAME}
    URI ${MODULE_NAME}
    VERSION 1.0
    QML_FILES
        Main.qml
        resources/Core/CSpecs.qml
        resources/Core/StartNode.qml
        resources/Core/EndNode.qml
        resources/Core/PerformanceScene.qml
        resources/View/PerformanceAnalyzerView.qml
    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
)

target_include_directories(${MODULE_NAME} PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_link_libraries(${MODULE_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
```

**Key Points**:
- Links to `NodeLinkplugin` and `QtQuickStreamplugin`
- Sets `CSpecs.qml` as a singleton for global access
- Includes Font Awesome fonts for icons

---

#### Step 2: Create Specifications (CSpecs.qml)

Create `resources/Core/CSpecs.qml` - a singleton that defines node type constants:

```qml
pragma Singleton
import QtQuick

QtObject {
    enum NodeType {
        StartNode = 0,
        EndNode = 1
    }
}
```

**Purpose**: Provides type-safe constants for node types used in performance testing.

---

#### Step 3: Create Node Types

##### 3.1 StartNode.qml

Create `resources/Core/StartNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.StartNode
    nodeData: I_NodeData {}

    guiConfig.width: 100
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right
        _port1.enable = true
        addPort(_port1);
    }
}
```

**Key Features**:
- Single output port on the right side
- Fixed size (100x100) for consistent performance
- Minimal implementation for fast creation

---

##### 3.2 EndNode.qml

Create `resources/Core/EndNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.EndNode
    nodeData: I_NodeData {}

    guiConfig.width: 100
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable = false
        addPort(_port1);
    }
}
```

**Key Features**:
- Single input port on the left side
- Fixed size (100x100) for consistent performance
- Minimal implementation for fast creation

---

#### Step 4: Create the Scene

##### 4.1 PerformanceScene.qml

Create `resources/Core/PerformanceScene.qml` - the main scene with batch creation methods:

```qml
import QtQuick
import NodeLink
import PerformanceAnalyzer
import QtQuickStream

Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["PerformanceAnalyzer"]
        defaultNode: CSpecs.NodeType.StartNode
        
        nodeTypes: [
            CSpecs.NodeType.StartNode = "StartNode",
            CSpecs.NodeType.EndNode = "EndNode"
        ];
        
        nodeNames: [
            CSpecs.NodeType.StartNode = "Start",
            CSpecs.NodeType.EndNode = "End"
        ];
        
        nodeIcons: [
            CSpecs.NodeType.StartNode = "\uf04b",
            CSpecs.NodeType.EndNode = "\uf11e"
        ];
        
        nodeColors: [
            CSpecs.NodeType.StartNode = "#444",
            CSpecs.NodeType.EndNode = "#444"
        ];
    }

    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    property UndoCore _undoCore: UndoCore {
        scene: scene
    }

    // Batch link creation for performance
    function createLinks(linkDataArray) {
        if (!linkDataArray || linkDataArray.length === 0) {
            return;
        }

        var addedLinks = [];

        for (var i = 0; i < linkDataArray.length; i++) {
            var linkData = linkDataArray[i];

            // Validate the link can be created
            if (!canLinkNodes(linkData.portA, linkData.portB)) {
                console.warn("Cannot create link between " + linkData.portA + " and " + linkData.portB);
                continue;
            }

            var nodeX = linkData.nodeA
            var nodeY = linkData.nodeB

            // Update children and parents
            nodeX.children[nodeY._qsUuid] = nodeY;
            nodeX.childrenChanged();

            nodeY.parents[nodeX._qsUuid] = nodeX;
            nodeY.parentsChanged();

            // Create the link object
            var obj = NLCore.createLink();
            obj.inputPort = findPort(linkData.portA);
            obj.outputPort = findPort(linkData.portB);
            obj._qsRepo = sceneActiveRepo;

            // Add to local administration
            links[obj._qsUuid] = obj;
            addedLinks.push(obj);
        }

        if (addedLinks.length > 0) {
            linksChanged();
            linksAdded(addedLinks);
        }
    }

    // Batch node pair creation for performance testing
    function createPairNodes(pairs) {
        // pairs format: [{xPos, yPos, nodeName}, {xPos, yPos, nodeName}, ...]
        var nodesToAdd = []
        var linksToCreate = []
        if (!pairs || pairs.length === 0) return;

        // Pre-allocate arrays for better performance
        nodesToAdd.length = pairs.length * 2;
        linksToCreate.length = pairs.length;

        var nodeIndex = 0;

        for (var i = 0; i < pairs.length; i++) {
            var pair = pairs[i]

            // Create start node
            var startNode = NLCore.createNode()
            startNode.type = CSpecs.NodeType.StartNode
            startNode._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo
            startNode.title = pair.nodeName + "_start"
            startNode.guiConfig.position.x = pair.xPos
            startNode.guiConfig.position.y = pair.yPos
            startNode.guiConfig.color = "#444444"
            startNode.guiConfig.width = 150
            startNode.guiConfig.height = 100

            var outputPort = NLCore.createPort()
            outputPort.portType = NLSpec.PortType.Output
            outputPort.portSide = NLSpec.PortPositionSide.Right
            startNode.addPort(outputPort)

            // Create end node
            var endNode = NLCore.createNode()
            endNode.type = CSpecs.NodeType.EndNode
            endNode._qsRepo = scene?._qsRepo ?? NLCore.defaultRepo
            endNode.title = pair.nodeName + "_end"
            endNode.guiConfig.position.x = pair.xPos + 230
            endNode.guiConfig.position.y = pair.yPos + 30
            endNode.guiConfig.color = "#444444"
            endNode.guiConfig.width = 150
            endNode.guiConfig.height = 100

            var inputPort = NLCore.createPort()
            inputPort.portType = NLSpec.PortType.Input
            inputPort.portSide = NLSpec.PortPositionSide.Left
            endNode.addPort(inputPort)

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
        addNodes(nodesToAdd, false)

        // Create all links at once
        createLinks(linksToCreate)
    }

    // Clear scene efficiently
    function clearScene() {
        console.time("Scene_clear")
        gc()  // Garbage collection
        scene.selectionModel.clear()
        var nodeIds = Object.keys(nodes)
        scene.deleteNodes(nodeIds)
        links = []
        console.timeEnd("Scene_clear")
    }
}
```

**Key Features**:
- **Batch Creation**: `createPairNodes()` creates multiple node pairs efficiently
- **Batch Linking**: `createLinks()` creates multiple links in one operation
- **Performance Optimized**: Pre-allocates arrays and minimizes function calls
- **Scene Clearing**: Efficient scene clearing with garbage collection

**Performance Optimizations**:
1. Pre-allocated arrays for nodes and links
2. Batch node addition using `addNodes()`
3. Batch link creation using `createLinks()`
4. Minimal validation during batch operations
5. Garbage collection before clearing

![Scene Architecture](images/PerformanceAnalyzer_13216.png) <!-- TODO: Insert diagram showing scene structure and batch operations -->

---

#### Step 5: Create Views

##### 5.1 PerformanceAnalyzerView.qml

Create `resources/View/PerformanceAnalyzerView.qml` - main view container:

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NodeLink
import QtQuickStream
import PerformanceAnalyzer

Item {
    id: view
    property PerformanceScene scene: null

    property SceneSession sceneSession: SceneSession {
        enabledOverview: false;
        doNodesNeedImage: false
    }

    // Nodes Scene (flickable canvas)
    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
        }
    }

    // Side menu for adding nodes
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }
}
```

**Key Features**:
- **NodesScene**: Provides the scrollable canvas for nodes
- **SideMenu**: Allows manual node addition (for testing)
- **SceneSession**: Manages view state and interactions

---

#### Step 6: Create Main Application

##### 6.1 main.cpp

Create `main.cpp`:

```cpp
#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");
    engine.addImportPath(":/");

    const QUrl url(u"qrc:/PerformanceAnalyzer/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

---

##### 6.2 Main.qml

Create `Main.qml` - the main application with performance controls:

```qml
import QtQuick
import QtQuickStream
import QtQuick.Controls
import NodeLink
import PerformanceAnalyzer

ApplicationWindow {
    id: window

    visible: true
    width: 1280
    height: 960
    title: qsTr("Performance Test Example")
    color: "#1e1e1e"

    property PerformanceScene scene: null
    property int nodeCount: 100
    property bool spawnInsideView: true

    Component.onCompleted: {
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "PerformanceAnalyzer"])
        NLCore.defaultRepo.initRootObject("PerformanceScene")
        window.scene = Qt.binding(function() {
            return NLCore.defaultRepo.qsRootObject
        })
    }

    PerformanceAnalyzerView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }

    property var startTime

    BusyIndicator {
        id: busyIndicator
        running: false
        anchors.centerIn: parent
    }

    // Select all nodes function with timing
    function selectAll() {
        busyIndicator.running = true
        statusText.text = "Selecting..."
        statusText.color = "#FF9800"

        Qt.callLater(function () {
            const startTime = Date.now()
            console.log("(" + Object.keys(scene.nodes).length + ") Nodes, (" +
                        Object.keys(scene.links).length + ") Links and (" +
                        Object.keys(scene.containers).length + ") Containers to select")

            scene.selectionModel.selectAll(scene.nodes, [], scene.containers)

            const elapsed = Date.now() - startTime
            console.log("Selected items:", Object.keys(scene.selectionModel.selectedModel).length)
            console.log("Time elapsed:", elapsed, "ms")
            statusText.text = "Selected all items (" + elapsed + "ms)"
            statusText.color = "#4CAF50"
            busyIndicator.running = false
        })
    }

    // Keyboard shortcut for select all
    Shortcut {
        sequence: "Ctrl+A"
        onActivated: selectAll()
    }

    // Performance Controls Panel
    Rectangle {
        anchors.right: view.right
        anchors.top: view.top
        anchors.topMargin: 50
        anchors.rightMargin: 50
        width: 220
        height: 460
        color: "#2d2d2d"
        border.color: "#3e3e3e"
        radius: 8
        z: 10

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            Text {
                text: "Performance Controls"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 16
            }

            // Node pair count input
            Row {
                spacing: 10
                width: parent.width - 30

                Text {
                    text: "Node Pairs:"
                    color: "#cccccc"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14
                }

                TextField {
                    id: nodePairInput
                    width: 80
                    text: "100"
                    validator: IntValidator { bottom: 1; top: 10000 }
                    color: "#ffffff"
                    background: Rectangle {
                        color: "#1e1e1e"
                        border.color: "#3e3e3e"
                        radius: 4
                    }
                }
            }

            // Spawn mode toggle
            Button {
                id: spawnModeButton
                width: parent.width - 30
                checkable: true
                checked: spawnInsideView
                text: checked ? "Inside View" : "Across Scene"
                onToggled: spawnInsideView = checked
                highlighted: true
            }

            // Start test button
            Button {
                id: startButton
                text: "Start Test"
                width: parent.width - 30
                onClicked: {
                    if (!nodePairInput.acceptableInput) {
                        statusText.text = "Enter a value between 1 and 10000"
                        statusText.color = "#F44336"
                        return
                    }
                    nodeCount = parseInt(nodePairInput.text)
                    timer.running = true
                    startTime = Date.now()
                    statusText.text = "Creating " + nodeCount + " pairs..."
                    statusText.color = "#4CAF50"
                    enabled = false
                    busyIndicator.running = true
                }
            }

            // Status text
            Text {
                id: statusText
                text: "Ready"
                color: "#cccccc"
                font.pixelSize: 12
                width: parent.width - 30
                wrapMode: Text.WordWrap
            }

            // Clear scene button
            Button {
                text: "Clear Scene"
                width: parent.width - 30
                onClicked: {
                    scene.clearScene()
                    statusText.text = "Scene cleared"
                    statusText.color = "#cccccc"
                }
            }

            // Select all button
            Button {
                text: "Select All"
                width: parent.width - 30
                enabled: scene?.nodes ? Object.keys(scene.nodes).length > 0 : false
                onClicked: selectAll()
            }

            // Clear selection button
            Button {
                text: "Clear Selection"
                width: parent.width - 30
                enabled: scene?.selectionModel ? Object.keys(scene.selectionModel.selectedModel).length > 0 : false
                onClicked: {
                    const startTime = Date.now()
                    console.log("Items to deselect:", Object.keys(scene.selectionModel.selectedModel).length)
                    scene.selectionModel.clear()
                    const elapsed = Date.now() - startTime
                    console.log("Time elapsed:", elapsed, "ms")
                    statusText.text = `Cleared selection (${elapsed}ms)`
                    statusText.color = "#FF9800"
                }
            }
        }
    }

    // Scene Monitor Panel
    Rectangle {
        anchors.left: view.left
        anchors.top: view.top
        anchors.topMargin: 50
        anchors.leftMargin: 50
        width: 160
        height: 160
        color: "#2d2d2d"
        border.color: "#3e3e3e"
        radius: 8
        z: 10

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 12

            Text {
                text: "Scene Monitor"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 16
            }

            Rectangle {
                width: parent.width - 30
                height: 1
                color: "#3e3e3e"
            }

            // Node count
            Row {
                spacing: 10
                Text {
                    text: "Nodes:"
                    color: "#cccccc"
                    font.pixelSize: 13
                    width: 80
                }
                Text {
                    id: nodeCountText
                    text: "0"
                    color: "#FF9800"
                    font.pixelSize: 13
                    font.bold: true
                }
            }

            // Link count
            Row {
                spacing: 10
                Text {
                    text: "Links:"
                    color: "#cccccc"
                    font.pixelSize: 13
                    width: 80
                }
                Text {
                    id: linkCountText
                    text: "0"
                    color: "#9C27B0"
                    font.pixelSize: 13
                    font.bold: true
                }
            }

            // Selected count
            Row {
                spacing: 10
                Text {
                    text: "Selected:"
                    color: "#cccccc"
                    font.pixelSize: 13
                    width: 80
                }
                Text {
                    id: selectedCountText
                    text: "0"
                    color: "#4CAF50"
                    font.pixelSize: 13
                    font.bold: true
                }
            }
        }
    }

    // Helper function for random positioning
    function randBetween(min, max) {
        return Math.random() * (max - min) + min;
    }

    // Node creation timer
    Timer {
        id: timer
        interval: 1
        running: false
        repeat: false
        onTriggered: {
            // Create all node pairs in one batch
            var pairs = []
            var guiCfg = scene.sceneGuiConfig
            const invZoom = 1 / guiCfg.zoomFactor
            const left = guiCfg.contentX * invZoom
            const top = guiCfg.contentY * invZoom
            const right = left + guiCfg.sceneViewWidth * invZoom - 380
            const bottom = top + guiCfg.sceneViewHeight * invZoom - 130

            for (let i = 0; i < nodeCount; ++i) {
                const xPos = spawnInsideView ? randBetween(left, right)
                                             : Math.random() * guiCfg.contentWidth
                const yPos = spawnInsideView ? randBetween(top, bottom)
                                             : Math.random() * guiCfg.contentHeight

                pairs.push({ xPos, yPos, nodeName: "test_" + i })
            }

            scene.createPairNodes(pairs)

            var elapsedTime = Date.now() - startTime
            statusText.text = "Completed in " + elapsedTime + "ms"
            statusText.color = "#4CAF50"
            console.log("Elapsed time: " + elapsedTime + "ms")
            startButton.enabled = true
            busyIndicator.running = false
            running = false
        }
    }

    // Node monitoring timer (updates every 500ms)
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            updateNodesInfo()
        }
    }

    // Update monitoring information
    function updateNodesInfo() {
        if (scene) {
            nodeCountText.text = Object.keys(scene.nodes).length
            linkCountText.text = Object.keys(scene.links).length
            selectedCountText.text = Object.keys(scene.selectionModel?.selectedModel).length ?? 0
        }
    }

    // Load Font Awesome fonts
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/PerformanceAnalyzer/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }
}
```

**Key Features**:
- **Performance Controls**: Panel for configuring and starting tests
- **Scene Monitor**: Real-time statistics display
- **Batch Creation**: Creates all node pairs in one operation
- **Timing**: Measures and displays operation times
- **Spawn Modes**: Inside viewport or across entire scene

![Main Application Layout](images/frame1.png)

---

#### Step 7: Build and Run

##### 7.1 Configure Build

1. Create a build directory:
   ```bash
   mkdir build
   cd build
   ```

2. Configure with CMake:
   ```bash
   cmake .. -DCMAKE_PREFIX_PATH=<Qt_Install_Path>
   ```

3. Build the project:
   ```bash
   cmake --build .
   ```

##### 7.2 Run the Application

Run the executable:
```bash
./PerformanceAnalyzer  # Linux/Mac
PerformanceAnalyzer.exe  # Windows
```

---

#### Step 8: Using the Performance Analyzer

##### Basic Usage

1. **Configure Test**:
   - Enter number of node pairs (1-10000)
   - Choose spawn mode: "Inside View" or "Across Scene"
   - Click "Start Test"

2. **Monitor Performance**:
   - Watch the Scene Monitor for real-time statistics
   - Check console for detailed timing information
   - Status text shows operation completion time

3. **Test Operations**:
   - **Select All**: Select all nodes/links (Ctrl+A)
   - **Clear Selection**: Deselect all items
   - **Clear Scene**: Remove all nodes and links

##### Performance Testing Scenarios

**Scenario 1: Small Scale (100 pairs)**
- Node Pairs: 100
- Expected: Fast creation (< 100ms)
- Use Case: Testing basic functionality

**Scenario 2: Medium Scale (1000 pairs)**
- Node Pairs: 1000
- Expected: Moderate creation time (< 1000ms)
- Use Case: Testing typical application loads

**Scenario 3: Large Scale (5000 pairs)**
- Node Pairs: 5000
- Expected: Longer creation time (< 5000ms)
- Use Case: Stress testing

**Scenario 4: Extreme Scale (10000 pairs)**
- Node Pairs: 10000
- Expected: Maximum creation time
- Use Case: Finding performance limits

![Performance Testing](images/frame2.png)

##### Interpreting Results

**Creation Time**:
- Measures time to create nodes, ports, and links
- Includes batch operations
- Displayed in milliseconds

**Selection Time**:
- Measures time to select all items
- Includes nodes, links, and containers
- Displayed in milliseconds

**Scene Statistics**:
- **Nodes**: Total number of nodes in scene
- **Links**: Total number of links in scene
- **Selected**: Number of currently selected items

##### Performance Tips

1. **Batch Operations**: Always use batch creation methods for multiple nodes
2. **Spawn Mode**: "Inside View" is faster than "Across Scene"
3. **Clear Before Test**: Clear scene before running new tests for accurate timing
4. **Monitor Memory**: Watch memory usage with large scenes
5. **Console Logging**: Check console for detailed performance metrics

---

### Architecture Overview

#### Component Hierarchy

```
PerformanceScene (Scene)
├── NodeRegistry (defines node types)
├── SelectionModel (manages selection)
├── UndoCore (undo/redo support)
└── Batch Operations
    ├── createPairNodes() (batch node creation)
    └── createLinks() (batch link creation)

Main Window
├── PerformanceAnalyzerView (canvas)
│   ├── NodesScene
│   └── SideMenu
├── Performance Controls Panel
│   ├── Node pair input
│   ├── Spawn mode toggle
│   ├── Start test button
│   └── Operation buttons
└── Scene Monitor Panel
    ├── Node count
    ├── Link count
    └── Selected count
```

#### Performance Optimizations

1. **Pre-allocated Arrays**: Arrays are pre-sized to avoid resizing
2. **Batch Operations**: Multiple nodes/links created in single operations
3. **Minimal Validation**: Reduced validation during batch creation
4. **Efficient Clearing**: Garbage collection before scene clearing
5. **Lazy Updates**: UI updates only when necessary

![Architecture Diagram](images/PerformanceAnalyzer_13815.png) <!-- TODO: Insert comprehensive architecture diagram -->

---

### Key Concepts

#### Batch Creation

Instead of creating nodes one by one, batch creation:
- Creates all nodes in memory first
- Adds them to the scene in one operation
- Creates all links in one operation
- Significantly faster than individual creation

#### Performance Metrics

Key metrics to monitor:
- **Creation Time**: Time to create nodes and links
- **Selection Time**: Time to select/deselect items
- **Clear Time**: Time to clear the scene
- **Memory Usage**: Memory consumed by the scene
- **Frame Rate**: Rendering performance

#### Spawn Modes

**Inside View**:
- Nodes created only in visible viewport
- Faster rendering
- Better for testing viewport performance

**Across Scene**:
- Nodes created across entire scene
- Tests scene-wide performance
- Better for testing scalability

---

### Extending the Performance Analyzer

#### Adding New Metrics

To add new performance metrics:

1. Add monitoring code in `Main.qml`:
   ```qml
   function measureOperation() {
       const startTime = Date.now()
       // Perform operation
       const elapsed = Date.now() - startTime
       console.log("Operation time:", elapsed, "ms")
   }
   ```

2. Add UI elements to display metrics

3. Update monitoring timer to refresh metrics

#### Custom Node Types

To test with custom node types:

1. Add node types to `CSpecs.qml`
2. Create node QML files
3. Register in `PerformanceScene.qml`
4. Modify `createPairNodes()` to use custom types

#### Performance Profiling

Integrate with profiling tools:
- Qt Creator Profiler
- Chrome DevTools (for QML)
- Custom performance counters
- Memory profilers

---

### Troubleshooting

#### Common Issues

1. **Slow Creation**:
   - Reduce node count
   - Use "Inside View" mode
   - Check for memory issues
   - Verify batch operations are used

2. **High Memory Usage**:
   - Clear scene regularly
   - Monitor memory with profiling tools
   - Reduce node count if needed

3. **UI Freezing**:
   - Use `Qt.callLater()` for heavy operations
   - Break operations into smaller chunks
   - Show busy indicator during operations

4. **Inaccurate Timing**:
   - Clear scene before each test
   - Close other applications
   - Run multiple tests and average results

#### Debug Tips

- Enable console logging for detailed metrics
- Use `console.time()` and `console.timeEnd()` for timing
- Monitor memory with system tools
- Check QML profiler for rendering issues
- Verify batch operations are actually batching

---

### Performance Benchmarks

#### Typical Performance (Reference)

These are example benchmarks - actual performance depends on hardware:

| Node Pairs | Nodes | Links | Creation Time | Selection Time |
|------------|-------|-------|---------------|----------------|
| 100 | 200 | 100 | ~50ms | ~10ms |
| 500 | 1000 | 500 | ~200ms | ~50ms |
| 1000 | 2000 | 1000 | ~400ms | ~100ms |
| 5000 | 10000 | 5000 | ~2000ms | ~500ms |
| 10000 | 20000 | 10000 | ~4000ms | ~1000ms |

**Note**: These are approximate values and will vary based on:
- Hardware specifications
- Operating system
- Qt version
- NodeLink optimizations

---

### Conclusion

The Performance Analyzer Example provides essential tools for:
- **Benchmarking**: Measure NodeLink's performance
- **Optimization**: Identify performance bottlenecks
- **Testing**: Verify framework scalability
- **Development**: Test during framework development

Key takeaways:
- **Batch Operations**: Always use batch methods for multiple items
- **Performance Monitoring**: Real-time statistics help identify issues
- **Scalability**: NodeLink can handle large scenes efficiently
- **Optimization**: Pre-allocation and batching significantly improve performance

This example serves as a foundation for:
- Performance testing in custom applications
- Benchmarking framework improvements
- Stress testing production applications
- Capacity planning for large-scale deployments

For more examples, see the other examples in the NodeLink repository.

![Final Example](images/PerformanceAnalyzer_Example2.png)


## Simple NodeLink Example

### Overview

The Simple NodeLink Example is the most basic example demonstrating how to get started with NodeLink. This minimal example shows the fundamental concepts of creating nodes, connecting them, and using basic NodeLink features like save/load, copy/paste, and cloning. It's the perfect starting point for developers new to NodeLink who want to understand the core framework concepts before building more complex applications.

![Simple NodeLink Overview](images/SimpleNodeLink_Example1.png)

---

### a. Purpose and Use Cases

#### Purpose

The Simple NodeLink Example demonstrates:

1. **Basic Node Creation**: Shows how to create a simple custom node with ports.

2. **Port Configuration**: Demonstrates how to add ports to nodes in different positions (top, bottom, left, right).

3. **Node Registry Setup**: Illustrates how to register node types in the node registry.

4. **Scene Management**: Shows basic scene creation and management using NodeLink's Scene component.

5. **Save/Load Functionality**: Demonstrates how to save and load scenes using QtQuickStream.

6. **Copy/Paste Operations**: Shows how to copy and paste nodes using keyboard shortcuts.

7. **Node Cloning**: Demonstrates how to clone selected nodes.

8. **Basic UI Integration**: Shows how to integrate NodeLink with a Qt Quick application.

#### Use Cases

- **Learning Tool**: Perfect starting point for developers new to NodeLink
- **Template Project**: Use as a template for creating new NodeLink applications
- **Quick Prototyping**: Rapidly prototype node-based interfaces
- **Framework Introduction**: Understand core NodeLink concepts and architecture
- **Testing**: Test NodeLink features in a minimal environment
- **Customization Base**: Start with this example and add custom functionality

#### Example Scenarios

- **First NodeLink Project**: Create your first NodeLink application
- **Understanding Ports**: Learn how ports work and how to configure them
- **Scene Persistence**: Learn how to save and load node graphs
- **Node Operations**: Practice copying, pasting, and cloning nodes
- **Custom Node Development**: Use as a base for creating custom node types

#### Real-World Applications

- **Learning Projects**: Educational projects to understand NodeLink
- **Prototype Development**: Quick prototypes before building full applications
- **Framework Testing**: Test NodeLink features and capabilities
- **Custom Application Foundation**: Starting point for building custom node-based applications

![Use Case Diagram](images/SimpleNodeLink_14029.png) <!-- TODO: Insert diagram showing different use cases -->

---

### b. Node Types Explained

The Simple NodeLink Example implements one basic node type designed to demonstrate fundamental NodeLink concepts.

#### Node Example (`NodeExample`)

**Purpose**: A simple example node that demonstrates how to create a custom node with ports on all four sides.

**Type ID**: `0`

**Properties**:
- Contains four ports, one on each side (top, bottom, left, right)
- All ports are bidirectional (InAndOut type)
- Minimal implementation to show basic node structure

**Ports**:
- **Top Port**: InAndOut type (Top side)
- **Bottom Port**: InAndOut type (Bottom side)
- **Left Port**: InAndOut type (Left side)
- **Right Port**: InAndOut type (Right side)

**Port Types**:
- `InAndOut`: Bidirectional port that can act as both input and output
- Ports can be connected to other ports regardless of direction

**Properties**:
- `type`: Set to `0` (node type identifier)
- Default node appearance and behavior from NodeLink base classes

**Behavior**:
- Can be connected to other nodes via any of its four ports
- Supports all standard NodeLink operations (select, move, delete, clone)
- No custom logic - purely for demonstration purposes

**Visual Appearance**:
- Icon: Document icon (Font Awesome \ue4e2)
- Color: Gray (#444)
- Default NodeLink node styling

**Usage**: 
- Add nodes using the side menu
- Connect nodes by dragging from one port to another
- Use standard NodeLink operations (select, move, delete, clone)

![Node Example](images/SimpleNodeLink_14077.png) <!-- TODO: Insert screenshot of NodeExample with ports visible -->

**Code Implementation**:
```qml
Node {
    type: 0

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();
        let _port4 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.InAndOut
        _port1.portSide = NLSpec.PortPositionSide.Top

        _port2.portType = NLSpec.PortType.InAndOut
        _port2.portSide = NLSpec.PortPositionSide.Bottom

        _port3.portType = NLSpec.PortType.InAndOut
        _port3.portSide = NLSpec.PortPositionSide.Left

        _port4.portType = NLSpec.PortType.InAndOut
        _port4.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
        addPort(_port4);
    }
}
```

---

#### Container Node

The example also includes support for Container nodes (from NodeLink core), which allow grouping nodes together.

**Type ID**: `1`

**Properties**:
- Groups multiple nodes together
- Can contain other nodes and containers
- Provides organizational structure for complex scenes

**Visual Appearance**:
- Icon: Folder icon (Font Awesome \uf247)
- Color: Primary color from NLStyle

---

#### Node Type Summary Table

| Node Type | Type ID | Ports | Port Type | Purpose |
|-----------|---------|-------|-----------|---------|
| NodeExample | 0 | 4 (all sides) | InAndOut | Basic example node |
| Container | 1 | N/A | N/A | Node grouping |

---

### c. Step-by-Step Building Guide

This guide will walk you through building the Simple NodeLink Example from scratch, explaining each component and how they work together.

#### Prerequisites

- Qt 6.2.4 or later (Qt 6.10.0 recommended)
- CMake 3.1.0 or later
- C++ compiler with C++14 support (MSVC 2019/2022 on Windows)
- NodeLink framework built and installed
- QtQuickStream module built and installed

#### Step 1: Project Setup

##### 1.1 Create Project Structure

Create the following directory structure:

```
simpleNodeLink/
├── CMakeLists.txt
├── main.cpp
├── main.qml
└── NodeExample.qml
```

##### 1.2 Configure CMakeLists.txt

Create `CMakeLists.txt` with the following configuration:

```cmake
cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

set(QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml/NodeLink/resources/View)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# Create executable
qt_add_executable(SimpleNodeLink main.cpp)

# Define QML module
qt_add_qml_module(SimpleNodeLink
    URI "SimpleNodeLink"
    VERSION 1.0
    QML_FILES
        main.qml
        NodeExample.qml
)

target_include_directories(SimpleNodeLink PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_link_libraries(SimpleNodeLink PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
```

**Key Points**:
- Links to `NodeLinkplugin` and `QtQuickStreamplugin`
- Sets QML import paths for NodeLink resources
- Minimal QML files (just main.qml and NodeExample.qml)

---

#### Step 2: Create Node Example

##### 2.1 NodeExample.qml

Create `NodeExample.qml` - a simple example node:

```qml
import QtQuick
import NodeLink

Node {
    type: 0

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();
        let _port4 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.InAndOut
        _port1.portSide = NLSpec.PortPositionSide.Top

        _port2.portType = NLSpec.PortType.InAndOut
        _port2.portSide = NLSpec.PortPositionSide.Bottom

        _port3.portType = NLSpec.PortType.InAndOut
        _port3.portSide = NLSpec.PortPositionSide.Left

        _port4.portType = NLSpec.PortType.InAndOut
        _port4.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
        addPort(_port4);
    }
}
```

**Key Features**:
- Inherits from `Node` base class
- Sets `type` to `0` (node type identifier)
- Adds four ports in `addPorts()` function
- All ports are bidirectional (InAndOut)
- Ports positioned on all four sides

---

#### Step 3: Create Main Application

##### 3.1 main.cpp

Create `main.cpp`:

```cpp
#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");
    engine.addImportPath(":/");

    const QUrl url(u"qrc:/SimpleNodeLink/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

---

##### 3.2 main.qml

Create `main.qml` - the main application with scene setup and controls:

```qml
import QtQuick
import QtQuickStream
import QtQuick.Dialogs
import QtQuick.Controls
import NodeLink

Window {
    id: window

    // Scene property (will be overridden by load)
    property Scene scene: Scene { }

    // Node registry setup
    property NLNodeRegistry nodeRegistry: NLNodeRegistry {
        _qsRepo: NLCore.defaultRepo
        imports: ["SimpleNodeLink", "NodeLink"];
        defaultNode: 0
    }

    width: 1280
    height: 960
    visible: true
    title: qsTr("Simple NodeLink Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        // Prepare node registry
        var nodeType = 0;
        nodeRegistry.nodeTypes[nodeType] = "NodeExample";
        nodeRegistry.nodeNames[nodeType] = "NodeExample";
        nodeRegistry.nodeIcons[nodeType] = "\ue4e2";
        nodeRegistry.nodeColors[nodeType] = "#444";

        // Register Container node type
        nodeRegistry.nodeTypes[nodeType + 1] = "Container";
        nodeRegistry.nodeNames[nodeType + 1] = "Container";
        nodeRegistry.nodeIcons[nodeType + 1] = "\uf247";
        nodeRegistry.nodeColors[nodeType + 1] = NLStyle.primaryColor;

        // Initialize QtQuickStream repository
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "SimpleNodeLink"])
        NLCore.defaultRepo.initRootObject("Scene");

        // Set registry to scene
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });
        window.scene.nodeRegistry = Qt.binding(function() { 
            return window.nodeRegistry;
        });
    }

    // Main view
    NLView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }

    // Save/Load controls
    Rectangle {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        width: 400
        height: 40
        color: "#b0aeab"

        Button {
            text: "Save"
            width: 150
            anchors.left: parent.left
            anchors.margins: 20
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle {
                radius: 5
                color: "#6899e3"
            }
            onClicked: {
                saveDialog.visible = true
            }
        }

        Button {
            text: "Load"
            anchors.right: parent.right
            anchors.margins: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 150
            background: Rectangle {
                radius: 5
                color: "#eb5e65"
            }
            onClicked: loadDialog.visible = true
        }
    }

    // Save dialog
    FileDialog {
        id: saveDialog
        currentFile: "QtQuickStream.QQS.json"
        fileMode: FileDialog.SaveFile
        nameFilters: [ "QtQuickStream Files (*.QQS.json)" ]
        onAccepted: {
            NLCore.defaultRepo.saveToFile(saveDialog.currentFile);
        }
    }

    // Load dialog
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

    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl+C"
        onActivated: {
            view.copyNodes();
        }
    }

    Shortcut {
        sequence: "Ctrl+V"
        onActivated: {
            view.pasteNodes()
        }
    }

    Shortcut {
        sequence: "Ctrl+A"
        onActivated: scene?.selectionModel.selectAll(
            scene.nodes, scene.links, scene.containers
        );
    }

    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            var copiedNodes = ({});
            var copiedContainers = ({});
            Object.keys(scene?.selectionModel.selectedModel ?? []).forEach(key => {
                if (Object.keys(scene.nodes).includes(key)) {
                    var copiedNode = scene?.cloneNode(key);
                    copiedNodes[copiedNode._qsUuid] = copiedNode;
                }
                if (Object.keys(scene?.containers).includes(key)) {
                    var copiedContainer = scene?.cloneContainer(key);
                    copiedContainers[copiedContainer._qsUuid] = copiedContainer;
                }
            });
            scene?.selectionModel.selectAll(copiedNodes, ({}), copiedContainers);
        }
    }
}
```

**Key Features**:
- **Scene Setup**: Creates a Scene using QtQuickStream
- **Node Registry**: Registers NodeExample and Container node types
- **NLView**: Main view component for displaying the node graph
- **Save/Load**: File dialogs for saving and loading scenes
- **Keyboard Shortcuts**: Copy, paste, select all, and clone operations

![Main Application Layout](images/SimpleNodeLink_14476.png) <!-- TODO: Main Application Layout -->
---

#### Step 4: Build and Run

##### 4.1 Configure Build

1. Create a build directory:
   ```bash
   mkdir build
   cd build
   ```

2. Configure with CMake:
   ```bash
   cmake .. -DCMAKE_PREFIX_PATH=<Qt_Install_Path>
   ```

3. Build the project:
   ```bash
   cmake --build .
   ```

##### 4.2 Run the Application

Run the executable:
```bash
./SimpleNodeLink  # Linux/Mac
SimpleNodeLink.exe  # Windows
```

---

#### Step 5: Using the Simple NodeLink Example

##### Basic Usage

1. **Add Nodes**: 
   - Click the side menu (right side)
   - Select "NodeExample" to add a node
   - Nodes appear on the canvas

2. **Connect Nodes**:
   - Click and drag from one port to another
   - A link will be created between the ports
   - Ports can connect in any direction (InAndOut type)

3. **Move Nodes**:
   - Click and drag nodes to move them
   - Selected nodes can be moved together

4. **Select Nodes**:
   - Click on a node to select it
   - Drag to select multiple nodes
   - Use Ctrl+A to select all

5. **Delete Nodes**:
   - Select nodes and press Delete key
   - Or use the context menu

##### Save and Load

1. **Save Scene**:
   - Click the "Save" button (bottom left)
   - Choose a location and filename
   - Scene is saved as `.QQS.json` file

2. **Load Scene**:
   - Click the "Load" button (bottom left)
   - Select a previously saved `.QQS.json` file
   - Scene is loaded and displayed

##### Keyboard Shortcuts

- **Ctrl+C**: Copy selected nodes
- **Ctrl+V**: Paste copied nodes
- **Ctrl+A**: Select all nodes and links
- **Ctrl+D**: Clone selected nodes
- **Delete**: Delete selected nodes

---

### Architecture Overview

#### Component Hierarchy

```
Main Window
├── Scene (QtQuickStream)
│   ├── NodeRegistry (defines node types)
│   ├── SelectionModel (manages selection)
│   ├── Nodes (NodeExample instances)
│   ├── Links (connections between nodes)
│   └── Containers (node groups)
├── NLView (main view component)
│   ├── NodesScene (canvas)
│   └── SideMenu (add nodes)
└── Save/Load Controls
    ├── Save Button
    └── Load Button
```

#### Data Flow

```
User Action
    ↓
NLView (handles interaction)
    ↓
Scene (manages nodes/links)
    ↓
QtQuickStream (persistence)
```

![Architecture Diagram](images/SimpleNodeLink_14589.png) <!-- TODO: Insert comprehensive architecture diagram -->

---

### Key Concepts

#### Node Creation

Nodes are created by:
1. Defining a QML component that inherits from `Node`
2. Setting a unique `type` identifier
3. Adding ports in `Component.onCompleted`
4. Registering in the node registry

#### Port Types

- **Input**: Can only receive connections
- **Output**: Can only send connections
- **InAndOut**: Bidirectional - can both send and receive

#### Port Positions

- **Top**: Port on the top side of the node
- **Bottom**: Port on the bottom side
- **Left**: Port on the left side
- **Right**: Port on the right side

#### Scene Persistence

Scenes are saved/loaded using QtQuickStream:
- **Save**: Serializes all nodes, links, and containers to JSON
- **Load**: Deserializes from JSON and recreates the scene
- **Format**: `.QQS.json` (QtQuickStream JSON format)

---

### Extending the Simple Example

#### Adding Custom Node Types

To add a new node type:

1. **Create Node QML File**:
   ```qml
   // MyCustomNode.qml
   import QtQuick
   import NodeLink

   Node {
       type: 1  // Unique type ID
       Component.onCompleted: addPorts();
       function addPorts() {
           // Add your ports here
       }
   }
   ```

2. **Register in main.qml**:
   ```qml
   nodeRegistry.nodeTypes[1] = "MyCustomNode";
   nodeRegistry.nodeNames[1] = "My Custom Node";
   nodeRegistry.nodeIcons[1] = "\uf123";  // Font Awesome icon
   nodeRegistry.nodeColors[1] = "#FF5733";
   ```

3. **Add to CMakeLists.txt**:
   ```cmake
   QML_FILES
       main.qml
       NodeExample.qml
       MyCustomNode.qml
   ```

#### Adding Custom Logic

To add custom behavior to nodes:

1. **Add Properties**:
   ```qml
   Node {
       property string myData: "Hello"
       // ...
   }
   ```

2. **Add Functions**:
   ```qml
   Node {
       function doSomething() {
           console.log("Doing something");
       }
   }
   ```

3. **Handle Events**:
   ```qml
   Node {
       onSomeEvent: {
           // Handle event
       }
   }
   ```

#### Customizing Appearance

Modify node appearance:
- **Size**: Set `guiConfig.width` and `guiConfig.height`
- **Color**: Set `guiConfig.color`
- **Icon**: Change icon in node registry
- **Custom View**: Create custom NodeView component

---

### Troubleshooting

#### Common Issues

1. **Nodes Not Appearing**:
   - Check node registry registration
   - Verify QML file is included in CMakeLists.txt
   - Check console for import errors

2. **Ports Not Visible**:
   - Verify `addPorts()` is called in `Component.onCompleted`
   - Check port properties are set correctly
   - Ensure ports are added to the node

3. **Save/Load Not Working**:
   - Check file permissions
   - Verify QtQuickStream is properly linked
   - Check console for error messages

4. **Shortcuts Not Working**:
   - Ensure window has focus
   - Check for conflicting shortcuts
   - Verify scene is properly initialized

#### Debug Tips

- Enable console logging: `console.log("Debug message")`
- Check QML errors in console
- Verify all imports are correct
- Test node creation step by step
- Check NodeLink documentation for API details

---

### Next Steps

After understanding this simple example, you can:

1. **Explore Other Examples**:
   - Calculator Example: Learn about data flow
   - Chatbot Example: Learn about pattern matching
   - Logic Circuit Example: Learn about complex node logic
   - Performance Analyzer: Learn about optimization

2. **Build Custom Applications**:
   - Start with this example as a template
   - Add your own node types
   - Implement custom logic
   - Create domain-specific applications

3. **Learn Advanced Features**:
   - Custom node views
   - Complex data types
   - Undo/redo system
   - Container nesting
   - Custom link types

---

### Conclusion

The Simple NodeLink Example provides a minimal, clean introduction to NodeLink framework. Key takeaways:

- **Basic Setup**: How to set up a NodeLink application
- **Node Creation**: How to create custom nodes with ports
- **Scene Management**: How to work with scenes
- **Persistence**: How to save and load scenes
- **Operations**: Basic node operations (copy, paste, clone)

This example serves as the foundation for:
- Learning NodeLink concepts
- Building custom node-based applications
- Understanding the framework architecture
- Prototyping new ideas

For more advanced examples, see the other examples in the NodeLink repository.

![Final Example](images/SimpleNodeLink_Example1.png)


## VisionLink Example

### Overview

The VisionLink Example demonstrates how to build a visual image processing application using NodeLink. This example allows users to create image processing pipelines by connecting nodes that load, process, and display images. It showcases how to integrate C++ image processing code with QML nodes, handle image data flow through the node graph, and create interactive controls for real-time image manipulation. Perfect for learning how to build domain-specific node-based applications with custom data types and processing logic.

![VisionLink Overview](images/VisionLink_Example1.png)

---

### a. Purpose and Use Cases

#### Purpose

The VisionLink Example demonstrates:

1. **Image Processing Pipelines**: Create visual pipelines for processing images using connected nodes.

2. **C++/QML Integration**: Shows how to integrate C++ image processing code with QML node-based interfaces.

3. **Custom Data Types**: Demonstrates handling complex data types (images) through the node graph.

4. **Real-Time Processing**: Process images in real-time as parameters change or images are loaded.

5. **Interactive Controls**: Provides sliders and controls for adjusting processing parameters interactively.

6. **Image Visualization**: Displays images directly in nodes for visual feedback.

7. **Data Flow Management**: Handles complex data propagation through processing chains.

#### Use Cases

- **Image Editing Tools**: Build custom image editing applications with visual workflows
- **Photo Processing**: Create photo processing pipelines for batch operations
- **Computer Vision**: Prototype computer vision algorithms visually
- **Educational Tool**: Learn image processing concepts through visual programming
- **Prototyping**: Quickly prototype image processing workflows
- **Custom Filters**: Create and test custom image filters and effects

#### Example Scenarios

- **Basic Image Processing**: Load an image, apply blur, adjust brightness, and view the result
- **Multi-Step Pipelines**: Chain multiple operations (blur → brightness → contrast)
- **Parameter Tuning**: Adjust processing parameters in real-time and see immediate results
- **Image Comparison**: Process the same image with different parameters side-by-side
- **Workflow Design**: Design reusable image processing workflows

#### Real-World Applications

- **Photo Editing Software**: Build custom photo editing tools
- **Image Filter Apps**: Create Instagram-like filter applications
- **Scientific Image Processing**: Process microscopy or medical images
- **Artistic Tools**: Create digital art processing tools
- **Quality Control**: Automated image quality enhancement pipelines

![Use Case Diagram](images/VisionLink_14837.png) <!-- TODO: Insert diagram showing different use cases -->

---

### b. Node Types Explained

The VisionLink Example implements five node types, each serving a specific role in the image processing pipeline.

#### 1. Image Input Node (`ImageInputNode`)

**Purpose**: Loads image files from disk and provides them to the processing pipeline.

**Type ID**: `CSpecs.NodeType.ImageInput` (0)

**Properties**:
- Contains a single output port
- Loads images from file system
- Displays image preview in the node
- Acts as the starting point for image processing pipelines

**Ports**:
- **Output Port**: (Right side) - Emits the loaded image data

**Properties**:
- `imagePath`: String path to the loaded image file
- `nodeData.data`: QImage object containing the loaded image

**Behavior**:
- Click "Load Image" button to open file dialog
- Supports common image formats (PNG, JPG, JPEG, BMP)
- Displays image preview in the node
- When image is loaded, triggers scene update to propagate to connected nodes
- Image data is stored as QImage object

**Visual Appearance**:
- Icon: Upload icon (Font Awesome \uf093)
- Color: Gray (#444)
- Size: 250x220 pixels
- Shows image preview when loaded
- "Load Image" button at the bottom

**Usage Example**:
- Click "Load Image" → Select image file → Image loads and displays
- Image is available at output port for connected nodes

![Image Input Node](images/VisionLink_14882.png) <!-- TODO: Insert screenshot of ImageInputNode with loaded image -->

**Code Implementation**:
```qml
function loadImage(path) {
    imagePath = path;
    var loadedImage = ImageProcessor.loadImage(path);
    if (ImageProcessor.isValidImage(loadedImage)) {
        nodeData.data = loadedImage;
    } else {
        nodeData.data = null;
    }
}
```

---

#### 2. Blur Operation Node (`BlurOperationNode`)

**Purpose**: Applies blur effect to input images using a configurable blur radius.

**Type ID**: `CSpecs.NodeType.Blur` (2)

**Properties**:
- Has one input port and one output port
- Applies box blur algorithm to images
- Configurable blur radius (0.0 to 20.0)

**Ports**:
- **Input Port**: (Left side) - Receives image to blur
- **Output Port**: (Right side) - Emits blurred image

**Properties**:
- `blurRadius`: Real value (0.0 to 20.0) controlling blur intensity
- `nodeData.input`: Input image data
- `nodeData.data`: Processed blurred image

**Behavior**:
- Waits for input image to be connected
- Applies blur using box blur algorithm (implemented in C++)
- Updates output when blur radius changes
- Shows status indicator (✓ Blurred or Waiting...)

**Visual Appearance**:
- Icon: Blur icon (Font Awesome \uf1fc)
- Color: Purple (#9013FE)
- Size: 250x70 pixels (expands based on content)
- Slider control for blur radius
- Status text showing processing state

**Usage Example**:
- Connect ImageInput output → Blur input
- Adjust blur radius slider (0-20)
- Output shows blurred image

![Blur Operation Node](images/VisionLink_14937.png) <!-- TODO: Insert screenshot of BlurOperationNode with controls -->

**Code Implementation**:
```qml
function updataData() {
    if (!nodeData.input) {
        nodeData.data = null;
        return;
    }
    var inputImage = nodeData.input;
    if (!ImageProcessor.isValidImage(inputImage)) {
        nodeData.data = null;
        return;
    }
    var blurredImage = ImageProcessor.applyBlur(inputImage, blurRadius);
    nodeData.data = blurredImage;
}
```

---

#### 3. Brightness Operation Node (`BrightnessOperationNode`)

**Purpose**: Adjusts the brightness of input images.

**Type ID**: `CSpecs.NodeType.Brightness` (3)

**Properties**:
- Has one input port and one output port
- Adjusts image brightness by adding/subtracting from pixel values
- Configurable brightness level (-1.0 to 1.0)

**Ports**:
- **Input Port**: (Left side) - Receives image to adjust
- **Output Port**: (Right side) - Emits brightness-adjusted image

**Properties**:
- `brightnessLevel`: Real value (-1.0 to 1.0) where 0 = normal, negative = darker, positive = brighter
- `nodeData.input`: Input image data
- `nodeData.data`: Processed image with adjusted brightness

**Behavior**:
- Waits for input image to be connected
- Adjusts brightness by modifying RGB values
- Updates output when brightness level changes
- Shows status indicator (✓ Adjusted or Waiting...)

**Visual Appearance**:
- Icon: Sun/Brightness icon (Font Awesome \uf185)
- Color: Orange (#F5A623)
- Size: 250x70 pixels (expands based on content)
- Slider control for brightness level (-1.0 to 1.0)
- Status text showing processing state

**Usage Example**:
- Connect ImageInput output → Brightness input
- Adjust brightness slider (-1.0 to 1.0)
- Output shows brighter or darker image

![Brightness Operation Node](images/brightness-operation-node.png) <!-- TODO: Insert screenshot of BrightnessOperationNode with controls -->

**Code Implementation**:
```qml
function updataData() {
    if (!nodeData.input) {
        nodeData.data = null;
        return;
    }
    var inputImage = nodeData.input;
    if (!ImageProcessor.isValidImage(inputImage)) {
        nodeData.data = null;
        return;
    }
    var processedImage = ImageProcessor.applyBrightness(inputImage, brightnessLevel);
    nodeData.data = processedImage;
}
```

---

#### 4. Contrast Operation Node (`ContrastOperationNode`)

**Purpose**: Adjusts the contrast of input images.

**Type ID**: `CSpecs.NodeType.Contrast` (4)

**Properties**:
- Has one input port and one output port
- Adjusts image contrast by scaling pixel values around midpoint
- Configurable contrast level (-1.0 to 1.0)

**Ports**:
- **Input Port**: (Left side) - Receives image to adjust
- **Output Port**: (Right side) - Emits contrast-adjusted image

**Properties**:
- `contrastLevel`: Real value (-1.0 to 1.0) where 0 = normal, negative = less contrast, positive = more contrast
- `nodeData.input`: Input image data
- `nodeData.data`: Processed image with adjusted contrast

**Behavior**:
- Waits for input image to be connected
- Adjusts contrast using formula: `newValue = factor * (oldValue - 128) + 128`
- Updates output when contrast level changes
- Shows status indicator (✓ Enhanced or Waiting...)

**Visual Appearance**:
- Icon: Contrast/Eye icon (Font Awesome \uf042)
- Color: Pink (#E91E63)
- Size: 250x70 pixels (expands based on content)
- Slider control for contrast level (-1.0 to 1.0)
- Status text showing processing state

**Usage Example**:
- Connect ImageInput output → Contrast input
- Adjust contrast slider (-1.0 to 1.0)
- Output shows image with adjusted contrast

![Contrast Operation Node](images/VisionLink_15055.png) <!-- TODO: Insert screenshot of ContrastOperationNode with controls -->

**Code Implementation**:
```qml
function updataData() {
    if (!nodeData.input) {
        nodeData.data = null;
        return;
    }
    var inputImage = nodeData.input;
    if (!ImageProcessor.isValidImage(inputImage)) {
        nodeData.data = null;
        return;
    }
    var processedImage = ImageProcessor.applyContrast(inputImage, contrastLevel);
    nodeData.data = processedImage;
}
```

---

#### 5. Image Result Node (`ImageResultNode`)

**Purpose**: Displays the final processed image result.

**Type ID**: `CSpecs.NodeType.ImageResult` (1)

**Properties**:
- Contains a single input port
- Displays processed images for visual feedback
- Read-only display node

**Ports**:
- **Input Port**: (Left side) - Receives processed image to display

**Properties**:
- `nodeData.data`: QImage object to display

**Behavior**:
- Receives image from connected operation node
- Converts QImage to data URL for display
- Updates automatically when input image changes
- Shows "No Image" when no input is connected

**Visual Appearance**:
- Icon: Image/Photo icon (Font Awesome \uf03e)
- Color: Gray (#444)
- Size: 250x220 pixels
- Displays image preview with aspect ratio preserved
- Shows status text when no image is available

**Usage Example**:
- Connect any operation node output → ImageResult input
- ImageResult displays the processed image
- Useful for viewing final results or intermediate steps

![Image Result Node](images/VisionLink_15111.png) <!-- TODO: Insert screenshot of ImageResultNode displaying processed image -->

**Display Behavior**:
- Converts QImage to base64 data URL
- Displays image using QML Image component
- Preserves aspect ratio
- Shows loading/error states

---

#### Node Type Summary Table

| Node Type | Type ID | Input Ports | Output Ports | Operation | Color |
|-----------|---------|-------------|--------------|-----------|-------|
| ImageInput | 0 | 0 | 1 | Load image from file | Gray (#444) |
| ImageResult | 1 | 1 | 0 | Display image | Gray (#444) |
| Blur | 2 | 1 | 1 | Apply blur effect | Purple (#9013FE) |
| Brightness | 3 | 1 | 1 | Adjust brightness | Orange (#F5A623) |
| Contrast | 4 | 1 | 1 | Adjust contrast | Pink (#E91E63) |

---

#### Data Flow Architecture

The image processing follows a pipeline pattern:

```
Image Input Node (loads image)
    ↓
Operation Nodes (Blur/Brightness/Contrast)
    ↓
Image Result Node (displays result)
```

Images flow through the pipeline as QImage objects, processed by C++ code for performance.

![Data Flow Diagram](images/VisionLink_15147.png) <!-- TODO: Insert diagram showing image data flow through nodes -->

---

### c. Step-by-Step Building Guide

This guide will walk you through building the VisionLink Example from scratch, explaining each component and how they work together.

#### Prerequisites

- Qt 6.2.4 or later (Qt 6.10.0 recommended)
- CMake 3.1.0 or later
- C++ compiler with C++14 support (MSVC 2019/2022 on Windows)
- NodeLink framework built and installed
- QtQuickStream module built and installed
- Basic understanding of C++/QML integration

#### Step 1: Project Setup

##### 1.1 Create Project Structure

Create the following directory structure:

```
visionLink/
├── CMakeLists.txt
├── main.cpp
├── main.qml
├── ImageProcessor.h
├── ImageProcessor.cpp
└── resources/
    ├── Core/
    ├── View/
    └── fonts/
```

##### 1.2 Configure CMakeLists.txt

Create `CMakeLists.txt` with the following configuration:

```cmake
cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Create executable
qt_add_executable(VisionLink main.cpp)

# Set singletons
set_source_files_properties(
    resources/Core/CSpecs.qml
    resources/Core/ImageProcessor.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# Define QML module
qt_add_qml_module(VisionLink
    URI "VisionLink"
    VERSION 1.0
    QML_FILES
        main.qml
        resources/Core/CSpecs.qml
        resources/Core/ImageProcessor.qml
        resources/Core/VisionLinkScene.qml
        resources/Core/ImageInputNode.qml
        resources/Core/ImageResultNode.qml
        resources/Core/OperationNode.qml
        resources/Core/OperationNodeData.qml
        resources/Core/BlurOperationNode.qml
        resources/Core/BrightnessOperationNode.qml
        resources/Core/ContrastOperationNode.qml
        resources/View/VisionLinkView.qml
        resources/View/VisionLinkNodeView.qml
    SOURCES
        ImageProcessor.h
        ImageProcessor.cpp
    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
)

target_include_directories(VisionLink PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_link_libraries(VisionLink PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
```

**Key Points**:
- Links to `NodeLinkplugin` and `QtQuickStreamplugin`
- Sets `CSpecs.qml` and `ImageProcessor.qml` as singletons
- Includes C++ source files for image processing
- Includes Font Awesome fonts for icons

---

#### Step 2: Create C++ Image Processor

##### 2.1 ImageProcessor.h

Create `ImageProcessor.h` - C++ header for image processing:

```cpp
#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H

#include <QObject>
#include <QImage>
#include <QString>
#include <QUrl>
#include <QVariant>
#include <QQmlEngine>
#include <QJSEngine>

class ImageProcessor : public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(ImageProcessorCPP)
    QML_SINGLETON

public:
    explicit ImageProcessor(QObject *parent = nullptr);
    
    static ImageProcessor* create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
    {
        Q_UNUSED(jsEngine);
        return new ImageProcessor(qmlEngine);
    }

    Q_INVOKABLE QVariant loadImage(const QString &path);
    Q_INVOKABLE QVariant applyBlur(const QVariant &imageData, qreal radius);
    Q_INVOKABLE QVariant applyBrightness(const QVariant &imageData, qreal level);
    Q_INVOKABLE QVariant applyContrast(const QVariant &imageData, qreal level);
    Q_INVOKABLE QString saveToDataUrl(const QVariant &imageData);
    Q_INVOKABLE bool isValidImage(const QVariant &imageData) const;

private:
    QImage variantToImage(const QVariant &imageData) const;
    QVariant imageToVariant(const QImage &image) const;
    QImage boxBlur(const QImage &source, int radius);
    QImage adjustBrightness(const QImage &source, qreal level);
    QImage adjustContrast(const QImage &source, qreal level);
};

#endif // IMAGEPROCESSOR_H
```

**Key Features**:
- QML singleton accessible from QML
- Methods for loading and processing images
- Helper methods for QVariant/QImage conversion
- Image processing algorithms (blur, brightness, contrast)

---

##### 2.2 ImageProcessor.cpp

Create `ImageProcessor.cpp` - C++ implementation (see source file for full implementation).

**Key Algorithms**:

1. **Box Blur**: Two-pass blur (horizontal then vertical) for performance
2. **Brightness**: Adds/subtracts value from RGB channels
3. **Contrast**: Scales pixel values around midpoint (128)

**Key Features**:
- Handles file:// URL cleanup
- Ensures detached image copies for memory safety
- Converts images to data URLs for QML display
- Validates image data

---

#### Step 3: Create QML Image Processor Wrapper

##### 3.1 ImageProcessor.qml

Create `resources/Core/ImageProcessor.qml` - QML wrapper for C++ processor:

```qml
pragma Singleton

import QtQuick
import VisionLink

QtObject {
    function loadImage(path) {
        return ImageProcessorCPP.loadImage(path);
    }
    
    function applyBlur(imageData, radius) {
        return ImageProcessorCPP.applyBlur(imageData, radius);
    }
    
    function applyBrightness(imageData, level) {
        return ImageProcessorCPP.applyBrightness(imageData, level);
    }
    
    function applyContrast(imageData, level) {
        return ImageProcessorCPP.applyContrast(imageData, level);
    }
    
    function saveToDataUrl(imageData) {
        return ImageProcessorCPP.saveToDataUrl(imageData);
    }
    
    function isValidImage(imageData) {
        return ImageProcessorCPP.isValidImage(imageData);
    }
}
```

**Purpose**: Provides a clean QML interface to C++ image processing functions.

---

#### Step 4: Create Specifications

##### 4.1 CSpecs.qml

Create `resources/Core/CSpecs.qml`:

```qml
pragma Singleton
import QtQuick

QtObject {
    enum NodeType {
        ImageInput      = 0,
        ImageResult     = 1,
        Blur            = 2,
        Brightness      = 3,
        Contrast        = 4,
        Operation       = 5,
        Unknown         = 99
    }

    enum OperationType {
        Blur            = 0,
        Brightness      = 1,
        Contrast        = 2,
        Unknown         = 99
    }
}
```

---

#### Step 5: Create Node Data Models

##### 5.1 OperationNodeData.qml

Create `resources/Core/OperationNodeData.qml`:

```qml
import QtQuick
import NodeLink

I_NodeData {
    property var input: null
}
```

**Purpose**: Stores input image data for operation nodes.

---

#### Step 6: Create Base Node Types

##### 6.1 OperationNode.qml

Create `resources/Core/OperationNode.qml` - base class for operation nodes:

```qml
import QtQuick
import NodeLink

Node {
    property int operationType: CSpecs.OperationType.Blur
    
    type: CSpecs.NodeType.Operation
    nodeData: OperationNodeData {}
    
    guiConfig.width: 250
    guiConfig.height: 70

    Component.onCompleted: addPorts();

    function addPorts() {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable = false;

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
        addPort(_port2);
    }
}
```

---

#### Step 7: Create Specific Operation Nodes

##### 7.1 BlurOperationNode.qml

Create `resources/Core/BlurOperationNode.qml`:

```qml
import QtQuick
import NodeLink
import VisionLink

OperationNode {
    operationType: CSpecs.OperationType.Blur
    type: CSpecs.NodeType.Blur
    
    property real blurRadius: 5.0

    function updataData() {
        if (!nodeData.input) {
            nodeData.data = null;
            return;
        }
        var inputImage = nodeData.input;
        if (!ImageProcessor.isValidImage(inputImage)) {
            nodeData.data = null;
            return;
        }
        var blurredImage = ImageProcessor.applyBlur(inputImage, blurRadius);
        nodeData.data = blurredImage;
    }
}
```

---

##### 7.2 BrightnessOperationNode.qml

Create `resources/Core/BrightnessOperationNode.qml`:

```qml
import QtQuick
import NodeLink
import VisionLink

OperationNode {
    operationType: CSpecs.OperationType.Brightness
    type: CSpecs.NodeType.Brightness
    
    property real brightnessLevel: 0.0

    function updataData() {
        if (!nodeData.input) {
            nodeData.data = null;
            return;
        }
        var inputImage = nodeData.input;
        if (!ImageProcessor.isValidImage(inputImage)) {
            nodeData.data = null;
            return;
        }
        var processedImage = ImageProcessor.applyBrightness(inputImage, brightnessLevel);
        nodeData.data = processedImage;
    }
}
```

---

##### 7.3 ContrastOperationNode.qml

Create `resources/Core/ContrastOperationNode.qml`:

```qml
import QtQuick
import NodeLink
import VisionLink

OperationNode {
    operationType: CSpecs.OperationType.Contrast
    type: CSpecs.NodeType.Contrast
    
    property real contrastLevel: 0.0

    function updataData() {
        if (!nodeData.input) {
            nodeData.data = null;
            return;
        }
        var inputImage = nodeData.input;
        if (!ImageProcessor.isValidImage(inputImage)) {
            nodeData.data = null;
            return;
        }
        var processedImage = ImageProcessor.applyContrast(inputImage, contrastLevel);
        nodeData.data = processedImage;
    }
}
```

---

#### Step 8: Create Input and Result Nodes

##### 8.1 ImageInputNode.qml

Create `resources/Core/ImageInputNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.ImageInput
    nodeData: I_NodeData {}
    
    guiConfig.width: 250
    guiConfig.height: 220
    
    property string imagePath: ""

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
        imagePath = "";
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right
        addPort(_port1);
    }

    function loadImage(path) {
        imagePath = path;
        var loadedImage = ImageProcessor.loadImage(path);
        if (ImageProcessor.isValidImage(loadedImage)) {
            nodeData.data = loadedImage;
        } else {
            nodeData.data = null;
        }
    }
}
```

---

##### 8.2 ImageResultNode.qml

Create `resources/Core/ImageResultNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    type: CSpecs.NodeType.ImageResult
    nodeData: I_NodeData {}
    
    guiConfig.width: 250
    guiConfig.height: 220

    Component.onCompleted: addPorts();

    onCloneFrom: function (baseNode) {
        nodeData.data = null;
    }

    function addPorts() {
        let _port1 = NLCore.createPort();
        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        addPort(_port1);
    }
}
```

---

#### Step 9: Create the Scene

##### 9.1 VisionLinkScene.qml

Create `resources/Core/VisionLinkScene.qml` - the main scene with image data propagation:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import VisionLink

I_Scene {
    id: scene

    nodeRegistry: NLNodeRegistry {
        _qsRepo: scene._qsRepo
        imports: ["VisionLink"]
        defaultNode: CSpecs.NodeType.ImageInput
        
        nodeTypes: [
            CSpecs.NodeType.ImageInput = "ImageInputNode",
            CSpecs.NodeType.ImageResult = "ImageResultNode",
            CSpecs.NodeType.Blur = "BlurOperationNode",
            CSpecs.NodeType.Brightness = "BrightnessOperationNode",
            CSpecs.NodeType.Contrast = "ContrastOperationNode"
        ];
        
        nodeNames: [
            CSpecs.NodeType.ImageInput = "Image Input",
            CSpecs.NodeType.ImageResult = "Image Result",
            CSpecs.NodeType.Blur = "Blur",
            CSpecs.NodeType.Brightness = "Brightness",
            CSpecs.NodeType.Contrast = "Contrast"
        ];
        
        nodeIcons: [
            CSpecs.NodeType.ImageInput = "\uf093",
            CSpecs.NodeType.ImageResult = "\uf03e",
            CSpecs.NodeType.Blur = "\uf1fc",
            CSpecs.NodeType.Brightness = "\uf185",
            CSpecs.NodeType.Contrast = "\uf042"
        ];
        
        nodeColors: [
            CSpecs.NodeType.ImageInput = "#444",
            CSpecs.NodeType.ImageResult = "#444",
            CSpecs.NodeType.Blur = "#9013FE",
            CSpecs.NodeType.Brightness = "#F5A623",
            CSpecs.NodeType.Contrast = "#E91E63"
        ];
    }

    selectionModel: SelectionModel {
        existObjects: [...Object.keys(nodes), ...Object.keys(links)]
    }

    property UndoCore _undoCore: UndoCore {
        scene: scene
    }

    onLinkRemoved: _upateDataTimer.start();
    onNodeRemoved: _upateDataTimer.start();
    onLinkAdded: updateData();

    property Timer _upateDataTimer: Timer {
        repeat: false
        running: false
        interval: 1
        onTriggered: scene.updateData();
    }

    function createCustomizeNode(nodeType, xPos, yPos) {
        var title = nodeRegistry.nodeNames[nodeType] + "_" + 
                   (Object.values(scene.nodes).filter(node => node.type === nodeType).length + 1);
        return createSpecificNode(nodeRegistry.imports, nodeType,
                                 nodeRegistry.nodeTypes[nodeType],
                                 nodeRegistry.nodeColors[nodeType],
                                 title, xPos, yPos);
    }

    // Update all node data with iterative propagation
    function updateData() {
        // Reset operation and result nodes
        Object.values(nodes).forEach(node => {
            switch (node.type) {
                case CSpecs.NodeType.Blur:
                case CSpecs.NodeType.Brightness:
                case CSpecs.NodeType.Contrast: {
                    node.nodeData.data = null;
                    node.nodeData.input = null;
                } break;
                case CSpecs.NodeType.ImageResult: {
                    node.nodeData.data = null;
                } break;
            }
        });

        // Iterative propagation algorithm
        var allLinks = Object.values(links);
        var remainingLinks = allLinks.slice();
        var maxIterations = 100;
        var iteration = 0;
        
        while (remainingLinks.length > 0 && iteration < maxIterations) {
            iteration++;
            var linksProcessedThisIteration = [];
            var linksStillWaiting = [];
            
            remainingLinks.forEach(function(link) {
                var portA = link.inputPort._qsUuid;
                var portB = link.outputPort._qsUuid;
                var upstreamNode = findNode(portA);
                var downStreamNode = findNode(portB);
                
                var upstreamHasData = upstreamNode.nodeData.data !== null && 
                                     upstreamNode.nodeData.data !== undefined;
                
                if (upstreamNode.type === CSpecs.NodeType.ImageInput) {
                    upstreamHasData = true;
                }
                
                if (upstreamHasData) {
                    upadateNodeData(upstreamNode, downStreamNode);
                    linksProcessedThisIteration.push(link);
                } else {
                    linksStillWaiting.push(link);
                }
            });
            
            remainingLinks = linksStillWaiting;
            
            if (linksProcessedThisIteration.length === 0) {
                break;
            }
        }
    }

    // Update data from a specific node (for parameter changes)
    function updateDataFromNode(startingNode) {
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
            
            var downstreamLinks = Object.values(links).filter(function(link) {
                var upstreamNodeId = findNodeId(link.inputPort._qsUuid);
                return upstreamNodeId === currentNode._qsUuid;
            });
                        
            downstreamLinks.forEach(function(link) {
                var portB = link.outputPort._qsUuid;
                var downStreamNode = findNode(portB);
                upadateNodeData(currentNode, downStreamNode);
                
                if (processedNodes.indexOf(downStreamNode._qsUuid) === -1) {
                    nodesToUpdate.push(downStreamNode);
                }
            });
        }
    }

    // Update specific node data
    function upadateNodeData(upstreamNode, downStreamNode) {
        switch (downStreamNode.type) {
            case CSpecs.NodeType.Blur:
            case CSpecs.NodeType.Brightness:
            case CSpecs.NodeType.Contrast: {
                downStreamNode.nodeData.input = upstreamNode.nodeData.data;
                downStreamNode.updataData();
            } break;
            case CSpecs.NodeType.ImageResult: {
                downStreamNode.nodeData.data = upstreamNode.nodeData.data;
            } break;
        }
    }

    // Link validation (same as other examples)
    function linkNodes(portA, portB) {
        if (!canLinkNodes(portA, portB)) {
            console.error("[Scene] Cannot link Nodes");
            return;
        }
        let link = Object.values(links).find(conObj =>
            conObj.inputPort._qsUuid === portA &&
            conObj.outputPort._qsUuid === portB);
        if (link === undefined)
            createLink(portA, portB);
    }

    function canLinkNodes(portA, portB) {
        // Validation logic (see source file)
        return true;
    }
}
```

**Key Features**:
- **Iterative Propagation**: Handles complex image data flow
- **Parameter Updates**: `updateDataFromNode()` for real-time parameter changes
- **Image Data Handling**: Properly propagates QImage objects through the graph

![Scene Architecture](images/VisionLink_15863.png) <!-- TODO: Insert diagram showing scene structure and data flow -->

---

#### Step 10: Create Views

##### 10.1 VisionLinkNodeView.qml

Create `resources/View/VisionLinkNodeView.qml` - custom view with image display and controls (see source file for full implementation).

**Key Features**:
- **Dynamic Components**: Different views for each node type
- **Image Display**: Shows image previews in ImageInput and ImageResult nodes
- **Interactive Controls**: Sliders for operation parameters
- **Status Indicators**: Shows processing state
- **Minimal Mode**: Icon-only view when zoomed out

---

##### 10.2 VisionLinkView.qml

Create `resources/View/VisionLinkView.qml`:

```qml
import QtQuick
import QtQuick.Controls
import NodeLink
import QtQuickStream
import VisionLink

Item {
    id: view
    property VisionLinkScene scene

    property SceneSession sceneSession: SceneSession {
        enabledOverview: false;
        doNodesNeedImage: false
    }

    NodesScene {
        id: nodesScene
        anchors.fill: parent
        scene: view.scene
        sceneSession: view.sceneSession
        sceneContent: NodesRect {
            scene: view.scene
            sceneSession: view.sceneSession
            nodeViewComponent: Qt.createComponent("VisionLinkNodeView.qml")
        }
    }

    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }
}
```

---

#### Step 11: Create Main Application

##### 11.1 main.cpp

Create `main.cpp`:

```cpp
#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");
    engine.addImportPath(":/");

    const QUrl url(u"qrc:/VisionLink/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
```

---

##### 11.2 main.qml

Create `main.qml`:

```qml
import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuickStream
import NodeLink
import VisionLink

Window {
    id: window
    property VisionLinkScene scene: null

    width: 1280
    height: 960
    visible: true
    title: qsTr("VisionLink Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "VisionLink"])
        NLCore.defaultRepo.initRootObject("VisionLinkScene");
        window.scene = Qt.binding(function() { 
            return NLCore.defaultRepo.qsRootObject;
        });
    }

    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/VisionLink/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }

    VisionLinkView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
```

![Main Application Layout](images/VisionLink_Example1.png)

---

#### Step 12: Build and Run

##### 12.1 Configure Build

1. Create a build directory:
   ```bash
   mkdir build
   cd build
   ```

2. Configure with CMake:
   ```bash
   cmake .. -DCMAKE_PREFIX_PATH=<Qt_Install_Path>
   ```

3. Build the project:
   ```bash
   cmake --build .
   ```

##### 12.2 Run the Application

Run the executable:
```bash
./VisionLink  # Linux/Mac
VisionLink.exe  # Windows
```

---

#### Step 13: Using VisionLink

##### Basic Usage

1. **Load Image**:
   - Add an ImageInput node
   - Click "Load Image" button
   - Select an image file

2. **Apply Operations**:
   - Add operation nodes (Blur, Brightness, Contrast)
   - Connect ImageInput output → Operation input
   - Adjust sliders to change parameters
   - See real-time updates

3. **View Results**:
   - Add ImageResult node
   - Connect operation output → ImageResult input
   - View processed image

##### Example: Blur Pipeline

**Setup**:
1. Add ImageInput node → Load image
2. Add Blur node
3. Add ImageResult node

**Connections**:
- ImageInput → Blur
- Blur → ImageResult

**Usage**:
- Adjust blur radius slider
- See blurred result in ImageResult node

##### Example: Multi-Step Pipeline

**Setup**:
1. ImageInput → Blur → Brightness → Contrast → ImageResult

**Usage**:
- Adjust any operation parameter
- See final result in ImageResult
- All downstream nodes update automatically

![Example Workflow](images/VisionLink_Example1.png)

---

### Architecture Overview

#### Component Hierarchy

```
VisionLinkScene (I_Scene)
├── NodeRegistry (defines node types)
├── SelectionModel (manages selection)
├── UndoCore (undo/redo support)
└── Nodes & Links
    ├── ImageInputNode (loads images)
    ├── OperationNodes (Blur, Brightness, Contrast)
    └── ImageResultNode (displays results)

ImageProcessor (C++ Singleton)
├── loadImage() (loads from file)
├── applyBlur() (box blur algorithm)
├── applyBrightness() (brightness adjustment)
├── applyContrast() (contrast adjustment)
└── saveToDataUrl() (converts to base64)

Main Window
├── VisionLinkView
│   ├── NodesScene (canvas)
│   │   └── NodesRect (renders nodes)
│   │       └── VisionLinkNodeView (custom node UI)
│   └── SideMenu (add nodes)
```

#### Data Flow

```
Image File
    ↓
ImageInputNode (loads QImage)
    ↓
OperationNode (processes QImage)
    ↓
ImageResultNode (displays QImage)
```

Images flow as QImage objects through the pipeline, processed by C++ for performance.

![Architecture Diagram](images/VisionLink_16132.png) <!-- TODO: Insert comprehensive architecture diagram -->

---

### Key Concepts

#### C++/QML Integration

- **QML Singleton**: C++ class registered as QML singleton
- **QVariant Transfer**: Images transferred as QVariant containing QImage
- **Memory Management**: Detached copies ensure proper memory handling
- **Data URLs**: Images converted to base64 data URLs for QML display

#### Image Processing

- **Box Blur**: Two-pass blur algorithm (horizontal + vertical)
- **Brightness**: Adds/subtracts value from RGB channels
- **Contrast**: Scales pixel values around midpoint

#### Data Propagation

- **Iterative Algorithm**: Handles complex processing chains
- **Parameter Updates**: Real-time updates when parameters change
- **Validation**: Checks for valid images before processing

---

### Extending VisionLink

#### Adding New Operations

To add a new operation (e.g., Grayscale):

1. **Add to CSpecs.qml**:
   ```qml
   enum NodeType {
       // ... existing
       Grayscale = 5
   }
   ```

2. **Add C++ Method** in ImageProcessor:
   ```cpp
   Q_INVOKABLE QVariant applyGrayscale(const QVariant &imageData);
   ```

3. **Create GrayscaleOperationNode.qml**:
   ```qml
   OperationNode {
       operationType: CSpecs.OperationType.Grayscale
       type: CSpecs.NodeType.Grayscale
       function updataData() {
           // Implementation
       }
   }
   ```

4. **Register in VisionLinkScene.qml**

5. **Add View Component** in VisionLinkNodeView.qml

#### Performance Optimization

- Use C++ for heavy processing
- Cache processed images when possible
- Optimize blur algorithm (use GPU if available)
- Reduce image resolution for previews

---

### Troubleshooting

#### Common Issues

1. **Images Not Loading**:
   - Check file path format
   - Verify image format is supported
   - Check file permissions

2. **Processing Slow**:
   - Large images take longer
   - Consider downscaling for preview
   - Optimize C++ algorithms

3. **Images Not Displaying**:
   - Check data URL conversion
   - Verify QImage is valid
   - Check console for errors

4. **Parameters Not Updating**:
   - Verify `updateDataFromNode()` is called
   - Check slider value changes
   - Ensure scene update is triggered

#### Debug Tips

- Enable console logging
- Check image validity: `ImageProcessor.isValidImage()`
- Verify data propagation: `console.log(node.nodeData.data)`
- Monitor memory usage with large images

---

### Conclusion

The VisionLink Example demonstrates how to build sophisticated image processing applications with NodeLink. Key takeaways:

- **C++ Integration**: Use C++ for performance-critical operations
- **Complex Data Types**: Handle images and other complex data through nodes
- **Real-Time Processing**: Update results as parameters change
- **Visual Feedback**: Display images directly in nodes
- **Extensible Design**: Easy to add new operations and effects

This example serves as a foundation for building:
- Professional image editing tools
- Computer vision applications
- Scientific image processing
- Artistic image manipulation tools
- Automated image processing pipelines

For more examples, see the other examples in the NodeLink repository.

![Final Example](images/VisionLink_Example1.png)

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


## C++ Classes

### ObjectCreator

**Location**: `include/NodeLink/Core/objectcreator.h`  
**Source**: `Source/Core/objectcreator.cpp`  
**QML Name**: `ObjectCreator`  
**Type**: QML Singleton  
**Inherits**: `QObject`  
**Purpose**: Factory class for creating QML components programmatically with caching for improved performance.

#### Where to Use

**ObjectCreator** is used in the following contexts:

1. **Dynamic Component Creation** (View Layer):
   - Create node views dynamically from QML components
   - Create link views dynamically
   - Create container views dynamically
   - Batch creation of multiple items for performance

   ```qml
   // resources/View/I_NodesRect.qml
   // Create multiple node views at once
   var result = ObjectCreator.createItems(
       "node",           // Property name
       nodeArray,        // Array of node objects
       root,             // Parent item
       nodeViewUrl,      // Component URL
       baseProperties    // Base properties for all items
   );
   
   var createdItems = result.items;
   var needsPropertySet = result.needsPropertySet;
   ```

2. **Single Item Creation**:
   - Create individual QML items programmatically
   - Set initial properties during creation

   ```qml
   // Create a single item
   var result = ObjectCreator.createItem(
       parentItem,       // Parent QQuickItem
       componentUrl,     // URL to QML component
       properties        // Initial properties map
   );
   
   var item = result.item;
   var needsPropertySet = result.needsPropertySet;
   ```

3. **Performance Optimization**:
   - Component caching for faster subsequent creations
   - Batch operations for creating multiple items efficiently
   - Asynchronous component loading

**Use Cases**:
- **Node View Creation**: Dynamically create NodeView components for each node in the scene
- **Link View Creation**: Create LinkView components for connections
- **Container View Creation**: Create ContainerView components for containers
- **Batch Operations**: Create multiple views at once for better performance

#### Public Methods

##### `createItem(parentItem: QQuickItem, componentUrl: string, properties: QVariantMap): QVariantMap`

Creates a single QML item from a component URL.

**Parameters**:
- `parentItem`: Parent QQuickItem for the created item
- `componentUrl`: URL string to the QML component file
- `properties`: QVariantMap of initial properties to set on the created item

**Returns**: QVariantMap with:
- `item`: QVariant containing the created QQuickItem (or null if creation failed)
- `needsPropertySet`: Boolean indicating if properties need to be set manually (Qt < 6.2.4)

**Example**:
```qml
var result = ObjectCreator.createItem(
    parentItem,
    "qrc:/MyApp/MyComponent.qml",
    {
        "property1": value1,
        "property2": value2
    }
);

if (result.item) {
    var createdItem = result.item;
    // Use created item
}
```

**Note**: For Qt 6.2.4+, properties are set automatically during creation. For older versions, you may need to set properties manually if `needsPropertySet` is `true`.

##### `createItems(name: string, itemArray: QVariantList, parentItem: QQuickItem, componentUrl: string, baseProperties: QVariantMap): QVariantMap`

Creates multiple QML items from the same component in a batch operation.

**Parameters**:
- `name`: Property name to set for each item in the array
- `itemArray`: QVariantList of objects to create items for
- `parentItem`: Parent QQuickItem for all created items
- `componentUrl`: URL string to the QML component file
- `baseProperties`: QVariantMap of base properties applied to all items

**Returns**: QVariantMap with:
- `items`: QVariantList of created QQuickItem objects
- `needsPropertySet`: Boolean indicating if properties need to be set manually

**Example**:
```qml
// Create node views for multiple nodes
var nodeArray = Object.values(scene.nodes);
var result = ObjectCreator.createItems(
    "node",                    // Property name
    nodeArray,                 // Array of node objects
    nodesRect,                 // Parent item
    "qrc:/NodeLink/NodeView.qml",  // Component URL
    {                          // Base properties
        "scene": scene,
        "sceneSession": sceneSession
    }
);

var createdViews = result.items;
createdViews.forEach(function(view) {
    // Process each created view
});
```

**Performance**: This method is optimized for batch creation and includes component caching. Use this instead of multiple `createItem()` calls for better performance.

#### Private Methods

##### `getOrCreateComponent(componentUrl: string): QQmlComponent*`

Internal method that caches components for reuse. Components are cached in a QHash for fast subsequent access.

**Note**: This is a private method and cannot be called directly from QML.

#### Implementation Details

- **Component Caching**: Components are cached in `m_components` QHash to avoid reloading
- **Asynchronous Loading**: Components are loaded asynchronously for better performance
- **Memory Management**: Created items use `QQmlEngine::JavaScriptOwnership` for proper cleanup
- **Qt Version Compatibility**: Handles differences between Qt 5 and Qt 6 for property setting

---

### HashCompareStringCPP

**Location**: `include/NodeLink/Core/HashCompareStringCPP.h`  
**Source**: `Source/Core/HashCompareStringCPP.cpp`  
**QML Name**: `HashCompareString`  
**Type**: QML Singleton  
**Inherits**: `QObject`  
**Purpose**: Provides efficient string comparison using MD5 hashing for comparing UUID strings and other identifiers.

#### Where to Use

**HashCompareStringCPP** is used in the following contexts:

1. **UUID Comparison** (Scene Link Validation):
   - Compare port UUIDs when checking for duplicate links
   - Compare node UUIDs when validating connections
   - Efficient comparison of string identifiers

   ```qml
   // resources/Core/Scene.qml
   function canLinkNodes(portA: string, portB: string): bool {
       // Check for duplicate links
       var sameLinks = Object.values(links).filter(link =>
           HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
           HashCompareString.compareStringModels(link.outputPort._qsUuid, portB));
       
       if (sameLinks.length > 0)
           return false;
       
       // Compare node UUIDs
       var nodeA = findNodeId(portA);
       var nodeB = findNodeId(portB);
       if (HashCompareString.compareStringModels(nodeA, nodeB))
           return false;  // Same node
   }
   ```

2. **Link Validation**:
   - Check if a link already exists between two ports
   - Validate port connections
   - Prevent duplicate connections

   ```qml
   // Check for existing link
   var existingLink = Object.values(links).find(link =>
       HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
       HashCompareString.compareStringModels(link.outputPort._qsUuid, portB)
   );
   ```

3. **Performance-Critical Comparisons**:
   - When comparing many strings (e.g., iterating over all links)
   - UUID comparisons in validation loops
   - String identity checks

**Use Cases**:
- **Calculator Example**: Validates links and prevents duplicates
- **Logic Circuit Example**: Validates gate connections
- **VisionLink Example**: Validates image processing pipeline connections
- **Chatbot Example**: Validates conversation flow connections
- **All Scene Implementations**: Link validation and UUID comparison

#### Public Methods

##### `compareStringModels(strModelFirst: string, strModelSecond: string): bool`

Compares two strings using MD5 hash comparison for efficient equality checking.

**Parameters**:
- `strModelFirst`: First string to compare
- `strModelSecond`: Second string to compare

**Returns**: `true` if strings are equal (same MD5 hash), `false` otherwise

**Example**:
```qml
// Compare UUIDs
var port1Uuid = port1._qsUuid;
var port2Uuid = port2._qsUuid;

if (HashCompareString.compareStringModels(port1Uuid, port2Uuid)) {
    console.log("Ports have the same UUID");
}

// Check for duplicate link
var isDuplicate = Object.values(links).some(function(link) {
    return HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
           HashCompareString.compareStringModels(link.outputPort._qsUuid, portB);
});
```

**Performance**: Uses MD5 hashing for efficient comparison, especially useful when comparing many strings in loops.

**Algorithm**: 
1. Computes MD5 hash of both strings
2. Compares the hash values
3. Returns `true` if hashes match (strings are equal)

---

### BackgroundGridsCPP

**Location**: `include/NodeLink/View/BackgroundGridsCPP.h`  
**Source**: `Source/View/BackgroundGridsCPP.cpp`  
**QML Name**: `BackgroundGridsCPP`  
**Type**: QML Element  
**Inherits**: `QQuickItem`  
**Purpose**: High-performance background grid rendering using Qt's Scene Graph (QSG) for GPU-accelerated rendering.

#### Where to Use

**BackgroundGridsCPP** is used in the following contexts:

1. **Scene Background** (View Layer):
   - Render background grid in the scene view
   - Provide visual reference for node positioning
   - Support snap-to-grid functionality

   ```qml
   // resources/View/SceneViewBackground.qml
   BackgroundGridsCPP {
       anchors.fill: parent
       spacing: NLStyle.backgroundGrid.spacing
   }
   ```

2. **Grid Visualization**:
   - Display grid points or lines in the scene
   - Provide visual feedback for alignment
   - Support zoom-aware grid rendering

   ```qml
   // Custom grid configuration
   BackgroundGridsCPP {
       id: backgroundGrid
       anchors.fill: parent
       spacing: 20  // Grid spacing in pixels
       
       onSpacingChanged: {
           console.log("Grid spacing changed to:", spacing);
       }
   }
   ```

3. **Performance-Critical Rendering**:
   - When rendering large scenes with many grid points
   - When grid needs to update frequently
   - When smooth scrolling/zooming is required

**Use Cases**:
- **All NodeLink Views**: Background grid in scene canvas
- **Zoom Operations**: Grid updates when zooming
- **Snap-to-Grid**: Visual feedback for grid snapping
- **Large Scenes**: Efficient rendering of grid for large canvases

#### Properties

##### `spacing: int`

Grid spacing in pixels. Determines the distance between grid points.

**Default**: `0` (grid disabled)

**Access**: Read/Write

**Signal**: `spacingChanged()` emitted when spacing changes

**Example**:
```qml
BackgroundGridsCPP {
    spacing: 20  // 20 pixels between grid points
}
```

**Note**: Setting spacing to `0` or negative value disables grid rendering.

#### Signals

##### `spacingChanged()`

Emitted when the `spacing` property changes.

**Example**:
```qml
BackgroundGridsCPP {
    onSpacingChanged: {
        console.log("Grid spacing:", spacing);
    }
}
```

#### Implementation Details

- **Scene Graph Rendering**: Uses `QQuickItem::updatePaintNode()` for GPU-accelerated rendering
- **Triangle-Based Grid**: Renders grid as series of small triangles for efficient GPU rendering
- **Automatic Updates**: Grid automatically updates when spacing or item size changes
- **Performance**: Optimized for rendering thousands of grid points efficiently
- **Memory Efficient**: Only allocates geometry when spacing > 0 and item has valid size

**Rendering Algorithm**:
1. Calculates number of grid points based on spacing and item size
2. Creates triangle geometry for each grid point (2x2 pixel squares)
3. Uses QSGFlatColorMaterial for rendering
4. Updates geometry only when spacing or size changes

---

### NLUtilsCPP

**Location**: `Utils/NLUtilsCPP.h`  
**Source**: `Utils/NLUtilsCPP.cpp`  
**QML Name**: `NLUtilsCPP`  
**Type**: QML Element  
**Inherits**: `QObject`  
**Purpose**: Utility functions for common operations like image conversion and key sequence formatting.

#### Where to Use

**NLUtilsCPP** is used in the following contexts:

1. **Image Processing**:
   - Convert image files to base64 strings
   - Convert image URLs to data strings
   - Prepare images for QML Image components

   ```qml
   // Convert image file to base64 string
   var imageString = NLUtilsCPP.imageURLToImageString("file:///path/to/image.png");
   // Use in Image component
   Image {
       source: "data:image/png;base64," + imageString
   }
   ```

2. **Key Sequence Formatting**:
   - Format keyboard shortcuts for display
   - Convert QKeySequence::StandardKey to readable string
   - Display shortcuts in UI

   ```qml
   // Format key sequence for display
   var keyString = NLUtilsCPP.keySequenceToString(QKeySequence.Copy);
   // Result: "Ctrl + C" (platform-specific)
   ```

**Use Cases**:
- **Image Handling**: Converting images for display in QML
- **UI Display**: Formatting keyboard shortcuts in menus and tooltips
- **File Operations**: Reading and converting image files

#### Public Methods

##### `imageURLToImageString(url: string): string`

Reads an image file and converts it to a base64-encoded string.

**Parameters**:
- `url`: File path or URL to the image file (supports `file://` URLs)

**Returns**: Base64-encoded string of the image data, or empty string on failure

**Example**:
```qml
// Load image from file
var imagePath = fileDialog.selectedFile;
var base64String = NLUtilsCPP.imageURLToImageString(imagePath);

// Use in Image component
Image {
    source: "data:image/png;base64," + base64String
}
```

**Error Handling**: Returns empty string if file cannot be opened or read.

##### `keySequenceToString(keySequence: int): string`

Converts a QKeySequence::StandardKey integer to a formatted string representation.

**Parameters**:
- `keySequence`: Integer value from QKeySequence::StandardKey enum

**Returns**: Formatted string with platform-specific key sequence (e.g., "Ctrl + C", "Cmd + C")

**Example**:
```qml
// Format standard key sequences
var copyKey = NLUtilsCPP.keySequenceToString(QKeySequence.Copy);
// Result: "Ctrl + C" (Windows/Linux) or "Cmd + C" (macOS)

var pasteKey = NLUtilsCPP.keySequenceToString(QKeySequence.Paste);
// Result: "Ctrl + V" (Windows/Linux) or "Cmd + V" (macOS)

// Display in UI
Text {
    text: "Copy: " + copyKey
}
```

**Format**: Keys are separated by " + " (space, plus, space) for readability.

**Platform Support**: Returns platform-specific key representations (Ctrl on Windows/Linux, Cmd on macOS).

---

### Common Usage Patterns

#### Creating Multiple Node Views

```qml
// Batch create node views for better performance
function onNodesAdded(nodeArray) {
    var result = ObjectCreator.createItems(
        "node",
        nodeArray,
        nodesRect,
        "qrc:/NodeLink/NodeView.qml",
        {
            "scene": scene,
            "sceneSession": sceneSession
        }
    );
    
    // Handle property setting for older Qt versions
    if (result.needsPropertySet) {
        for (var i = 0; i < result.items.length; i++) {
            result.items[i].node = nodeArray[i];
        }
    }
}
```

#### Validating Links with Hash Comparison

```qml
// Check if link already exists
function linkExists(portA, portB) {
    return Object.values(links).some(function(link) {
        return HashCompareString.compareStringModels(link.inputPort._qsUuid, portA) &&
               HashCompareString.compareStringModels(link.outputPort._qsUuid, portB);
    });
}
```

#### Custom Grid Configuration

```qml
BackgroundGridsCPP {
    id: grid
    anchors.fill: parent
    spacing: 25
    
    onSpacingChanged: {
        console.log("Grid spacing:", spacing);
    }
}

// Change grid spacing dynamically
function setGridSpacing(newSpacing) {
    grid.spacing = newSpacing;
}
```

#### Image Loading and Display

```qml
// Load and display image
function loadImage(imagePath) {
    var base64 = NLUtilsCPP.imageURLToImageString(imagePath);
    if (base64) {
        imageComponent.source = "data:image/png;base64," + base64;
    } else {
        console.error("Failed to load image:", imagePath);
    }
}
```

---

### Performance Considerations

#### ObjectCreator

- **Component Caching**: Components are cached after first use, making subsequent creations much faster
- **Batch Operations**: Use `createItems()` instead of multiple `createItem()` calls for better performance
- **Asynchronous Loading**: Components are loaded asynchronously to avoid blocking the UI thread

#### HashCompareStringCPP

- **MD5 Hashing**: Uses MD5 for efficient comparison, especially beneficial when comparing many strings
- **Use for UUIDs**: Optimized for comparing UUID strings and identifiers
- **Avoid for Short Strings**: For very short strings (< 10 characters), direct comparison may be faster

#### BackgroundGridsCPP

- **GPU Acceleration**: Uses Qt Scene Graph for hardware-accelerated rendering
- **Efficient Geometry**: Only updates geometry when spacing or size changes
- **Large Scenes**: Handles thousands of grid points efficiently

#### NLUtilsCPP

- **File I/O**: Image loading is synchronous, consider using async operations for large files
- **Base64 Encoding**: Base64 strings are larger than binary data (~33% overhead)

---

### Thread Safety

**Important**: All C++ classes in NodeLink are **not thread-safe**. All operations should be performed on the main UI thread (QML thread). Attempting to use these classes from background threads will result in undefined behavior.

---

## Configuration Options

### Configuration Options-

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
