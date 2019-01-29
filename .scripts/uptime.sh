#!/bin/sh

uptime | awk 'BEGIN{ FS="," } { split($(NF-2), a, " "); print a[3] $(NF-1) $(NF) }'
