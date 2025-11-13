cmake_minimum_required(VERSION 3.1.0)

# Require C++14
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Creates and finalizes an application target of a platform-specific type
qt_add_executable(VisionLink 
    main.cpp
)

# Extra QML File properties
set_source_files_properties(
    resources/Core/CSpecs.qml
    resources/Core/ImageProcessor.qml

    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)


# This command defines a QML module that can consist of C++ sources, .qml files, or both.
qt_add_qml_module(VisionLink
    URI "VisionLink"
    VERSION 1.0

   QML_FILES
        main.qml

        resources/Core/CSpecs.qml
        resources/Core/ImageProcessor.qml
        resources/Core/OperationNode.qml
        resources/Core/OperationNodeData.qml
        resources/Core/ImageInputNode.qml
        resources/Core/VisionLinkScene.qml
        resources/Core/BlurOperationNode.qml
        resources/Core/BrightnessOperationNode.qml
        resources/Core/ContrastOperationNode.qml
        resources/Core/ImageResultNode.qml

        resources/View/VisionLinkNodeView.qml
        resources/View/VisionLinkView.qml

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

target_compile_definitions(VisionLink
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(VisionLink PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
