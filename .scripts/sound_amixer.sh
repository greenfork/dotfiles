#!/bin/sh

# amixer should be installed and possibly the command should be tweaked

amixer -c1 get Master | awk '/Mono:/ { split($4, a, "%"); print substr(a[1], 2) }'
