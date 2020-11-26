cmake_minimum_required(VERSION 3.15.1)

project(01_STM32L VERSION 0.0.1 LANGUAGES C ASM)
set(CMAKE_VERBOSE_MAKEFILE TRUE)

#cmake specific
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../../cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../cmake)

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
message( STATUS "Project:           ${PROJECT_NAME}")
message( STATUS "Version:           ${PROJECT_VERSION}")
message( STATUS "=============================================================================" )
message( STATUS )

#ChibiOS
include(ChibiOS)

set(EXECUTABLE ${PROJECT_NAME}.elf)

add_executable(${EXECUTABLE}
		${CHIBIOS_STARTUP_SRC}
		${CHIBIOS_STARTUP_ASM}
		${CHIBIOS_HAL_SRC}
		${CHIBIOS_HAL_PLATFORM_SRC}
		${CHIBIOS_CORE_SRC}
		${CHIBIOS_PORT_SRC}
		${CHIBIOS_PORT_ASM}
		${CHIBIOS_OTHERS_SRC}
		${CHIBIOS_TEST_SRC}
		${CMAKE_CURRENT_SOURCE_DIR}/main.c
		${CMAKE_CURRENT_SOURCE_DIR}/chconf.h
		${CMAKE_CURRENT_SOURCE_DIR}/halconf.h
		${CMAKE_CURRENT_SOURCE_DIR}/mcuconf.h
		${CHIBIOS}/os/common/ports/ARMCMx/chcore_timer.h
		)

set(SOURCE
		${CHIBIOS_STARTUP_SRC}
		${CHIBIOS_STARTUP_ASM}
		${CHIBIOS_HAL_SRC}
		${CHIBIOS_HAL_PLATFORM_SRC}
		${CHIBIOS_CORE_SRC}
		${CHIBIOS_PORT_SRC}
		${CHIBIOS_PORT_ASM}
		${CHIBIOS_OTHERS_SRC}
		${CHIBIOS_TEST_SRC}
		${CMAKE_CURRENT_SOURCE_DIR}/main.c
		${CMAKE_CURRENT_SOURCE_DIR}/chconf.h
		${CMAKE_CURRENT_SOURCE_DIR}/halconf.h
		${CMAKE_CURRENT_SOURCE_DIR}/mcuconf.h
		)

foreach(FILE ${SOURCE})
	get_filename_component(FILENAME ${FILE}
			NAME
			)
	set_source_files_properties (${FILE}
			PROPERTIES
			COMPILE_FLAGS "-Wa,-alms=${CMAKE_BINARY_DIR}/${FILENAME}.lst")
	message(STATUS "${FILE} -->> ${CMAKE_BINARY_DIR}/${FILENAME}.lst")
endforeach(FILE in ${SOURCE})

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

target_include_directories(${EXECUTABLE} PUBLIC
		${CMAKE_CURRENT_SOURCE_DIR}
		${CHIBIOS_LIC_INC}
		${CHIBIOS_STARTUP_INC}
		${CHIBIOS_HAL_INC}
		${CHIBIOS_HAL_PLATFORM_INC}
		${CHIBIOS_CORE_INC}
		${CHIBIOS_PORT_INC}
		${CHIBIOS_OTHERS_INC}
		${CHIBIOS_TEST_INC}
		${CHIBIOS_STARTUP_LD}
        )

target_link_libraries(${EXECUTABLE}
		)

target_compile_options(${EXECUTABLE} PUBLIC
		-c
		-mcpu=cortex-m3 -mthumb -O2 -ggdb
		-fomit-frame-pointer -falign-functions=16 -ffunction-sections -fdata-sections -fno-common -flto
		-Wall -Wextra -Wundef -Wstrict-prototypes
		-DCORTEX_USE_FPU=FALSE  -MD -MP
		#-fno-common
		#-Og
       # $<$<CONFIG:Debug>:-g -gdwarf-2>
        )

IF(NOT CHIBIOS_PROCESS_STACK_SIZE)
	SET(CHIBIOS_PROCESS_STACK_SIZE 0x400)
	MESSAGE(STATUS "No CHIBIOS_PROCESS_STACK_SIZE specified, using default: ${CHIBIOS_PROCESS_STACK_SIZE}")
ENDIF()

IF(NOT CHIBIOS_MAIN_STACK_SIZE)
	SET(CHIBIOS_MAIN_STACK_SIZE 0x400)
	MESSAGE(STATUS "No CHIBIOS_MAIN_STACK_SIZE specified, using default: ${CHIBIOS_MAIN_STACK_SIZE}")
ENDIF()

target_link_options(${EXECUTABLE} PUBLIC
		-L ${CHIBIOS_STARTUP_LD}
		-T ${CHIBIOS_STARTUP_LD}/STM32L152xB.ld
        #-specs=nano.specs
        #-lc
        #-lm
        #-lnosys
		-mcpu=cortex-m3
		-mthumb
		-O2
		-ggdb
		-fomit-frame-pointer
		-falign-functions=16
		-ffunction-sections
		-fdata-sections
		-fno-common
		-flto
		-nostartfiles
		-Wl,--defsym=__process_stack_size__=${CHIBIOS_PROCESS_STACK_SIZE}
		-Wl,--defsym=__main_stack_size__=${CHIBIOS_MAIN_STACK_SIZE}
        -Wl,-Map=${PROJECT_NAME}.map,--cref,--no-warn-mismatch
		-Wl,--gc-sections
        )

# Print executable size
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-size ${EXECUTABLE})

# Create hex file
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${EXECUTABLE} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${EXECUTABLE} ${PROJECT_NAME}.bin)
