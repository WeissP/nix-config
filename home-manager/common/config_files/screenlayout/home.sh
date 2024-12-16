#!/bin/sh
xrandr --output DisplayPort-0 --primary --mode 3440x1440 --pos 0x480 --rotate normal --output DisplayPort-1 --mode 2560x1440 --pos 3440x0 --rotate right 
mapwacom.sh --device-regex ".*Wacom.*" -s "DP-1" 
