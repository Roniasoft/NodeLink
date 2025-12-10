# Installation Guide - Create Your First Custom Node in 10 Minutes

## Overview

This guide will walk you through installing NodeLink and creating your first custom node in just 10 minutes. By the end of this tutorial, you'll have a working NodeLink application with a custom "HelloWorld" node that you can create, connect, and interact with.


---

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Qt Framework** (Version 6.2.4 or higher)
   - Download from: [Qt Official Website](https://www.qt.io/download)
   - Required modules:
     - Qt Quick
     - Qt Quick Controls 2
     - Qt QML
     - Qt Quick Layouts

2. **CMake** (Version 3.8 or higher, recommended: 3.20+)
   - Download from: [CMake Official Website](https://cmake.org/download/)
   - Or install via package manager:
     ```bash
     # Ubuntu/Debian
     sudo apt-get install cmake
     
     # macOS (Homebrew)
     brew install cmake
     
     # Windows
     # Download installer from cmake.org
     ```

3. **C++ Compiler**
   - **Linux**: GCC ≥ 7.0 or Clang ≥ 7.0
   - **Windows**: MSVC 2019 (Visual Studio 2019) or MinGW
   - **macOS**: Apple Clang (Xcode Command Line Tools)

4. **Git** (Version 2.20 or higher)
   - Download from: [Git Official Website](https://git-scm.com/downloads)

### Optional Tools

- **Qt Creator** (Recommended IDE for Qt/QML development)
  - Download from: [Qt Official Website](https://www.qt.io/download)
- **Visual Studio Code** with Qt/QML extensions (Alternative IDE)

---

## Installation

### Step 1: Clone the Repository

Open a terminal/command prompt and run:

```bash
# Clone with submodules (recommended)
git clone --recursive https://github.com/Roniasoft/NodeLink.git
cd NodeLink
```

If you already cloned without `--recursive`:

```bash
git submodule update --init --recursive
```

### Step 2: Build NodeLink

#### Option A: Command Line (Linux/macOS)

```bash
# Create build directory
mkdir build
cd build

# Configure with CMake
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build (use -j flag for parallel compilation)
make -j$(nproc)  # Linux
# or
make -j$(sysctl -n hw.ncpu)  # macOS
```

#### Option B: Qt Creator

1. Open Qt Creator
2. Select **File → Open File or Project**
3. Navigate to NodeLink directory and select `CMakeLists.txt`
4. Click **Configure Project**
5. Select your Qt version and compiler
6. Click **Build → Build All** (or press `Ctrl+B` / `Cmd+B`)

#### Option C: Windows (Visual Studio)

```powershell
# Create build directory
mkdir build
cd build

# Configure with CMake (adjust generator if needed)
cmake .. -G "Visual Studio 17 2022" -A x64

# Build
cmake --build . --config Release
```

### Step 3: Verify Installation

After building, verify that the examples compile successfully:

```bash
# Run simpleNodeLink example
cd build/examples/simpleNodeLink
./SimpleNodeLink  # Linux/macOS
# or
SimpleNodeLink.exe  # Windows
```

If the example runs and shows a NodeLink window, installation is successful!

---

## Quick Start: Your First Custom Node

In this section, we'll create a simple "HelloWorld" node that displays a message. This will take approximately 10 minutes.

### What We'll Build

A custom node that:
- Has an input port and an output port
- Takes a text input
- Appends "Hello, " to the input
- Outputs the result

### Project Structure

We'll create a minimal example project:

```
HelloNodeLink/
├── CMakeLists.txt
├── main.cpp
├── main.qml
└── HelloWorldNode.qml
```

---

## Step-by-Step Tutorial

### Step 1: Create Project Directory (1 minute)

Create a new directory for your project:

```bash
mkdir HelloNodeLink
cd HelloNodeLink
```

### Step 2: Create main.cpp (1 minute)

Create `main.cpp`:

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    // Set Material style
    QQuickStyle::setStyle("Material");
    
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/HelloNodeLink/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    return app.exec();
}
```

### Step 3: Create HelloWorldNode.qml (2 minutes)

Create `HelloWorldNode.qml`:

```qml
import QtQuick
import NodeLink

Node {
    // Set unique type identifier
    type: 0

    // Configure node data
    nodeData: I_NodeData {}

    // Configure GUI
    guiConfig.width: 200
    guiConfig.height: 120
    guiConfig.color: "#4A90E2"

    // Custom property for input text
    property string inputText: ""

    // Add ports when node is created
    Component.onCompleted: addPorts();

    // Update output when input changes
    onInputTextChanged: {
        if (inputText.length > 0) {
            nodeData.data = "Hello, " + inputText;
        } else {
            nodeData.data = "";
        }
    }

    // Function to add ports
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

    // Handle data from connected nodes
    function processInput() {
        // This will be called by the scene when data flows
        var inputPort = findPortByPortSide(NLSpec.PortPositionSide.Left);
        if (inputPort) {
            // Get data from connected node (simplified - actual implementation depends on your scene)
            // For now, we'll use the inputText property
            if (nodeData.input !== undefined && nodeData.input !== null) {
                inputText = String(nodeData.input);
            }
        }
    }
}
```

### Step 4: Create main.qml (3 minutes)

Create `main.qml`:

```qml
import QtQuick
import QtQuickStream
import QtQuick.Controls
import NodeLink

Window {
    id: window

    // Scene property (will be overridden by load)
    property Scene scene: Scene { }

    // Node registry setup
    property NLNodeRegistry nodeRegistry: NLNodeRegistry {
        _qsRepo: NLCore.defaultRepo
        imports: ["HelloNodeLink", "NodeLink"]
        defaultNode: 0
    }

    width: 1280
    height: 960
    visible: true
    title: qsTr("Hello NodeLink - Your First Custom Node")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"

    Component.onCompleted: {
        // Register HelloWorldNode
        var nodeType = 0;
        nodeRegistry.nodeTypes[nodeType] = "HelloWorldNode";
        nodeRegistry.nodeNames[nodeType] = "Hello World";
        nodeRegistry.nodeIcons[nodeType] = "\uf075";  // Font Awesome comment icon
        nodeRegistry.nodeColors[nodeType] = "#4A90E2";

        // Initialize QtQuickStream repository
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "NodeLink", "HelloNodeLink"])
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

    // Instructions label
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20
        width: 300
        height: 150
        color: "#2d2d2d"
        radius: 5
        border.color: "#4890e2"
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Text {
                text: "Instructions:"
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 14
            }

            Text {
                text: "1. Right-click to create nodes"
                color: "#cccccc"
                font.pixelSize: 12
            }

            Text {
                text: "2. Drag from ports to connect"
                color: "#cccccc"
                font.pixelSize: 12
            }

            Text {
                text: "3. Your HelloWorld node is ready!"
                color: "#7ED321"
                font.pixelSize: 12
            }
        }
    }
}
```

### Step 5: Create CMakeLists.txt (2 minutes)

Create `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.16)

