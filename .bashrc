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

GREEN="\[\e[0;92m\]"
RESET="\[\e[0m\]"
BASE_PROMPT="\u@\h ${GREEN}\w${RESET}"

[[ -f "$HOME/.config/guix/current/etc/bash_completion.d/guix" ]] && \
  . "$HOME/.config/guix/current/etc/bash_completion.d/guix"

if [ -n "$GUIX_ENVIRONMENT" ]
then
    export PS1="${BASE_PROMPT} [env]\$ "
else
    export PS1="${BASE_PROMPT} \$ "
fi

# Use gpg-agent for ssh
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
