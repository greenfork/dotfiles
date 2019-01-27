#!/bin/sh

uptime | awk -F, '{ split($3 $4 $5, a, " " ); print a[3], a[4], a[5] }'
