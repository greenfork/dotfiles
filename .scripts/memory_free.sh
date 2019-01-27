#!/bin/sh

free -h | awk 'NR==2 { print $3 " / " $4 }'
