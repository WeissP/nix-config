#!/bin/sh
title=$(xdotool getactivewindow getwindowname)
title="'$title'"
notify-send "$title"
