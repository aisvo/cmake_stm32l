#ChibiOS Specific implementation
message( STATUS "Configuring ChibiOS...                                                    " )
message( STATUS "............................................................................." )

#ChibiOS
set(CHIBIOS ${CMAKE_CURRENT_SOURCE_DIR}/ChibiOS)
message( STATUS "ChibiOS Root = ${CHIBIOS}")

#LICENSING
message( STATUS "Licensing files")
set(CHIBIOS_LIC_INC
        ${CHIBIOS}/os/license
        )
message( STATUS "  ${CHIBIOS_LIC_INC}")

#STARTUP
message( STATUS "Startup files STM32L1xx and CMSIS files")
set(CHIBIOS_STARTUP_SRC
        ${CHIBIOS}/os/common/startup/ARMCMx/compilers/GCC/crt1.c
        )
set(CHIBIOS_STARTUP_ASM
        ${CHIBIOS}/os/common/startup/ARMCMx/compilers/GCC/crt0_v7m.S
        ${CHIBIOS}/os/common/startup/ARMCMx/compilers/GCC/vectors.S
        )
set(CHIBIOS_STARTUP_INC
        ${CHIBIOS}/os/common/portability/GCC
        ${CHIBIOS}/os/common/startup/ARMCMx/compilers/GCC
        ${CHIBIOS}/os/common/startup/ARMCMx/devices/STM32L1xx
        ${CHIBIOS}/os/common/ext/ARM/CMSIS/Core/Include
        ${CHIBIOS}/os/common/ext/ST/STM32L1xx
        )
set(CHIBIOS_STARTUP_LD
        ${CHIBIOS}/os/common/startup/ARMCMx/compilers/GCC/ld
        )
message( STATUS "  ${CHIBIOS_STARTUP_SRC}")
message( STATUS "  ${CHIBIOS_STARTUP_ASM}")
message( STATUS "  ${CHIBIOS_STARTUP_INC}")
message( STATUS "  ${CHIBIOS_STARTUP_LD}")

#HAL-OSAL GENERIC
message( STATUS "Generic HAL/OSAL")
set(CHIBIOS_HAL_SRC
        ${CHIBIOS}/os/hal/src/hal.c
        ${CHIBIOS}/os/hal/src/hal_buffers.c
        ${CHIBIOS}/os/hal/src/hal_queues.c
        ${CHIBIOS}/os/hal/src/hal_flash.c
        ${CHIBIOS}/os/hal/src/hal_mmcsd.c
        ${CHIBIOS}/os/hal/src/hal_adc.c
        ${CHIBIOS}/os/hal/src/hal_can.c
        ${CHIBIOS}/os/hal/src/hal_crypto.c
        ${CHIBIOS}/os/hal/src/hal_dac.c
        ${CHIBIOS}/os/hal/src/hal_efl.c
        ${CHIBIOS}/os/hal/src/hal_gpt.c
        ${CHIBIOS}/os/hal/src/hal_i2c.c
        ${CHIBIOS}/os/hal/src/hal_i2s.c
        ${CHIBIOS}/os/hal/src/hal_icu.c
        ${CHIBIOS}/os/hal/src/hal_mac.c
        ${CHIBIOS}/os/hal/src/hal_mmc_spi.c
        ${CHIBIOS}/os/hal/src/hal_pal.c
        ${CHIBIOS}/os/hal/src/hal_pwm.c
        ${CHIBIOS}/os/hal/src/hal_rtc.c
        ${CHIBIOS}/os/hal/src/hal_sdc.c
        ${CHIBIOS}/os/hal/src/hal_serial.c
        ${CHIBIOS}/os/hal/src/hal_serial_usb.c
        ${CHIBIOS}/os/hal/src/hal_sio.c
        ${CHIBIOS}/os/hal/src/hal_spi.c
        ${CHIBIOS}/os/hal/src/hal_trng.c
        ${CHIBIOS}/os/hal/src/hal_uart.c
        ${CHIBIOS}/os/hal/src/hal_usb.c
        ${CHIBIOS}/os/hal/src/hal_wdg.c
        ${CHIBIOS}/os/hal/src/hal_wspi.c
        )
set(CHIBIOS_HAL_INC
        ${CHIBIOS}/os/hal/include
        )
message( STATUS "  ${CHIBIOS_HAL_SRC}")
message( STATUS "  ${CHIBIOS_HAL_INC}")

#HAL-OSAL PLATFORM PORT (STM32L1xx)
message( STATUS "Platform HAL/OSAL (STM32L1xx)")
#Required Platform files
set(CHIBIOS_HAL_PLATFORM_SRC
        ${CHIBIOS}/os/hal/ports/common/ARMCMx/nvic.c
        ${CHIBIOS}/os/hal/ports/STM32/STM32L1xx/stm32_isr.c
        ${CHIBIOS}/os/hal/ports/STM32/STM32L1xx/hal_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/STM32L1xx/hal_adc_lld.c
        )
set(CHIBIOS_HAL_PLATFORM_INC
        ${CHIBIOS}/os/hal/ports/common/ARMCMx
        ${CHIBIOS}/os/hal/ports/STM32/STM32L1xx
        )
# Platform compatible drivers
# DACv1, DMAv1, EXTIv1, GPIOv2, I2Cv1, RTCv2, SPIv1, TIMv1, USARTv1, USBv1, xWDGv1
LIST(APPEND CHIBIOS_HAL_PLATFORM_SRC
        ${CHIBIOS}/os/hal/ports/STM32/LLD/DACv1/hal_dac_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/DMAv1/stm32_dma.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/EXTIv1/stm32_exti.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/GPIOv2/hal_pal_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/I2Cv1/hal_i2c_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/RTCv2/hal_rtc_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/SPIv1/hal_i2s_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/SPIv1/hal_spi_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/TIMv1/hal_gpt_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/TIMv1/hal_icu_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/TIMv1/hal_pwm_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/USARTv1/hal_serial_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/USARTv1/hal_uart_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/USBv1/hal_usb_lld.c
        ${CHIBIOS}/os/hal/ports/STM32/LLD/xWDGv1/hal_wdg_lld.c
        )