# Require C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

# Set QML import path
set(QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml/NodeLink/resources/View)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# Add NodeLink as subdirectory (adjust path to your NodeLink installation)
# Option 1: If NodeLink is in parent directory
add_subdirectory(../NodeLink NodeLink)

# Option 2: If NodeLink is installed system-wide, use find_package instead
# find_package(NodeLink REQUIRED)

# Create executable
qt_add_executable(HelloNodeLink main.cpp)

# Define QML module
qt_add_qml_module(HelloNodeLink
    URI "HelloNodeLink"
    VERSION 1.0

    QML_FILES
        main.qml
        HelloWorldNode.qml

    SOURCES
)

# Include directories
target_include_directories(HelloNodeLink PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

# Link libraries
target_link_libraries(HelloNodeLink PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)

# Debug definitions
target_compile_definitions(HelloNodeLink
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
```

**Important**: Adjust the `add_subdirectory` path to point to your NodeLink installation directory.

### Step 6: Build and Run (1 minute)

#### Using Command Line:

```bash
# Create build directory
mkdir build
cd build

# Configure
cmake ..

# Build
cmake --build . --config Release

# Run
./HelloNodeLink  # Linux/macOS
# or
HelloNodeLink.exe  # Windows
```

#### Using Qt Creator:

1. Open `CMakeLists.txt` in Qt Creator
2. Configure the project
3. Build (Ctrl+B / Cmd+B)
4. Run (Ctrl+R / Cmd+R)

---

## Testing Your Node

### Test 1: Create a Node

1. **Right-click** anywhere in the scene
2. You should see a context menu with "Hello World" option
3. Click it to create a HelloWorld node
4. The node should appear with:
   - Blue color (#4A90E2)
   - Input port on the left
   - Output port on the right

### Test 2: Verify Ports

1. Hover over the **left port** - it should highlight (this is the input)
2. Hover over the **right port** - it should highlight (this is the output)

### Test 3: Connect Nodes (Optional)

If you want to test connections, you'll need to create a source node first. For now, the HelloWorld node is ready to use!

### Expected Result

**Screenshot of the example after running the program:**

![Example after running the program](images/frame1.png)

You should see:
- ✅ A NodeLink window with dark theme
- ✅ Instructions in the top-left corner
- ✅ Ability to create HelloWorld nodes via right-click
- ✅ Nodes with input and output ports

---

## Next Steps

Congratulations! You've created your first custom node. Here's what you can do next:

### 1. Explore the Examples

Check out the provided examples in the `examples/` directory:
- **simpleNodeLink**: Basic node operations
- **calculator**: Mathematical operations
- **chatbot**: Rule-based conversations
- **logicCircuit**: Digital logic gates
- **visionLink**: Image processing

### 2. Enhance Your HelloWorld Node

Try these improvements:

#### Add a Text Input Field

```qml
// In HelloWorldNode.qml, add a custom view
// Create HelloWorldNodeView.qml
import QtQuick
import QtQuick.Controls

Rectangle {
    property var node
    
    TextField {
        anchors.centerIn: parent
        placeholderText: "Enter text..."
        onTextChanged: {
            if (node) {
                node.inputText = text;
            }
        }
    }
}
```

#### Add Multiple Inputs

```qml
function addPorts() {
    // First input
    let input1 = NLCore.createPort();
    input1.portType = NLSpec.PortType.Input;
    input1.portSide = NLSpec.PortPositionSide.Left;
    input1.title = "Name";
    addPort(input1);

    // Second input
    let input2 = NLCore.createPort();
    input2.portType = NLSpec.PortType.Input;
    input2.portSide = NLSpec.PortPositionSide.Left;
    input2.title = "Greeting";
    addPort(input2);

    // Output
    let output = NLCore.createPort();
    output.portType = NLSpec.PortType.Output;
    output.portSide = NLSpec.PortPositionSide.Right;
    output.title = "Result";
    addPort(output);
}
```

### 3. Learn More

- Read the [Custom Node Creation Guide](../AdvancedTopics/CustomNodeCreation.md) for detailed documentation
- Check the [Undo/Redo System](../AdvancedTopics/UndoRedo.md) documentation
- Explore example README files in `examples/` directories

### 4. Create More Complex Nodes

Try creating:
- **MathNode**: Performs calculations
- **StringNode**: String manipulation
- **ConditionNode**: Conditional logic
- **LoopNode**: Iteration operations

---

## Troubleshooting

### Problem: "Module not found" Error

**Solution**: 
- Check that `imports` in `nodeRegistry` includes your module name
- Verify `CMakeLists.txt` URI matches the import name
- Ensure QML files are listed in `QML_FILES` in CMakeLists.txt

```qml
// main.qml
imports: ["HelloNodeLink", "NodeLink"]  // Must match URI in CMakeLists.txt
```

```cmake
# CMakeLists.txt
qt_add_qml_module(HelloNodeLink
    URI "HelloNodeLink"  # Must match import name
    ...
)
```

### Problem: Node Doesn't Appear in Context Menu

**Solution**:
- Verify node is registered in `Component.onCompleted`
- Check that `nodeRegistry.nodeTypes[0]` matches your QML file name
- Ensure scene has the registry assigned

```qml
Component.onCompleted: {
    nodeRegistry.nodeTypes[0] = "HelloWorldNode";  // Must match HelloWorldNode.qml
    // ...
    scene.nodeRegistry = nodeRegistry;  // Must assign registry
}
```

### Problem: Ports Not Showing

**Solution**:
- Ensure `addPorts()` is called in `Component.onCompleted`
- Verify ports are added with `addPort(port)`
- Check port type and side are set

```qml
Component.onCompleted: addPorts();  // Must call this

function addPorts() {
    let port = NLCore.createPort();
    port.portType = NLSpec.PortType.Input;  // Must set type
    port.portSide = NLSpec.PortPositionSide.Left;  // Must set side
    addPort(port);  // Must add to node
}
```

### Problem: Build Errors

**Solution**:
- Check Qt version (must be 6.2.4+)
- Verify CMake version (must be 3.8+)
- Ensure NodeLink is built before building your project
- Check that all required Qt modules are installed

```bash
# Verify Qt version
qmake --version

# Verify CMake version
cmake --version

# Rebuild NodeLink first
cd NodeLink/build
cmake ..
cmake --build .
```

### Problem: Application Crashes on Startup

**Solution**:
- Check console for error messages
- Verify all QML files are in the correct location
- Ensure imports are correct
- Check that NodeLink plugins are linked

```cmake
# CMakeLists.txt must link plugins
target_link_libraries(HelloNodeLink PRIVATE
    NodeLinkplugin      # Must include
    QtQuickStreamplugin # Must include
    ...
)
```

### Problem: Can't Find NodeLink Directory

**Solution**:
- If NodeLink is installed system-wide, use `find_package`:

```cmake
find_package(NodeLink REQUIRED)
target_link_libraries(HelloNodeLink PRIVATE NodeLink::NodeLink)
```

- If NodeLink is in a subdirectory, adjust the path:

```cmake
add_subdirectory(/path/to/NodeLink NodeLink)
```

### Getting Help

If you encounter issues not covered here:

1. **Check the Examples**: Look at working examples in `examples/` directory
2. **Read Documentation**: See [Custom Node Creation Guide](../AdvancedTopics/CustomNodeCreation.md)
3. **GitHub Issues**: Report bugs or ask questions on [GitHub Issues](https://github.com/Roniasoft/NodeLink/issues)
4. **Community**: Check for community discussions and solutions

---

## Summary

In this 10-minute tutorial, you've:

✅ Installed NodeLink  
✅ Created your first custom node (HelloWorldNode)  
✅ Set up a complete project structure  
✅ Built and ran your application  
✅ Learned the basics of node creation  

### Key Takeaways

1. **Node Structure**: Every node needs a `type`, `nodeData`, `guiConfig`, and `ports`
2. **Registration**: Nodes must be registered in `NLNodeRegistry` with type, name, icon, and color
3. **Ports**: Created using `NLCore.createPort()` and added with `addPort()`
4. **Build System**: CMake configuration links NodeLink plugins and registers QML files

### What's Next?

- Explore more advanced features in the [Custom Node Creation Guide](../AdvancedTopics/CustomNodeCreation.md)
- Build more complex nodes with data processing
- Create custom node views and UI components
- Integrate with C++ backends for performance-critical operations

Happy node building! 🎉

