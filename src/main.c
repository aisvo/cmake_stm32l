/*
    ChibiOS - Copyright (C) 2006..2018 Giovanni Di Sirio

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#include "ch.h"
#include "hal.h"
#include "rt_test_root.h"
#include "oslib_test_root.h"

#include "chprintf.h"

/*
 * Blinker thread #1.
 */
static THD_WORKING_AREA(waThread1, 128);
static THD_FUNCTION(Thread1, arg) {

  (void)arg;

  chRegSetThreadName("blinker");
  while (true) {
    palSetPad(GPIOB, GPIOB_LED4);
    chThdSleepMilliseconds(250);
    palClearPad(GPIOB, GPIOB_LED4);
    chThdSleepMilliseconds(250);
  }
}

/*
 * Blinker thread #2.
 */
static THD_WORKING_AREA(waThread2, 128);
static THD_FUNCTION(Thread2, arg) {

  (void)arg;

  chRegSetThreadName("blinker");
  while (true) {
    palSetPad(GPIOB, GPIOB_LED3);
    chThdSleepMilliseconds(1500);
    palClearPad(GPIOB, GPIOB_LED3);
    chThdSleepMilliseconds(1500);
  }
}

/*
 * Thread 3: USART1 + I2C1
 * Printing MEMS
 */
static const I2CConfig i2ccfg = {
        OPMODE_I2C,
        400000,
        FAST_DUTY_CYCLE_2,
};
static const I2CConfig i2ccfg2 = {
        OPMODE_I2C,
        100000,
        STD_DUTY_CYCLE,
};
static THD_WORKING_AREA(waThread3, 128);
static THD_FUNCTION(Thread3, arg) {

    (void) arg;

    while (true) {

        chThdSleepMilliseconds(2000);
    }
}

/*
 * Application entry point.
 */
int main(void) {

  /*
   * System initializations.
   * - HAL initialization, this also initializes the configured device drivers
   *   and performs the board-specific initializations.
   * - Kernel initialization, the main() function becomes a thread and the
   *   RTOS is active.
   */
  halInit();
  chSysInit();

  /* Activates the serial driver 1 using the driver default configuration. */
  sdStart(&SD1, NULL);
  palSetPadMode(GPIOA, 9, PAL_MODE_ALTERNATE(7)); /* PA9: USART1 TX */
  palSetPadMode(GPIOA, 10, PAL_MODE_ALTERNATE(7)); /* PA10: USART1 RX */

  /* Configuring I2C SCK and SDA related GPIOs */
  palSetPadMode(GPIOB, 8, PAL_MODE_ALTERNATE(4) | PAL_STM32_OTYPE_OPENDRAIN); /* PB8: I2C1 SCL */
  palSetPadMode(GPIOB, 9, PAL_MODE_ALTERNATE(4) | PAL_STM32_OTYPE_OPENDRAIN); /* PB9: I2C1 SDA */
  /* palSetGroupMode(GPIOB, 3, 8, PAL_MODE_ALTERNATE(4) | PAL_STM32_OTYPE_OPENDRAIN); */

  chnWrite(&SD1, (const uint8_t *)"Configuring I2C1\r\n", 18);
  msg_t i2cmsg;
  i2cStart(&I2CD1, &i2ccfg);
  static uint8_t tx_data[14];
  static uint8_t rx_data[14];

  /*
   * Creates the example threads.
   */
  chThdCreateStatic(waThread1, sizeof(waThread1), NORMALPRIO+1, Thread1, NULL);
  chThdCreateStatic(waThread2, sizeof(waThread2), NORMALPRIO+1, Thread2, NULL);
  chThdCreateStatic(waThread3, sizeof(waThread3), NORMALPRIO+1, Thread3, NULL);

  /*
   * Normal main() thread activity, in this demo it does nothing except
   * sleeping in a loop and check the button state, when the button is
   * pressed the test procedure is launched.
   */
  while (true) {
    if (palReadPad(GPIOA, GPIOA_BUTTON)) {
      test_execute((BaseSequentialStream *)&SD1, &rt_test_suite);
      test_execute((BaseSequentialStream *)&SD1, &oslib_test_suite);
    }

    chprintf((BaseSequentialStream*)&SD1, "==Read Data:==: \n\r");
    i2cAcquireBus(&I2CD1);
    tx_data[0] = 0x3B; /* Accel data */
    i2cmsg = i2cMasterTransmitTimeout(&I2CD1, 0x68, tx_data, 1, rx_data, 14, 2000);
    i2cReleaseBus(&I2CD1);
    if(i2cmsg == MSG_TIMEOUT || MSG_RESET) {
        chprintf((BaseChannel *)&SD1,"I2C STATUS: %d\n\r", i2cmsg);
        chprintf((BaseChannel *)&SD1,"I2C ERROR: %d\n\r", i2cGetErrors(&I2CD1));
    }

    chThdSleepMilliseconds(2000);
    chprintf((BaseSequentialStream*)&SD1, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d\n\r", rx_data[0], rx_data[1],rx_data[2],rx_data[3],rx_data[4],rx_data[5],rx_data[6],rx_data[7],rx_data[8],rx_data[9],rx_data[10],rx_data[11],rx_data[12],rx_data[13]);
  }
}
