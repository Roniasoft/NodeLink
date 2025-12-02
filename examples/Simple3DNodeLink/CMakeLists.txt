cmake_minimum_required(VERSION 3.1.0)

# Require C++14
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 Quick3D REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 Quick3D REQUIRED)
message(${CMAKE_BINARY_DIR}/qml/NodeLink/resources/View)
set (QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml/NodeLink/resources/View)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# Creates and finalizes an application target of a platform-specific type
qt_add_executable(Simple3DNodeLink main.cpp)

# This command defines a QML module that can consist of C++ sources, .qml files, or both.
qt_add_qml_module(Simple3DNodeLink
    URI "Simple3DNodeLink"
    VERSION 1.0
    DEPENDENCIES
        NodeLink
        QtQuickStream

   QML_FILES
    main.qml
    resources/Core/Simple3DNodeLinkScene.qml
    resources/Core/SourceNode.qml
    resources/Core/ResultNode.qml
    resources/Core/Specs.qml
    resources/View/Simple3DNodeLinkView.qml
    resources/View/Simple3DNodeLinkNodeView.qml
    resources/View/Simple3DNodeLinkNodeView2D.qml
    resources/View/LinkHelperView3D.qml
    resources/View/ContextMenu3D.qml

   RESOURCES
    resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
    resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
    resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
    resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf

   SOURCES

)

target_include_directories(Simple3DNodeLink PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_compile_definitions(Simple3DNodeLink
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(Simple3DNodeLink PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    Qt${QT_VERSION_MAJOR}::Quick3D
    NodeLinkplugin
    QtQuickStreamplugin
)

#set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY} CACHE STRING "QtCreator QML Modules Lookup")

