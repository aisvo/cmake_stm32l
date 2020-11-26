cmake_minimum_required(VERSION 3.15.1)

project(discoveryl152 VERSION 0.0.1 LANGUAGES C ASM)
set(CMAKE_VERBOSE_MAKEFILE TRUE)

#cmake specific
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Find includes in the build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

#Language Def
enable_language(C ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

message( STATUS )
message( STATUS "=============================================================================" )
message( STATUS "== STM32 ChibiOS  Build Information                                        ==" )
message( STATUS "=============================================================================" )
message( STATUS "Version:           ${PROJECT_VERSION}")
if (CMAKE_BUILD_TYPE)
	message( STATUS "Build type:        ${CMAKE_BUILD_TYPE}")
endif(CMAKE_BUILD_TYPE)
message( STATUS "Using compiler:    ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}" )
message( STATUS "Compiler predefs:  ${CMAKE_CXX_COMPILER_PREDEFINES_COMMAND}" )
message( STATUS "Architecture:      ${CMAKE_CXX_LIBRARY_ARCHITECTURE} / ${CMAKE_LIBRARY_ARCHITECTURE}" )
message( STATUS "C:                 ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}" )
message( STATUS "C Predefs:         ${CMAKE_C_COMPILER_PREDEFINES_COMMAND}" )
message( STATUS "C Architecture     ${CMAKE_C_LIBRARY_ARCHITECTURE} / ${CMAKE_LIBRARY_ARCHITECTURE}" )
message( STATUS "System Name:       ${CMAKE_SYSTEM_NAME}" )
message( STATUS "Processor Name:    ${CMAKE_SYSTEM_PROCESSOR}" )
message( STATUS "Installing to:     ${CMAKE_INSTALL_PREFIX}" )
message( STATUS "=============================================================================" )
message( STATUS )

#Projects
add_subdirectory(./projects/01)
add_subdirectory(./projects/02)
