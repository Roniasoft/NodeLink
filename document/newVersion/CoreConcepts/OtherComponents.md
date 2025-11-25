## main.cpp (Main Application Entry Point)
### Overview

The `main.cpp` file serves as the entry point for the Qt application, responsible for setting up the QML runtime environment and loading the main QML file.

### Class Description

The `main` function is the entry point of the application, and it utilizes the following Qt classes:

* `QGuiApplication`: The main application object, which provides the QML runtime environment.
* `QQmlApplicationEngine`: The QML engine, responsible for loading and executing QML files.

### Properties and Explanations

None.

### Signals

None.

### Functions

* `main(int argc, char* argv[])`: The entry point of the application.
* `QObject::connect()`: Connects the `objectCreated` signal of the `QQmlApplicationEngine` to a lambda function, which handles the case where the QML file fails to load.

### Example Usage in QML

Not applicable, as this file is written in C++.

### Extension/Override Points

To extend or customize the application entry point, you can:

* Override the `QGuiApplication` class to provide custom application-wide functionality.
* Modify the QML engine loading process to use a different QML file or add custom loading logic.

### Caveats or Assumptions

* The QML file `main.qml` is assumed to be located in the `qrc:/ColorTools/` resource path.
* The application uses the `Qt::QueuedConnection` type for signal-slot connections.

### Related Components

* `main.qml`: The main QML file loaded by the application.
* `NodeLinkModel`: The Model component, which provides data and business logic for the application.
* `NodeLinkView`: The View component, which provides the user interface for the application.

### Code Snippets

The following code snippet demonstrates how to load a QML file using the `QQmlApplicationEngine`:
```cpp
QQmlApplicationEngine engine;
const QUrl url(u"qrc:/ColorTools/main.qml"_qs);
engine.load(url);
```
Note that this code snippet is a subset of the `main.cpp` file and is provided for illustrative purposes only.


## main.qml (Main QML Application Window)
### Overview

The `main.qml` file serves as the entry point for the Qt/QML application, defining the main application window and its layout. It demonstrates a simple color wheel application using the NodeLink MVC architecture.

### Architecture

In the context of the NodeLink MVC (Model-View-Controller) architecture, `main.qml` acts as the View, which is responsible for rendering the UI components. The ColorTool and ColorPickerDialog components interact with each other to provide a color selection interface.

### Component Description

The `main.qml` file defines an `ApplicationWindow` with a `Pane` containing a `Column` layout. This layout includes a `ColorTool` component, which provides a color selection interface.

### Properties and Explanations

The following properties are relevant:

* `width` and `height`: Define the size of the application window (1920x1080).
* `visible`: A boolean indicating whether the window is visible (true).
* `title`: The title of the application window ("Color Wheel").

### Signals

No custom signals are defined in this file. However, the following signals are used:

* `onCurrentColorChanged`: Emitted by the `ColorTool` component when the current color changes.
* `onAccepted`: Emitted by the `ColorPickerDialog` component when a color is selected.

### Functions

No custom functions are defined in this file.

### Example Usage in QML

To use this component, simply create a new QML file (e.g., `main.qml`) and paste the provided code. You can then run the application using `qmlscene` or another QML runtime.

### Extension/Override Points

To extend or customize this component, consider the following:

* Override the `ColorTool` component to provide a custom color selection interface.
* Modify the `ColorPickerDialog` component to change the color picker layout or behavior.

### Caveats or Assumptions

The following assumptions are made:

* The `ColorTool` and `ColorPickerDialog` components are defined in separate files and imported correctly.
* The NodeLink MVC architecture is implemented correctly, with the Model and Controller components interacting with the View (this file).

### Related Components

The following components are related:

* `ColorTool`: A custom component providing a color selection interface.
* `ColorPickerDialog`: A custom dialog component for selecting colors.

### Usage Example

```qml
// Create a new QML file (e.g., main.qml) and paste the provided code
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    // ... (paste the code here)
}
```


## NodeExample.qml
### Overview

The `NodeExample.qml` file provides an example implementation of a Node in the NodeLink MVC architecture. This node demonstrates how to create a basic node with multiple ports.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `NodeExample.qml` serves as a **View** component. It represents a visual node that can be used in a NodeLink diagram. The node is designed to work with the NodeLink **Model** and **Controller** components, which manage the node's data and behavior.

### Component Description

The `NodeExample` component is a QML-based node that inherits from the `Node` type. It has a `type` property set to `0`, which can be used to identify the node type.

### Properties

The following properties are exposed by the `NodeExample` component:

* `type`: An integer property that identifies the node type (set to `0` by default).

### Signals

The `NodeExample` component does not emit any custom signals. However, it inherits signals from the `Node` base type, such as `onClicked` and `onDoubleClicked`.

### Functions

The `NodeExample` component provides the following functions:

* `addPorts()`: A temporary function that creates and adds four ports to the node. This function is called when the component is completed.

### Example Usage in QML

To use the `NodeExample` component in a QML file, simply import the `NodeLink` module and create an instance of the node:
```qml
import NodeLink

NodeExample {
    x: 100
    y: 100
}
```
### Extension/Override Points

To extend or customize the behavior of the `NodeExample` component, you can:

* Override the `addPorts()` function to create custom ports or modify the existing port creation logic.
* Add custom properties or signals to the node.
* Create a new node type by inheriting from `NodeExample` and adding custom features.

### Caveats or Assumptions

The `NodeExample` component assumes that the NodeLink module is properly installed and imported in the QML file. Additionally, the component uses the `NLCore` object to create ports, which is assumed to be available in the NodeLink module.

### Related Components

The `NodeExample` component is related to the following components in the NodeLink module:

* `Node`: The base node type that `NodeExample` inherits from.
* `Port`: The port type that is created and added to the node using the `addPorts()` function.
* `NLCore`: The core object that provides functions for creating ports and other NodeLink-related functionality.


## ImageProcessor.cpp
### Overview

The `ImageProcessor` class provides a set of image processing functions for loading, manipulating, and converting images. It is designed to work seamlessly with the NodeLink MVC architecture, providing a robust and efficient way to handle image-related tasks.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `ImageProcessor` class acts as a service provider, offering a range of image processing functions that can be used by the application's controllers and models. By separating image processing logic into a dedicated class, the architecture remains modular and maintainable.

### Class Description

The `ImageProcessor` class is a QObject-based class that provides the following key features:

* Image loading from file paths or URLs
* Application of box blur, brightness, and contrast filters
* Conversion of images to base64 data URLs for use in QML
* Validation of image data

### Properties

The `ImageProcessor` class does not have any properties.

### Signals

The `ImageProcessor` class does not emit any signals.

### Functions

#### Image Loading

* `loadImage(const QString &path)`: Loads an image from a file path or URL and returns it as a QVariant.
* `isValidImage(const QVariant &imageData)`: Checks if a QVariant contains valid image data.

#### Image Filters

* `applyBlur(const QVariant &imageData, qreal radius)`: Applies a box blur filter to an image.
* `applyBrightness(const QVariant &imageData, qreal level)`: Adjusts the brightness of an image.
* `applyContrast(const QVariant &imageData, qreal level)`: Adjusts the contrast of an image.

#### Image Conversion

* `saveToDataUrl(const QVariant &imageData)`: Converts an image to a base64 data URL.

### Example Usage in QML

```qml
import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480

    ImageProcessor {
        id: imageProcessor
    }

    Image {
        id: image
        source: ""
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        var imageData = imageProcessor.loadImage("path/to/image.jpg")
        if (imageProcessor.isValidImage(imageData)) {
            var blurredImage = imageProcessor.applyBlur(imageData, 5.0)
            var dataUrl = imageProcessor.saveToDataUrl(blurredImage)
            image.source = dataUrl
        }
    }
}
```

### Extension/Override Points

To extend or override the functionality of the `ImageProcessor` class, you can:

* Subclass `ImageProcessor` and override specific functions
* Add new functions to the class to provide additional image processing capabilities

### Caveats or Assumptions

* The `ImageProcessor` class assumes that the input image data is in a format that can be processed by the Qt image classes.
* The class uses a simple box blur algorithm, which may not be suitable for all use cases.

### Related Components

* `QImage`: The Qt image class used by the `ImageProcessor` class to represent and manipulate images.
* `QVariant`: The Qt variant class used by the `ImageProcessor` class to store and pass image data.


## ImageProcessor.h
### Overview

The `ImageProcessorCPP` class provides a set of image loading and processing functions, designed to be used within the NodeLink MVC architecture. It allows for the manipulation of images, including loading, applying effects, and saving.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `ImageProcessorCPP` serves as a Model component, providing a set of functions for image processing. It can be used by Views (QML components) to load and manipulate images.

### Class Description

The `ImageProcessorCPP` class is a singleton QObject that provides a set of image processing functions. It is designed to be used in QML, with a set of Q_INVOKABLE functions that can be called from QML.

### Properties

None.

### Signals

None.

### Functions

#### Constructors

* `explicit ImageProcessor(QObject *parent = nullptr)`: Constructor for the `ImageProcessorCPP` class.

#### Image Processing Functions

* `Q_INVOKABLE QVariant loadImage(const QString &path)`: Loads an image from a file path and returns it as a QVariant.
* `Q_INVOKABLE QVariant applyBlur(const QVariant &imageData, qreal radius)`: Applies a blur effect to an image.
* `Q_INVOKABLE QVariant applyBrightness(const QVariant &imageData, qreal level)`: Adjusts the brightness of an image.
* `Q_INVOKABLE QVariant applyContrast(const QVariant &imageData, qreal level)`: Adjusts the contrast of an image.
* `Q_INVOKABLE QString saveToDataUrl(const QVariant &imageData)`: Saves an image to a data URL.
* `Q_INVOKABLE bool isValidImage(const QVariant &imageData) const`: Checks if an image is valid.

#### Private Helper Functions

* `QImage variantToImage(const QVariant &imageData) const`: Converts a QVariant to a QImage.
* `QVariant imageToVariant(const QImage &image) const`: Converts a QImage to a QVariant.
* `QImage boxBlur(const QImage &source, int radius)`: Applies a box blur effect to an image.
* `QImage adjustBrightness(const QImage &source, qreal level)`: Adjusts the brightness of an image.
* `QImage adjustContrast(const QImage &source, qreal level)`: Adjusts the contrast of an image.

### Example Usage in QML

```qml
import QtQuick 2.0
import NodeLink 1.0

Item {
    ImageProcessorCPP {
        id: imageProcessor
    }

    Component.onCompleted: {
        var imageData = imageProcessor.loadImage("path/to/image.jpg")
        var blurredImage = imageProcessor.applyBlur(imageData, 10)
        var brightenedImage = imageProcessor.applyBrightness(blurredImage, 1.5)
        var dataUrl = imageProcessor.saveToDataUrl(brightenedImage)
        console.log(dataUrl)
    }
}
```

### Extension/Override Points

To extend or override the functionality of `ImageProcessorCPP`, you can:

* Create a subclass of `ImageProcessorCPP` and override the desired functions.
* Use a different image processing library or algorithm.

### Caveats or Assumptions

* The `ImageProcessorCPP` class assumes that the image data is in a format that can be processed by the Qt image classes.
* The `applyBlur`, `applyBrightness`, and `applyContrast` functions modify the image data in memory, and do not save the changes to disk.

### Related Components

* `ImageView`: A QML component that displays an image.
* `ImageModel`: A data model that stores image data.

## QSCoreCpp.h
### Overview

The `QSCoreCpp` class is the core component of any QtQuickStream application, providing access to the default repository (`defaultRepo`) and a collection of QtQuickStream repositories (`qsRepos`). It serves as a central hub for managing repositories and facilitating communication between them.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSCoreCpp` acts as the **Model** component, responsible for managing the data and business logic of the application. It interacts with the **Controller** and **View** components to provide a seamless user experience.

### Component Description

`QSCoreCpp` is a C++ class that inherits from `QObject`, allowing it to be easily integrated with QML. It provides a set of properties, signals, and functions that enable repository management and communication.

### Properties

The following properties are available:

* `coreId`: A unique identifier for the core component, represented as a string. (READ-ONLY)
* `defaultRepo`: The default repository used by the application, represented as a `QSRepositoryCpp` object. (READ/WRITE)
* `qsRepos`: A collection of QtQuickStream repositories, represented as a `QVariantMap`. (READ-ONLY)

### Signals

The following signals are emitted:

* `defaultRepoChanged()`: Emitted when the `defaultRepo` property changes.
* `qsReposChanged()`: Emitted when the `qsRepos` property changes.
* `sigCreateRepo(const QString &repoId, bool isRemote = false)`: Emitted to create a new repository with the specified ID and remote status.

### Functions

The following functions are available:

* `QSCoreCpp(QObject *parent = nullptr)`: Constructor.
* `getCoreIdStr() const`: Returns the core ID as a string.
* `getDefaultRepo() const`: Returns the default repository.
* `onRepoMessage(const QVariantList &targetIds, const QByteArray &msg)`: Slot function to handle repository messages.
* `onRepoMessageToAll(const QByteArray &msg)`: Slot function to handle repository messages sent to all repositories.
* `addRepo(QSRepositoryCpp *repo)`: Adds a repository to the collection.
* `setDefaultRepo(QSRepositoryCpp* repo)`: Sets the default repository.

### Example Usage in QML

```qml
import QtQuick 2.15
import QtQuickStream 1.0

ApplicationWindow {
    id: window
    visible: true

    // Create a QSCoreCpp instance
    QSCoreCpp {
        id: core
    }

    // Access the default repository
    Component.onCompleted: {
        console.log("Default Repository:", core.defaultRepo)
    }

    // Create a new repository
    Button {
        text: "Create Repository"
        onClicked: core.sigCreateRepo("myRepo")
    }
}
```

### Extension/Override Points

To extend or override the behavior of `QSCoreCpp`, you can:

* Create a subclass of `QSCoreCpp` and override its functions or add new ones.
* Use the `QSRepositoryCpp` class to create custom repository implementations.

### Caveats or Assumptions

* The `QSCoreCpp` class assumes that the `QSRepositoryCpp` class is available and properly configured.
* The `sigCreateRepo` signal is emitted to create a new repository, but the actual creation process is not implemented in `QSCoreCpp`. This should be handled by the application or a custom repository implementation.

### Related Components

* `QSRepositoryCpp`: The repository class used by `QSCoreCpp` to manage data and communication.
* `NodeLink`: The MVC architecture that `QSCoreCpp` is a part of.


## QSObjectCpp.h
### Overview

The `QSObjectCpp` class provides a base class for objects in the NodeLink MVC architecture, offering UUID and JSON serialization functionality. It serves as a foundation for creating serializable objects that can be easily stored, retrieved, and manipulated within the application.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSObjectCpp` acts as a model component, providing a standardized way to represent and manage data. It integrates with the `QSRepositoryCpp` class, which handles data storage and retrieval.

### Component Description

`QSObjectCpp` is a QML-enabled QObject that provides the following key features:

*   **UUID Generation and Management**: Each instance of `QSObjectCpp` is assigned a unique UUID, which can be used for identification and serialization purposes.
*   **JSON Serialization**: The class provides a mechanism for serializing and deserializing its properties to and from JSON format.
*   **Repository Integration**: `QSObjectCpp` instances can be associated with a `QSRepositoryCpp` instance, enabling data storage and retrieval.

### Properties

The following properties are exposed by `QSObjectCpp`:

*   `_qsInterfaceType`: A constant string property representing the interface type of the object.
*   `_qsParent`: A QObject pointer property referencing the parent object.
*   `_qsRepo`: A QSRepositoryCpp pointer property referencing the associated repository.
*   `_qsUuid`: A string property representing the UUID of the object.
*   `qsIsAvailable`: A boolean property indicating the availability of the object.
*   `qsType`: A constant string property representing the type of the object.

### Signals

The following signals are emitted by `QSObjectCpp`:

*   `isAvailableChanged()`: Emitted when the `qsIsAvailable` property changes.
*   `repoChanged()`: Emitted when the `_qsRepo` property changes.
*   `uuidChanged()`: Emitted when the `_qsUuid` property changes.

### Functions

The following functions are provided by `QSObjectCpp`:

*   `getInterfaceMetaObject()`: Returns the QMetaObject associated with the interface type.
*   `getInterfaceType()`: Returns the interface type as a string.
*   `getIsAvailable()`: Returns the availability status of the object.
*   `getRepo()`: Returns the associated repository.
*   `getType()`: Returns the type of the object.
*   `getUuid()`: Returns the UUID of the object.
*   `getUuidStr()`: Returns the UUID as a string.
*   `setIsAvailable(bool)`: Sets the availability status of the object.

### Example Usage in QML

```qml
import QtQuick 2.15
import QtQuick.Window 2.15
import com.example.qsobjectcpp 1.0

Window {
    visible: true
    width: 640
    height: 480

    QSObjectCpp {
        id: obj
        qsType: "exampleType"
        qsIsAvailable: true
        _qsUuid: "123e4567-e89b-12d3-a456-426614174000"
    }

    Component.onCompleted: {
        console.log(obj.qsType) // Output: exampleType
        console.log(obj.qsIsAvailable) // Output: true
        console.log(obj._qsUuid) // Output: 123e4567-e89b-12d3-a456-426614174000
    }
}
```

### Extension/Override Points

To extend or override the behavior of `QSObjectCpp`, you can:

*   Subclass `QSObjectCpp` and add custom properties, functions, or signals.
*   Override the `deriveTypes()` function to customize the type derivation process.

### Caveats or Assumptions

*   **UUID Stability**: Once a repository is set, the UUID of a `QSObjectCpp` instance should not be changed.
*   **Serialization Limitations**: Qt's list\<SomeType> will not deserialize properly.
*   **Private Attributes**: Attributes starting with an underscore (_) will not be serialized or deserialized.

### Related Components

*   `QSRepositoryCpp`: The repository class that integrates with `QSObjectCpp` for data storage and retrieval.

### Future Development

*   **Thread Safety**: Add mutex locking to ensure thread safety.

By following these guidelines and using `QSObjectCpp` as a foundation, you can create robust and serializable objects within the NodeLink MVC architecture.


## QSRepositoryCpp.h
### Overview

The `QSRepositoryCpp` class is a container that stores and manages `QSObjectCpp` instances. It provides functionality for serialization to and from disk and enables other mechanisms such as RPCs.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSRepositoryCpp` serves as a model component. It manages a collection of `QSObjectCpp` instances and provides data binding and notification mechanisms.

### Component Description

`QSRepositoryCpp` is a QML-enabled C++ class that inherits from `QSObjectCpp`. It provides properties, signals, and slots for managing `QSObjectCpp` instances.

### Properties

The following properties are available:

* `qsRootObject`: The root object of the repository.
* `_addedObjects`: A list of added objects.
* `_deletedObjects`: A list of deleted objects.
* `_forwardedRepos`: A list of forwarded repositories.
* `_updatedObjects`: A list of updated objects.
* `_qsObjects`: A map of QSObjects.
* `_isLoading`: A boolean indicating whether the repository is loading.
* `name`: The name of the repository.

### Signals

The following signals are emitted:

* `addedObjectsChanged()`: Emitted when the list of added objects changes.
* `deletedObjectsChanged()`: Emitted when the list of deleted objects changes.
* `forwardedReposChanged()`: Emitted when the list of forwarded repositories changes.
* `updatedObjectsChanged()`: Emitted when the list of updated objects changes.
* `objectAdded(QSObjectCpp *qsObject)`: Emitted when an object is added to the repository.
* `objectDeleted(const QString &uuidStr)`: Emitted when an object is deleted from the repository.
* `isLoadingChanged()`: Emitted when the loading state of the repository changes.
* `nameChanged()`: Emitted when the name of the repository changes.
* `objectsChanged()`: Emitted when the map of QSObjects changes.
* `rootObjectChanged()`: Emitted when the root object of the repository changes.
* `messageReceived(const QString &sourceId, const QByteArray &msg)`: Emitted when a message is received from an RPC.
* `sendMessage(const QVariantList &targetIds, const QByteArray &msg)`: Emitted when a message is sent to a list of targets.
* `sendMessageToAll(const QByteArray &msg)`: Emitted when a message is sent to all targets.

### Functions

The following functions are available:

* `forwardRepo(QSRepositoryCpp *qsRepository)`: Forwards a repository.
* `unforwardRepo(QSRepositoryCpp *qsRepository)`: Unforwards a repository.
* `registerObject(QSObjectCpp *qsObject)`: Registers an object with the repository.
* `unregisterObject(QSObjectCpp *qsObject)`: Unregisters an object with the repository.
* `addObject(const QString &uuidStr, QSObjectCpp *qsObject, bool force = false)`: Adds an object to the repository.
* `clearObjects()`: Clears all objects from the repository.
* `delObject(const QString &uuidStr, bool suppressSignal = false)`: Deletes an object from the repository.

### Example Usage in QML

```qml
import QtQuick 2.15
import NodeLink 1.0

QSRepositoryCpp {
    id: repository
    name: "My Repository"

    // Create and add an object to the repository
    QSObjectCpp {
        id: myObject
        uuid: "my-object-uuid"
    }

    Component.onCompleted: {
        repository.registerObject(myObject)
    }
}
```

### Extension/Override Points

The following points can be extended or overridden:

* `observeObject(QSObjectCpp *qsObject)`: Called when an object is observed by the repository.
* `unobserveObject(QSObjectCpp *qsObject)`: Called when an object is unobserved by the repository.

### Caveats or Assumptions

The following caveats or assumptions should be noted:

* The repository assumes that all objects have a unique UUID.
* The repository does not handle object lifetime; objects must be managed by the application.

### Related Components

The following components are related to `QSRepositoryCpp`:

* `QSObjectCpp`: The base class for all objects managed by the repository.
* `NodeLink`: The NodeLink framework that provides the architecture and infrastructure for building node-based applications.


## QSCore.qml
### Overview

The `QSCore.qml` file provides the core functionality for the QtQuickStream framework. It acts as the central hub for managing repositories and provides essential functions for creating and handling repository objects.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSCore.qml` serves as the **Model** component. It encapsulates the data and business logic related to repository management, providing a bridge between the C++ backend and the QML frontend.

### Component Description

The `QSCore.qml` component is an instance of `QSCoreCpp`, a C++-based QML component that provides the underlying functionality for repository management. This QML component extends the C++ backend with QML-specific functionality and signal handling.

### Properties

The following properties are exposed by the `QSCore.qml` component:

* `id`: The identifier of the core component, set to "core" by default.

### Signals

The `QSCore.qml` component handles the following signal:

* `sigCreateRepo(repoId, isRemote)`: Emitted by the C++ backend to create a new repository. This signal is handled by the `onSigCreateRepo` handler, which calls the `createRepo` function.

### Functions

The `QSCore.qml` component provides the following functions:

#### createDefaultRepo(imports: object)

Creates a new default repository with the specified imports.

* **Parameters:** `imports` (object) - The imports for the new repository.
* **Returns:** The newly created repository object.

#### createRepo(repoId: string, isRemote: bool)

Creates a new repository with the specified ID and remote status.

* **Parameters:**
	+ `repoId` (string) - The ID of the repository.
	+ `isRemote` (bool) - Whether the repository is remote or not.
* **Returns:** The newly created repository object.

### Example Usage in QML

```qml
import QtQuick
import QtQuickStream

Item {
    Component.onCompleted: {
        // Create a new default repository with some imports
        var imports = { "someImport": "someValue" };
        var newRepo = core.createDefaultRepo(imports);
        
        // Create a new repository with a specific ID and remote status
        var repoId = "myRepoId";
        var isRemote = true;
        var customRepo = core.createRepo(repoId, isRemote);
    }
}
```

### Extension/Override Points

To extend or override the functionality of the `QSCore.qml` component, you can:

* Create a custom QML component that inherits from `QSCoreCpp` and provides additional functionality.
* Override the `createRepo` or `createDefaultRepo` functions to provide custom repository creation logic.

### Caveats or Assumptions

* The `QSCore.qml` component assumes that the `QSUtil` singleton has been initialized properly.
* The component relies on the C++ backend to provide the underlying functionality for repository management.

### Related Components

The following components are related to `QSCore.qml`:

* `QSRepository.qml`: Represents a repository object created by the `QSCore.qml` component.
* `QSUtil.qml`: Provides utility functions for the QtQuickStream framework.
* `QSSerializer.qml`: Provides serialization functionality for QtQuickStream objects.


## QSFileIO.qml
### Overview

The `QSFileIO` QML component is a singleton wrapper around the C++-implemented `FileIO` class. It provides a convenient interface for performing file input/output operations within the QtQuickStream framework.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSFileIO` serves as a model component, responsible for encapsulating data access and manipulation logic. It interacts with the C++-implemented `FileIO` class to provide file I/O capabilities.

### Component Description

The `QSFileIO` component is a singleton, meaning only one instance of it exists throughout the application. It acts as a proxy to the underlying `FileIO` C++ class, exposing its functionality through QML.

### Properties

The following properties are available:

* None (all properties are inherited from the `FileIO` class)

### Signals

The following signals are emitted:

* None (all signals are inherited from the `FileIO` class)

### Functions

The following functions are available:

* None (all functions are inherited from the `FileIO` class)

### Example Usage in QML

```qml
import QtQuick 2.0
import QtQuickStream 1.0

