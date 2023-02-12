cmake_minimum_required(VERSION 3.1.0)

# Require C++14
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)


# Configure Qt
find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Gui QuickControls2 REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Gui QuickControls2 REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(SOURCE_FILES
  main.cpp
)

set(HEADER_FILES
)

add_executable(simple ${SOURCE_FILES} simple.qrc)
target_include_directories(simple PUBLIC NodeLink Qt${QT_VERSION_MAJOR}::QuickControls2)
target_link_libraries(simple NodeLink Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Gui Qt${QT_VERSION_MAJOR}::QuickControls2)


#target_link_libraries(simple NodeLink)
