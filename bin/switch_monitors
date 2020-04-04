#!/bin/env elvish
use re

intern = eDP1
extern = HDMI1

if (re:match $extern' connected' (xrandr --query --current | slurp)) {
  monitors = (joins , [(xrandr --listmonitors --current)])
  if (re:match $intern $monitors) {
    xrandr --output $intern --off --output $extern --auto --primary
  } elif (re:match $extern $monitors) {
    xrandr --output $extern --off --output $intern --auto --primary
  }
}