LIST(APPEND CHIBIOS_HAL_PLATFORM_INC
        ${CHIBIOS}/os/hal/ports/STM32/LLD/DACv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/DMAv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/EXTIv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/GPIOv2
        ${CHIBIOS}/os/hal/ports/STM32/LLD/I2Cv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/RTCv2
        ${CHIBIOS}/os/hal/ports/STM32/LLD/SPIv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/TIMv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/USARTv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/USBv1
        ${CHIBIOS}/os/hal/ports/STM32/LLD/xWDGv1
        )
#BOARD (ST_STM32L_DISCOVERY)
LIST(APPEND CHIBIOS_HAL_PLATFORM_SRC
        ${CHIBIOS}/os/hal/boards/ST_STM32L_DISCOVERY/board.c
        )
LIST(APPEND CHIBIOS_HAL_PLATFORM_INC
        ${CHIBIOS}/os/hal/boards/ST_STM32L_DISCOVERY
        )
#OSAL
LIST(APPEND CHIBIOS_HAL_PLATFORM_SRC
        ${CHIBIOS}/os/hal/osal/rt-nil/osal.c
        )
LIST(APPEND CHIBIOS_HAL_PLATFORM_INC
        ${CHIBIOS}/os/hal/osal/rt-nil
        )
message( STATUS "  ${CHIBIOS_HAL_PLATFORM_SRC}")
message( STATUS "  ${CHIBIOS_HAL_PLATFORM_INC}")

#RTOS
message( STATUS "RTOS")
set(CHIBIOS_CORE_SRC
        ${CHIBIOS}/os/rt/src/chsys.c
        ${CHIBIOS}/os/rt/src/chdebug.c
        ${CHIBIOS}/os/rt/src/chtrace.c
        ${CHIBIOS}/os/rt/src/chvt.c
        ${CHIBIOS}/os/rt/src/chschd.c
        ${CHIBIOS}/os/rt/src/chthreads.c
        ${CHIBIOS}/os/rt/src/chtm.c
        ${CHIBIOS}/os/rt/src/chstats.c
        ${CHIBIOS}/os/rt/src/chregistry.c
        ${CHIBIOS}/os/rt/src/chsem.c
        ${CHIBIOS}/os/rt/src/chmtx.c
        ${CHIBIOS}/os/rt/src/chcond.c
        ${CHIBIOS}/os/rt/src/chevents.c
        ${CHIBIOS}/os/rt/src/chmsg.c
        ${CHIBIOS}/os/rt/src/chdynamic.c
        )
set(CHIBIOS_CORE_INC
        ${CHIBIOS}/os/rt/include
        )
#OS-Lib
LIST(APPEND CHIBIOS_CORE_SRC
        ${CHIBIOS}/os/oslib/src/chmboxes.c
        ${CHIBIOS}/os/oslib/src/chmemcore.c
        ${CHIBIOS}/os/oslib/src/chmemheaps.c
        ${CHIBIOS}/os/oslib/src/chmempools.c
        ${CHIBIOS}/os/oslib/src/chpipes.c
        ${CHIBIOS}/os/oslib/src/chobjcaches.c
        ${CHIBIOS}/os/oslib/src/chdelegates.c
        ${CHIBIOS}/os/oslib/src/chfactory.c
        )
LIST(APPEND CHIBIOS_CORE_INC
        ${CHIBIOS}/os/oslib/include
        )

message( STATUS "  ${CHIBIOS_CORE_SRC}")
message( STATUS "  ${CHIBIOS_CORE_INC}")

#PORT
message( STATUS "PORT")
set(CHIBIOS_PORT_SRC
        ${CHIBIOS}/os/common/ports/ARMCMx/chcore.c
        ${CHIBIOS}/os/common/ports/ARMCMx/chcore_v7m.c
        )
set(CHIBIOS_PORT_ASM
        ${CHIBIOS}/os/common/ports/ARMCMx/compilers/GCC/chcoreasm_v7m.S
        )
set(CHIBIOS_PORT_INC
        ${CHIBIOS}/os/common/ports/ARMCMx
        ${CHIBIOS}/os/common/ports/ARMCMx/compilers/GCC
        )
message( STATUS "  ${CHIBIOS_PORT_SRC}")
message( STATUS "  ${CHIBIOS_PORT_ASM}")
message( STATUS "  ${CHIBIOS_PORT_INC}")

#Test files
message( STATUS "TEST")
set(CHIBIOS_TEST_SRC
        ${CHIBIOS}/test/lib/ch_test.c
        ${CHIBIOS}/test/rt/source/test/rt_test_root.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_001.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_002.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_003.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_004.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_005.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_006.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_007.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_008.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_009.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_010.c
        ${CHIBIOS}/test/rt/source/test/rt_test_sequence_011.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_root.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_001.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_002.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_003.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_004.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_005.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_006.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_007.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_008.c
        ${CHIBIOS}/test/oslib/source/test/oslib_test_sequence_009.c
        )
set(CHIBIOS_TEST_INC
        ${CHIBIOS}/test/lib
        ${CHIBIOS}/test/rt/source/test
        ${CHIBIOS}/test/oslib/source/test
        )
message( STATUS "  ${CHIBIOS_TEST_SRC}")
message( STATUS "  ${CHIBIOS_TEST_INC}")

message( STATUS "............................................................................." )