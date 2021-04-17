#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto -F'
alias la='ls --color=auto -lFa'
alias ll='ls --color=auto -lF'
alias ip='ip -color=auto'
alias ..='cd ..'
alias grep='grep --color=auto'

[[ -f "$HOME/.config/guix/current/etc/bash_completion.d/guix" ]] && \
  . "$HOME/.config/guix/current/etc/bash_completion.d/guix"

GREEN="\[\e[0;92m\]"
RESET="\[\e[0m\]"
BASE_PROMPT="\u@\h ${GREEN}\w${RESET}"

if [ -n "$GUIX_ENVIRONMENT" ]
then
    export PS1="${BASE_PROMPT} [env]\$ "
else
    export PS1="${BASE_PROMPT} \$ "
fi
