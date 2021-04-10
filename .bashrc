#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -F'
alias la='ls --color=auto -lFa'
alias ll='ls --color=auto -lF'

[[ -f "$HOME/.config/guix/current/etc/bash_completion.d/guix" ]] && \
  . "$HOME/.config/guix/current/etc/bash_completion.d/guix"

GREEN="\[\e[0;92m\]"
RESET="\[\e[0m\]"
BASE_PROMPT="${GREEN}\u${RESET}@\h ${GREEN}\w${RESET}"

if [ -n "$GUIX_ENVIRONMENT" ]
then
    export PS1="${BASE_PROMPT} [dev]\$ "
else
    export PS1="${BASE_PROMPT} \$ "
fi