Item {
    Component.onCompleted: {
        // Use QSFileIO to read/write files
        QSFileIO.writeFile("example.txt", "Hello, World!")
        var content = QSFileIO.readFile("example.txt")
        console.log(content) // Output: "Hello, World!"
    }
}
```

### Extension/Override Points

To extend or override the behavior of `QSFileIO`, you can:

* Create a custom QML component that inherits from `QSFileIO`
* Implement a custom C++ class that inherits from the underlying `FileIO` class and provides additional functionality

### Caveats or Assumptions

* The `QSFileIO` component assumes that the underlying `FileIO` C++ class is properly implemented and registered with the QtQuickStream framework.
* File I/O operations may be subject to platform-specific limitations and security restrictions.

### Related Components

* `FileIO` (C++ class)
* `NodeLink` (MVC architecture framework)
* `QtQuickStream` (QML framework)

Note: As `QSFileIO` is a singleton wrapper, it does not have a detailed property, signal and function list. For a detailed list, please refer to the `FileIO` C++ class documentation.


## QSObject.qml
### Overview

The `QSObject.qml` provides additional JavaScript/QML helper functionality for managing objects in the NodeLink MVC architecture. It extends the `QSObjectCpp` class with utility functions for adding, removing, and updating elements in containers, as well as setting properties.

### Architecture

In the NodeLink MVC architecture, `QSObject.qml` serves as a utility component that facilitates interactions between the Model, View, and Controller. It provides a set of functions that can be used to manage objects and their relationships, making it easier to implement complex logic in QML.

### Component Description

The `QSObject.qml` component is an extension of `QSObjectCpp` and provides the following features:

*   Signal handling for loaded and removed objects
*   Utility functions for adding, removing, and updating elements in containers
*   Functionality for setting properties on objects

### Properties

The following properties are available:

*   `_qsRepo`: The repository associated with the object
*   `_qsParent`: The parent object

### Signals

The following signals are emitted:

*   `loadedFromStorage()`: Emitted when the object is loaded from storage
*   `removedFromRepo()`: Emitted when the object is removed from the repository

### Functions

The following functions are available:

#### addElement

```qml
function addElement(container, element: QSObject, containerChangedSignal, emit = true)
```

Adds an element to a container and emits the specified signal.

*   `container`: The container to add the element to
*   `element`: The element to add
*   `containerChangedSignal`: The signal to emit when the container changes
*   `emit`: Whether to emit the signal (default: `true`)

#### setElements

```qml
function setElements(container, elements, containerChangedSignal)
```

Adds or removes elements from a container to match the specified elements and emits the specified signal.

*   `container`: The container to update
*   `elements`: The elements to add or remove
*   `containerChangedSignal`: The signal to emit when the container changes

#### removeElement

```qml
function removeElement(container, element: QSObject, containerChangedSignal, emit = true)
```

Removes an element from a container and emits the specified signal.

*   `container`: The container to remove the element from
*   `element`: The element to remove
*   `containerChangedSignal`: The signal to emit when the container changes
*   `emit`: Whether to emit the signal (default: `true`)

#### setProperties

```qml
function setProperties(propertiesMap: object, qsRepo = _qsRepo)
```

Copies all properties from the specified map to the object.

*   `propertiesMap`: The map of properties to set
*   `qsRepo`: The repository to use (default: `_qsRepo`)

### Example Usage in QML

```qml
import QtQuick

Item {
    id: root

    // Create a QSObject instance
    QSObject.qml {
        id: qsObject
    }

    // Define a container and elements
    property var container: ({})
    property var elements: [
        QSObject.qml { id: element1 },
        QSObject.qml { id: element2 }
    ]

    // Add elements to container
    Component.onCompleted: {
        qsObject.addElement(container, element1, onContainerChanged)
        qsObject.addElement(container, element2, onContainerChanged)
    }

    // Handle container changes
    function onContainerChanged() {
        console.log("Container changed")
    }
}
```

### Extension/Override Points

To extend or override the behavior of `QSObject.qml`, you can:

*   Create a custom QML component that extends `QSObject.qml`
*   Override specific functions or signals in your custom component

### Caveats or Assumptions

*   The `QSObject.qml` component assumes that the `QSObjectCpp` class is available and properly configured.
*   The component uses JavaScript and QML features that may not be compatible with all platforms or environments.

### Related Components

*   `QSObjectCpp`: The C++ class that `QSObject.qml` extends
*   `QSSerializer`: The serializer class used by `QSObject.qml` to set properties

By using `QSObject.qml`, you can simplify the management of objects and their relationships in your QML applications, making it easier to implement complex logic and interactions.


## QSRepository.qml
### Overview

The `QSRepository` component serves as a central container for storing and managing `QSObject` instances. It provides functionality for serialization and deserialization to and from disk, enabling features like data persistence and restoration.

### Architecture

Within the NodeLink MVC architecture, `QSRepository` acts as a model component. It interacts with the controller by providing data access and manipulation capabilities, while also notifying the view of changes through signals.

### Component Description

`QSRepository` is a QML component that wraps a C++ implementation (`QSRepositoryCpp`). It manages a collection of `QSObject` instances and provides methods for initializing, serializing, and deserializing the repository.

### Properties

* `_rootkey`: A readonly property representing the root key of the repository (`"root"`).
* `qsRootInterface`: A property storing the interface type of the root object.
* `_allImports`: An internal property containing a list of all imports used for creating objects.
* `_localImports`: A property intended to be set by the concrete application (e.g., `SystemGUI`), providing local imports.
* `imports`: A property set by the system core (e.g., `SystemCore`), listing default imports (`["QtQuickStream"]`).
* `name`: A property reflecting the name of the root object or `"Uninitialized Repo"` if not set.

### Signals

No signals are explicitly declared in this component. However, it reacts to changes in `qsRootObject` and `name` through on-changed handlers.

### Functions

#### Initialization

* `initRootObject(rootObjectType: string)`: Initializes the root object of the repository based on the provided type. It returns `true` if successful.

#### Serialization and Deserialization

* `dumpRepo(serialType: QSSerializer.SerialType)`: Returns a JSON object representing the repository's data, with `QSObject` references replaced by URLs.
* `loadRepo(jsonObjects: object, deleteOldObjects: bool)`: Loads the repository from a JSON object, optionally deleting old objects. Returns `true` if successful.
* `loadQSObjects(jsonObjects: object)`: Loads `QSObject` instances from a JSON object.

#### File Operations

* `loadFromFile(fileName: string)`: Loads the repository from a file.
* `saveToFile(fileName: string)`: Saves the repository to a file.

### Example Usage in QML

```qml
import QtQuick 2.15

Item {
    QSRepository {
        id: repository
        _localImports: ["MyCustomModule"]
        imports: ["QtQuickStream", "MyOtherModule"]

        Component.onCompleted: {
            repository.initRootObject("MyRootObjectType.qml")
            // Use the repository
            repository.saveToFile("myrepo.json")
        }
    }
}
```

### Extension/Override Points

* Concrete applications can extend or override the behavior by setting `_localImports` and providing custom `QSObject` types.
* System cores can modify the default `imports` property to include additional modules.

### Caveats or Assumptions

* The component assumes that `QSObject` types are correctly registered and available in the import list.
* It relies on the `QSSerializer` component for serialization and deserialization operations.

### Related Components

* `QSObject`: The base class for objects managed by the repository.
* `QSSerializer`: Provides serialization and deserialization functionality for `QSObject` instances.
* `NodeLink MVC`: The architectural pattern that `QSRepository` is part of.


## QSSerializer.qml
### Overview

The `QSSerializer` is a singleton QML object responsible for transforming objects from their in-memory form to a format that can be saved or loaded to/from disk. It plays a crucial role in the NodeLink MVC architecture by providing a way to serialize and deserialize QtQuickStream objects.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `QSSerializer` acts as a utility component that helps with data persistence and retrieval. It works closely with the `QSRepository` component to resolve object references and handle serialization/deserialization tasks.

### Component Description

The `QSSerializer` component provides a set of functions for serializing and deserializing QtQuickStream objects. It supports two serialization types: `STORAGE` and `NETWORK`, which determine how objects are represented during serialization.

### Properties

* `blackListedPropNames`: A readonly property containing an array of property names that should be excluded from serialization.
* `protoString`: A readonly property representing the protocol string used for QtQuickStream object references.
* `protoStrLen`: A readonly property representing the length of the protocol string.

### Signals

None

### Functions

#### createQSObject

* **Purpose:** Creates a new QtQuickStream object based on its type and imports.
* **Parameters:**
	+ `qsType`: The type of the object to create.
	+ `imports`: An optional array of imports required for the object.
	+ `parent`: The parent object for the newly created object.
* **Returns:** The newly created object.

#### fromQSUrlProps

* **Purpose:** Restores QtQuickStream URLs by object references and handles problematic data types.
* **Parameters:**
	+ `obj`: The object to restore properties for.
	+ `props`: The properties to restore.
	+ `repo`: The QSRepository instance used for resolving object references.
* **Returns:** The object with restored properties.

#### fromQSUrlProp

* **Purpose:** Restores a single QtQuickStream URL by object reference and handles problematic data types.
* **Parameters:**
	+ `objProp`: The property to restore.
	+ `propValue`: The value of the property to restore.
	+ `repo`: The QSRepository instance used for resolving object references.
* **Returns:** The restored property value.

#### getQSProps

* **Purpose:** Returns a map of properties where QtQuickStream objects are replaced by their URLs.
* **Parameters:**
	+ `obj`: The object to serialize properties for.
	+ `serialType`: The serialization type (STORAGE or NETWORK).
* **Returns:** A map of serialized properties.

#### getQSProp

* **Purpose:** Replaces QtQuickStream objects by their URLs during serialization.
* **Parameters:**
	+ `propValue`: The property value to serialize.
	+ `serialType`: The serialization type (STORAGE or NETWORK).
* **Returns:** The serialized property value.

### Helper Functions

* `isPropertyBlackListed`: Returns whether a property should be excluded from serialization.
* `getQSUrl`: Returns a QtQuickStream URL for a given object.
* `isQVector`: Returns whether an object is a Qt vector.
* `isQSObject`: Returns whether an object is a QtQuickStream object.
* `isRegisteredQSObject`: Returns whether an object is a registered QtQuickStream object.
* `resolveQSUrl`: Returns an object reference based on a QtQuickStream URL.

### Example Usage in QML

```qml
import QtQuick 2.15
import QtQuickStream 1.0

Item {
    id: root

    // Create a serializer instance
    QtObject {
        id: serializer
        // Use QSSerializer as a singleton
        function createQSObject(qsType, imports, parent) {
            return QSSerializer.createQSObject(qsType, imports, parent);
        }
    }

    // Serialize an object
    function serializeObject(obj) {
        var props = QSSerializer.getQSProps(obj, QSSerializer.SerialType.STORAGE);
        console.log(props);
    }

    // Deserialize an object
    function deserializeObject(props, repo) {
        var obj = QSSerializer.fromQSUrlProps({}, props, repo);
        console.log(obj);
    }
}
```

### Extension/Override Points

* To add custom serialization logic, override the `getQSProp` function.
* To add custom deserialization logic, override the `fromQSUrlProp` function.

### Caveats or Assumptions

* The `QSSerializer` assumes that QtQuickStream objects have a `_qsUuid` property.
* The `QSSerializer` uses a simple protocol string to identify QtQuickStream URLs.

### Related Components

* `QSRepository`: A component responsible for managing QtQuickStream objects and providing a way to resolve object references.
* `QSObject`: A base class for QtQuickStream objects that provides a `_qsUuid` property and other essential functionality.


## QSObjectCpp.cpp
### Overview

The `QSObjectCpp` class is a base class for objects in the QtQuickStream (QS) framework. It provides a common interface for QS objects, including properties, signals, and functions for managing object metadata and repository registration.

### High-Level Purpose

The `QSObjectCpp` class serves as a foundation for creating QS objects that can be used in QML applications. It provides a standardized way of managing object metadata, such as UUIDs, types, and interfaces, and facilitates registration with a repository.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSObjectCpp` objects play a crucial role as model objects. They represent the data and behavior of a node in the application, and provide a interface for interacting with the node.

### Component or Class Description

The `QSObjectCpp` class is a C++ class that inherits from `QObject`. It provides a set of properties, signals, and functions for managing object metadata and repository registration.

### Properties

The following properties are available:

* `isAvailable`: A boolean indicating whether the object is available.
* `repo`: A pointer to the repository that the object is registered with.
* `uuid`: A UUID that uniquely identifies the object.
* `uuidStr`: A string representation of the UUID.
* `type`: A string representing the type of the object.
* `interfaceType`: A string representing the interface type of the object.

### Signals

The following signals are emitted:

* `isAvailableChanged()`: Emitted when the `isAvailable` property changes.
* `repoChanged()`: Emitted when the `repo` property changes.
* `uuidChanged()`: Emitted when the `uuid` property changes.

### Functions

The following functions are available:

* `getInterfaceMetaObject()`: Returns the most specific superclass that whose name starts with `I_`.
* `getInterfacePropNames()`: Returns a list of property names belonging to the interface of this object.
* `deriveTypes()`: Finds and caches the type and interface type of the object.
* `setRepo(QSRepositoryCpp *newRepo)`: Sets the repository that the object is registered with.
* `setUuidStr(const QString &uuid)`: Sets the UUID of the object.

### Example Usage in QML

```qml
import QtQuick 2.0
import QtQuickStream 1.0

QSObjectCpp {
    id: myObject
    objectName: "MyObject"

    // Accessing properties
    onIsAvailableChanged: console.log("Is available:", isAvailable)
    onRepoChanged: console.log("Repo changed:", repo)
    onUuidChanged: console.log("UUID changed:", uuidStr)

    // Calling functions
    function getInterfacePropNames() {
        return myObject.getInterfacePropNames()
    }
}
```

### Extension/Override Points

To extend or override the behavior of `QSObjectCpp`, you can:

* Subclass `QSObjectCpp` and add custom properties, signals, and functions.
* Override the `deriveTypes()` function to customize the type and interface type derivation process.
* Implement custom repository registration and unregistration logic.

### Caveats or Assumptions

* The `QSObjectCpp` class assumes that the object is registered with a repository.
* The `setUuidStr()` function can only be called if the object is not registered with a repository.

### Related Components

* `QSRepositoryCpp`: The repository class that manages QS objects.
* `QSNodeLink`: The NodeLink class that represents a connection between QS objects.


## QSRepositoryCpp.cpp
### Overview

The `QSRepositoryCpp` class is a C++ implementation of a repository in the NodeLink MVC architecture. It manages a collection of `QSObjectCpp` instances, providing functionality for adding, removing, and updating objects.

### Purpose

The primary purpose of `QSRepositoryCpp` is to serve as a centralized storage and management system for `QSObjectCpp` instances. It provides a way to register, unregister, and forward objects, as well as propagate availability changes to its contained objects.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `QSRepositoryCpp` acts as a model component, responsible for managing a collection of data objects (`QSObjectCpp` instances). It interacts with other components, such as views and controllers, to provide data access and manipulation functionality.

### Class Description

`QSRepositoryCpp` is a subclass of `QSObjectCpp` and provides the following key features:

*   Manages a collection of `QSObjectCpp` instances
*   Supports adding, removing, and updating objects
*   Propagates availability changes to its contained objects
*   Allows forwarding of objects from other repositories

### Properties

The following properties are available:

*   `addedObjects`: A list of added objects
*   `deletedObjects`: A list of deleted object UUIDs
*   `forwardedRepos`: A list of forwarded repositories
*   `isLoading`: A flag indicating whether the repository is currently loading
*   `name`: The name of the repository
*   `objects`: A map of objects, keyed by their UUIDs
*   `rootObject`: The root object of the repository (not used in this implementation)
*   `updatedObjects`: A list of updated objects

### Signals

The following signals are emitted:

*   `addedObjectsChanged()`: Emitted when the list of added objects changes
*   `deletedObjectsChanged()`: Emitted when the list of deleted object UUIDs changes
*   `forwardedReposChanged()`: Emitted when the list of forwarded repositories changes
*   `objectAdded(QSObjectCpp* qsObject)`: Emitted when an object is added to the repository
*   `objectDeleted(const QString &uuidStr)`: Emitted when an object is removed from the repository
*   `objectsChanged()`: Emitted when the collection of objects changes
*   `updatedObjectsChanged()`: Emitted when the list of updated objects changes

### Functions

The following functions are available:

*   `addObject(const QString &uuidStr, QSObjectCpp *qsObject, bool force = false)`: Adds an object to the repository
*   `clearObjects()`: Removes all objects from the repository
*   `delObject(const QString &uuidStr, bool suppressSignal = false)`: Removes an object from the repository
*   `forwardRepo(QSRepositoryCpp *qsRepository)`: Forwards objects from another repository
*   `onIsAvailableChanged()`: Propagates availability changes to contained objects
*   `onObjectChanged()`: Handles object changes
*   `observeObject(QSObjectCpp *qsObject)`: Connects to object change signals
*   `registerObject(QSObjectCpp *qsObject)`: Registers an object with the repository
*   `unforwardRepo(QSRepositoryCpp *qsRepository)`: Stops forwarding objects from another repository
*   `unobserveObject(QSObjectCpp *qsObject)`: Disconnects from object change signals
*   `unregisterObject(QSObjectCpp *qsObject)`: Unregisters an object from the repository

### Example Usage in QML

```qml
import QtQuick 2.15

Item {
    id: root

    // Create a QSRepositoryCpp instance
    property QSRepositoryCpp repository: QSRepositoryCpp {
        id: repository
    }

    // Register an object with the repository
    Component.onCompleted: {
        var obj = QSObjectCpp {
            id: obj
        }
        repository.registerObject(obj)
    }
}
```

### Extension/Override Points

To extend or override the behavior of `QSRepositoryCpp`, you can:

*   Subclass `QSRepositoryCpp` and override its virtual functions
*   Connect to its signals and handle events as needed

### Caveats or Assumptions

*   This implementation assumes that `QSObjectCpp` instances have a unique UUID.
*   The `isLoading` flag is used to prevent unnecessary signal emissions during loading.

### Related Components

*   `QSObjectCpp`: The object class managed by `QSRepositoryCpp`
*   `NodeLink`: The MVC framework that `QSRepositoryCpp` is part of

## Container.qml
### Overview

The `Container.qml` file defines a QML component that represents a container for grouping items in the NodeLink architecture. This component is a crucial part of the NodeLink Model-View-Controller (MVC) architecture, serving as a model that can hold multiple nodes and containers.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `Container` component acts as a model. It manages a collection of nodes and containers, providing methods for adding and removing them. The view components can then bind to the properties of this model to display the contents of the container.

### Component Description

The `Container` component is an instance of `I_Node`, which is a base interface for all nodes in the NodeLink architecture. It has several properties and methods that enable it to manage its contents and notify about changes.

### Properties

*   **`title`**: A string property that represents the name of the container. Default value is "Untitled".
*   **`nodes`**: A var property that holds an object with nodes inside the container, where each key is a unique node ID.
*   **`containersInside`**: A var property that holds an object with containers inside the container, where each key is a unique container ID.
*   **`guiConfig`**: A `ContainerGuiConfig` property that holds the UI configuration for the container.

### Signals

The `Container` component emits the following signals:

*   **`nodesChanged`**: Emitted when the list of nodes inside the container changes.
*   **`containersInsideChanged`**: Emitted when the list of containers inside the container changes.

### Functions

*   **`addNode(node: Node)`**: Adds a node to the container.
*   **`removeNode(node: Node)`**: Removes a node from the container.
*   **`addContainerInside(container: Container)`**: Adds a container to the container.
*   **`removeContainerInside(container: Container)`**: Removes a container from the container.
*   **`onCloneFrom(container)`**: An override function that manages the cloning of containers, enabling each subclass to copy its own properties.

### Example Usage in QML

```qml
import NodeLink

Container {
    id: myContainer
    title: "My Container"

    // Adding nodes
    Component.onCompleted: {
        var node1 = Node {}
        myContainer.addNode(node1)

        var node2 = Node {}
        myContainer.addNode(node2)
    }
}
```

### Extension/Override Points

*   **`onCloneFrom(container)`**: Subclasses can override this function to copy their own properties when cloning a container.

### Caveats or Assumptions

*   The `Container` component assumes that the nodes and containers added to it have a unique `_qsUuid` property.
*   The `guiConfig` property is an instance of `ContainerGuiConfig`, which is not defined in this file. It is assumed to be defined elsewhere in the project.

### Related Components

*   **`I_Node`**: The base interface for all nodes in the NodeLink architecture.
*   **`Node`**: A QML component that represents a node in the NodeLink architecture.
*   **`ContainerGuiConfig`**: A QML component that holds the UI configuration for a container.


## ContainerGuiConfig.qml
### Overview

The `ContainerGuiConfig` QML component provides a configuration object for container GUI elements in the NodeLink framework. It encapsulates properties that define the visual appearance and behavior of a container in the NodeLink scene.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `ContainerGuiConfig` serves as a configuration object that can be used by the View components to display container GUI elements. It does not directly interact with the Model or Controller but provides essential data for rendering and user interaction.

### Component Description

`ContainerGuiConfig` is a `QSObject` that aggregates properties related to the GUI configuration of a container. It includes properties for zoom factor, size, color, position, lock status, and title text height.

### Properties

The following properties are available:

* `zoomFactor`: The zoom factor of the container, default is `1.0`.
* `width` and `height`: The width and height of the container, default is `200`.
* `color`: The color of the container, default is `NLStyle.primaryColor`.
* `colorIndex`: The color index of the container, default is `-1`.
* `position`: The position of the container in the scene, default is `Qt.vector2d(0.0, 0.0)`.
* `locked`: A boolean indicating whether the container is locked, default is `false`.
* `containerTextHeight`: The height of the title text, default is `35`.

### Signals

None.

### Functions

None.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Create a ContainerGuiConfig object
ContainerGuiConfig {
    id: containerConfig
    zoomFactor: 1.5
    width: 300
    height: 200
    color: "blue"
    position: Qt.vector2d(100, 100)
}

// Use the config object in a NodeLink component
NodeLinkComponent {
    containerGuiConfig: containerConfig
}
```

### Extension/Override Points

To extend or customize the behavior of `ContainerGuiConfig`, you can:

* Create a custom QML component that inherits from `ContainerGuiConfig` and overrides specific properties or adds new ones.
* Use the `ContainerGuiConfig` object as a property in a custom NodeLink component and bind its properties to custom logic.

### Caveats or Assumptions

* The `ContainerGuiConfig` object assumes that it will be used in a NodeLink scene context.
* The `QSObject` base class requires the `Component.onDestruction` handler to unregister the object from the `_qsRepo` when destroyed.

### Related Components

* `NodeLinkComponent`: A NodeLink component that can use the `ContainerGuiConfig` object to display a container GUI element.
* `NLStyle`: A NodeLink style component that provides default colors and styles for NodeLink components.


## ImagesModel.qml
### Overview

The `ImagesModel` component is a QML object that manages a collection of images for a node in the NodeLink MVC architecture. It provides properties and functions to add and delete images, as well as notify listeners of changes to the image collection.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `ImagesModel` serves as a model component that stores and manages the images associated with a node. It interacts with the controller to provide data and notify listeners of changes.

### Component Description

`ImagesModel` is a `QSObject` that provides the following features:

* Manages a list of image sources
* Allows adding and deleting images
* Notifies listeners of changes to the image collection

### Properties

| Property Name | Type | Description |
| --- | --- | --- |
| `imagesSources` | var | A list of image sources (e.g., base64 encoded strings) |
| `coverImageIndex` | int | The index of the cover image (-1 means no cover image) |

### Signals

| Signal Name | Description |
| --- | --- |
| `imagesSourcesChanged()` | Emitted when the `imagesSources` list changes |

### Functions

| Function Name | Description |
| --- | --- |
| `addImage(base64int)` | Adds an image to the `imagesSources` list |
| `deleteImage(base64int)` | Deletes an image from the `imagesSources` list |

### Example Usage in QML

```qml
import NodeLink 1.0

Node {
    id: node

    // Create an ImagesModel instance
    property ImagesModel imagesModel: ImagesModel {
        id: imagesModel
    }

    // Add an image
    Component.onCompleted: imagesModel.addImage("base64 encoded string")

    // Delete an image
    Button {
        text: "Delete Image"
        onClicked: imagesModel.deleteImage("base64 encoded string")
    }
}
```

### Extension/Override Points

To extend or override the behavior of `ImagesModel`, you can:

* Create a custom model that inherits from `ImagesModel` and overrides its functions
* Use a different data storage mechanism (e.g., a database) to store the image sources

### Caveats or Assumptions

* The `imagesSources` list is not persisted across application restarts
* The `coverImageIndex` property is not validated to ensure it is within the bounds of the `imagesSources` list

### Related Components

* `Node`: The node component that uses `ImagesModel` to manage its images
* `ImageViewer`: A component that displays the images managed by `ImagesModel`


## I_Node.qml
### Overview

The `I_Node` QML component serves as the base interface for all objects within the NodeLink scene. It provides a foundation for node-like objects, defining essential properties, signals, and functions that can be extended or overridden by derived classes.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `I_Node` acts as a crucial part of the Model component. It represents the data and behavior of nodes within the scene, providing a blueprint for concrete node implementations. The `I_Node` component interacts with the `NodeLink` module, facilitating the management of node data and behavior.

### Component Description

The `I_Node` component is a `QSObject` that encapsulates the basic characteristics of a node. It includes properties for the node's type and associated data, as well as signals and functions for managing node cloning.

### Properties

* `objectType`: An integer property that specifies the type of the node, defaulting to `NLSpec.ObjectType.Unknown`. This property can be overridden by derived classes to specify a more specific node type.
* `nodeData`: A property of type `I_NodeData` that holds the node's data. This property is initially set to `null` and can be set by derived classes to associate specific data with the node.

### Signals

* `cloneFrom(baseNode: I_Node)`: Emitted when a node is cloned or copied. This signal allows derived classes to implement custom cloning behavior.

### Functions

* `onCloneFrom(baseNode: I_Node)`: A slot function that is automatically called when the `cloneFrom` signal is emitted. It manages the cloning of nodes by copying direct properties from the base node. Derived classes can extend this function to copy their specific properties.

### Example Usage in QML

```qml
import NodeLink

