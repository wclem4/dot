#!/bin/bash

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        if xrandr --query | grep "$m connected primary" > /dev/null; then
            MONITOR=$m polybar --reload primary &
        else
            MONITOR=$m polybar --reload secondary &
        fi
    done
else
    polybar --reload primary &
fi
