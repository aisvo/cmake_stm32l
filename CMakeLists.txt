cmake_minimum_required(VERSION 3.15.1)

project(discoveryl152)

enable_language(C ASM)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)


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

set(EXECUTABLE ${PROJECT_NAME}.out)

add_executable(${EXECUTABLE} ${STM32CUBEMX_GENERATED_FILES})

target_compile_definitions(${EXECUTABLE} PRIVATE
        -DUSE_HAL_DRIVER
        -DSTM32L152xB
        )

target_include_directories(${EXECUTABLE} PRIVATE
        BSP/Inc
		BSP/Drivers/STM32L1xx_HAL_Driver/Inc
		BSP/Drivers/STM32L1xx_HAL_Driver/Inc/Legacy
		BSP/Drivers/CMSIS/Device/ST/STM32L1xx/Include
        BSP/Drivers/CMSIS/Include
        )

target_compile_options(${EXECUTABLE} PRIVATE
        -mcpu=cortex-m3
        -mthumb
        -fdata-sections
        -ffunction-sections
        -Wall
        $<$<CONFIG:Debug>:-Og>
        )

target_link_options(${EXECUTABLE} PRIVATE
        -T${CMAKE_SOURCE_DIR}/BSP/STM32L152RBTx_FLASH.ld
        -mcpu=cortex-m3
        -mthumb
        -specs=nano.specs
        -lc
        -lm
        -lnosys
        -Wl,-Map=${PROJECT_NAME}.map,--cref
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
