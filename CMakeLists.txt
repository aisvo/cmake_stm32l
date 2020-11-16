cmake_minimum_required(VERSION 3.15.1)

project(discoveryl152 VERSION 0.0.1 LANGUAGES C CXX ASM)
set(CMAKE_VERBOSE_MAKEFILE TRUE)
#set(STM32_CHIP STM32F103C8)
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

#ChibiOS
#FIND_PACKAGE(ChibiOS 20.3 COMPONENTS rt hal st REQUIRED)
include(ChibiOS)

set(STM32CUBEMX_GENERATED_FILES

        BSP/Src/main.c
		BSP/Src/stm32l1xx_it.c
		BSP/Src/stm32l1xx_hal_msp.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_adc.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_adc_ex.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_rcc.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_rcc_ex.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_flash.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_flash_ex.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_flash_ramfunc.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_gpio.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_dma.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_pwr.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_pwr_ex.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_cortex.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_lcd.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_tim.c
		BSP/Drivers/STM32L1xx_HAL_Driver/Src/stm32l1xx_hal_tim_ex.c
		BSP/Src/system_stm32l1xx.c
        BSP/startup_stm32l152xb.s)

set(EXECUTABLE ${PROJECT_NAME}.elf)

#add_executable(${EXECUTABLE} ${STM32CUBEMX_GENERATED_FILES})
add_executable(${EXECUTABLE}
		${CHIBIOS_STARTUP_SRC}
		${CHIBIOS_STARTUP_ASM}
		${CHIBIOS_HAL_SRC}
		${CHIBIOS_HAL_PLATFORM_SRC}
		${CHIBIOS_CORE_SRC}
		${CHIBIOS_PORT_SRC}
		${CHIBIOS_PORT_ASM}
		${CHIBIOS_TEST_SRC}
		${CMAKE_SOURCE_DIR}/src/main.c
		)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

#target_compile_definitions(${EXECUTABLE} PRIVATE
#        -DUSE_HAL_DRIVER
#        -DSTM32L152xB
#        )

target_include_directories(${EXECUTABLE} PUBLIC
#        BSP/Inc
#		BSP/Drivers/STM32L1xx_HAL_Driver/Inc
#		BSP/Drivers/STM32L1xx_HAL_Driver/Inc/Legacy
#		BSP/Drivers/CMSIS/Device/ST/STM32L1xx/Include
#        BSP/Drivers/CMSIS/Include
		${CMAKE_SOURCE_DIR}/src/cfg
		${CHIBIOS_LIC_INC}
		${CHIBIOS_STARTUP_INC}
		${CHIBIOS_HAL_INC}
		${CHIBIOS_HAL_PLATFORM_INC}
		${CHIBIOS_CORE_INC}
		${CHIBIOS_PORT_INC}
		${CHIBIOS_TEST_INC}
		${CHIBIOS_STARTUP_LD}
        )

target_compile_options(${EXECUTABLE} PUBLIC
		-c
		-mcpu=cortex-m3 -mthumb -O2 -ggdb -fomit-frame-pointer -falign-functions=16 -ffunction-sections -fdata-sections -fno-common -flto  -Wall -Wextra -Wundef -Wstrict-prototypes
		-DCORTEX_USE_FPU=FALSE  -MD -MP
       # -mcpu=cortex-m3
       # -mthumb
       # -fdata-sections
       # -ffunction-sections
		#-fno-common
		#-Og
       # -Wall
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
        #-T${CMAKE_SOURCE_DIR}/BSP/STM32L152RBTx_FLASH.ld
		-L ${CHIBIOS_STARTUP_LD}
		-T ${CHIBIOS_STARTUP_LD}/STM32L152xB.ld
        #-mcpu=cortex-m3
        #-mthumb
        #-specs=nano.specs
		#-nostartfiles
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
