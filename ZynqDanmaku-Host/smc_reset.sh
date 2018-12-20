#!/bin/bash
rstn=1008
boot=1009
cd /sys/class/gpio
[ -d gpio$rstn ] || (echo $rstn >export && echo out >gpio$rstn/direction)
[ -d gpio$boot ] || (echo $boot >export && echo out >gpio$boot/direction)
echo 0 >gpio$rstn/value
echo 1 >gpio$boot/value
sleep 0.1
echo 1 >gpio$rstn/value
sleep 0.1
echo 0 >gpio$boot/value
