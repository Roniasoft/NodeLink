cmake_minimum_required(VERSION 3.8)

#The Library name
project(NodeLink VERSION 0.1 LANGUAGES CXX)

# ##################################################################################################
# Project Settings
# ##################################################################################################

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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
find_package(Qt6 QUIET
  COMPONENTS
   Core
   Quick
   Core5Compat
   Gui
   OpenGL
)

if (NOT Qt6_FOUND)
  find_package(Qt5 QUIET
    COMPONENTS
    Core
    Quick
    Core5Compat
    Gui
    OpenGL
  )
endif()


if (NOT (Qt6_FOUND OR Qt5_FOUND))
  message(FATAL_ERRROR "Qt libraries were not found.")
endif()


if (Qt6_FOUND)
  #qt_add_resources(RESOURCES ex.qrc)
  set(Qt Qt)
else()
  #qt5_add_resources(RESOURCES ex.qrc)
  set(Qt Qt5)
endif()


# ##################################################################################################
# Project Files
# ##################################################################################################

qt_add_qml_module(NodeLink
    URI "NodeLink"
    VERSION 1.0

    QML_FILES
	
	
    SOURCES
	
    RESOURCES
)
	
	
add_library(NodeLink::NodeLink ALIAS NodeLink)

target_include_directories(NodeLink
  PUBLIC
    $<INSTALL_INTERFACE:include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Source>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/NodeLink>
)

target_link_libraries(NodeLink
  PUBLIC
    ${Qt}::Core
    ${Qt}::OpenGL
    ${Qt}::Quick
    ${Qt}::Core5Compat
    ${Qt}::Gui
)

if(${BUILD_EXAMPLES})
  add_subdirectory(examples)
endif()

if(BUILD_TESTING)
#  add_subdirectory(test)
endif()
