#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME=$HOME/.config
export PAGER=less
export EDITOR=kak

export GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
[[ -d $HOME/reps/guix ]] && export GUIX_CHECKOUT=$HOME/reps/guix

[[ -r "/home/grfork/reps/emsdk/emsdk_env.sh" ]] && source "/home/grfork/reps/emsdk/emsdk_env.sh"

export XKB_DEFAULT_LAYOUT="us,ru"
export XKB_DEFAULT_OPTIONS="ctrl:nocaps,shift:both_capslock,grp:rctrl_toggle"
