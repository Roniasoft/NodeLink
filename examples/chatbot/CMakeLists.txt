cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

list(APPEND QML_IMPORT_PATH ${CMAKE_BINARY_DIR}/qml)


qt_add_executable(Chatbot main.cpp)

set_source_files_properties(
    resources/Core/CSpecs.qml

    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

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

        resources/View/ChatbotView.qml
        resources/View/ChatbotNodeView.qml

   SOURCES

   RESOURCES
       resources/fonts/Font\ Awesome\ 6\ Pro-Thin-100.otf
       resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf
       resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
       resources/fonts/Font\ Awesome\ 6\ Pro-Light-300.otf
)

target_include_directories(Chatbot PUBLIC
    Qt${QT_VERSION_MAJOR}::QuickControls2)

target_compile_definitions(Chatbot
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(Chatbot PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::QuickControls2
    NodeLinkplugin
    QtQuickStreamplugin
)
