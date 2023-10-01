cmake_minimum_required(VERSION 3.1.0)

# Require C++14
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)
message(${CMAKE_BINARY_DIR}/qml/NodeLink/resources/View)
set (QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml/NodeLink/resources/View)
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# Creates and finalizes an application target of a platform-specific type
qt_add_executable(simpleNodeLink main.cpp)

# Extra QML File properties
set_source_files_properties(
    SNLSpecs.qml

    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

# This command defines a QML module that can consist of C++ sources, .qml files, or both.
qt_add_qml_module(simpleNodeLink
    URI "simpleNodeLink"
    VERSION 1.0

   QML_FILES
    main.qml
    SNLSpecs.qml

   SOURCES

)

target_include_directories(simpleNodeLink PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_compile_definitions(simpleNodeLink
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(simpleNodeLink PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)


#set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY} CACHE STRING "QtCreator QML Modules Lookup")
