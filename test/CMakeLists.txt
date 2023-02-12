if (Qt6_FOUND)
  find_package(Qt6 COMPONENTS Test)
  set(Qt Qt)
else()
  find_package(Qt5 COMPONENTS Test)
  set(Qt Qt5)
endif()

add_executable(test_nodes
  test_main.cpp
)

target_include_directories(test_nodes
  PRIVATE
    ../src
    ../include
    include
)

target_link_libraries(test_nodes
  PRIVATE
    NodeLink::NodeLink
    ${Qt}::Test
)

add_test(
  NAME test_nodes
  COMMAND
    $<TARGET_FILE:test_nodes>
    $<$<BOOL:${NE_FORCE_TEST_COLOR}>:--use-colour=yes>
)
