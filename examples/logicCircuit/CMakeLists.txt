cmake_minimum_required(VERSION 3.1.0)

set(MODULE_NAME LogicCircuit)

# Require C++14
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)

# Creates and finalizes an application target of a platform-specific type
qt_add_executable(${MODULE_NAME}
    main.cpp
)

# Extra QML File properties
set_source_files_properties(
    resources/Core/LSpecs.qml

    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# Define the QML module
qt_add_qml_module(${MODULE_NAME}
    URI "LogicCircuit"
    VERSION 1.0

    QML_FILES
        main.qml
        resources/Core/InputNode.qml
        resources/Core/LSpecs.qml
        resources/Core/OutputNode.qml
        resources/Core/AndNode.qml
        resources/Core/LogicCircuitScene.qml
        resources/Core/LogicNodeData.qml
        resources/Core/NotNode.qml
        resources/Core/OrNode.qml
        resources/View/LogicCircuitNodeView.qml
        resources/View/LogicCircuitView.qml

    SOURCES

    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
        QML_FILES resources/Core/LogicNode.qml

)

# Include Qt and NodeLink
target_include_directories(${MODULE_NAME} PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2
)

target_compile_definitions(${MODULE_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

# Link with required libraries
target_link_libraries(${MODULE_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
