set(SOURCE_FILES
  main.cpp
)

set(HEADER_FILES
)

add_executable(simple
  ${SOURCE_FILES}
  ${HEAEDR_FILES}
)

target_link_libraries(simple NodeLink)
