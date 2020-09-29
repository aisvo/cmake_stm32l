# CMAKE Template STM32L152 DISCOVERY

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Basic template for STM32L152 Discovery

## Build

Use CMAKE > v3.15.1

```
mkdir build
cd build

cmake -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=../arm-none-eabi-gcc.cmake -DCMAKE_BUILD_TYPE=Debug ..
cmake --build . --
```