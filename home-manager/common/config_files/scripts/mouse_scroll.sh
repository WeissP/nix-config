#!/bin/sh
set -e
Mouse_ID=$(xinput list | grep "ELECOM ELECOM TrackBall Mouse" | head -n 1 | sed -r 's/.*id=([0-9]+).*/\1/') &
xinput set-prop ${Mouse_ID} 'libinput Button Scrolling Button' 9 &
xinput set-prop ${Mouse_ID} "libinput Scroll Method Enabled" 0 0 1 &
