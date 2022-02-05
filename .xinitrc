[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

xset -b
xbacklight -set 100
setxkbmap -option "ctrl:nocaps"
setxkbmap -option "shift:both_capslock"
setxkbmap -layout us,ru -option grp:rctrl_toggle
# xidle -program "/usr/bin/slock" -timeout 630 &
xset r rate 180 50
# eval `ssh-agent`
# dunst &
# exec /usr/X11R6/bin/cwm
# exec /usr/bin/awesome
# exec /usr/local/bin/dwm
exec /usr/bin/i3