// Create a concrete node component that extends I_Node
Item {
    id: myNode
    objectType: NLSpec.ObjectType.CustomNode
    nodeData: MyNodeData { /* initialize node data */ }

    // Handle cloning
    onCloneFrom: function(baseNode) {
        // Extend the base cloning behavior
        mySpecificProperty = baseNode.mySpecificProperty;
    }
}
```

### Extension/Override Points

* Derived classes can override the `objectType` property to specify a custom node type.
* The `nodeData` property can be set to associate specific data with the node.
* The `onCloneFrom` function can be extended to implement custom cloning behavior for derived classes.

### Caveats or Assumptions

* The `I_Node` component assumes that derived classes will properly implement the `cloneFrom` signal and the `onCloneFrom` function to ensure correct node cloning behavior.
* The component uses the `QSObject` type, which may have specific requirements or limitations.

### Related Components

* `I_NodeData`: The interface for node data, which is used by the `nodeData` property.
* `NLSpec`: The specification module for NodeLink, which defines constants and types used by the `I_Node` component.
* Concrete node components (e.g., `MyNode.qml`): Derived classes that extend the `I_Node` component to implement specific node behavior.


## I_NodeData.qml
### Overview

The `I_NodeData` QML interface serves as the base class for defining node data in the NodeLink architecture. It provides a fundamental structure for node data, allowing for flexibility and extensibility.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `I_NodeData` plays a crucial role in the Model component. It acts as a data container and interface for node-specific data, which is then utilized by the Controller to manage node behavior and the View to display node information.

### Component Description

The `I_NodeData` interface is a QSObject that defines a single property for storing node data. This property can hold any type of data, including arrays, maps of objects, or any other QML-supported types.

### Properties

*   **`data`**: A property of type `var` that can store any type of data, including arrays and maps of objects. This allows for flexible and dynamic data storage for node-specific information.

### Signals

None.

### Functions

None.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Create an instance of I_NodeData
I_NodeData {
    id: nodeData
    data: { "name": "Example Node", "type": "info" }
}

// Accessing the data property
console.log(nodeData.data.name)  // Outputs: Example Node
```

### Extension/Override Points

To create a custom node data class, you can create a QML object that inherits from `I_NodeData` and adds additional properties or functions as needed. For example:

```qml
// CustomNodeData.qml
import QtQuick
import NodeLink

I_NodeData {
    property string nodeName
    property string nodeType

    // Additional functions or properties can be added here
}
```

### Caveats or Assumptions

*   The `data` property is not restricted to a specific type, which may require careful handling to avoid type-related errors.
*   This interface does not provide any data validation or serialization mechanisms; these may need to be implemented by derived classes.

### Related Components

*   `Node`: The base class for nodes in the NodeLink architecture, which likely utilizes `I_NodeData` for its data storage.
*   `NodeController`: The controller class that manages node behavior and interacts with node data through this interface.

By using the `I_NodeData` interface, developers can ensure consistency and flexibility in node data management within the NodeLink architecture.


## I_Scene.qml
### Overview

The `I_Scene` QML component represents a scene in the NodeLink architecture, responsible for managing nodes, links, and containers. It provides a comprehensive set of properties, signals, and functions to interact with the scene.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `I_Scene` serves as the Model component. It manages the data and business logic of the scene, including nodes, links, and containers. The View components, such as `NodeOverview` and `LinkView`, interact with the `I_Scene` model to display and update the scene.

### Component Description

The `I_Scene` component is a `QSObject` that provides a centralized management system for nodes, links, and containers. It maintains a map of nodes, links, and containers, and provides signals and functions to add, remove, and manipulate these objects.

### Properties

* `title`: The title of the scene (string, default: "<Untitled>")
* `nodes`: A map of nodes in the scene (var, default: {})
* `links`: A map of links in the scene (var, default: {})
* `containers`: A map of containers in the scene (var, default: {})
* `selectionModel`: The selection model for the scene (SelectionModel, default: null)
* `nodeRegistry`: The node registry for the scene (NLNodeRegistry, default: null)
* `sceneActiveRepo`: The active repository for the scene (var, default: NLCore.defaultRepo)
* `sceneGuiConfig`: The GUI configuration for the scene (SceneGuiConfig)

### Signals

* `nodeAdded(Node node)`: Emitted when a node is added to the scene
* `nodesAdded(var nodes)`: Emitted when multiple nodes are added to the scene
* `nodeRemoved(Node node)`: Emitted when a node is removed from the scene
* `linkAdded(Link link)`: Emitted when a link is added to the scene
* `linksAdded(var links)`: Emitted when multiple links are added to the scene
* `linkRemoved(Link link)`: Emitted when a link is removed from the scene
* `containerAdded(Container container)`: Emitted when a container is added to the scene
* `containersRemoved(var containers)`: Emitted when multiple containers are removed from the scene
* `containerRemoved(Container container)`: Emitted when a container is removed from the scene
* `copyCalled()`: Emitted when the copy action is triggered
* `pasteCalled()`: Emitted when the paste action is triggered
* `contentMoveRequested(diff: vector2d)`: Emitted when the content move is requested
* `contentResizeRequested(diff: vector2d)`: Emitted when the content resize is requested

### Functions

* `createContainer()`: Creates a new container
* `addContainer(container: Container)`: Adds a container to the scene
* `deleteContainer(containerUUId: string)`: Deletes a container from the scene
* `deleteContainers(containerUUIds: string)`: Deletes multiple containers from the scene
* `isSceneEmpty()`: Checks if the scene is empty
* `addNode(node: Node, autoSelect: bool)`: Adds a node to the scene
* `addNodes(nodeArray: list<Node>, autoSelect: bool)`: Adds multiple nodes to the scene
* `createSpecificNode(imports, nodeType: int, nodeTypeName: string, nodeColor: string, title: string, xPos: real, yPos: real)`: Creates a node with a specific type and position
* `deleteNode(nodeUUId: string)`: Deletes a node from the scene
* `deleteNodes(nodeUUIds: list<string>)`: Deletes multiple nodes from the scene
* `cloneContainer(nodeUuid: string)`: Clones a container
* `cloneNode(nodeUuid: string)`: Clones a node
* `copyScene()`: Copies the scene and returns a new scene
* `createLinks(linkDataArray)`: Creates multiple links
* `createLink(portA: string, portB: string)`: Creates a link between two ports
* `unlinkNodes(portA: string, portB: string)`: Unlinks two ports
* `findNodeId(portId: string)`: Finds the node ID associated with a port ID
* `findNodeByItsId(nodeId: string)`: Finds a node by its ID
* `findNode(portId: string)`: Finds a node associated with a port ID
* `findPort(portId: string)`: Finds a port object
* `deleteSelectedObjects()`: Deletes selected objects (nodes and links)
* `findNodesInContainerItem(containerItem)`: Finds nodes in a container item
* `copyNodes()`: Copies nodes
* `pasteNodes()`: Pastes nodes
* `snappedPosition(position)`: Calculates the snapped position for a given position
* `snapAllNodesToGrid()`: Snaps all nodes and containers to the grid

### Example Usage in QML

```qml
import QtQuick 2.15
import NodeLink 1.0

Item {
    I_Scene {
        id: scene
        title: "My Scene"
        nodeRegistry: NLNodeRegistry {}
        selectionModel: SelectionModel {}
    }

    // Add a node to the scene
    Component.onCompleted: {
        var node = QSSerializer.createQSObject("Node", ["NodeLink"], scene.sceneActiveRepo);
        scene.addNode(node, true);
    }
}
```

### Extension/Override Points

* To extend or override the behavior of the `I_Scene` component, you can create a custom QML component that inherits from `I_Scene` and overrides specific functions or properties.

### Caveats or Assumptions

* The `I_Scene` component assumes that the `nodeRegistry` and `selectionModel` properties are properly initialized before use.
* The `sceneActiveRepo` property is used to store and retrieve data from the scene's repository.

### Related Components

* `NLNodeRegistry`: The node registry component that manages node types and imports.
* `SelectionModel`: The selection model component that manages the selection of nodes and links.
* `SceneGuiConfig`: The GUI configuration component that manages the scene's GUI properties.


## Link.qml
### Overview

The `Link` component represents a connection between two nodes in the NodeLink architecture. It maintains references to the input and output ports, as well as control points for line rendering. This allows for interactive connection selection and manipulation.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, the `Link` component serves as a model that represents a connection between two nodes. It interacts with the `Port` components, which are part of the node architecture, to establish and manage connections.

### Component Description

The `Link` component inherits from `I_Node` and has the following key features:

*   Maintains references to `inputPort` and `outputPort`
*   Stores an array of `controlPoints` for line rendering
*   Supports different `direction` types (unidirectional, bidirectional)
*   Has a `guiConfig` property for customizing the link's UI appearance

### Properties

The `Link` component has the following properties:

*   `inputPort`: The input port of the link (type: `Port`)
*   `outputPort`: The output port of the link (type: `Port`)
*   `controlPoints`: An array of control points for line rendering (type: `var`)
*   `direction`: The direction of the link (type: `int`, values: `NLSpec.LinkDirection.Unidirectional`, etc.)
*   `guiConfig`: The UI configuration for the link (type: `LinkGUIConfig`)

### Signals

The `Link` component does not emit any custom signals. However, it inherits signals from its base class `I_Node`.

### Functions

The `Link` component has the following functions:

*   `onCloneFrom(baseLink)`: A callback function for handling link GUI configuration when copying and pasting. It sets the properties of the current link's GUI configuration to match the provided base link.

### Example Usage in QML

```qml
import NodeLink

Link {
    id: myLink
    inputPort: Port { }
    outputPort: Port { }
    controlPoints: [ { x: 10, y: 20 }, { x: 30, y: 40 } ]
    direction: NLSpec.LinkDirection.Unidirectional
    guiConfig: LinkGUIConfig { }
}
```

### Extension/Override Points

To extend or customize the behavior of the `Link` component, you can:

*   Override the `onCloneFrom` function to implement custom cloning logic
*   Create a custom `LinkGUIConfig` component to modify the link's UI appearance

### Caveats or Assumptions

*   The `inputPort` and `outputPort` properties are expected to be of type `Port`
*   The `controlPoints` array should contain objects with `x` and `y` properties
*   The `direction` property should be one of the values defined in `NLSpec.LinkDirection`

### Related Components

*   `Port`: Represents a node port that can be connected to a link
*   `Node`: The base component for nodes in the NodeLink architecture
*   `LinkGUIConfig`: A component for customizing the UI appearance of links


## LinkGUIConfig.qml
### Overview

The `LinkGUIConfig` component is a QML object that stores UI-related properties for a link in the NodeLink MVC architecture. It provides a centralized way to manage link-specific settings, such as description, color, style, and type.

### Architecture Integration

In the NodeLink MVC architecture, `LinkGUIConfig` serves as a configuration object for link-related UI components. It is typically used in conjunction with the `Link` model and `LinkView` components to provide a cohesive user interface for link editing and visualization.

### Component Description

The `LinkGUIConfig` component is a `QSObject` that exposes several properties to control the appearance and behavior of a link in the UI.

### Properties

* **`description`**: A string property that stores the link's description. (Default: "")
* **`color`**: A string property that sets the link's color. (Default: "white")
* **`colorIndex`**: An integer property that stores the link's color index. (Default: -1)
* **`style`**: An integer property that sets the link's style, using values from `NLSpec.LinkStyle`. (Default: `NLSpec.LinkStyle.Solid`)
* **`type`**: An integer property that sets the link's type, using values from `NLSpec.LinkType`. (Default: `NLSpec.LinkType.Bezier`)
* **`_isEditableDescription`**: A boolean property that indicates whether the link's description is editable. (Default: `false`)

### Signals

None

### Functions

None

### Example Usage in QML

```qml
import QtQuick

Item {
    LinkGUIConfig {
        id: linkConfig
        description: "Example Link"
        color: "blue"
        style: NLSpec.LinkStyle.Dashed
        type: NLSpec.LinkType.Straight
    }

    // Use linkConfig properties in your UI components
    Text {
        text: linkConfig.description
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `LinkGUIConfig`, you can:

* Create a custom QML component that inherits from `LinkGUIConfig` and adds or overrides properties and functions.
* Use the `_isEditableDescription` property to implement custom editing logic for the link's description.

### Caveats or Assumptions

* The `LinkGUIConfig` component assumes that it will be used in a NodeLink MVC architecture context, where the `Link` model and `LinkView` components are available.
* The component uses `NLSpec.LinkStyle` and `NLSpec.LinkType` enums, which are assumed to be defined elsewhere in the application.

### Related Components

* `Link`: The model component that represents a link in the NodeLink MVC architecture.
* `LinkView`: The view component that displays a link in the UI, using the properties stored in `LinkGUIConfig`.


## NLCore.qml
### Overview

The `NLCore` QML component is a singleton that serves as the core of the NodeLink framework. It is responsible for creating the default repository scene and handling top-level functionalities such as de/serialization and network connectivity.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `NLCore` acts as a controller, providing an interface to create and manage scenes, nodes, ports, and links. It interacts with the model (repository) to create and retrieve data.

### Component Description

The `NLCore` component is a subclass of `QSCore` and provides the following key features:

*   Creates scenes, nodes, ports, and links using the `QSSerializer`
*   Manages copied nodes, links, and containers for paste functionality
*   Provides functions for creating scenes, nodes, ports, and links

### Properties

The following properties are exposed by the `NLCore` component:

*   `_internal`: An internal QtObject containing information about the imports used by the component
*   `_copiedNodes`: A dictionary of shallow-copied nodes used for paste functionality
*   `_copiedLinks`: A dictionary of shallow-copied links used for paste functionality
*   `_copiedContainers`: A dictionary of shallow-copied containers used for paste functionality

### Signals

None

### Functions

The following functions are provided by the `NLCore` component:

*   `createScene()`: Creates a new scene object using the `QSSerializer`
*   `createNode()`: Creates a new node object using the `QSSerializer`
*   `createPort(qsRepo = null)`: Creates a new port object using the `QSSerializer`. If `qsRepo` is not provided, it defaults to the `defaultRepo`
*   `createLink()`: Creates a new link object using the `QSSerializer`

### Example Usage in QML

```qml
import NodeLink 1.0

