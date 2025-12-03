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
qt_add_executable(Multiple3DEditors main.cpp)

# This command defines a QML module that can consist of C++ sources, .qml files, or both.
qt_add_qml_module(Multiple3DEditors
    URI "Multiple3DEditors"
    VERSION 1.0
    DEPENDENCIES
        NodeLink
        QtQuickStream

   QML_FILES
    main.qml
    resources/Core/Multiple3DEditorsScene.qml
    resources/View/Multiple3DEditorsView.qml
    resources/View/PropertyPanel.qml
    resources/View/Custom3DNode.qml

   RESOURCES
    resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
    resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
    resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
    resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf

   SOURCES

)

target_include_directories(Multiple3DEditors PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_compile_definitions(Multiple3DEditors
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(Multiple3DEditors PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    Qt${QT_VERSION_MAJOR}::Quick3D
    NodeLinkplugin
    QtQuickStreamplugin
)

