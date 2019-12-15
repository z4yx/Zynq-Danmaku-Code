#!/bin/bash
set -v
gpioset gpiochip0 0=1
gpioset gpiochip0 1=0
sleep 0.1
gpioset gpiochip0 1=1
sleep 1
dfu-util -R -D danmaku.bin -a 0 -s 0x08000000
sleep 0.1
gpioset gpiochip0 0=0
gpioset gpiochip0 1=0
sleep 0.1
gpioset gpiochip0 1=1
