#!/bin/bash
cd /sys/class/gpio
[ -d gpio904 ] || (echo 904 >export && echo out >gpio904/direction)
[ -d gpio905 ] || (echo 905 >export && echo out >gpio905/direction)
echo 0 >gpio904/value
echo 1 >gpio905/value
sleep 0.1
echo 1 >gpio904/value
sleep 0.1
echo 0 >gpio905/value
