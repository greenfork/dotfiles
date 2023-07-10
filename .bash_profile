#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME=$HOME/.config
export PAGER=less-f
export EDITOR=kak
export TERMINAL=kitty

export GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
[[ -d $HOME/reps/guix ]] && export GUIX_CHECKOUT=$HOME/reps/guix

# [[ -r "/home/grfork/reps/emsdk/emsdk_env.sh" ]] && source "/home/grfork/reps/emsdk/emsdk_env.sh"

export XKB_DEFAULT_LAYOUT="us,ru"
export XKB_DEFAULT_OPTIONS="ctrl:nocaps,shift:both_capslock,grp:rctrl_toggle"

export PATH="${HOME}/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.local/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.roswell/bin${PATH:+:${PATH}}"
export PATH="${HOME}/go/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.nimble/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.rbenv/shims${PATH:+:${PATH}}"
export PATH="${HOME}/.cargo/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.yarn/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.fly/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.npm/bin${PATH:+:${PATH}}"
export PATH="${HOME}/.emacs.d/bin${PATH:+:${PATH}}"

# For river
export XDG_CURRENT_DESKTOP=Unity
