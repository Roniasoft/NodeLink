cmake_minimum_required(VERSION 3.16)

#The Library name
project(NodeLink VERSION 1.0 LANGUAGES CXX)

# ##################################################################################################
# Project Settings
# ##################################################################################################


set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set (QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR})


#message(${QML_IMPORT_PATH})
#Turns on default settings for development of NodeLink
set(DEVELOPER_DEFAULTS ON)

option(BUILD_TESTING "Build tests" ${DEVELOPER_DEFAULTS})
option(BUILD_EXAMPLES "Build Examples" ${DEVELOPER_DEFAULTS})
option(BUILD_SHARED_LIBS "Build as shared library" ON)
option(BUILD_DEBUG_POSTFIX_D "Append d suffix to debug libraries" OFF)

# ##################################################################################################
# Dependencies
# ##################################################################################################
# Find the Qt libraries

# QtQuickStream to save and load project.
add_subdirectory(QtQuickStream)

find_package(Qt6
  COMPONENTS
   Quick
)

if (NOT Qt6_FOUND)
  find_package(Qt5 QUIET
    COMPONENTS
    Quick
  )
endif()


if (NOT (Qt6_FOUND OR Qt5_FOUND))
  message(FATAL_ERRROR "Qt libraries were not found.")
endif()


if (Qt6_FOUND)
  set(Qt Qt)
else()
  set(Qt Qt5)
endif()


# ##################################################################################################
# Project Files
# ##################################################################################################
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# Library Definition
qt_add_library(NodeLink STATIC)

# Extra QML File properties
set_source_files_properties(
    resources/Core/NLCore.qml
    resources/Core/NLSpec.qml
    resources/View/NLStyle.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE True
)

qt_add_qml_module(NodeLink
    URI "NodeLink"
    VERSION 1.0

    QML_FILES
        resources/Core/NLCore.qml
        resources/Core/NLSpec.qml
        resources/Core/Node.qml
        resources/Core/Action.qml
        resources/Core/Port.qml
        resources/Core/ActionItem.qml
        resources/Core/GeneralNode.qml
        resources/Core/RootNode.qml
        resources/Core/Scene.qml
        resources/Core/SelectionModel.qml
        resources/Core/NodeGuiConfig.qml

        resources/View/Components/ColorPicker/ColorItem.qml
        resources/View/Components/ColorPicker/ColorPicker.qml
        resources/View/Components/NLToolButton.qml
        resources/View/Components/ConfirmPopUp.qml
        resources/View/NLView.qml
        resources/View/SceneSession.qml
        resources/View/NLStyle.qml
        resources/View/PortView.qml
        resources/View/NodeView.qml
        resources/View/NodesRect.qml
        resources/View/NodesScene.qml
        resources/View/NodesOverview.qml
        resources/View/ConnectionView.qml    
        resources/View/SceneViewBackground.qml
        resources/View/Widgets/NodeToolsRect.qml
        resources/View/Widgets/SideMenu.qml
        resources/View/Components/SideMenuButtonGroup.qml
        resources/View/Components/SideMenuButton.qml
        resources/View/Components/ContextMenu.qml
        resources/View/Components/ContextMenuItem.qml
        resources/View/Components/NLToolTip.qml
        resources/View/Components/VerticalScrollBar.qml
        resources/View/Components/HorizontalScrollBar.qml

    SOURCES
	

    RESOURCES
        resources/fonts/Font\ Awesome\ 6\ Pro-Regular-400.otf
        resources/fonts/Font\ Awesome\ 6\ Pro-Solid-900.otf

)
	
#Add a library to the project using the specified source file
#add_library(NodeLink::NodeLink ALIAS NodeLink)

target_include_directories(NodeLink
  PUBLIC
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/resources>
  PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/NodeLink>
)

#Definitions of preprocessor macros
target_compile_definitions(NodeLink
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(NodeLink
  PRIVATE
    ${Qt}::Quick
    QtQuickStreamplugin
)

set_target_properties(NodeLink PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

install(TARGETS NodeLink
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY} CACHE STRING "QtCreator QML Modules Lookup")

if(${BUILD_EXAMPLES})
  add_subdirectory(examples)
endif()

if(BUILD_TESTING)
#  add_subdirectory(test)
endif()
