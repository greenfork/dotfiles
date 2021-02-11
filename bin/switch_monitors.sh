#!/bin/sh

# export DISPLAY=:0
# export XAUTHORITY=/home/grfork/.Xauthority

internal=eDP-1
external=HDMI-1

if [ $(xrandr --query --current | grep --count "${external} connected") = "1" ]; then
    xrandr --output $external --left-of $internal --auto
else
    xrandr --output $external --off
fi
