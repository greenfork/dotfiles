#!/bin/sh

# You will need `lm_sensors` set up in order for this to work,
# additional tweaking may be required with the `NR` variable
sensors | awk 'NR==4 { split($3, a, "."); print substr(a[1], 2) substr(a[2], 2) }'
