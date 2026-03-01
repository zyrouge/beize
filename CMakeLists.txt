cmake_minimum_required(VERSION 3.20)

project(beize
    VERSION 0.0.1
    DESCRIPTION "Beize Script"
    LANGUAGES C
)

option(BEIZE_BUILD_SHARED "Build shared library" OFF)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

file(GLOB_RECURSE BEIZE_SOURCES
    src/common/*.c
    src/compiler/*.c
    src/vm/*.c
)

file(GLOB_RECURSE BEIZE_CLI_SOURCES
    src/cli/*.c
)

if(BEIZE_BUILD_SHARED)
    add_library(beize SHARED ${BEIZE_SOURCES})
else()
    add_library(beize STATIC ${BEIZE_SOURCES})
endif()

target_include_directories(beize
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

target_compile_options(beize PRIVATE
    -Wall
    -Wextra
    -Wpedantic
)

add_executable(beize_cli ${BEIZE_CLI_SOURCES})

target_link_libraries(beize_cli PRIVATE beize)

include(GNUInstallDirs)

install(TARGETS beize
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
