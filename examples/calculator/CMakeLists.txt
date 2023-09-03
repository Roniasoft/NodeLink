cmake_minimum_required(VERSION 3.1.0)

# Require C++14
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Creates and finalizes an application target of a platform-specific type
qt_add_executable(Calculator main.cpp)

# Extra QML File properties
set_source_files_properties(
    resources/Core/CSpecs.qml

    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)


# This command defines a QML module that can consist of C++ sources, .qml files, or both.
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

   SOURCES

   RESOURCES
       resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
       resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
       resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
       resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf


)

target_include_directories(Calculator PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_compile_definitions(Calculator
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(Calculator PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