Item {
    id: root

    // Access the NLCore singleton
    property NLCore core: NLCore {}

    // Create a new scene
    Component.onCompleted: {
        var scene = core.createScene()
        console.log("Scene created:", scene)
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `NLCore` component, you can:

*   Create a custom QML component that imports and extends `NLCore`
*   Override the functions provided by `NLCore` to customize their behavior

### Caveats or Assumptions

*   The `NLCore` component assumes that the `QSSerializer` and `defaultRepo` are properly configured and available
*   The component uses shallow copying for nodes, links, and containers, which may not be suitable for all use cases

### Related Components

The following components are related to `NLCore`:

*   `QSSerializer`: Responsible for serializing and deserializing NodeLink objects
*   `Scene`: The scene object created by `NLCore`
*   `Node`: The node object created by `NLCore`
*   `Port`: The port object created by `NLCore`
*   `Link`: The link object created by `NLCore`


## NLNodeRegistry.qml
### Overview

The `NLNodeRegistry` component is a crucial part of the NodeLink MVC architecture, responsible for registering and managing node types, their corresponding views, and other relevant metadata. It acts as a central registry for all node-related information, enabling the creation and customization of nodes within the application.

### Architecture Integration

In the NodeLink MVC architecture, `NLNodeRegistry` plays a key role in the Model layer, providing essential data and configuration for node creation and rendering. It interacts closely with the `NLNode` and `NLLink` components, as well as the `NodeLink` model, to ensure a cohesive and extensible node-based system.

### Component Description

The `NLNodeRegistry` component is a `QSObject` that encapsulates the following key features:

*   Node type registration
*   Node metadata management (names, icons, colors)
*   Default node type configuration
*   View URL management for nodes, links, and containers

### Properties

The following properties are exposed by the `NLNodeRegistry` component:

*   `imports`: A list of imports required to create a node type.
*   `nodeTypes`: A map of node type IDs to their corresponding class names.
*   `nodeNames`: A map of node type IDs to their display names.
*   `nodeIcons`: A map of node type IDs to their icon URLs.
*   `nodeColors`: A map of node type IDs to their color values.
*   `defaultNode`: The ID of the default node type.
*   `nodeView`, `linkView`, `containerView`: URLs for the node, link, and container views, respectively.

### Signals

None.

### Functions

None.

### Example Usage in QML

```qml
import NodeLink

NLNodeRegistry {
    id: nodeRegistry

    // Register node types
    nodeTypes: {
        1: "MyNodeType1",
        2: "MyNodeType2"
    }

    // Configure node metadata
    nodeNames: {
        1: "Node 1",
        2: "Node 2"
    }

    nodeIcons: {
        1: "qrc:/icons/node1.png",
        2: "qrc:/icons/node2.png"
    }

    nodeColors: {
        1: "#FF0000",
        2: "#00FF00"
    }

    // Set default node type
    defaultNode: 1

    // Configure view URLs
    nodeView: "qrc:/views/MyNodeView.qml"
    linkView: "qrc:/views/MyLinkView.qml"
    containerView: "qrc:/views/MyContainerView.qml"
}
```

### Extension/Override Points

To extend or customize the behavior of `NLNodeRegistry`, you can:

*   Subclass `NLNodeRegistry` and override its properties or add new ones.
*   Use the `imports` property to add custom imports for node creation.
*   Provide custom node type registrations, metadata, and view URLs.

### Caveats or Assumptions

*   The `NLNodeRegistry` component assumes that node types are registered with unique IDs.
*   The component uses the `qrc:/` format for registering view URLs; ensure that these URLs are correctly configured in your project's resource file.

### Related Components

*   `NLNode`: Represents a node in the NodeLink graph.
*   `NLLink`: Represents a link between nodes in the NodeLink graph.
*   `NodeLink`: The main model component that manages the node-link graph and interacts with `NLNodeRegistry`.


## NLSpec.qml
### Overview

NLSpec.qml is a singleton QML file that provides a centralized specification for various enumerations and properties used throughout the NodeLink (NL) framework. It serves as a reference point for developers to ensure consistency across the application.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, NLSpec.qml acts as a supporting module that provides essential definitions for the Model, View, and Controller components. It does not directly correspond to a specific MVC component but rather supplements the architecture by offering a unified set of specifications.

### Component Description

NLSpec.qml defines a QtObject with several enumerations and properties that describe various aspects of the NodeLink framework, including:

* Object types
* Selection tool object types
* Port positions on node sides
* Port types for data flow
* Link types
* Link directions
* Link styles
* Node types

### Properties

The following properties are exposed by NLSpec.qml:

* `undo`: A QtObject with a single property `blockObservers`, which is a boolean flag indicating whether observers should be blocked during undo operations.

### Enumerations

The following enumerations are defined in NLSpec.qml:

#### ObjectType

* `Node` (0): Represents a node object.
* `Link` (1): Represents a link object.
* `Container` (2): Represents a container object.
* `Unknown` (99): Represents an unknown object type.

#### SelectionSpecificToolType

* `Node` (0): Selection tool type for single node selection.
* `Link` (1): Selection tool type for single link selection.
* `Any` (2): Selection tool type for single selection with any type.
* `All` (3): Selection tool type for multiple selection with any types.
* `Unknown` (99): Unknown selection tool type.

#### PortPositionSide

* `Top` (0): Port position on the top side of a node.
* `Bottom` (1): Port position on the bottom side of a node.
* `Left` (2): Port position on the left side of a node.
* `Right` (3): Port position on the right side of a node.
* `Unknown` (99): Unknown port position.

#### PortType

* `Input` (0): Input port type.
* `Output` (1): Output port type.
* `InAndOut` (2): Port type that supports both input and output.

#### LinkType

* `Bezier` (0): Bezier curve link type.
* `LLine` (1): L-shaped line link type.
* `Straight` (2): Straight line link type.
* `Unknown` (99): Unknown link type.

#### LinkDirection

* `Nondirectional` (0): Nondirectional link.
* `Unidirectional` (1): Unidirectional link.
* `Bidirectional` (2): Bidirectional link.

#### LinkStyle

* `Solid` (0): Solid line style.
* `Dash` (1): Dashed line style.
* `Dot` (2): Dotted line style.

#### NodeType

* `CustomNode` (98): Custom node type.
* `Unknown` (99): Unknown node type.

### Example Usage in QML

```qml
import NLSpec 1.0

QtObject {
    property int linkType: NLSpec.LinkType.Bezier
    property int nodeType: NLSpec.NodeType.CustomNode

    Component.onCompleted: {
        console.log("Link type:", linkType)
        console.log("Node type:", nodeType)
    }
}
```

### Extension/Override Points

Developers can extend or override the enumerations and properties provided by NLSpec.qml by creating custom QML modules or C++ classes that inherit from the existing types.

### Caveats or Assumptions

* The enumerations and properties defined in NLSpec.qml are intended to be used consistently throughout the NodeLink framework.
* The `undo` property is used to block observers during undo operations, which may have implications for the application's behavior.

### Related Components

* NodeLink Model: Uses NLSpec.qml to define the structure and behavior of nodes and links.
* NodeLink View: Uses NLSpec.qml to render nodes and links according to their types and properties.
* NodeLink Controller: Uses NLSpec.qml to manage the interactions between nodes and links.


## NLUtils.qml
### Overview

The `NLUtils` component is a utility module within the NodeLink framework, providing a set of helper functions and properties to facilitate development and integration with the NodeLink MVC architecture.

### Architecture Integration

In the NodeLink MVC architecture, `NLUtils` serves as a supporting module that can be used across various components, including models, views, and controllers. It does not directly correspond to a specific MVC layer but rather acts as a utility belt, offering functionalities that can be leveraged to simplify development and improve code readability.

### Component Description

`NLUtils` is essentially a QML wrapper around the `NLUtilsCPP` C++ class, which is implemented in C++. This component exposes a set of static utility functions and properties that can be easily accessed and used within QML files.

### Properties

| Property Name | Type | Description |
| --- | --- | --- |
| None | - | `NLUtils` does not expose any properties. It is used solely for its functions. |

### Signals

| Signal Name | Parameters | Description |
| --- | --- | --- |
| None | - | `NLUtils` does not emit any signals. |

### Functions

The following functions are available in `NLUtils`. Note that since `NLUtils` is a wrapper around `NLUtilsCPP`, the actual implementation details are in C++, but they are exposed in a QML-friendly manner.

| Function Name | Parameters | Return Type | Description |
| --- | --- | --- | --- |
| None | - | - | Currently, no functions are directly exposed through `NLUtils.qml`. The actual utility functions are part of the `NLUtilsCPP` class and would be documented separately. |

### Example Usage in QML

```qml
import QtQuick 2.0
import NodeLink 1.0

Item {
    id: root

    // Example usage, assuming a utility function 'exampleFunction' exists in NLUtilsCPP
    // and is properly exposed.
    Component.onCompleted: {
        // NLUtils.exampleFunction(); // Uncomment if exampleFunction is available
    }
}
```

### Extension/Override Points

To extend or override the behavior of `NLUtils`, you would typically work with the `NLUtilsCPP` class, as it contains the core implementation. This might involve:

1. **C++ Implementation**: Modifying or extending the C++ class `NLUtilsCPP` to add new functionalities or modify existing ones.
2. **QML Wrappers**: If additional QML-specific functionality is needed, creating a new QML component that wraps `NLUtils` and adds the required features.

### Caveats or Assumptions

- The actual functionality of `NLUtils` depends on the implementation of `NLUtilsCPP`.
- Usage of `NLUtils` assumes that the NodeLink framework and its dependencies are properly set up and configured.

### Related Components

- `NLUtilsCPP`: The C++ class providing the core implementation of the utility functions.
- [Other NodeLink components]: Depending on the specific functionalities used from `NLUtils`, various other NodeLink components might be relevant, such as models, views, and controllers.


## Node.qml
### Overview

The `Node` QML component is a model that manages node properties, serving as a fundamental building block in the NodeLink MVC architecture. It encapsulates the data and behavior of a node, including its GUI configuration, title, type, children, parents, and ports.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `Node` component acts as the Model, which holds the data and business logic of a node. It interacts with the `NodeGuiConfig` component to manage the node's GUI properties and with the `Port` component to manage the node's ports.

### Component Description

The `Node` component is an implementation of the `I_Node` interface and provides the following key features:

*   Manages node properties, such as title, type, children, parents, and ports
*   Handles node cloning and property copying
*   Emits signals for port additions and node completion
*   Provides functions for adding, deleting, and finding ports

### Properties

The `Node` component has the following properties:

*   `guiConfig`: A `NodeGuiConfig` object that manages the node's GUI properties
*   `title`: A string representing the node's title, defaulting to "<No Title>"
*   `type`: An integer representing the node's type, defaulting to 0
*   `children`: A map of child node IDs to actual node objects
*   `parents`: A map of parent node IDs to actual node objects
*   `ports`: A map of port UUIDs to `Port` objects
*   `imagesModel`: An `ImagesModel` object that manages the node's images

### Signals

The `Node` component emits the following signals:

*   `portAdded(var portId)`: Emitted when a new port is added to the node
*   `nodeCompleted()`: Emitted when all node properties are set and the component is completed

### Functions

The `Node` component provides the following functions:

*   `addPort(port: Port)`: Adds a new port to the node's port map
*   `deletePort(port: Port)`: Deletes a port from the node's port map
*   `findPort(portId: string): Port`: Finds a port by its UUID
*   `findPortByPortSide(portSide: int): Port`: Finds a port by its port side

### Example Usage in QML

```qml
import NodeLink

Node {
    id: myNode
    title: "My Node"
    type: 1

    // Add a new port to the node
    function addMyPort() {
        var myPort = Port {}
        myNode.addPort(myPort)
    }

    // Delete a port from the node
    function deleteMyPort(portId) {
        var myPort = myNode.findPort(portId)
        if (myPort) {
            myNode.deletePort(myPort)
        }
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `Node` component, you can:

*   Create a custom node component that inherits from `Node`
*   Override the `onCloneFrom` function to customize node cloning behavior
*   Connect to the `portAdded` and `nodeCompleted` signals to perform custom actions

### Caveats or Assumptions

*   The `Node` component assumes that the `I_Node` interface is implemented correctly
*   The component uses the `_qsRepo` object to manage object registration and destruction

### Related Components

*   `NodeGuiConfig`: Manages the node's GUI properties
*   `Port`: Represents a port in the node's port map
*   `ImagesModel`: Manages the node's images

By using the `Node` QML component, you can create and manage nodes in your NodeLink-based application, leveraging its built-in features and signals to simplify your development process.


## NodeData.qml
### Overview

The `NodeData.qml` file provides a basic implementation of the `I_NodeData` interface, which is a crucial part of the NodeLink Model-View-Controller (MVC) architecture. This component serves as a foundation for representing data associated with nodes in a graph or network.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `NodeData.qml` acts as the Model component. It encapsulates the data and business logic related to nodes, providing a standardized interface for accessing and manipulating node data. This allows for a clear separation of concerns between the data representation, visualization, and control logic.

### Component Description

The `NodeData.qml` component implements the `I_NodeData` interface, which defines the contract for node data objects. This interface ensures that any node data object provides a consistent set of properties and methods, facilitating interoperability and reuse across the NodeLink framework.

### Properties

The following properties are inherited from the `I_NodeData` interface:

* **id**: A unique identifier for the node data object (not explicitly declared in this file, but assumed to be part of the interface)
* Other properties may be defined in the `I_NodeData` interface or implementing classes

### Signals

No custom signals are defined in this component. However, it may emit signals as specified in the `I_NodeData` interface.

### Functions

No custom functions are defined in this component. However, it must implement the functions specified in the `I_NodeData` interface.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Node {
    id: exampleNode
    data: NodeData {
        // Access and manipulate node data properties here
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `NodeData.qml`, you can:

* Implement a custom node data class that inherits from `NodeData.qml` and overrides specific properties or functions.
* Provide a custom implementation of the `I_NodeData` interface.

### Caveats or Assumptions

* This component assumes that the `I_NodeData` interface is properly defined and implemented.
* The actual properties, signals, and functions available in this component depend on the definition of the `I_NodeData` interface.

### Related Components

* `I_NodeData`: The interface that defines the contract for node data objects.
* `Node.qml`: A sample node component that uses `NodeData.qml` to represent its data.
* Other NodeLink components that interact with node data objects.


## NodeGuiConfig.qml
### Overview

The `NodeGuiConfig` component is a QML object that stores the UI properties of a node in the NodeLink architecture. It provides a centralized location for managing node-specific properties, such as position, size, color, and opacity.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `NodeGuiConfig` serves as a View Configuration object. It provides the necessary properties for rendering a node in the graphical user interface (GUI). The NodeLink Controller updates this object's properties, which in turn are used by the NodeLink View to render the node.

### Component Description

The `NodeGuiConfig` component is a QSObject that stores the UI properties of a node. It is designed to be used as a configuration object for nodes in the NodeLink GUI.

### Properties

The following properties are available:

* `description`: A string describing the node (default: "<No Description>").
* `logoUrl`: A URL pointing to the node's logo image (default: "").
* `position`: A 2D vector representing the node's position in the world (default: Qt.vector2d(0.0, 0.0)).
* `width` and `height`: The node's width and height (default: NLStyle.node.width and NLStyle.node.height).
* `color`: The node's color (default: NLStyle.node.color).
* `colorIndex`: An integer index representing the node's color (default: -1).
* `opacity`: The node's opacity (default: NLStyle.node.opacity).
* `locked`: A boolean indicating whether the node is locked (default: false).
* `autoSize`: A boolean indicating whether the node should auto-size based on its content and port titles (default: true).
* `minWidth` and `minHeight`: The minimum width and height of the node (default: 120 and 80).
* `baseContentWidth`: The base content width of the node (default: 100).

### Signals

None.

### Functions

None.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Node {
    id: myNode
    config: NodeGuiConfig {
        description: "My Node"
        logoUrl: "qrc:/images/node_logo.png"
        position: Qt.vector2d(100, 100)
        width: 200
        height: 100
        color: "blue"
    }
}
```

### Extension/Override Points

To extend or override the behavior of `NodeGuiConfig`, you can:

* Create a custom QML object that inherits from `NodeGuiConfig` and adds or overrides properties and functions.
* Use a different QML object that provides similar properties and functions.

### Caveats or Assumptions

* The `logoUrl` property currently uses a string to store the image URL. In the future, this may be changed to a byte array to store the image data directly.
* The `NodeGuiConfig` object is automatically unregistered from the `_qsRepo` when it is destroyed.

### Related Components

* `Node`: The Node component that uses `NodeGuiConfig` to store its UI properties.
* `NLStyle`: The NodeLink style object that provides default values for node properties.


## Port.qml
### Overview

The `Port` QML component represents a port in the NodeLink architecture, managing its properties and behavior. It is a crucial part of the NodeLink Model-View-Controller (MVC) architecture, serving as a model that interacts with the view and controller to facilitate the creation and manipulation of nodes and their ports.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `Port` component acts as the model. It encapsulates the data and properties of a port, such as its position, type, and enablement. The view (e.g., a QML visual component) binds to the properties of the `Port` model to display the port's information. The controller interacts with the `Port` model to update its properties and respond to user interactions.

### Component Description

The `Port` component is a `QSObject` that manages port properties. It is designed to be used within a node to represent input or output ports.

### Properties

The following properties are exposed by the `Port` component:

* `node`: The parent node of the port.
* `color`: The color of the port (default: "white").
* `portSide`: The side of the node where the port is located (default: `NLSpec.PortPositionSide.Top`).
* `portType`: The type of port (input, output, or both) (default: `NLSpec.PortType.InAndOut`).
* `enable`: A flag indicating whether the port is enabled (default: `true`).
* `_position`: A cached vector2d representing the global position of the port in the UI (initialized to (-1, -1)).
* `title`: The title of the port, which is always visible.
* `_measuredTitleWidth`: The measured width of the title for auto-sizing purposes (initialized to -1).

### Signals

The `Port` component does not emit any signals.

### Functions

The `Port` component does not expose any functions.

### Example Usage in QML

```qml
import NodeLink

Node {
    id: myNode

    Port {
        node: myNode
        title: "Input Port"
        portType: NLSpec.PortType.Input
        portSide: NLSpec.PortPositionSide.Left
    }

    Port {
        node: myNode
        title: "Output Port"
        portType: NLSpec.PortType.Output
        portSide: NLSpec.PortPositionSide.Right
    }
}
```

### Extension/Override Points

To extend or customize the behavior of the `Port` component, you can:

* Create a custom QML component that inherits from `Port` and overrides its properties or behavior.
* Use a `QSObject` to create a custom model that interacts with the `Port` component.

### Caveats or Assumptions

* The `_position` property is cached and may not always reflect the actual position of the port in the UI. Use this property with caution.
* The `_measuredTitleWidth` property is used for auto-sizing and should not be modified directly.

### Related Components

* `Node`: The parent component of the `Port` component, representing a node in the NodeLink architecture.
* `NLSpec`: A specification component that provides constants and enumerations for the NodeLink architecture, such as `PortPositionSide` and `PortType`.


## Scene.qml
### Overview

The `Scene` component is a crucial part of the NodeLink MVC architecture, responsible for managing nodes and links between them. It provides a comprehensive set of properties, functions, and signals to facilitate the creation, manipulation, and interaction of nodes and links within a scene.

### Architecture Integration

In the NodeLink MVC architecture, the `Scene` component serves as the central hub for node and link management. It interacts closely with other components, such as nodes, links, and the undo core, to provide a seamless and intuitive user experience.

### Component Description

The `Scene` component is an instance of `I_Scene` and provides the following key features:

*   Node and link management
*   Undo and redo functionality through the `_undoCore` property
*   Automatic node reordering
*   Customizable node creation
*   Link creation and validation

### Properties

The `Scene` component has the following properties:

*   `selectionModel`: A `SelectionModel` instance that manages the selection of nodes and links in the scene.
*   `_undoCore`: An `UndoCore` instance that provides undo and redo functionality.

### Functions

The `Scene` component provides the following functions:

*   `automaticNodeReorder(nodes, rootId, keepRootPosition)`: Reorders nodes in the scene based on their hierarchy and position.
*   `createCustomizeNode(nodeType, xPos, yPos)`: Creates a custom node with the specified type and position. This function can be overridden in custom scenes.
*   `linkNodes(portA, portB)`: Links two nodes via their ports. This function can be overridden in custom scenes.
*   `canLinkNodes(portA, portB)`: Checks if two nodes can be linked via their ports. This function can be overridden in custom scenes.

### Signals

The `Scene` component does not emit any signals.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Scene {
    id: myScene

    // Create a custom node
    function createCustomNode() {
        var nodeType = 1; // Node type
        var xPos = 100; // X position
        var yPos = 100; // Y position
        return createCustomizeNode(nodeType, xPos, yPos);
    }

    // Link two nodes
    function linkTwoNodes() {
        var portA = "portA"; // Port A UUID
        var portB = "portB"; // Port B UUID
        linkNodes(portA, portB);
    }
}
```

### Extension/Override Points

The `Scene` component provides several extension and override points:

*   `createCustomizeNode(nodeType, xPos, yPos)`: Can be overridden to create custom nodes.
*   `linkNodes(portA, portB)`: Can be overridden to customize link creation.
*   `canLinkNodes(portA, portB)`: Can be overridden to customize link validation.

### Caveats and Assumptions

The `Scene` component assumes that nodes and links are properly registered and managed within the NodeLink framework. It also assumes that the undo core is properly configured and integrated.

### Related Components

The `Scene` component interacts closely with the following components:

*   `Node`: Represents a node in the scene.
*   `Link`: Represents a link between two nodes.
*   `UndoCore`: Provides undo and redo functionality.
*   `SelectionModel`: Manages the selection of nodes and links in the scene.


## SceneGuiConfig.qml
### Overview

The `SceneGuiConfig` QML component is designed to store and manage the visual properties of a scene within the NodeLink MVC architecture. It provides a centralized location for scene-specific GUI configuration, facilitating the synchronization of visual settings across different parts of the application.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `SceneGuiConfig` serves as a supporting model component. It does not directly control the scene's logic but provides essential visual configuration properties that can be observed and bound to by views and controllers. This separation allows for a flexible and decoupled design, enabling easier maintenance and extension of the application's GUI.

### Component Description

`SceneGuiConfig` is a `QSObject` that encapsulates several key visual properties of a scene. These include zoom factors, content dimensions, and positions within a flickable area, as well as scene view dimensions. The component automatically unregisters itself from the `_qsRepo` upon destruction, ensuring proper cleanup.

### Properties

The following properties are exposed by `SceneGuiConfig`:

*   **`zoomFactor`**: A real number representing the current zoom factor of the scene. Defaults to `1.0`.
*   **`contentWidth`** and **`contentHeight`**: Real numbers specifying the width and height of the flickable content in the UI session. Defaults are provided by `NLStyle.scene.defaultContentWidth` and `NLStyle.scene.defaultContentHeight`, respectively.
*   **`contentX`** and **`contentY`**: Real numbers representing the current X and Y positions of the content within the flickable area. Defaults are provided by `NLStyle.scene.defaultContentX` and `NLStyle.scene.defaultContentY`, respectively.
*   **`sceneViewWidth`** and **`sceneViewHeight`**: Real numbers specifying the width and height of the scene view within the flickable area. These properties do not have default values and must be set explicitly.
*   **`_mousePosition`**: A `vector2d` representing the current mouse position within the scene. This is used for operations like pasting based on mouse positions. **Note**: This property is prefixed with an underscore, indicating it is intended for internal use or subclassing.

### Signals

This component does not emit any signals.

### Functions

There are no functions provided by `SceneGuiConfig`.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Assuming access to a SceneGuiConfig instance named 'sceneGuiConfig'
SceneGuiConfig {
    id: sceneGuiConfig
    // Example of binding a property
    contentWidth: 800
    contentHeight: 600
    // ...
}

// Usage in another component
Flickable {
    id: flickable
    width: sceneGuiConfig.contentWidth
    height: sceneGuiConfig.contentHeight
    contentX: sceneGuiConfig.contentX
    contentY: sceneGuiConfig.contentY
    // ...
}
```

### Extension/Override Points

To extend or customize the behavior of `SceneGuiConfig`, you can:

*   Subclass `SceneGuiConfig` and add custom properties or functions as needed.
*   Override the `Component.onDestruction` handler if additional cleanup is required.

### Caveats or Assumptions

*   The `_mousePosition` property is currently used for pasting based on mouse positions but is marked for a potential better approach in the future.
*   It is assumed that `_qsRepo` is properly set up and accessible within the context where `SceneGuiConfig` is used.

### Related Components

*   `NLStyle`: Provides default style values used by `SceneGuiConfig`.
*   Other components within the NodeLink MVC architecture that interact with or observe `SceneGuiConfig` for scene GUI configuration.


## SelectionModel.qml
### Overview

The `SelectionModel.qml` component is a crucial part of the NodeLink MVC architecture, responsible for managing the selection of nodes, links, and containers in a scene. It keeps track of the currently selected items and provides methods for selecting, deselecting, and checking the selection status of objects.

### Component Description

The `SelectionModel.qml` component is a QtObject that stores the selection state of nodes, links, and containers in a scene. It provides a centralized way to manage the selection of objects, ensuring that the selection state is consistent across the application.

### Properties

* `selectedModel`: A map of selected objects, where each key is a unique identifier (UUID) and the value is the corresponding model object (Node, Link, or Container).
* `existObjects`: A list of UUIDs of all existing objects in the scene.
* `notifySelectedObject`: A boolean flag that indicates whether the `selectedObjectChanged` signal should be emitted when the selection changes.

### Signals

* `selectedObjectChanged()`: Emitted when the selection changes, indicating that the `selectedModel` property has been updated.

### Functions

* `checkSelectedObjects()`: Checks the selection state of all objects in the scene and updates the `selectedModel` property accordingly. This function is called when the `existObjects` property changes.
* `clear()`: Clears all objects from the selection model.
* `clearAllExcept(qsUuid: string)`: Clears all objects from the selection model except for the one with the specified UUID.
* `remove(qsUuid: string)`: Removes an object from the selection model.
* `selectNode(node: Node)`: Selects a node object and adds it to the selection model.
* `selectContainer(container: Container)`: Selects a container object and adds it to the selection model.
* `selectLink(link: Link)`: Selects a link object and adds it to the selection model.
* `isSelected(qsUuid: string): bool`: Checks whether an object with the specified UUID is selected.
* `lastSelectedObject(objType: int)`: Returns the last selected object of the specified type.
* `selectAll(nodes, links, containers)`: Selects all nodes, links, and containers in the scene.

### Example Usage in QML

```qml
import QtQuick 2.0
import NodeLink 1.0

Item {
    SelectionModel {
        id: selectionModel
    }

    Node {
        id: node1
        _qsUuid: "node1_uuid"
    }

    Node {
        id: node2
        _qsUuid: "node2_uuid"
    }

    // Select node1
    selectionModel.selectNode(node1)

    // Check if node1 is selected
    console.log(selectionModel.isSelected("node1_uuid")) // Output: true

    // Clear selection
    selectionModel.clear()

    // Select all nodes
    selectionModel.selectAll([node1, node2], [], [])
}
```

### Extension/Override Points

The `SelectionModel.qml` component can be extended or overridden by subclassing it and adding custom functionality. For example, you can add additional selection logic or integrate it with other components.

### Caveats or Assumptions

* The `SelectionModel.qml` component assumes that the `existObjects` property is updated whenever objects are added or removed from the scene.
* The component uses the `notifySelectedObject` flag to control whether the `selectedObjectChanged` signal is emitted. This flag should be set to `false` when updating the selection model programmatically to avoid unnecessary signal emissions.

### Related Components

* `Node.qml`: Represents a node object in the scene.
* `Link.qml`: Represents a link object in the scene.
* `Container.qml`: Represents a container object in the scene.

By using the `SelectionModel.qml` component, you can easily manage the selection of objects in your NodeLink-based application, ensuring a consistent and efficient selection mechanism.


## SelectionSpecificTool.qml
### Overview

The `SelectionSpecificTool` component is a QtObject that represents a selection tool button model. It provides a way to create a customizable button that can be used in a menu or toolbar to perform a specific action on a selected node.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `SelectionSpecificTool` fits into the View category. It is a UI component that displays a button and emits a signal when clicked. The button's visibility and behavior can be controlled through its properties.

### Component Description

The `SelectionSpecificTool` component is a simple QtObject that has a few properties and a signal. It does not have any visual representation on its own and is intended to be used as a model for a button in a menu or toolbar.

### Properties

* `name`: A string property that can be used for debugging purposes. It is optional and defaults to an empty string.
* `icon`: A string property that specifies the icon to be displayed on the button. The icon should be a font character from Font Awesome 6.
* `enable`: A boolean property that controls the visibility of the button. It is optional and defaults to `true`.
* `type`: An integer property that specifies the type of node or link that the tool applies to. It can take one of the following values:
	+ `NLSpec.SelectionSpecificToolType.Any`: The tool applies to any type of node or link.
	+ Other values are not specified in this documentation, but can be found in the `NLSpec` enum.

### Signals

* `clicked(node: I_Node)`: A signal that is emitted when the button is clicked. The signal includes the node that was clicked on.

### Functions

None.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Create a SelectionSpecificTool instance
SelectionSpecificTool {
    id: myTool
    name: "My Tool"
    icon: "\uF0A8" // Font Awesome 6 icon
    enable: true
    type: NLSpec.SelectionSpecificToolType.Any

    // Connect to the clicked signal
    onClicked: (node) => {
        console.log("My tool clicked on node:", node)
        // Perform action on node
    }
}
```

### Extension/Override Points

The `SelectionSpecificTool` component can be extended or overridden by creating a custom QML component that inherits from it. This allows developers to add custom properties, signals, or functions to the component.

### Caveats or Assumptions

* The `icon` property assumes that the Font Awesome 6 font is available in the application.
* The `type` property assumes that the `NLSpec` enum is defined and accessible.

### Related Components

* `I_Node`: The interface for nodes in the NodeLink architecture.
* `NLSpec`: The specification for NodeLink enums and constants.


## CommandStack.qml
### Overview

The `CommandStack` component is a QtObject that manages a stack of commands for undo and redo functionality. It is designed to work within the NodeLink MVC architecture.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `CommandStack` component serves as a central hub for managing commands that modify the model. It provides a way to record, undo, and redo changes made to the model.

### Component Description

The `CommandStack` component is a QtObject that provides the following features:

*   A stack of undo commands
*   A stack of redo commands
*   Methods for pushing, undoing, and redoing commands
*   Signals for notifying observers of changes to the command stacks

### Properties

The `CommandStack` component has the following properties:

*   `undoStack`: A list of commands that can be undone
*   `redoStack`: A list of commands that can be redone
*   `isValidUndo`: A boolean indicating whether there are commands in the undo stack
*   `isValidRedo`: A boolean indicating whether there are commands in the redo stack
*   `isReplaying`: A boolean indicating whether the command stack is currently replaying commands (i.e., executing undo or redo)

### Signals

The `CommandStack` component emits the following signals:

*   `stacksUpdated()`: Emitted when the undo or redo stacks change
*   `undoRedoDone()`: Emitted when an undo or redo operation is completed

### Functions

The `CommandStack` component provides the following functions:

*   `clearRedo()`: Clears the redo stack
*   `push(cmd, appliedAlready = true)`: Pushes a command onto the undo stack
*   `_finalizePending()`: Finalizes a batch of pending commands
*   `undo()`: Undoes the top command on the undo stack
*   `redo()`: Redoes the top command on the redo stack
*   `resetStacks()`: Resets both the undo and redo stacks

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Item {
    CommandStack {
        id: commandStack
    }

    // Create a command
    var myCommand = {
        undo: function() {
            console.log("Undoing command")
        },
        redo: function() {
            console.log("Redoing command")
        }
    }

    // Push the command onto the stack
    commandStack.push(myCommand)

    // Undo the command
    commandStack.undo()

    // Redo the command
    commandStack.redo()
}
```

### Extension/Override Points

The `CommandStack` component can be extended or overridden by creating a custom command stack component that inherits from `CommandStack`. This allows developers to add custom functionality or modify the existing behavior of the command stack.

### Caveats or Assumptions

The `CommandStack` component assumes that commands have `undo` and `redo` functions that can be called to perform the corresponding actions. It also assumes that commands are objects with `undo` and `redo` properties.

### Related Components

The `CommandStack` component is related to the following components:

*   `NodeLink.Model`: The model component that the command stack interacts with
*   `NodeLink.Controller`: The controller component that uses the command stack to manage changes to the model

## Command Object Structure

A command object should have the following structure:

```javascript
var command = {
    undo: function() {
        // Undo the command
    },
    redo: function() {
        // Redo the command
    }
}
```

This structure allows the command stack to call the `undo` and `redo` functions on the command object to perform the corresponding actions.


## HashCompareString.qml
### Overview

The `HashCompareString` QML component serves as a bridge between QML and the `HashCompareStringCPP` C++ class, facilitating the comparison of strings using hash functions. This singleton component is designed to work within the NodeLink Model-View-Controller (MVC) architecture.

### Architecture Integration

In the NodeLink MVC architecture, `HashCompareString` acts as a model component that provides a QML interface to the `HashCompareStringCPP` C++ class. This allows QML views to interact with the string comparison functionality without directly accessing C++ code.

### Component Description

The `HashCompareString` component is a singleton, meaning only one instance of it can exist throughout the application. It wraps the functionality of `HashCompareStringCPP`, making it accessible from QML.

### Properties

| Property Name | Type | Description |
| --- | --- | --- |
| None | - | This component does not expose any properties. |

### Signals

| Signal Name | Parameters | Description |
| --- | --- | --- |
| None | - | This component does not emit any signals. |

### Functions

| Function Name | Parameters | Return Type | Description |
| --- | --- | --- | --- |
| None | - | - | This component does not expose any functions. |

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Item {
    // Using the singleton instance
    HashCompareString {
        id: hashCompareString
    }
    
    // Example usage (assuming HashCompareStringCPP has a function compareStrings(string, string))
    // Note: Actual usage depends on the implementation of HashCompareStringCPP
    Component.onCompleted: {
        console.log("Comparing strings:", hashCompareString.compareStrings("Hello", "World"))
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `HashCompareString`, you can:

1. **Modify the C++ Backend**: Since `HashCompareString` is a wrapper around `HashCompareStringCPP`, modifications and extensions should be made at the C++ level. This involves altering the `HashCompareStringCPP` class to add new functionality or override existing behavior.

2. **Create a Subclass**: While not directly applicable due to the singleton nature and the fact that it's a QML wrapper, you can create similar components that wrap different C++ classes, providing a similar interface but with different implementations.

### Caveats or Assumptions

- **C++ Implementation**: The functionality of `HashCompareString` is entirely dependent on the implementation of `HashCompareStringCPP`. Any changes or assumptions about the behavior of string comparisons should be validated against the C++ code.

- **Singleton Pattern**: Being a singleton, `HashCompareString` should be used judiciously to avoid tight coupling between different parts of the application.

### Related Components

- `HashCompareStringCPP`: The C++ class that provides the actual string comparison functionality.
- Other NodeLink MVC components that might interact with or depend on string comparison operations.

This documentation provides a comprehensive overview of the `HashCompareString.qml` component, its role within the NodeLink architecture, and how to interact with it from QML.


## UndoContainerGuiObserver.qml
### Overview

The `UndoContainerGuiObserver` is a QML component that observes changes to the properties of a `ContainerGuiConfig` object and pushes undo commands onto a `CommandStack` when changes occur. This component is part of the NodeLink MVC architecture and plays a crucial role in enabling undo/redo functionality for GUI configurations.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `UndoContainerGuiObserver` acts as a controller component that listens to changes in the model (`ContainerGuiConfig`) and updates the command stack accordingly. This allows users to undo and redo changes made to the GUI configuration.

### Component Description

The `UndoContainerGuiObserver` is an `Item` component that observes changes to the following properties of the `ContainerGuiConfig` object:

* `position`
* `width`
* `height`
* `color`

When a change is detected, it pushes an undo command onto the `CommandStack`.

### Properties

* `guiConfig`: The `ContainerGuiConfig` object being observed.
* `undoStack`: The `CommandStack` where undo commands are pushed.
* `_cache`: An internal cache object used to store the previous values of the observed properties.

### Signals

None.

### Functions

* `_ensureCache()`: Ensures that the internal cache is initialized with the current values of the observed properties.
* `_positionsEqual(a, b)`: Compares two positions for equality, taking into account floating-point precision issues.
* `_copyPos(p)`: Creates a copy of a position object.
* `pushProp(key, oldV, newV, apply)`: Pushes an undo command onto the `CommandStack` for a change to a specific property.

### Example Usage in QML

```qml
import NodeLink 1.0

Item {
    id: root

    ContainerGuiConfig {
        id: guiConfig
        position: Qt.vector2d(10, 20)
        width: 100
        height: 50
        color: "red"
    }

    CommandStack {
        id: undoStack
    }

    UndoContainerGuiObserver {
        guiConfig: guiConfig
        undoStack: undoStack
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `UndoContainerGuiObserver`, you can:

* Create a custom component that inherits from `UndoContainerGuiObserver` and overrides specific functions or properties.
* Use a different command stack or modify the existing one to suit your needs.

### Caveats or Assumptions

* The `UndoContainerGuiObserver` assumes that the `ContainerGuiConfig` object has the necessary properties (e.g., `position`, `width`, `height`, `color`) and that they are bindable.
* The component uses a simple caching mechanism to store the previous values of the observed properties. This cache is not persisted across sessions.

### Related Components

* `ContainerGuiConfig`: The model object being observed.
* `CommandStack`: The command stack where undo commands are pushed.
* `NodeLink`: The overall framework that this component is part of.


## UndoContainerObserver.qml
### Overview

The `UndoContainerObserver` is a QML component that updates the `UndoStack` when properties of a `Container` change. It plays a crucial role in the NodeLink MVC architecture by providing a way to track and revert changes made to container properties.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `UndoContainerObserver` acts as an observer of the `Container` model. When a property of the `Container` changes, the observer creates a `PropertyCommand` and pushes it onto the `UndoStack`. This allows the application to maintain a history of changes and provide undo/redo functionality.

### Component Description

The `UndoContainerObserver` is an `Item` component that observes a `Container` and updates the `UndoStack` accordingly. It has two main properties: `container` and `undoStack`, which are used to track the container being observed and the undo stack being updated.

### Properties

* `container`: The `Container` being observed.
* `undoStack`: The `CommandStack` being updated.

### Signals

None.

### Functions

* `_ensureCache()`: Ensures that the internal cache is initialized with the current container properties.
* `pushProp(targetObj, key, oldV, newV)`: Creates a `PropertyCommand` and pushes it onto the `UndoStack` if the property change is significant.

### Example Usage in QML

```qml
import NodeLink 1.0

Item {
    UndoContainerObserver {
        id: observer
        container: myContainer
        undoStack: myUndoStack
    }

    Container {
        id: myContainer
        title: "My Container"
    }

    CommandStack {
        id: myUndoStack
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `UndoContainerObserver`, you can:

* Create a custom observer component that inherits from `UndoContainerObserver` and overrides its functions.
* Use the `Connections` component to connect to the `container` signals and implement custom logic.

### Caveats or Assumptions

* The `UndoContainerObserver` assumes that the `container` property is a valid `Container` object.
* The observer only tracks changes to the `title` property of the `Container`. Structural changes (e.g., nodes or containers inside) are handled by scene commands.

### Related Components

* `Container`: The model being observed.
* `CommandStack`: The stack being updated with property commands.
* `UndoContainerGuiObserver`: A related observer component that tracks GUI-related changes to the container.
* `PropertyCommand`: The command type used to represent property changes.


## UndoCore.qml
### Overview

The `UndoCore.qml` file provides the core functionality for managing undo and redo operations within the NodeLink MVC architecture. It acts as a central component that coordinates the interaction between the scene, undo/redo stacks, and observers.

### Architecture Integration

In the NodeLink MVC architecture, `UndoCore` plays a crucial role in the Model-View-Controller (MVC) pattern by providing a mechanism for tracking and reverting changes made to the scene. It integrates with the `I_Scene` interface, which represents the scene being managed, and utilizes command-based undo/redo stacks (`CommandStack`) to store and execute commands.

### Component Description

The `UndoCore` component is a `QtObject` that serves as a container for managing undo/redo functionality. It has the following key responsibilities:

*   Hosting the undo/redo stacks (`CommandStack`)
*   Providing an observer (`UndoSceneObserver`) for monitoring scene changes
*   Ensuring integration with the scene (`I_Scene`)

### Properties

The `UndoCore` component has the following properties:

*   `scene`: A required property of type `I_Scene` that represents the scene being managed. **Note:** The type is specified as `I_Scene` to avoid application crashes when using the `Scene` type directly.
*   `undoStack`: A property of type `CommandStack` that represents the undo stack. It is initialized with a default `CommandStack` instance.
*   `undoSceneObserver`: A property of type `UndoSceneObserver` that observes scene changes and interacts with the undo stack.

### Signals

The `UndoCore` component does not emit any signals directly. However, the `undoSceneObserver` property may emit signals related to scene changes.

### Functions

The `UndoCore` component does not provide any functions beyond those inherited from `QtObject`.

### Example Usage in QML

To use the `UndoCore` component in a QML file, you can create an instance and bind its `scene` property to your scene instance:

```qml
import QtQuick
import NodeLink

// Assuming you have a scene instance
I_Scene {
    id: myScene
    // Other properties and children
}

// Create an UndoCore instance
UndoCore {
    id: undoCore
    scene: myScene
}
```

### Extension/Override Points

To extend or customize the behavior of `UndoCore`, you can:

*   Subclass `UndoCore` and override its properties or behavior.
*   Provide a custom `CommandStack` instance to modify the undo/redo stack behavior.
*   Implement a custom `UndoSceneObserver` to handle scene changes differently.

### Caveats or Assumptions

*   The `scene` property must be set to an instance of `I_Scene` to avoid application crashes.
*   The `undoStack` property is initialized with a default `CommandStack` instance, which can be replaced with a custom instance.

### Related Components

The following components are related to `UndoCore`:

*   `I_Scene`: The interface representing the scene being managed.
*   `CommandStack`: The component providing the undo/redo stack functionality.
*   `UndoSceneObserver`: The observer component monitoring scene changes and interacting with the undo stack.


## UndoLinkGuiObserver.qml
### Overview

The `UndoLinkGuiObserver` is a QML component that observes changes to the properties of a `LinkGUIConfig` object and pushes undo commands onto a `CommandStack` when changes occur. This allows for easy implementation of undo/redo functionality in a NodeLink-based application.

### Architecture

The `UndoLinkGuiObserver` fits into the NodeLink MVC architecture as a supporting component that works closely with the `LinkGUIConfig` model and the `CommandStack` controller. It observes changes to the `LinkGUIConfig` properties and pushes undo commands onto the `CommandStack`, which can then be used to undo and redo changes.

### Component Description

The `UndoLinkGuiObserver` is an `Item` component that has the following properties:

* `guiConfig`: The `LinkGUIConfig` object being observed.
* `undoStack`: The `CommandStack` onto which undo commands are pushed.

The component uses a cache to store the previous values of the `LinkGUIConfig` properties, allowing it to compute the old and new values of each property when a change occurs.

### Properties

* `guiConfig`: The `LinkGUIConfig` object being observed. (required)
* `undoStack`: The `CommandStack` onto which undo commands are pushed. (required)
* `_cache`: An internal cache used to store the previous values of the `LinkGUIConfig` properties.

### Signals

None.

### Functions

* `_ensureCache()`: Ensures that the cache is initialized with the current values of the `LinkGUIConfig` properties.
* `_positionsEqual(a, b)`: Compares two positions (objects with `x` and `y` properties) for equality.
* `_copyPos(p)`: Creates a copy of a position object.
* `pushProp(key, oldV, newV, apply)`: Pushes an undo command onto the `CommandStack` for a change to a `LinkGUIConfig` property.

### Example Usage in QML

```qml
import NodeLink 1.0

Item {
    LinkGUIConfig {
        id: guiConfig
    }

    CommandStack {
        id: undoStack
    }

    UndoLinkGuiObserver {
        guiConfig: guiConfig
        undoStack: undoStack
    }
}
```

### Extension/Override Points

The `UndoLinkGuiObserver` can be extended or overridden by creating a custom component that inherits from `UndoLinkGuiObserver` and overrides one or more of its functions.

### Caveats or Assumptions

* The `UndoLinkGuiObserver` assumes that the `LinkGUIConfig` object has properties that can be observed (e.g. `description`, `color`, etc.).
* The `UndoLinkGuiObserver` assumes that the `CommandStack` has a `push` function that can be used to add undo commands.

### Related Components

* `LinkGUIConfig`: The model object being observed by the `UndoLinkGuiObserver`.
* `CommandStack`: The controller that manages the undo/redo stack.
* `NodeLink`: The overall framework that this component is a part of.


## UndoLinkObserver.qml
### Overview

The `UndoLinkObserver` is a QML component that updates the `UndoStack` when properties of a `Link` change. It plays a crucial role in the NodeLink MVC architecture by providing undo and redo functionality for link property changes.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `UndoLinkObserver` acts as an observer of the `Link` model. When a `Link` property changes, the observer notifies the `UndoStack`, which stores the changes as commands. These commands can then be used to undo or redo the changes.

### Component Description

The `UndoLinkObserver` is an `Item` component that:

* Observes a `Link` object and its properties
* Updates the `UndoStack` when a `Link` property changes
* Provides a cache to store the previous values of `Link` properties

### Properties

* `link`: The `Link` object being observed
* `undoStack`: The `CommandStack` used to store undo and redo commands
* `_cache`: An internal cache to store the previous values of `Link` properties

### Signals

None

### Functions

* `_ensureCache()`: Ensures that the cache is initialized with the current values of `Link` properties
* `pushProp(targetObj, key, oldV, newV)`: Pushes a command to the `UndoStack` to update a property of the `Link` object

### Example Usage in QML

```qml
import NodeLink

// Create a Link object
Link {
    id: myLink
    title: "My Link"
    type: "input"
}

// Create an UndoStack
CommandStack {
    id: myUndoStack
}

// Create an UndoLinkObserver
UndoLinkObserver {
    link: myLink
    undoStack: myUndoStack
}
```

### Extension/Override Points

To extend or override the behavior of the `UndoLinkObserver`, you can:

* Create a custom observer component that inherits from `UndoLinkObserver`
* Override the `pushProp` function to customize the command creation process
* Add additional observers to handle other types of changes

### Caveats or Assumptions

* The `UndoLinkObserver` assumes that the `Link` object has `title` and `type` properties
* The observer only handles changes to `title` and `type` properties; other properties may require additional observers
* The `UndoStack` must be properly configured to handle the commands pushed by the observer

### Related Components

* `Link`: The model object being observed
* `CommandStack`: The stack that stores undo and redo commands
* `UndoLinkGuiObserver`: A related observer that handles GUI-related changes to the `Link` object


## UndoNodeGuiObserver.qml
### Overview

The `UndoNodeGuiObserver` is a QML component that observes changes to a `NodeGuiConfig` object's properties and pushes undo commands onto a `CommandStack` when changes occur. This component is part of the NodeLink MVC architecture and plays a crucial role in enabling undo/redo functionality for NodeGuiConfig properties.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `UndoNodeGuiObserver` acts as a controller component that listens to changes in the `NodeGuiConfig` model and updates the `CommandStack` accordingly. This allows users to undo and redo changes made to NodeGuiConfig properties.

### Component Description

The `UndoNodeGuiObserver` is an `Item` component that observes changes to a `NodeGuiConfig` object's properties and pushes undo commands onto a `CommandStack`. It uses a cache to store the previous values of the properties and compares them with the new values to determine if an undo command should be pushed.

### Properties

* `guiConfig`: The `NodeGuiConfig` object being observed.
* `undoStack`: The `CommandStack` where undo commands are pushed.
* `_cache`: An internal cache object that stores the previous values of the `NodeGuiConfig` properties.

### Signals

None.

### Functions

* `_ensureCache()`: Ensures that the cache is initialized with the current values of the `NodeGuiConfig` properties.
* `_positionsEqual(a, b)`: Compares two `QVector2D` objects for equality.
* `_copyPos(p)`: Creates a copy of a `QVector2D` object.
* `pushProp(key, oldV, newV, apply)`: Pushes an undo command onto the `CommandStack` if the value of a property has changed.

### Example Usage in QML

```qml
import NodeLink 1.0

Item {
    NodeGuiConfig {
        id: nodeConfig
    }

    CommandStack {
        id: commandStack
    }

    UndoNodeGuiObserver {
        guiConfig: nodeConfig
        undoStack: commandStack
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `UndoNodeGuiObserver`, you can:

* Create a custom component that inherits from `UndoNodeGuiObserver` and overrides its functions.
* Use a different cache implementation by replacing the `_cache` property.
* Modify the `pushProp` function to handle custom properties or undo command logic.

### Caveats or Assumptions

* The `UndoNodeGuiObserver` assumes that the `NodeGuiConfig` object has properties that can be observed (e.g., `position`, `width`, `height`, etc.).
* The `UndoNodeGuiObserver` uses a simple cache implementation that stores the previous values of the properties. This cache is not persisted across sessions.

### Related Components

* `NodeGuiConfig`: The model object being observed by the `UndoNodeGuiObserver`.
* `CommandStack`: The stack where undo commands are pushed by the `UndoNodeGuiObserver`.
* `NodeLink`: The overall framework that includes the `UndoNodeGuiObserver` and other related components.


## UndoNodeObserver.qml
### Overview

The `UndoNodeObserver` is a QML component that plays a crucial role in the NodeLink MVC architecture by updating the `UndoStack` when properties of a `Node` change. This allows for efficient undo and redo functionality within the application.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `UndoNodeObserver` acts as a bridge between the Model (`Node`) and the Controller (`CommandStack` or `UndoStack`). It observes changes to a `Node`'s properties and pushes corresponding commands onto the `UndoStack`, enabling the tracking of changes for undo and redo operations.

### Component Description

The `UndoNodeObserver` component is designed to be used in conjunction with a `Node` and an `UndoStack`. It listens for changes to the `Node`'s properties (currently `title` and `type`) and creates commands to push onto the `UndoStack` to record these changes.

### Properties

*   **`node`**: The `Node` object being observed for property changes.
*   **`undoStack`**: The `CommandStack` or `UndoStack` where commands are pushed to record changes.
*   **`_cache`**: An internal property used to cache the initial state of the `Node`'s properties.

### Signals

The `UndoNodeObserver` component does not emit any signals directly. However, it reacts to signals emitted by the `Node` object it observes.

### Functions

*   **`_ensureCache()`**: Ensures that the internal cache (`_cache`) is initialized with the current state of the `Node`'s properties. This is called when the component is completed and when properties change.
*   **`pushProp(targetObj, key, oldV, newV)`**: Creates a command to change a property of `targetObj` and pushes it onto the `undoStack`. The command has `undo` and `redo` functions to set the property to `oldV` and `newV`, respectively.

### Example Usage in QML

```qml
import NodeLink 1.0

Item {
    Node {
        id: myNode
        title: "My Node"
        type: "example"
    }

    UndoStack {
        id: myUndoStack
    }

    UndoNodeObserver {
        node: myNode
        undoStack: myUndoStack
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `UndoNodeObserver`, you can:

*   Add observers for additional `Node` properties by following the pattern established with `title` and `type` property change handlers.
*   Modify the command creation process in `pushProp` to suit specific requirements, such as adding more complex logic for certain property types.

### Caveats or Assumptions

*   This component assumes that the `Node` object has `title` and `type` properties, and that these properties are relevant for undo/redo operations.
*   The component uses a simple caching mechanism (`_cache`) to store the initial state of `Node` properties. This might need to be adjusted or expanded for more complex property types or scenarios.

### Related Components

*   `Node`: The model object being observed for changes.
*   `UndoStack`: The controller component managing the stack of undo/redo commands.
*   `UndoNodeGuiObserver`: Another observer component that handles GUI-related aspects of undo/redo for `Node` instances.


## UndoSceneObserver.qml
### Overview

The `UndoSceneObserver` is a QML component that plays a crucial role in integrating the scene model with the command stack, enabling undo functionality within the NodeLink MVC architecture. It acts as an observer, monitoring changes to the scene model and updating the command stack accordingly.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `UndoSceneObserver` serves as a bridge between the Model (scene) and the Controller (command stack). It ensures that any changes to the scene model are properly recorded and can be undone or redone through the command stack.

### Component Description

The `UndoSceneObserver` component is an `Item` that requires two properties:

* `scene`: An instance of `I_Scene`, representing the scene model.
* `undoStack`: An instance of `CommandStack`, representing the command stack.

### Properties

| Property | Type | Description | Required |
| --- | --- | --- | --- |
| `scene` | `I_Scene` | The scene model being observed. | Yes |
| `undoStack` | `CommandStack` | The command stack for undo/redo functionality. | Yes |

### Signals

None.

### Functions

None.

### Child Components

The `UndoSceneObserver` component contains three `Repeater` components, each responsible for observing a different aspect of the scene model:

* `UndoNodeObserver`: Observes changes to nodes within the scene.
* `UndoLinkObserver`: Observes changes to links within the scene.
* `UndoContainerObserver`: Observes changes to containers within the scene.

### Example Usage in QML

```qml
import NodeLink

// Assuming you have a scene model and a command stack
Item {
    property I_Scene myScene
    property CommandStack myUndoStack

    UndoSceneObserver {
        scene: myScene
        undoStack: myUndoStack
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `UndoSceneObserver`, you can:

* Create custom observer components (e.g., `UndoNodeObserver`, `UndoLinkObserver`, `UndoContainerObserver`) to handle specific types of scene model changes.
* Modify the `Repeater` components to filter or transform the scene model data before passing it to the observer components.

### Caveats or Assumptions

* The `UndoSceneObserver` assumes that the scene model and command stack are properly initialized and configured.
* The component relies on the `I_Scene` and `CommandStack` interfaces being correctly implemented.

### Related Components

* `I_Scene`: The scene model interface.
* `CommandStack`: The command stack interface.
* `UndoNodeObserver`, `UndoLinkObserver`, `UndoContainerObserver`: Observer components for nodes, links, and containers, respectively.


## UndoStack.qml
### Overview

The `UndoStack` component is responsible for managing undo and redo operations in the NodeLink MVC architecture. It maintains two stacks, one for undo and one for redo, and provides functions for updating, undoing, and redoing actions.

### Architecture

The `UndoStack` component fits into the NodeLink MVC architecture as a supporting component that works closely with the `I_Scene` interface. It uses the `sceneActiveRepo` property to interact with the scene's repository.

### Component Description

The `UndoStack` component is a QtObject that provides the following properties and functions:

### Properties

* `scene`: The target scene, required.
* `isValidRedo`: A boolean indicating whether a redo operation is valid.
* `isValidUndo`: A boolean indicating whether an undo operation is valid.
* `undoStack`: The undo stack, an array of scene models.
* `redoStack`: The redo stack, an array of scene models.
* `sceneActiveRepo`: The active repository of the scene, defaults to `NLCore.defaultRepo`.
* `undoMax`: The maximum size of the undo stack, defaults to 6.

### Signals

* `stacksUpdated()`: Emitted when the undo and redo stacks are updated.
* `undoRedoDone()`: Emitted when an undo or redo operation is completed.
* `updateUndoStack()`: Emitted when the undo stack needs to be updated.

### Functions

* `updateStacks()`: Updates the undo and redo stacks based on the current scene model.
* `redo()`: Performs a redo operation.
* `undo()`: Performs an undo operation.
* `dumpRepo(scene: I_Scene)`: Dumps the scene's repository to a string.
* `setSceneObject(sceneString: string)`: Sets the scene model from a string.
* `resetStacks()`: Resets the undo and redo stacks.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Item {
    UndoStack {
        id: undoStack
        scene: myScene
    }

    // Perform an undo operation
    function undo() {
        undoStack.undo();
    }

    // Perform a redo operation
    function redo() {
        undoStack.redo();
    }
}
```

### Extension/Override Points

The `UndoStack` component provides several points for extension or override:

* `dumpRepo(scene: I_Scene)`: Can be overridden to provide a custom way of dumping the scene's repository.
* `setSceneObject(sceneString: string)`: Can be overridden to provide a custom way of setting the scene model from a string.

### Caveats or Assumptions

* The `UndoStack` component assumes that the `scene` property is set to a valid `I_Scene` object.
* The `UndoStack` component uses a timer to update the stacks, which may not be suitable for all use cases.

### Related Components

* `I_Scene`: The interface for scenes that interact with the `UndoStack` component.
* `NLCore`: The core module that provides the `defaultRepo` property used by the `UndoStack` component.


## AddContainerCommand.qml
### Overview

The `AddContainerCommand` is a QtObject that represents a command to add a container to a scene in the NodeLink MVC architecture. It provides a way to encapsulate the addition of a container as a command that can be executed, undone, and redone.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `AddContainerCommand` serves as a command object that interacts with the `I_Scene` interface and a `Container` object. It is typically used in conjunction with a `CommandHistory` to manage the execution, undoing, and redoing of commands.

### Component Description

The `AddContainerCommand` QtObject has the following properties and functions:

#### Properties

* `scene`: The scene to which the container will be added. This property must be set to an object that implements the `I_Scene` interface.
* `container`: The container to be added to the scene.

#### Signals

None

#### Functions

* `redo()`: Executes the command to add the container to the scene.
* `undo()`: Reverts the command to remove the container from the scene.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Create a scene that implements I_Scene
I_Scene {
    id: myScene
}

// Create a container
Container {
    id: myContainer
}

// Create an AddContainerCommand
AddContainerCommand {
    id: addCommand
    scene: myScene
    container: myContainer
}

// Execute the command
addCommand.redo()

// Undo the command
addCommand.undo()
```

### Extension/Override Points

To extend or override the behavior of `AddContainerCommand`, you can:

* Create a subclass of `AddContainerCommand` and override the `redo()` and `undo()` functions to provide custom behavior.
* Provide a custom implementation of the `I_Scene` interface to change how containers are added and removed.

### Caveats or Assumptions

* The `AddContainerCommand` assumes that the `scene` property is set to an object that implements the `I_Scene` interface.
* The `AddContainerCommand` assumes that the `container` property is set to a valid `Container` object.

### Related Components

* `I_Scene`: The interface that defines the scene to which containers are added.
* `Container`: The object that represents the container to be added to the scene.
* `CommandHistory`: The component that manages the execution, undoing, and redoing of commands.


## AddNodeCommand.qml
### Overview

The `AddNodeCommand` QML component is a concrete implementation of the Command pattern, specifically designed to add a node to a scene within the NodeLink MVC architecture. This component is essential for managing changes in the scene graph, allowing for easy undo and redo functionality.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `AddNodeCommand` serves as a Controller component. It encapsulates the logic required to add a node to the scene model and provides a way to reverse this action (undo). This fits into the broader architecture by enabling the management of scene state changes in a structured and reversible manner.

### Component Description

The `AddNodeCommand` component is a `QtObject` that holds references to a `scene` and a `node`. It provides `redo` and `undo` functions to add and remove the specified node from the scene, respectively.

### Properties

* **scene**: A reference to the scene (`I_Scene`) where the node will be added or removed. This property is essential for executing the add and delete operations.
* **node**: The node (`Node`) that will be added to or removed from the scene. This property directly references the node affected by the command.

### Signals

This component does not emit any signals.

### Functions

* **redo()**: Adds the specified `node` to the `scene`. This method modifies the scene by including the node if both `scene` and `node` properties are valid.
* **undo()**: Removes the specified `node` from the `scene` using its unique identifier (`_qsUuid`). This method reverts the addition of the node to the scene.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Assuming you have a scene and a node defined
Item {
    id: root
    property var myScene: // Initialize your scene here
    property var myNode: // Initialize your node here

    Component.onCompleted: {
        var addCommand = Qt.createQmlObject('import NodeLink; AddNodeCommand { scene: root.myScene; node: root.myNode }', root, "AddNodeCommand");
        addCommand.redo(); // Adds the node to the scene
        addCommand.undo(); // Removes the node from the scene
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `AddNodeCommand`, you could:
- Subclass `AddNodeCommand` and override the `redo` and `undo` functions to add custom logic before or after adding/removing a node.
- Implement additional validation or actions in the `redo` and `undo` functions based on specific requirements.

### Caveats or Assumptions

- This component assumes that the `scene` property implements the `I_Scene` interface and provides `addNode` and `deleteNode` functions.
- It assumes that the `node` property has a `_qsUuid` property for identification.

### Related Components

- `I_Scene`: The interface that a scene must implement to work with `AddNodeCommand`.
- `Node`: The type of object that represents a node in the scene.
- Other command classes (e.g., `DeleteNodeCommand`, `MoveNodeCommand`): These classes, similar to `AddNodeCommand`, provide a comprehensive command management system for the scene.


## CreateLinkCommand.qml
### Overview

The `CreateLinkCommand` is a QtObject that represents a command to create a link between two nodes in the NodeLink MVC architecture. It provides a way to encapsulate the creation and deletion of links, making it easier to manage the history of changes in a scene.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `CreateLinkCommand` serves as a command object that interacts with the `I_Scene` interface. It is responsible for creating and deleting links between nodes, and it notifies the scene about these changes.

### Component Description

The `CreateLinkCommand` is a QtObject that has the following properties:

* `scene`: The scene in which the link will be created. It must implement the `I_Scene` interface.
* `inputPortUuid`: The UUID of the input port of the link.
* `outputPortUuid`: The UUID of the output port of the link.
* `createdLink`: The link that was created, set after the `redo` function is called.

### Properties

| Property | Type | Description |
| --- | --- | --- |
| scene | var | The scene in which the link will be created. |
| inputPortUuid | string | The UUID of the input port of the link. |
| outputPortUuid | string | The UUID of the output port of the link. |
| createdLink | var | The link that was created, set after the `redo` function is called. |

### Signals

None.

### Functions

#### redo()

The `redo` function creates a link between the input and output ports in the scene. It checks if the scene, input port UUID, and output port UUID are valid before creating the link.

#### undo()

The `undo` function deletes the link between the input and output ports in the scene. It checks if the scene, input port UUID, and output port UUID are valid before deleting the link.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Item {
    id: root

    // Create a scene
    Scene {
        id: scene
    }

    // Create a CreateLinkCommand
    CreateLinkCommand {
        id: createLinkCommand
        scene: scene
        inputPortUuid: "inputPortUuid"
        outputPortUuid: "outputPortUuid"
    }

    // Create a link
    Button {
        text: "Create Link"
        onClicked: createLinkCommand.redo()
    }

    // Undo the link creation
    Button {
        text: "Undo"
        onClicked: createLinkCommand.undo()
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `CreateLinkCommand`, you can:

* Create a subclass of `CreateLinkCommand` and override the `redo` and `undo` functions.
* Provide a custom implementation of the `I_Scene` interface to change how the command interacts with the scene.

### Caveats or Assumptions

* The `CreateLinkCommand` assumes that the scene implements the `I_Scene` interface.
* The `CreateLinkCommand` does not handle cases where the input or output port UUIDs are invalid.

### Related Components

* `I_Scene`: The interface that the scene must implement to interact with the `CreateLinkCommand`.
* `Link`: The class that represents a link between two nodes in the scene.
* `Scene`: The class that represents a scene in the NodeLink MVC architecture.


## PropertyCommand.qml
### Overview

The `PropertyCommand` QML component is a fundamental building block in the NodeLink MVC architecture, designed to manage property changes on target objects. It encapsulates the logic for setting, undoing, and redoing property modifications, making it an essential part of the application's command history and undo/redo functionality.

### Architecture Integration

In the NodeLink MVC architecture, `PropertyCommand` serves as a command object that encapsulates a specific property change on a model object. It acts as a bridge between the Model and Controller components, allowing for easy tracking and reversal of changes made to the model's properties.

### Component Description

`PropertyCommand` is a QtObject that represents a single command to change a property on a target object. It maintains references to the target object, the property key, and the old and new values of the property. Optionally, a custom applier function can be provided to handle complex property setting logic.

### Properties

* **target**: The object on which the property change will be applied.
* **key**: The name of the property to be modified.
* **oldValue**: The original value of the property before the change.
* **newValue**: The new value of the property after the change.
* **apply**: An optional custom function that takes two arguments, `target` and `value`, to apply the property change. If not provided, the property change is applied directly using `target[key] = value`.

### Signals

None.

### Functions

* **setProp(value)**: Sets the property on the target object to the specified `value`. If a custom applier function is provided, it is called with `target` and `value` as arguments; otherwise, the property is set directly.
* **undo()**: Reverts the property change by calling `setProp(oldValue)`.
* **redo()**: Applies the property change by calling `setProp(newValue)`.

### Example Usage in QML

```qml
import QtQuick 2.0

Item {
    id: root
    property int myProperty: 0

    PropertyCommand {
        id: command
        target: root
        key: "myProperty"
        oldValue: 0
        newValue: 10
    }

    Component.onCompleted: {
        console.log(myProperty) // prints 0
        command.setProp(5)
        console.log(myProperty) // prints 5
        command.undo()
        console.log(myProperty) // prints 0
        command.redo()
        console.log(myProperty) // prints 10
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `PropertyCommand`, you can:

* Provide a custom applier function using the `apply` property.
* Subclass `PropertyCommand` to create specialized command objects for specific use cases.

### Caveats or Assumptions

* The target object must have a property with the same name as the `key` property.
* If a custom applier function is provided, it must handle the property change logic correctly.

### Related Components

* `NodeLinkModel`: The model component that uses `PropertyCommand` to manage property changes.
* `CommandHistory`: The component responsible for managing the command history and undo/redo functionality.


## RemoveContainerCommand.qml
### Overview

The `RemoveContainerCommand` is a QtObject designed to manage the removal and restoration of a container within a scene in the context of the NodeLink MVC architecture. It encapsulates the logic for deleting a container from a scene and provides methods to redo and undo this action.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `RemoveContainerCommand` serves as a command object that can be used to manage changes to the model (in this case, the scene and its containers). It acts as a bridge between the controller (which initiates actions) and the model (which manages the data and state), allowing for easy implementation of undo/redo functionality.

### Component Description

The `RemoveContainerCommand` QtObject has the following key characteristics:

- It holds references to the `scene` and the `container` it operates on.
- It provides `redo` and `undo` functions to execute and reverse the removal of the container.

### Properties

| Property  | Type | Description                                                                 |
|-----------|------|-----------------------------------------------------------------------------|
| `scene`   | `var` | A reference to the scene (`I_Scene`) where the container will be removed.   |
| `container`| `var` | The container (`Container`) to be removed from the scene.                   |

### Signals

None.

### Functions

#### redo()

- **Description**: Deletes the specified container from the scene.
- **Parameters**: None.
- **Returns**: None.

#### undo()

- **Description**: Adds the previously deleted container back to the scene.
- **Parameters**: None.
- **Returns**: None.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

// Assuming you have a scene and a container
Item {
    NodeLinkScene {
        id: myScene
    }

    // Create a RemoveContainerCommand
    RemoveContainerCommand {
        id: removeCommand
        scene: myScene
        container: myScene.getContainer("containerId")
    }

    // To remove the container
    Button {
        text: "Remove Container"
        onClicked: removeCommand.redo()
    }

    // To undo the removal
    Button {
        text: "Undo Removal"
        onClicked: removeCommand.undo()
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `RemoveContainerCommand`, you could:

- Override the `redo` and `undo` functions to add additional logic or error handling.
- Add more properties to store custom data related to the removal and restoration process.

### Caveats or Assumptions

- It is assumed that the `scene` and `container` properties are properly set before calling `redo` or `undo`.
- The command does not handle cases where the container does not exist in the scene or where the scene is null.

### Related Components

- `NodeLinkScene`: The scene object that manages containers and provides methods to add and delete containers.
- `Container`: The container object that represents a node within the scene.
- Other command objects (e.g., `AddContainerCommand`) that work in conjunction with `RemoveContainerCommand` to manage changes to the scene.


## RemoveNodeCommand.qml
### Overview
The `RemoveNodeCommand` is a QtObject designed to manage the removal and restoration of nodes within a scene in the NodeLink MVC architecture. It encapsulates the logic for deleting a node and its associated links, as well as undoing these actions to restore the node and its connections.

### NodeLink MVC Architecture Fit
In the NodeLink MVC (Model-View-Controller) architecture, `RemoveNodeCommand` serves as a command object that can be used to execute or undo changes to the model (in this case, the scene and its nodes). It interacts with the `I_Scene` interface to perform node deletion and addition, and it maintains a reference to the affected `Node` and its associated links.

### Component Description
The `RemoveNodeCommand` QtObject has the following key features:
- It holds references to the scene and the node to be removed.
- It stores information about links connected to the node before its removal.
- It provides `redo` and `undo` functions to execute and reverse the removal of the node.

### Properties
| Property | Type | Description |
| --- | --- | --- |
| `scene` | `var` | Reference to the scene (`I_Scene`) where the node exists. |
| `node` | `var` | Reference to the node (`Node`) to be removed. |
| `links` | `var` | A list of objects containing `inputPortUuid` and `outputPortUuid` to restore connections. |

### Signals
None.

### Functions
#### redo()
Deletes the specified node from the scene.

- **Description**: When called, this function removes the node from the scene if both `scene` and `node` are valid.
- **Parameters**: None.
- **Returns**: None.

#### undo()
Adds the removed node back to the scene and restores its connections.

- **Description**: This function adds the node back to the scene and recreates links that were connected to it before its removal.
- **Parameters**: None.
- **Returns**: None.

### Example Usage in QML
```qml
import QtQuick
import NodeLink

// Assuming you have a scene and a node
NodeLink.I_Scene {
    id: myScene
}

NodeLink.Node {
    id: myNode
    scene: myScene
}

// Create RemoveNodeCommand instance
RemoveNodeCommand {
    id: removeCommand
    scene: myScene
    node: myNode
    links: [{inputPortUuid: myNode.inputPorts[0].uuid, outputPortUuid: myNode.outputPorts[0].uuid}]
}

// To remove the node
removeCommand.redo()

// To undo and add the node back
removeCommand.undo()
```

### Extension/Override Points
To extend or customize the behavior of `RemoveNodeCommand`, you could:
- Override the `redo` and `undo` functions to add custom logic before or after node removal and restoration.
- Add additional properties or functions to handle more complex node relationships or scene interactions.

### Caveats or Assumptions
- This command assumes that the node to be removed and its links are properly set before executing `redo` or `undo`.
- It is the user's responsibility to ensure that the scene and node references are valid and that the links list accurately reflects the connections to be restored.

### Related Components
- `I_Scene`: The interface for scenes where nodes are managed.
- `Node`: Represents a node within a scene.
- Other command objects (e.g., `AddNodeCommand`, `CreateLinkCommand`) for comprehensive scene management.


## UnlinkCommand.qml
### Overview

The `UnlinkCommand` QML component is a part of the NodeLink framework, designed to encapsulate the logic for unlinking two nodes within a scene. It adheres to the Command pattern, allowing for the action of unlinking nodes to be executed and then undone.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `UnlinkCommand` serves as a Controller component. It acts as an intermediary between the Model (`I_Scene`) and the View, encapsulating the business logic required to unlink nodes. This component is pivotal in managing the state changes within the scene, specifically when nodes are to be disconnected.

### Component Description

The `UnlinkCommand` component is a `QtObject` that encapsulates the functionality to unlink two nodes, identified by their input and output port UUIDs, within a given scene. It maintains references to the scene and the UUIDs of the input and output ports involved in the unlinking process.

### Properties

* **scene**: A reference to the scene (`I_Scene`) where the unlinking operation takes place. This property is essential for executing the unlink command.
* **inputPortUuid**: The UUID of the input port of the node to be unlinked.
* **outputPortUuid**: The UUID of the output port of the node to be unlinked.

### Signals

This component does not emit any signals.

### Functions

* **redo()**: Executes the unlink command. It checks if the scene and both port UUIDs are valid, then calls `scene.unlinkNodes(inputPortUuid, outputPortUuid)` to perform the unlinking.
* **undo()**: Reverses the unlink command. It checks if the scene and both port UUIDs are valid, then calls `scene.createLink(inputPortUuid, outputPortUuid)` to recreate the link between the nodes.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Item {
    id: root

    // Assuming scene is an I_Scene instance
    property var scene: // initialize your scene here

    UnlinkCommand {
        id: unlinkCmd
        scene: root.scene
        inputPortUuid: "input-port-uuid"
        outputPortUuid: "output-port-uuid"
    }

    // To unlink nodes
    function unlinkNodes() {
        unlinkCmd.redo()
    }

    // To undo unlinking
    function undoUnlink() {
        unlinkCmd.undo()
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `UnlinkCommand`, you can:
- Subclass `UnlinkCommand` and override the `redo()` and `undo()` functions to add custom logic before or after unlinking/relinking nodes.
- Provide a custom implementation of `I_Scene` to change how nodes are unlinked and linked.

### Caveats or Assumptions

- This component assumes that the scene (`I_Scene`) and the port UUIDs are correctly set before executing the `redo()` or `undo()` functions.
- It is the responsibility of the scene implementation to manage the actual unlinking and linking of nodes, including any necessary validation.

### Related Components

- `I_Scene`: The interface for scenes where nodes are managed.
- `LinkCommand`: A command to create links between nodes (if available in the framework).
- Other command classes (e.g., `DeleteNodeCommand`, `CreateNodeCommand`) for comprehensive node and link management within the NodeLink framework.


## ContainerOverview.qml
### Overview

The `ContainerOverview.qml` file provides a QML component for displaying a container's overview in a NodeLink scene. This component is part of the NodeLink MVC architecture and plays a crucial role in visualizing container nodes in an overview.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `ContainerOverview.qml` serves as a view component. It is responsible for rendering the visual representation of a container node in the overview. The model provides the data (e.g., node properties), and this component uses that data to display the container's overview. The controller would handle interactions and updates to the model.

### Component Description

The `ContainerOverview` component is a specialized `ContainerView` that displays a container node in an overview. It takes into account the node's properties, such as position, size, and selection state, to render the overview accurately.

### Properties

* **`isSelected`**: A boolean property indicating whether the container node is currently selected. This property is automatically updated based on the scene's selection model.
* **`nodeRectTopLeft`**: A `vector2d` property representing the top-left position of the node's rectangle. This is used for calculating the position of the overview.
* **`overviewScaleFactor`**: A real property representing the scale factor used for mapping the scene to the overview.

### Object Properties

The component's visual properties are dynamically calculated based on the node's GUI configuration and the overview scale factor:

* **`x`**: The x-coordinate of the component, calculated based on the node's position and the overview scale factor.
* **`y`**: The y-coordinate of the component, calculated based on the node's position and the overview scale factor.
* **`width`**: The width of the component, scaled based on the node's width and the overview scale factor.
* **`height`**: The height of the component, scaled based on the node's height and the overview scale factor.
* **`border.color`**: The color of the border, which changes based on the node's locked state and selection state.
* **`border.width`**: The width of the border, which increases when the node is selected.
* **`opacity`**: The opacity of the component, which decreases when the node is not selected.
* **`radius`**: The corner radius of the component, scaled based on the node's view style and the overview scale factor.
* **`isNodeMinimal`**: A boolean property set to `true`, indicating that this is a minimal node view.

### Signals

This component does not emit any custom signals.

### Functions

This component does not have any custom functions.

### Example Usage in QML

```qml
import NodeLink

// Assuming you have a NodeLink scene set up
NodeLinkScene {
    id: scene

    // Create a container node
    ContainerNode {
        id: containerNode
        guiConfig: NodeGuiConfig {
            position: Qt.point(100, 100)
            width: 200
            height: 100
            color: "blue"
        }
    }

    // Use the ContainerOverview component
    ContainerOverview {
        node: containerNode
        scene: scene
        viewProperties: ViewProperties {
            nodeRectTopLeft: Qt.point(0, 0)
            overviewScaleFactor: 0.5
        }
    }
}
```

### Extension/Override Points

To extend or customize the behavior of this component, you can:

* Override the visual properties (e.g., `x`, `y`, `width`, `height`) to provide a custom layout.
* Create a custom `ContainerView` component to change the appearance of the container node.

### Caveats or Assumptions

* This component assumes that the `node` property is a valid `ContainerNode` object.
* The component uses the `scene` property to access the selection model and other scene-related data.

### Related Components

* `ContainerNode.qml`: The model component representing a container node.
* `ContainerView.qml`: The base view component for container nodes.
* `NodeLinkScene.qml`: The main scene component that manages the NodeLink MVC architecture.


## ContainerView.qml
### Overview

The `ContainerView` component is a visual representation of a container in the NodeLink MVC architecture. It provides an interactive node view that can be resized, dragged, and dropped. The component is responsible for managing the container's position, size, and child nodes.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `ContainerView` component corresponds to the View layer. It receives data from the Model layer (represented by the `Container` object) and updates the UI accordingly. The component also sends user interactions (e.g., drag and drop) to the Controller layer for processing.

### Component Description

The `ContainerView` component is an instance of `InteractiveNodeView` and provides the following features:

*   Interactive node view with draggable and resizable functionality
*   Display of container title and child nodes
*   Management of container position, size, and child nodes

### Properties

The following properties are exposed by the `ContainerView` component:

*   `container`: The `Container` object associated with this view
*   `isNodeMinimal`: A boolean indicating whether the node is in a minimal state (based on the zoom factor)

### Signals

The `ContainerView` component does not emit any custom signals. However, it inherits signals from its parent `InteractiveNodeView` component.

### Functions

The following functions are provided by the `ContainerView` component:

*   `updateInnerItems()`: Updates the child nodes and containers inside the container
*   `isInsideBound(node)`: Checks if a given node is inside the container bounds

### Example Usage in QML

```qml
import NodeLink

ContainerView {
    id: myContainerView
    container: myContainer
}
```

### Extension/Override Points

To extend or override the behavior of the `ContainerView` component, you can:

*   Override the `updateInnerItems()` function to customize the logic for updating child nodes and containers
*   Override the `isInsideBound(node)` function to customize the logic for checking if a node is inside the container bounds

### Caveats or Assumptions

The following caveats or assumptions apply to the `ContainerView` component:

*   The component assumes that the `container` property is set to a valid `Container` object
*   The component uses the `sceneSession` object to access global scene data (e.g., zoom factor, selection model)

### Related Components

The following components are related to the `ContainerView` component:

*   `Container`: The model object representing a container in the NodeLink MVC architecture
*   `InteractiveNodeView`: The parent component of `ContainerView`, providing interactive node view functionality
*   `NodeLink`: The main module providing the NodeLink MVC architecture and related components


## ImagesFlickable.qml
### Overview

The `ImagesFlickable` component is a QML component designed to display a horizontal list of images associated with a node in the NodeLink MVC architecture. It appears on top of each node that has images.

### Architecture

In the NodeLink MVC architecture, `ImagesFlickable` is a view component that complements the `I_Node` model. It is used to visualize and interact with the images of a node.

### Component Description

The `ImagesFlickable` component is a `Rectangle` that contains a `ListView` with a horizontal orientation. The list displays images from the `imagesModel` of the associated node. Each image is represented by a `Rectangle` delegate that contains an `Image` and several interactive elements.

### Properties

* `scene`: The scene object that this component belongs to.
* `sceneSession`: The current scene session.
* `selectionModel`: The selection model of the scene.
* `selectedItems`: A list of currently selected items.
* `node`: The node that this component is associated with.
* `selectedAlone`: A boolean indicating whether the node is the only selected item.

### Signals

None.

### Functions

None.

### Example Usage in QML

```qml
import NodeLink

// Assuming 'node' is an I_Node object
ImagesFlickable {
    node: node
    scene: myScene
    sceneSession: mySceneSession
}
```

### Extension/Override Points

To extend or customize the behavior of `ImagesFlickable`, you can:

* Override the `ListView` delegate to change the appearance or behavior of individual images.
* Add custom interactive elements to the image delegates.

### Caveats or Assumptions

* The component assumes that the `node` property is an object that conforms to the `I_Node` interface.
* The component uses the `imagesModel` property of the node to retrieve the list of images.

### Related Components

* `I_Node`: The interface for nodes in the NodeLink MVC architecture.
* `ImageViewer`: A component used to display an image in its actual size.
* `NLIconButtonRound`: A custom icon button component used in the image delegates.

### Properties and Explanations

The following properties are used in the component:

* `color`: The background color of the component.
* `radius`: The corner radius of the component.
* `border.width` and `border.color`: The border properties of the component.
* `visible`: A boolean indicating whether the component is visible. It is only visible if the node has images.

The `ListView` has the following properties:

* `orientation`: The orientation of the list (set to `Qt.Horizontal`).
* `model`: The data model for the list (set to `node.imagesModel.imagesSources`).
* `clip`: A boolean indicating whether the list should clip its content.
* `spacing`: The spacing between items in the list.

Each image delegate has the following properties:

* `width` and `height`: The size of the delegate.
* `color`: The background color of the delegate.
* `radius`: The corner radius of the delegate.
* `bgColor`: The background color of the delegate.
* `drawRadius`: The radius used for drawing the rounded rectangle.

The `Image` component has the following properties:

* `source`: The source URL of the image.
* `asynchronous`: A boolean indicating whether the image should be loaded asynchronously.
* `fillMode`: The fill mode of the image (set to `Image.Stretch`).
* `aspectRatio`: The aspect ratio of the image.

The interactive elements (e.g., `MouseArea`, `NLIconButtonRound`) have their own properties and signals, which are not listed here for brevity.


## ImageViewer.qml
### Overview

The `ImageViewer.qml` component is a popup dialog that displays an image with navigation capabilities to view multiple images. It is designed to be used within the NodeLink MVC architecture.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `ImageViewer.qml` component serves as a view that can be triggered by a controller to display an image or a series of images. The images are passed to the component as a list of URLs or image sources.

### Component Description

The `ImageViewer.qml` component is a subclass of `NLPopUp`, which provides a basic popup dialog functionality. It contains the following key elements:

* An image display area with a close button
* Navigation buttons (left and right arrows) to view multiple images
* A keyboard navigation mechanism to move between images using the left and right arrow keys

### Properties

The `ImageViewer.qml` component has the following properties:

* `images`: A list of image sources (URLs or QImage) to be displayed in the popup.
* `shownImage`: The currently displayed image source.

### Signals

The `ImageViewer.qml` component does not emit any signals.

### Functions

The `ImageViewer.qml` component does not have any explicit functions. However, it uses the following functions:

* `close()`: Closes the popup dialog.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

ApplicationWindow {
    id: window
    visible: true

    // Create a list of image sources
    property var imageSources: [
        "image1.jpg",
        "image2.png",
        "image3.bmp"
    ]

    // Create an instance of the ImageViewer component
    ImageViewer {
        id: imageViewer
        images: window.imageSources
        shownImage: imageSources[0]
    }

    // Button to trigger the image viewer
    Button {
        text: "Show Image Viewer"
        onClicked: {
            imageViewer.open()
        }
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `ImageViewer.qml` component, you can:

* Override the `images` property to provide a custom list of image sources.
* Override the `shownImage` property to provide a custom initial image source.
* Add custom navigation logic by modifying the `onClicked` handlers of the navigation buttons.

### Caveats or Assumptions

The `ImageViewer.qml` component assumes that the image sources provided in the `images` list are valid and can be displayed. It also assumes that the `NLPopUp` and `NLIconButtonRound` components are available in the NodeLink library.

### Related Components

The `ImageViewer.qml` component is related to the following components:

* `NLPopUp`: The base popup dialog component.
* `NLIconButtonRound`: The round icon button component used for navigation.
* `NodeLink`: The NodeLink library that provides the MVC architecture and related components.


## InteractiveNodeView.qml
### Overview

The `InteractiveNodeView` component is a QML view that represents a node in a NodeLink scene. It provides interactive functionality for node resizing, selection, and deletion.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `InteractiveNodeView` serves as the View component. It is responsible for rendering the node's visual representation and handling user interactions. The Model component is represented by the `node` property, which provides access to the node's data and configuration. The Controller component is not explicitly defined in this QML file, but it is assumed to be handled by the surrounding NodeLink framework.

### Component Description

The `InteractiveNodeView` component is a QML component that extends the `I_NodeView` interface. It provides a visual representation of a node in a NodeLink scene, complete with interactive resizing, selection, and deletion functionality.

### Properties

The following properties are exposed by the `InteractiveNodeView` component:

* `isSelected`: A boolean indicating whether the node is currently selected.
* `isResizable`: A boolean indicating whether the node is resizable.
* `isNodeEditable`: A boolean indicating whether the node is editable.
* `autoSize`: A boolean indicating whether the node should automatically adjust its size.
* `minWidth` and `minHeight`: The minimum width and height of the node.
* `baseContentWidth`: The base content width of the node.
* `calculatedMinWidth` and `calculatedMinHeight`: The calculated minimum width and height of the node.
* `topBorderContainsMouse`, `bottomBorderContainsMouse`, `leftBorderContainsMouse`, and `rightBorderContainsMouse`: Booleans indicating whether the mouse is currently over the corresponding border.

### Signals

The `InteractiveNodeView` component does not emit any signals.

### Functions

The `InteractiveNodeView` component provides the following functions:

* `dimensionChanged(containsNothing)`: A function that handles dimension changes and updates the node's selection state accordingly.

### Example Usage in QML

```qml
import NodeLink

NodeLinkScene {
    id: scene

    // ...

    InteractiveNodeView {
        node: myNode
        scene: scene
        sceneSession: scene.session
    }
}
```

### Extension/Override Points

To extend or override the behavior of the `InteractiveNodeView` component, you can:

* Create a custom QML component that extends `InteractiveNodeView` and overrides its properties or functions as needed.
* Use the `node` property to access the underlying node data and configuration, and modify its behavior accordingly.

### Caveats or Assumptions

The `InteractiveNodeView` component assumes that it is used within a NodeLink scene, and that the `node` property is set to a valid node object. It also assumes that the `scene` and `sceneSession` properties are set to valid objects.

### Related Components

The following components are related to `InteractiveNodeView`:

* `I_NodeView`: The interface that `InteractiveNodeView` extends.
* `NodeLinkScene`: The scene component that manages the NodeLink model and provides the context for `InteractiveNodeView`.
* `PortView`: A component that represents a port on a node, used by `InteractiveNodeView` to display node ports.


## I_LinkView.qml
### Overview

The `I_LinkView` component is a QML interface class that displays links as Bezier curves. It is a crucial part of the NodeLink MVC architecture, responsible for rendering the visual representation of links between nodes.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `I_LinkView` serves as the View component for links. It receives data from the Model (`Link`) and updates its visual representation accordingly. The component interacts with the Controller through the `scene`, `sceneSession`, and `viewProperties` properties.

### Component Description

`I_LinkView` is a `Canvas` component that displays a link as a Bezier curve. It provides a customizable visual representation of a link, including its color, style, and type.

### Properties

* `scene`: The scene object that contains the link.
* `sceneSession`: The scene session object that provides additional context for the link.
* `viewProperties`: An object that encompasses view properties not included in the scene or scene session.
* `link`: The main link model.
* `inputPort`: The input port of the link.
* `outputPort`: The output port of the link.
* `isSelected`: A boolean indicating whether the link is selected.
* `inputPos`: The position of the input port.
* `outputPos`: The position of the output port.
* `linkMidPoint`: The midpoint of the link.
* `outputPortSide`: The side of the output port.
* `linkColor`: The color of the link.
* `topLeftX`, `topLeftY`, `bottomRightX`, `bottomRightY`: The bounding box coordinates of the link.

### Signals

None.

### Functions

* `preparePainter()`: Prepares the painter and requests a repaint of the canvas.
* `safePoints()`: Returns the control points of the link as an array.

### Example Usage in QML

```qml
import QtQuick 2.15
import NodeLink 1.0

Item {
    I_LinkView {
        id: linkView
        scene: myScene
        sceneSession: mySceneSession
        link: myLink
    }

    // ...
}
```

### Extension/Override Points

To extend or override the behavior of `I_LinkView`, you can:

* Create a custom `LinkPainter` script to modify the link rendering.
* Override the `preparePainter()` function to add custom logic.
* Create a custom `BasicLinkCalculator` script to modify the control point calculation.

### Caveats or Assumptions

* The link is assumed to be a Bezier curve.
* The input and output ports are assumed to have valid positions.

### Related Components

* `Link`: The model class that represents a link.
* `Port`: The model class that represents a port.
* `Scene`: The model class that represents a scene.
* `SceneSession`: The model class that represents a scene session.

### Usage Guidelines

* Use `I_LinkView` to display links between nodes in your NodeLink-based application.
* Customize the appearance of links by modifying the `linkColor`, `style`, and `type` properties.
* Extend or override the behavior of `I_LinkView` as needed to fit your specific use case.


## I_NodesRect.qml
### Overview

The `I_NodesRect` QML component is an interface class responsible for displaying nodes within a scene. It plays a crucial role in the NodeLink MVC (Model-View-Controller) architecture by acting as the view for nodes, links, and containers.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `I_NodesRect` serves as the view component. It receives updates from the model (scene and scene session) and displays the nodes, links, and containers accordingly. The controller (not shown in this component) would typically interact with the model and update the view through signals and properties.

### Component Description

The `I_NodesRect` component is an `Item` that fills its parent area. It has several properties that define its behavior and child components.

### Properties

*   **scene**: The scene object that this view is associated with.
*   **sceneSession**: The current session of the scene.
*   **viewProperties**: A QtObject that encompasses view-specific properties not included in the scene or scene session.
*   **nodeViewUrl**, **linkViewUrl**, **containerViewUrl**: URLs for the default node, link, and container views, respectively. These are retrieved from the scene's node registry.
*   **nodeViewComponent**, **linkViewComponent**, **containerViewComponent**: Components created from the respective view URLs.
*   **_nodeViewMap**, **_linkViewMap**, **_containerViewMap**: Internal maps to store created node, link, and container views.

### Signals

This component does not emit any signals. Instead, it listens to signals from the scene object to update its child components.

### Functions

There are no explicit functions defined in this component. However, it uses several functions from the `ObjectCreator` class to create node, link, and container views.

### Example Usage in QML

```qml
import NodeLink

I_NodesRect {
    id: nodesRect
    scene: myScene
    sceneSession: mySceneSession
    viewProperties: myViewProperties
}
```

### Extension/Override Points

To extend or customize the behavior of `I_NodesRect`, you can:

*   Override the `nodeViewUrl`, `linkViewUrl`, or `containerViewUrl` properties to use custom view components.
*   Provide a custom `viewProperties` object to configure the view.
*   Create a subclass of `I_NodesRect` to add additional functionality.

### Caveats or Assumptions

*   This component assumes that the scene and scene session objects are properly set up and provide the necessary signals and properties.
*   The component uses the `ObjectCreator` class to create views, which might have its own set of assumptions and requirements.

### Related Components

*   `I_Scene`: The scene object that this view is associated with.
*   `SceneSession`: The current session of the scene.
*   `Node`, `Link`, `Container`: Model objects that are displayed by this view.
*   `ObjectCreator`: A utility class used to create node, link, and container views.


## I_NodesScene.qml
### Overview

The `I_NodesScene` QML component represents the abstract base for a nodes scene in the NodeLink architecture. It provides a Flickable area for displaying nodes and links, along with properties and functionality for managing the scene's layout and user interactions.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `I_NodesScene` serves as the View component. It is responsible for rendering the scene's contents, handling user input, and updating the scene's layout in response to user interactions.

### Component Description

The `I_NodesScene` component is a Flickable area that displays the scene's contents, including nodes and links. It provides properties for customizing the scene's background, foreground, and contents.

### Properties

* `scene`: The main model containing information about all nodes and links. (type: `I_Scene`, default: `null`)
* `sceneSession`: The scene session containing information about scene states (UI related). (type: `SceneSession`, default: `null`)
* `background`: The scene background component. (type: `Component`, default: `null`)
* `sceneContent`: The scene contents component (nodes/links). (type: `Component`, default: `null`)
* `foreground`: The scene foreground component. (type: `Component`, default: `null`)
* `isFlickStarted`: A flag indicating whether a flick process has started. (type: `bool`, default: `false`)

### Signals

* `onFlickStarted`: Emitted when a flick process starts.
* `onMovementEnded`: Emitted when the user stops moving the Flickable area.

### Functions

* None

### Example Usage in QML

```qml
import NodeLink

I_NodesScene {
    id: nodesScene
    scene: myScene // assuming myScene is an I_Scene object
    sceneSession: mySceneSession // assuming mySceneSession is a SceneSession object
    background: Rectangle { color: "lightgray" }
    sceneContent: MySceneContentComponent {} // assuming MySceneContentComponent is a QML component
    foreground: MyForegroundComponent {} // assuming MyForegroundComponent is a QML component
}
```

### Extension/Override Points

* To customize the scene's layout or behavior, you can override the `onContentXChanged` and `onContentYChanged` handlers.
* To add custom functionality when the flick process starts or ends, you can connect to the `onFlickStarted` and `onMovementEnded` signals.

### Caveats or Assumptions

* The `I_NodesScene` component assumes that the `scene` property is an instance of `I_Scene`.
* The component uses the `NLStyle` singleton to access style-related constants.

### Related Components

* `I_Scene`: The main model containing information about all nodes and links.
* `SceneSession`: The scene session containing information about scene states (UI related).
* `MySceneContentComponent`: A custom QML component for rendering the scene's contents.
* `MyForegroundComponent`: A custom QML component for rendering the scene's foreground.


## I_NodeView.qml
### Overview

The `I_NodeView` QML component is an abstract representation of a node view in the NodeLink MVC architecture. It provides a basic structure for displaying node properties and serves as a base for more specific node view implementations.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `I_NodeView` is a view component that corresponds to a node in the model. It receives updates from the model through the `node` and `scene` properties and displays the node's properties accordingly. The `I_NodeView` component is part of the view layer, while the `I_Scene` and `SceneSession` components are part of the model layer.

### Component Description

The `I_NodeView` component is a `Rectangle` that displays the node's properties, such as position, size, color, and border style. It also provides a content area for displaying custom node content.

### Properties

The following properties are exposed by the `I_NodeView` component:

* `node`: The current node (or container) being displayed.
* `scene`: The main model containing information about all nodes/links.
* `sceneSession`: The scene session associated with the node.
* `viewProperties`: An object containing view properties that are not included in the scene or scene session.
* `contentItem`: A component that defines the content of the node.
* `scaleFactor`: A scale factor to rescale the node view.
* `positionMapped`: The correct position of the node based on the zoom point and zoom factor.
* `isContainer`: A boolean indicating whether the node is a container or not.

### Signals

The `I_NodeView` component does not emit any signals.

### Functions

The `I_NodeView` component does not provide any functions.

### Example Usage in QML

```qml
import NodeLink

I_NodeView {
    node: myNode
    scene: myScene
    sceneSession: mySceneSession
    contentItem: MyNodeContent {}
}
```

### Extension/Override Points

To create a custom node view, you can override the `I_NodeView` component and provide a custom implementation for the `contentItem` property. You can also bind to the `node` and `scene` properties to access additional node and scene data.

### Caveats or Assumptions

The `I_NodeView` component assumes that the `node` and `scene` properties are valid and non-null. It also assumes that the `contentItem` property is a valid QML component.

### Related Components

The following components are related to `I_NodeView`:

* `I_Scene`: The main model containing information about all nodes/links.
* `SceneSession`: The scene session associated with a node.
* `Node`: The data model representing a node in the NodeLink architecture.

### Usage Guidelines

When using the `I_NodeView` component, ensure that you provide valid `node` and `scene` properties. You can customize the appearance of the node view by binding to the `node` and `scene` properties and providing a custom `contentItem` component.

### Best Practices

* Always provide valid `node` and `scene` properties to ensure correct rendering of the node view.
* Use the `contentItem` property to provide custom node content.
* Bind to the `node` and `scene` properties to access additional node and scene data.


## LinkView.qml
### Overview

The `LinkView` component is a QML view that manages link children using the `I_LinkView` interface, specifically implementing a Bezier curve. It provides a visual representation of a link in the NodeLink MVC architecture.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `LinkView` is a view component that corresponds to a link model. It receives updates from the model and displays the link's properties, such as its description and color.

### Component Description

The `LinkView` component is an instance of `I_LinkView` and provides the following features:

*   Displays a link's description and allows editing it when in edit mode
*   Handles deletion of the link
*   Provides visual feedback for selection and focus

### Properties

The following properties are exposed by the `LinkView` component:

*   `z`: The z-order of the link view, which is set to 10 when the link is selected and 1 otherwise
*   `isSelected`: A boolean indicating whether the link is currently selected
*   `link`: The link model associated with this view
*   `sceneSession`: The scene session that this link view belongs to

### Signals

The `LinkView` component emits the following signals:

*   None

### Functions

The `LinkView` component provides the following functions:

*   None

### Example Usage in QML

To use the `LinkView` component in QML, you can simply import the `NodeLink` module and create an instance of `LinkView`:

```qml
import NodeLink

LinkView {
    id: linkView
    link: someLinkModel
    sceneSession: someSceneSession
}
```

### Extension/Override Points

To extend or override the behavior of the `LinkView` component, you can:

*   Create a custom component that inherits from `LinkView`
*   Override specific properties or functions of the `LinkView` component

### Caveats or Assumptions

The following caveats or assumptions apply to the `LinkView` component:

*   The link model associated with this view must provide a `guiConfig` property with a `description` and a `_isEditableDescription` property
*   The scene session must provide a `selectionModel` and an `isShiftModifierPressed` property

### Related Components

The following components are related to `LinkView`:

*   `I_LinkView`: The interface that `LinkView` implements
*   `LinkModel`: The model that `LinkView` is associated with
*   `SceneSession`: The scene session that `LinkView` belongs to
*   `NLTextArea`: The text area component used to display the link's description
*   `ConfirmPopUp`: The popup component used to confirm deletion of the link

### Properties Reference

#### Object Properties

| Property Name | Type | Description |
| --- | --- | --- |
| z | int | The z-order of the link view |
| isSelected | bool | A boolean indicating whether the link is currently selected |

#### Child Components

The following child components are used by `LinkView`:

*   `delTimer`: A timer used to delay deletion of the link
*   `deletePopup`: A popup used to confirm deletion of the link
*   `infoPopup`: A popup used to display information when the scene is not editable
*   `descriptionIcon`: A text component used to display an icon when the link has a description but is not in edit mode
*   `descriptionText`: A text area component used to display and edit the link's description

### Key Handling

The `LinkView` component handles the following key presses:

*   Delete: Deletes the selected link and node

### Focus Handling

The `LinkView` component handles focus as follows:

*   When the link is selected, it forces active focus
*   When the description text area is focused, it selects the link and makes the description editable

### Visual Feedback

The `LinkView` component provides visual feedback as follows:

*   When the link is selected, its z-order is increased and it displays a description text area
*   When the link has a description but is not in edit mode, it displays a description icon

## NodesRectOverview.qml
### Overview

The `NodesRectOverview.qml` component provides a user interface for an overview of a node rectangle in the NodeLink architecture. It serves as a visual representation of a node rectangle in a reduced scale, allowing users to navigate and understand the overall layout of nodes and links.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `NodesRectOverview.qml` acts as a View component. It displays the overview of node rectangles and provides properties and signals to interact with the Model and Controller. Specifically, it fits into the architecture as follows:

*   Model: The data model for nodes and links is assumed to be provided by the NodeLink architecture.
*   View: `NodesRectOverview.qml` is responsible for rendering the overview of node rectangles.
*   Controller: The controller is expected to manage the interaction between the Model and View, updating properties and handling user input.

### Component Description

The `NodesRectOverview.qml` component inherits from `I_NodesRect`, an interface or base component provided by the NodeLink architecture. It defines an overview of a node rectangle, including its top-left position and a scale factor for mapping between the scene and overview.

### Properties

The following properties are exposed by the `NodesRectOverview.qml` component:

*   `nodeRectTopLeft`: A `vector2d` property representing the top-left position of the node rectangle.
*   `overviewScaleFactor`: A `real` property representing the scale factor used for mapping between the scene and overview. A minimum value of 1.0 is used to avoid complications in link drawings.

Additionally, the component exposes the following object properties:

*   `nodeViewUrl`: A URL string referencing the QML component used to display node views in the overview (`NodeViewOverview.qml`).
*   `linkViewUrl`: A URL string referencing the QML component used to display link views in the overview (`LinkViewOverview.qml`).
*   `containerViewUrl`: A URL string referencing the QML component used to display container views in the overview (`ContainerOverview.qml`).
*   `viewProperties`: A `QtObject` containing properties that can be used by the node, link, and container views:
    *   `nodeRectTopLeft`: The top-left position of the node rectangle.
    *   `overviewScaleFactor`: The scale factor used for mapping between the scene and overview.

### Signals

No signals are explicitly declared in the provided code.

### Functions

No functions are explicitly declared in the provided code.

### Example Usage in QML

To use the `NodesRectOverview.qml` component in a QML file, you can import it and create an instance:

```qml
import NodeLink

NodesRectOverview {
    id: overview

    nodeRectTopLeft: Qt.vector2d(100, 100)
    overviewScaleFactor: 1.5

    // Access viewProperties
    console.log(overview.viewProperties.nodeRectTopLeft)
    console.log(overview.viewProperties.overviewScaleFactor)
}
```

### Extension/Override Points

To extend or override the behavior of `NodesRectOverview.qml`, you can:

*   Create a custom QML component that inherits from `I_NodesRect` and provides a different implementation.
*   Override the `nodeViewUrl`, `linkViewUrl`, or `containerViewUrl` properties to use custom view components.
*   Add custom properties or functions to the `viewProperties` object.

### Caveats or Assumptions

The following assumptions are made:

*   The NodeLink architecture provides a data model for nodes and links.
*   The `I_NodesRect` interface or base component is defined and implemented correctly.

### Related Components

The following components are related to `NodesRectOverview.qml`:

*   `NodeViewOverview.qml`: The QML component used to display node views in the overview.
*   `LinkViewOverview.qml`: The QML component used to display link views in the overview.
*   `ContainerOverview.qml`: The QML component used to display container views in the overview.
*   `I_NodesRect`: The interface or base component that `NodesRectOverview.qml` inherits from.


## SceneViewBackground.qml
### Overview

The `SceneViewBackground.qml` component is responsible for drawing the background of a scene in the NodeLink application. It utilizes a C++-based background grid component, `BackgroundGridsCPP`, to render a customizable grid pattern.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, `SceneViewBackground.qml` serves as a view component that displays the background of the scene. It interacts with the application's style and configuration to determine the appearance of the background grid.

### Component Description

The `SceneViewBackground.qml` component is a QML-based view that leverages the `BackgroundGridsCPP` C++ component to draw the background grid. It exposes properties to customize the grid's appearance and inherits behavior from its C++ counterpart.

### Properties

The following properties are exposed by the `SceneViewBackground.qml` component:

* `spacing`: The spacing between grid lines, retrieved from the application's style (`NLStyle.backgroundGrid.spacing`).
* `opacity`: The opacity of the background grid, also retrieved from the application's style (`NLStyle.backgroundGrid.opacity`).

### Signals

None.

### Functions

None.

### Example Usage in QML

To use the `SceneViewBackground.qml` component in a QML file, simply import the necessary modules and instantiate the component:
```qml
import QtQuick
import NodeLink

SceneViewBackground {
    // No additional properties need to be set, as they are retrieved from the application's style
}
```
### Extension/Override Points

To customize the appearance or behavior of the `SceneViewBackground.qml` component, you can:

* Override the `spacing` or `opacity` properties to use custom values.
* Create a custom C++ component that inherits from `BackgroundGridsCPP` and provides additional features or customization options.

### Caveats or Assumptions

* The `SceneViewBackground.qml` component assumes that the `NLStyle` object is properly configured and provides the necessary style settings for the background grid.
* The component relies on the `BackgroundGridsCPP` C++ component to perform the actual rendering of the grid.

### Related Components

* `BackgroundGridsCPP`: The C++ component responsible for rendering the background grid.
* `NLStyle`: The application's style object that provides configuration settings for the background grid.

## HorizontalScrollBar.qml
### Overview

The `HorizontalScrollBar` component is a customized `ScrollBar` designed to provide a horizontal scrolling indicator with a specific visual style. It is intended to be used within the NodeLink MVC architecture to provide a consistent user experience.

### Architecture Integration

In the NodeLink MVC architecture, the `HorizontalScrollBar` component serves as a view component, responsible for rendering the horizontal scrolling indicator. It can be used in conjunction with `NodeLink` views to provide a seamless user experience.

### Component Description

The `HorizontalScrollBar` component is a subclass of `ScrollBar` from `QtQuick.Controls`. It customizes the appearance of the scroll bar to have a horizontal orientation with a specific height and opacity.

### Properties

The following properties are inherited from `ScrollBar` and can be used to customize the behavior of the `HorizontalScrollBar` component:

* `orientation`: The orientation of the scroll bar. For horizontal scroll bars, this property should be set to `Qt.Horizontal` (default).
* `position`: The current position of the scroll bar.
* `size`: The size of the scroll bar handle.

The component also defines the following properties:

* `height`: The height of the scroll bar (set to 4 by default).
* `opacity`: The opacity of the scroll bar (set to 0.3 by default).

### Signals

The `HorizontalScrollBar` component does not define any custom signals. It inherits signals from `ScrollBar`, including:

* `onPositionChanged`: Emitted when the position of the scroll bar changes.

### Functions

The `HorizontalScrollBar` component does not define any custom functions. It inherits functions from `ScrollBar`, including:

* `setPosition(qreal position)`: Sets the position of the scroll bar.

### Example Usage in QML

```qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 800
    height: 600

    Flickable {
        id: flickable
        width: window.width
        height: window.height
        contentWidth: 1000
        HorizontalScrollBar {
            parent: flickable
            anchors.bottom: flickable.bottom
            anchors.left: flickable.left
            anchors.right: flickable.right
        }
    }
}
```

### Extension/Override Points

To customize the appearance or behavior of the `HorizontalScrollBar` component, you can override the following components:

* `background`: The background rectangle of the scroll bar.

### Caveats or Assumptions

* The `HorizontalScrollBar` component assumes that it will be used within a `Flickable` or similar component that provides scrolling behavior.
* The component's visual style is designed to be subtle and non-intrusive. If you need a more prominent scroll bar, you may need to adjust the component's properties or create a custom variant.

### Related Components

* `VerticalScrollBar`: A similar component for vertical scrolling indicators.
* `NodeLink`: The main view component in the NodeLink MVC architecture.

## NLRepeater.qml
### Overview

The `NLRepeater` component is a custom QML component designed to manage model overlays by converting JavaScript arrays to a `ListModel`. This enables intelligent control of model changes, making it a crucial part of the NodeLink MVC architecture.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `NLRepeater` serves as a bridge between the model and view components. It allows for dynamic management of model data, enabling efficient updates and manipulation of the data displayed in the view.

### Component Description

`NLRepeater` is a QML component that extends the built-in `Repeater` component. It provides a temporary model (`repeaterModel`) for connection to the repeater, enabling intelligent control of model changes.

### Properties

* `repeaterModel`: A `ListModel` property that serves as a temporary model for the repeater. This property is used to intelligently control model changes.

### Signals

None

### Functions

* `addElement(qsObj)`: Adds an element to the `repeaterModel`. This function takes a JavaScript object (`qsObj`) as an argument and appends it to the model.
* `removeElement(qsObj)`: Removes an element from the `repeaterModel`. This function takes a JavaScript object (`qsObj`) as an argument and removes the corresponding element from the model based on its `_qsUuid` property.

### Example Usage in QML

```qml
import NodeLink 1.0

NLRepeater {
    id: repeater

    // Example usage of addElement function
    Component.onCompleted: {
        repeater.addElement({"name": "Item 1", "_qsUuid": "uuid1"});
        repeater.addElement({"name": "Item 2", "_qsUuid": "uuid2"});
    }

    // Example usage of removeElement function
    Button {
        text: "Remove Item 1"
        onClicked: repeater.removeElement({"name": "Item 1", "_qsUuid": "uuid1"});
    }

    // Delegate example
    delegate: Rectangle {
        text: qsObj.name
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `NLRepeater`, you can:

* Override the `addElement` and `removeElement` functions to provide custom logic for adding and removing elements from the model.
* Create a custom delegate to display the data in the model.

### Caveats or Assumptions

* The `NLRepeater` component assumes that the JavaScript objects being added to the model have a `_qsUuid` property, which is used for identification and removal of elements.
* The component uses a `ListModel` to manage the data, which may have performance implications for large datasets.

### Related Components

* `NodeLink`: The main NodeLink module, which provides the foundation for the MVC architecture.
* `ListModel`: The built-in QML `ListModel` component, which is used by `NLRepeater` to manage the data.

## NLToolTip.qml
### Overview

The `NLToolTip` component is a custom tooltip designed for the NodeLink framework. It provides a customizable tooltip with a sleek and modern design.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `NLToolTip` is a view component that can be used to display additional information about nodes or other graphical elements. It does not interact directly with the model or controller, but rather serves as a visual aid to enhance the user experience.

### Component Description

`NLToolTip` is a QML component that extends the built-in `ToolTip` control from Qt Quick Controls. It provides a custom background and content item, allowing for a high degree of customization.

### Properties

The following properties are available:

* `text`: The text to be displayed in the tooltip. (Default: "This button does cool things")
* `delay`: The delay in milliseconds before the tooltip is shown. (Default: 200)

### Signals

None

### Functions

None

### Example Usage in QML

```qml
import QtQuick
import NodeLink

Item {
    ToolTip {
        text: "Hello World"
    }
    NLToolTip {
        text: "This is a custom tooltip"
        delay: 500
        visible: true
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `NLToolTip`, you can override the following components:

* `background`: The background rectangle of the tooltip. You can modify its properties, such as `color` or `radius`, to change the appearance.
* `contentItem`: The text item that displays the tooltip text. You can modify its properties, such as `font` or `color`, to change the appearance.

### Caveats or Assumptions

* The `exit` transition is set to an empty transition to fix the fade effect on the tooltip. This means that the tooltip will disappear immediately when the mouse leaves the target item.

### Related Components

* `NodeLink`: The main NodeLink framework component.
* `NLStyle`: A style component that provides constants for NodeLink's visual design.

### Best Practices

* Use `NLToolTip` to provide additional information about nodes or other graphical elements in your NodeLink application.
* Customize the `text` and `delay` properties to suit your application's needs.
* Override the `background` and `contentItem` components to match your application's visual design.


## SideMenuButtonGroup.qml
### Overview

The `SideMenuButtonGroup` component is a customizable button group designed for the side menu in the NodeLink application. It provides a container for a collection of buttons, allowing for a flexible and organized way to present menu options.

### NodeLink MVC Architecture

In the NodeLink Model-View-Controller (MVC) architecture, the `SideMenuButtonGroup` component serves as a View component. It is responsible for rendering a group of buttons in the side menu, which is likely controlled by a Controller that manages the application's menu logic.

### Component Description

The `SideMenuButtonGroup` component is a `Rectangle` that contains a `ColumnLayout` of buttons. It provides a default property `contents` to add buttons or other components to the group.

### Properties

* `contents`: A default property alias that allows adding buttons or other components to the group.
* `layout`: A property alias that references the internal `ColumnLayout` component.

### Object Properties

* `radius`: The corner radius of the rectangle, set to `NLStyle.radiusAmount.itemButton`.
* `height`: The height of the rectangle, automatically set to the implicit height of the `ColumnLayout`.
* `width`: The width of the rectangle, set to 34.
* `border.color`: The color of the rectangle's border, set to "#3f3f3f".
* `color`: The background color of the rectangle, set to "#3f3f3f".

### Signals

None.

### Functions

None.

### Example Usage in QML

```qml
import QtQuick
import NodeLink

SideMenuButtonGroup {
    // Add buttons to the group
    contents: [
        Button { text: "Button 1" },
        Button { text: "Button 2" },
        Button { text: "Button 3" }
    ]
}
```

### Extension/Override Points

To extend or customize the `SideMenuButtonGroup` component, you can:

* Add custom buttons or components to the `contents` property.
* Override the `layout` property to use a different layout component.
* Modify the rectangle's properties (e.g., `radius`, `width`, `height`) to change its appearance.

### Caveats or Assumptions

* The `SideMenuButtonGroup` component assumes that it will be used within a NodeLink application.
* The component uses the `NLStyle` object to access style-related properties (e.g., `radiusAmount.itemButton`).

### Related Components

* `NodeLink`: The main NodeLink module.
* `NLStyle`: The style-related object used by NodeLink components.
* `Button`: The standard Qt Quick button component used within the `SideMenuButtonGroup`.


## TextIcon.qml
### Overview

The `TextIcon` component is a simple QML text component designed to display FontAwesome icons. It provides a straightforward way to show icons in a NodeLink application, leveraging the power of FontAwesome for consistent and scalable iconography.

### Architecture Integration

In the context of the NodeLink MVC (Model-View-Controller) architecture, the `TextIcon` component primarily serves as a view component. It can be used within various views to display icons, enhancing the user interface with visual elements that are consistent across the application.

### Component Description

The `TextIcon` component extends the base `Text` component from QtQuick, customizing it to display FontAwesome icons. It sets specific properties to ensure that the text is rendered as a FontAwesome icon, centered both horizontally and vertically.

### Properties

The following properties are defined or inherited by the `TextIcon` component:

* **font.family**: Set to `"Font Awesome 6 Pro"` to use FontAwesome icons.
* **horizontalAlignment**: Set to `Qt.AlignHCenter` to center the icon horizontally.
* **verticalAlignment**: Set to `Qt.AlignVCenter` to center the icon vertically.
* **font.weight**: Set to `900` for FontAwesome icons.

Additionally, it inherits all properties from the `Text` component, such as `text`, `font`, `color`, etc., which can be used to customize the appearance and content of the icon.

### Signals

The `TextIcon` component does not define any custom signals. It inherits signals from the `Text` component, such as `onLinkActivated`.

### Functions

No custom functions are defined in the `TextIcon` component. It relies on the functions provided by the `Text` component.

### Example Usage in QML

```qml
import QtQuick 2.15
import NodeLink 1.0

Item {
    TextIcon {
        text: "\uF0A8" // Example FontAwesome icon code
        font.pixelSize: 24
        color: "blue"
    }
}
```

### Extension/Override Points

To extend or customize the `TextIcon` component, you can:

* Override the `font.family` property to use a different font.
* Change the `text` property to display a different icon.
* Modify the `font.weight`, `font.pixelSize`, and `color` properties for different visual effects.

### Caveats or Assumptions

* The `TextIcon` component assumes that the FontAwesome font is available and properly configured in the application.
* The component uses Unicode characters to represent FontAwesome icons, so ensure that your QML environment supports Unicode.

### Related Components

* `IconButton`: A button component that can use `TextIcon` for its icon.
* `NodeIcon`: A specialized icon component for nodes in the NodeLink application.

By using the `TextIcon` component, you can easily integrate FontAwesome icons into your NodeLink application, enhancing the user interface with a wide range of scalable and customizable icons.


## VerticalScrollBar.qml
### Overview

The `VerticalScrollBar` component is a customized vertical scrollbar designed for use in NodeLink-based user interfaces. It provides a compact and translucent scrollbar that can be easily integrated into various QML-based applications.

### Architecture

In the context of the NodeLink MVC architecture, the `VerticalScrollBar` component serves as a view component, primarily responsible for rendering the scrollbar and handling user interactions. It does not directly interact with the model or controller but can be used in conjunction with NodeLink's view components to provide a seamless user experience.

### Component Description

The `VerticalScrollBar` component is a subclass of `QtQuick.Controls.ScrollBar`, customized to provide a vertical scrollbar with a specific appearance.

### Properties

The following properties are relevant to the `VerticalScrollBar` component:

* `width`: The width of the scrollbar, set to **4** pixels by default.
* `opacity`: The overall opacity of the scrollbar, set to **0.3** by default.

The `background` property is also used, which is a child component of type `Rectangle`:

* `color`: The background color of the scrollbar, set to **"black"** by default.
* `width`: The width of the background rectangle, set to **4** pixels by default.
* `opacity`: The opacity of the background rectangle, set to **0.8** by default.

### Signals

The `VerticalScrollBar` component does not emit any custom signals. It inherits signals from the base `ScrollBar` component, such as `onPositionChanged`.

### Functions

No custom functions are provided by the `VerticalScrollBar` component. It relies on the functions inherited from the base `ScrollBar` component.

### Example Usage in QML

```qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 800
    height: 600

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentWidth: width
        contentHeight: 1000 // Example content height

        VerticalScrollBar {
            id: scrollBar
            parent: flickable
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            orientation: Qt.Vertical
            policy: ScrollBar.AlwaysOn
        }

        // Your content here
        Rectangle {
            anchors.fill: parent
            color: "lightblue"
        }
    }
}
```

### Extension/Override Points

To extend or customize the behavior of the `VerticalScrollBar` component, you can:

* Override the `background` component to change its appearance.
* Bind to the `position` property to react to changes in the scrollbar's position.

### Caveats or Assumptions

* The `VerticalScrollBar` component assumes it will be used within a `Flickable` or similar component that provides scrolling behavior.
* The appearance of the scrollbar is designed to be compact and subtle; adjust properties as needed to fit your application's visual style.

### Related Components

* `HorizontalScrollBar.qml`: A similar component for horizontal scrollbars.
* `NodeLinkView.qml`: A view component that can utilize the `VerticalScrollBar` component for navigation.

## NLButton.qml
### Overview

The `NLButton` component is a customizable button designed for use within the NodeLink MVC architecture. It extends the `NLBaseButton` component, adding a simple text object as its content.

### Architecture Integration

In the NodeLink MVC architecture, `NLButton` serves as a view component, primarily used in the presentation layer. It can be utilized in various contexts where a standard button with text content is required.

### Component Description

`NLButton` is a QML component that inherits from `NLBaseButton`. It features a text-based content item, making it suitable for scenarios where a button with textual content is needed.

### Properties

The following properties are available:

* `font.bold`: A boolean indicating whether the button text should be bold. Default is `false`.
* `font.pixelSize`: The size of the button text in pixels, calculated as `height * 0.6` by default.
* `text`: The text to be displayed on the button.

### Signals

`NLButton` does not emit any custom signals. It inherits signals from `NLBaseButton` and `QtQuick.Controls.Button`.

### Functions

No custom functions are provided by `NLButton`. It relies on the functions inherited from `NLBaseButton` and `QtQuick.Controls.Button`.

### Example Usage in QML

```qml
import QtQuick 2.0

Row {
    NLButton {
        text: "Click Me"
        onClicked: console.log("Button clicked")
    }
    NLButton {
        text: "Disabled Button"
        enabled: false
    }
}
```

### Extension/Override Points

To extend or customize `NLButton`, consider the following:

* Override the `contentItem` to use a different type of content, such as an icon or a custom component.
* Modify the `font` properties to change the appearance of the button text.
* Use the `NLBaseButton` properties and functions to further customize the button's behavior.

### Caveats or Assumptions

* The component assumes that the `Roboto` font family is available. If not, the text will use a default font.
* The button's text color changes based on its enabled state.

### Related Components

* `NLBaseButton`: The base button component from which `NLButton` inherits.
* `QtQuick.Controls.Button`: The Qt Quick Controls button component that `NLBaseButton` is based on.


## NLIconButtonRound.qml
### Overview

The `NLIconButtonRound` is a QML component that represents a round button with an icon as its content. It extends the `NLIconButton` component and provides a simplified way to create round buttons with a uniform size.

### NodeLink MVC Architecture

The `NLIconButtonRound` component fits into the NodeLink MVC architecture as a view component, specifically designed to display a round button with an icon. It can be used in various parts of the application where a round button is required.

### Component Description

The `NLIconButtonRound` component is a round button with an icon as its content. It has a single property `size` that determines both the width and height of the button, making it easy to use and size.

### Properties

* `size`: An integer property that determines the size of the button (width and height). Default value is 100.
* `backColor`: The background color of the button. Default value is "blue".
* `textColor`: The color of the icon. Default value is "white".
* `radius`: The radius of the button. Automatically calculated as half of the width.
* `iconPixelSize`: The size of the icon. Calculated as 55% of the button's height.

### Signals

The `NLIconButtonRound` component does not emit any custom signals. It inherits signals from its parent `NLIconButton` component.

### Functions

The `NLIconButtonRound` component does not have any custom functions. It inherits functions from its parent `NLIconButton` component.

### Example Usage in QML

```qml
import QtQuick
import QtQuick.Controls

Item {
    NLIconButtonRound {
        id: button
        size: 50
        anchors.centerIn: parent
    }
}
```

### Extension/Override Points

To extend or customize the `NLIconButtonRound` component, you can:

* Override the `backColor` and `textColor` properties to change the button's appearance.
* Provide a custom icon using the `icon` property inherited from `NLIconButton`.
* Override the `iconPixelSize` property to change the icon's size.

### Caveats or Assumptions

* The `NLIconButtonRound` component assumes that the `NLIconButton` component is available in the project.
* The component uses a simple calculation to determine the `radius` and `iconPixelSize` properties, which may not be suitable for all use cases.

### Related Components

* `NLIconButton`: The parent component of `NLIconButtonRound`, providing common functionality for icon buttons.
* Other button components in the NodeLink project, such as `NLButton` and `NLIconButton`.

## NLSideMenuButton.qml
### Overview

The `NLSideMenuButton` component is a specialized button designed for use in side menus, providing a consistent and visually appealing interface element. It extends the `NLIconButton` component, inheriting its core functionality while adding specific properties tailored for side menu buttons.

### NodeLink MVC Architecture

In the NodeLink MVC (Model-View-Controller) architecture, `NLSideMenuButton` serves as a view component. It is intended to be used within the application's UI, specifically in the side menu section, to provide users with interactive buttons that can be used for navigation or actions.

### Component Description

`NLSideMenuButton` is a QML component that represents a side menu button. It inherits from `NLIconButton` and customizes its appearance and behavior for a side menu context. The component is designed to display an icon and text, with a hover and checked state that changes its text color.

### Properties

The following properties are exposed by `NLSideMenuButton`:

* **textColor**: The color of the button's text. It dynamically changes based on the button's state (hovered or checked).
* **iconPixelSize**: The size of the icon displayed on the button, set to 19 pixels by default.
* **checkable**: A boolean property inherited from `NLIconButton`, set to `true` to allow the button to be checkable.

### Signals

`NLSideMenuButton` does not emit any custom signals. It relies on the signals inherited from `NLIconButton` and possibly its base QML types.

### Functions

This component does not introduce any new functions beyond those inherited from `NLIconButton` and its base types.

### Example Usage in QML

```qml
import QtQuick 2.0

Row {
    NLSideMenuButton {
        icon.source: "icon1.png"
        text: "Menu Item 1"
    }
    NLSideMenuButton {
        icon.source: "icon2.png"
        text: "Menu Item 2"
    }
}
```

### Extension/Override Points

To extend or customize the behavior of `NLSideMenuButton`, you can:

* Override the `textColor` property to provide a custom color logic.
* Change the `iconPixelSize` property to adjust the icon size according to your design requirements.
* Modify the `checkable` property or add custom logic to handle button check states.

### Caveats or Assumptions

* This component assumes that the `NLIconButton` component is properly styled and functional.
* The hover and checked states' appearance relies on the theme or styling applied to the application.

### Related Components

* `NLIconButton`: The base component providing the core button functionality with an icon.
* `NodeLink`: The main application component that integrates various UI elements, including side menus.

## HelpersView.qml
### Overview

The `HelpersView` component is a crucial part of the NodeLink MVC architecture, responsible for managing and displaying helper classes. It acts as a container for various helper views, providing a centralized location for rendering scene-related assistance.

### Architecture Integration

In the NodeLink MVC architecture, `HelpersView` fits into the View layer, working closely with the `I_Scene` and `SceneSession` models. It receives updates from these models and reacts accordingly, ensuring a seamless user experience.

### Component Description

The `HelpersView` component is an `Item` that fills its parent area. It serves as a host for two primary helper views:

*   `SelectionHelperView`: handles selection-related helpers, such as rubber bands.
*   `LinkHelperView`: displays user connection curves.

### Properties

The following properties are exposed by `HelpersView`:

*   `scene`: an instance of `I_Scene`, which represents the main model containing information about all nodes and links in the scene.
*   `sceneSession`: an instance of `SceneSession`, which holds information about the scene's state, including UI-related data.

### Signals

None.

### Functions

None.

### Example Usage in QML

To use `HelpersView` in a QML file, simply import the necessary modules and create an instance of the component:

```qml
import QtQuick
import NodeLink

Item {
    // ...
    HelpersView {
        scene: myScene
        sceneSession: mySceneSession
        anchors.fill: parent
    }
    // ...
}
```

### Extension/Override Points

To extend or customize the behavior of `HelpersView`, consider the following:

*   Create custom helper views by adding new child components to `HelpersView`.
*   Override the `z` property to adjust the stacking order of `HelpersView` in relation to other components.

### Caveats or Assumptions

*   The `scene` and `sceneSession` properties are expected to be valid instances of `I_Scene` and `SceneSession`, respectively.
*   The component assumes that its parent provides a sufficient area for it to fill.

### Related Components

The following components are closely related to `HelpersView`:

*   `I_Scene`: the main model for nodes and links.
*   `SceneSession`: the model for scene state and UI-related data.
*   `SelectionHelperView`: handles selection-related helpers.
*   `LinkHelperView`: displays user connection curves.

## ConfirmPopup.qml
### Overview

The `ConfirmPopup.qml` component is a customizable popup dialog used to confirm user actions. It provides a simple way to display a confirmation message to the user, allowing them to either accept or cancel the action.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, the `ConfirmPopup.qml` component serves as a view, responsible for displaying the confirmation dialog to the user. It receives input from the controller and emits signals to notify the controller of the user's response.

### Component Description

The `ConfirmPopup.qml` component is an `Item` that displays a confirmation dialog with a message, two buttons (accept and cancel), and optional custom content.

### Properties

| Property Name | Type | Description |
| --- | --- | --- |
| `message` | string | The confirmation message to display to the user. |
| `acceptButtonText` | string | The text to display on the accept button. Default is "OK". |
| `cancelButtonText` | string | The text to display on the cancel button. Default is "Cancel". |
| `showAcceptButton` | bool | Whether to show the accept button. Default is `true`. |
| `showCancelButton` | bool | Whether to show the cancel button. Default is `true`. |

### Signals

| Signal Name | Description |
| --- | --- |
| `accepted()` | Emitted when the user accepts the confirmation. |
| `canceled()` | Emitted when the user cancels the confirmation. |

### Functions

| Function Name | Description |
| --- | --- |
| `open()` | Opens the confirmation dialog. |
| `close()` | Closes the confirmation dialog. |

### Example Usage in QML

```qml
import QtQuick 2.12

ApplicationWindow {
    id: window
    visible: true

    ConfirmPopup {
        id: confirmPopup
        message: "Are you sure you want to delete this item?"
        onAccepted: console.log("Confirmed")
        onCanceled: console.log("Canceled")
    }

    Button {
        text: "Show Confirm Popup"
        onClicked: confirmPopup.open()
    }
}
```

### Extension/Override Points

To customize the appearance or behavior of the `ConfirmPopup.qml` component, you can override the following:

* The `content` property to add custom content to the dialog.
* The `acceptButton` and `cancelButton` properties to customize the buttons.

### Caveats or Assumptions

* The `ConfirmPopup.qml` component assumes that it will be used within a QML context that provides a valid `Window` or `ApplicationWindow`.
* The component does not handle keyboard navigation or accessibility features.

### Related Components

* `MessageDialog.qml`: A similar dialog component for displaying messages to the user.
* `NodeLinkController`: The controller class that interacts with the `ConfirmPopup.qml` component.

## HashCompareStringCPP.cpp
### Overview

The `HashCompareStringCPP` class is a Qt-based utility class designed to compare two string models by generating their hash values using the MD5 algorithm. This class fits into the NodeLink MVC architecture as a supporting utility component, providing a specific functionality that can be used across various models.

### Purpose and Architecture Fit

The primary purpose of `HashCompareStringCPP` is to enable efficient and secure comparison of string models. By utilizing hash values, it avoids direct string-to-string comparisons, which can be beneficial in scenarios where strings are large or when performance is critical. In the context of the NodeLink MVC architecture, this class serves as a tool that can be leveraged by model components to compare string data securely and efficiently.

### Class Description

The `HashCompareStringCPP` class is a subclass of `QObject`, allowing it to integrate seamlessly into Qt and QML applications. It provides a single public function for comparing two string models.

### Properties

None.

### Signals

None.

### Functions

#### `bool compareStringModels(QString strModelFirst, QString strModelSecound)`

Compares two string models by generating their MD5 hash values and checking if they are equal.

- **Parameters:**
  - `strModelFirst`: The first string model to compare.
  - `strModelSecound`: The second string model to compare.
- **Returns:** `true` if the hash values of both string models are equal, `false` otherwise.

### Example Usage in QML

To use `HashCompareStringCPP` in QML, you need to create an instance of it in C++ and expose it to the QML context. Here's a basic example:

```cpp
// In main.cpp or where your QML context is set up
#include "HashCompareStringCPP.h"

int main(int argc, char *argv[]) {
    // ...
    HashCompareStringCPP hashComparator;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("hashComparator", &hashComparator);
    // ...
}
```

Then, in your QML:

```qml
import QtQuick 2.15

Item {
    function compareStrings(str1, str2) {
        return hashComparator.compareStringModels(str1, str2)
    }

    // Example usage
    onCompleted: console.log("Are strings equal?", compareStrings("Hello", "Hello"))
}
```

### Extension/Override Points

- To use a different hashing algorithm, you can modify the `algorithm` variable in the `compareStringModels` function or make it a parameter of the function.
- For more complex comparison logic, consider subclassing `HashCompareStringCPP` and overriding the `compareStringModels` function.

### Caveats or Assumptions

- This class uses the MD5 hashing algorithm, which is considered fast but not cryptographically secure for all purposes. Choose a different algorithm if security is a concern.
- The comparison is case-sensitive and considers the string's encoding.

### Related Components

- `QCryptographicHash`: The Qt class used for generating hash values.
- Other utility classes within the NodeLink MVC architecture that might leverage `HashCompareStringCPP` for data comparison.

## NLUtilsCPP.cpp
### Overview

The `NLUtilsCPP` class provides a set of utility functions for common tasks, such as converting image URLs to base64-encoded strings and key sequences to human-readable strings. This class is part of the NodeLink MVC architecture and serves as a supporting component for various NodeLink features.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `NLUtilsCPP` acts as a utility class that provides helper functions for other components. It does not directly interact with the Model or View but instead offers a set of reusable functions that can be used throughout the application.

### Class Description

The `NLUtilsCPP` class is a QObject-based class that provides the following functionality:

* Conversion of image URLs to base64-encoded strings
* Conversion of key sequences to human-readable strings

### Properties

The `NLUtilsCPP` class does not have any properties.

### Signals

The `NLUtilsCPP` class does not emit any signals.

### Functions

#### `imageURLToImageString(QString url)`

* **Purpose:** Converts an image URL to a base64-encoded string.
* **Parameters:**
	+ `url`: The URL of the image to convert.
* **Return Value:** A base64-encoded string representing the image, or an empty string if the conversion fails.

#### `keySequenceToString(int keySequence)`

* **Purpose:** Converts a key sequence to a human-readable string.
* **Parameters:**
	+ `keySequence`: The key sequence to convert, represented as a QKeySequence::StandardKey value.
* **Return Value:** A human-readable string representing the key sequence.

### Example Usage in QML

To use the `NLUtilsCPP` class in QML, you need to create an instance of the class and expose it to the QML context. Here's an example:

```qml
import QtQuick 2.12
import NodeLink 1.0

Item {
    id: root

    // Create an instance of NLUtilsCPP
    property NLUtilsCPP utils: NLUtilsCPP {}

    // Convert an image URL to a base64-encoded string
    property string imageString: utils.imageURLToImageString("path/to/image.png")

    // Convert a key sequence to a human-readable string
    property string keySequenceString: utils.keySequenceToString(QKeySequence.Copy)
}
```

### Extension/Override Points

To extend or override the functionality of the `NLUtilsCPP` class, you can:

* Subclass `NLUtilsCPP` and add new functions or override existing ones.
* Use the `NLUtilsCPP` class as a starting point and create a new utility class with similar functionality.

### Caveats or Assumptions

* The `imageURLToImageString` function assumes that the provided URL points to a file that can be read. If the file cannot be read, an empty string is returned.
* The `keySequenceToString` function uses the QKeySequence::NativeText format to generate the human-readable string.

### Related Components

The `NLUtilsCPP` class is related to other NodeLink components, such as:

* `NLImageViewer`: A component that displays images and may use the `imageURLToImageString` function to convert image URLs to base64-encoded strings.
* `NLShortcutManager`: A component that manages keyboard shortcuts and may use the `keySequenceToString` function to generate human-readable strings for shortcut keys.


## NLUtilsCPP.h
### Overview

The `NLUtilsCPP` class provides a set of utility functions for converting and processing data in the NodeLink application. It is designed to be used in conjunction with the NodeLink MVC architecture, providing a bridge between C++ and QML.

### NodeLink MVC Architecture

In the NodeLink MVC architecture, `NLUtilsCPP` serves as a utility class that provides functionality to the Model or Controller components. It does not directly interact with the View, but rather provides functions that can be used by the Model or Controller to process data.

### Class Description

The `NLUtilsCPP` class is a QObject-based class that provides two utility functions: `imageURLToImageString` and `keySequenceToString`. These functions can be invoked from QML using the `Q_INVOKABLE` macro.

### Properties

None.

### Signals

None.

### Functions

#### `imageURLToImageString(QString url)`

*   **Description:** Reads an image file and converts it to a QString (UTF8).
*   **Parameters:**
    *   `url`: The URL of the image file to read.
*   **Return Value:** A QString representing the image data in UTF8 format.

#### `keySequenceToString(int keySequence)`

*   **Description:** Converts a QKeySequence::StandardKey to a QString.
*   **Parameters:**
    *   `keySequence`: The QKeySequence::StandardKey to convert.
*   **Return Value:** A QString representing the key sequence.

### Example Usage in QML

```qml
import QtQuick 2.15
import NodeLink 1.0

Item {
    id: root

    // Create an instance of NLUtilsCPP
    property NLUtilsCPP utils: NLUtilsCPP {}

    // Convert an image URL to a string
    property string imageString: utils.imageURLToImageString("path/to/image.png")

    // Convert a key sequence to a string
    property string keySequenceString: utils.keySequenceToString(Qt.Key_A)
}
```

### Extension/Override Points

To extend or override the functionality of `NLUtilsCPP`, you can:

*   Subclass `NLUtilsCPP` and add new functions or override existing ones.
*   Use a different utility class that provides similar functionality.

### Caveats or Assumptions

*   The `imageURLToImageString` function assumes that the image file can be read and converted to a QString.
*   The `keySequenceToString` function assumes that the QKeySequence::StandardKey is valid.

### Related Components

*   `NLModel`: The Model component that uses `NLUtilsCPP` to process data.
*   `NLController`: The Controller component that uses `NLUtilsCPP` to process data.

### Registration

The `NLUtilsCPP` class is registered with the QML engine using the `QML_ELEMENT` macro. To use this class in QML, ensure that the NodeLink module is imported.

### Notes

*   The `QML_SINGLETON` macro is currently commented out, indicating that `NLUtilsCPP` is not intended to be used as a singleton. If you need to use it as a singleton, uncomment this macro.