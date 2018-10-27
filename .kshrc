. /etc/ksh.kshrc

if [ $TERM = "vt220" ]; then
	wsconsctl keyboard.map+="keysym Caps_Lock = Control_L"
fi

if [[ $- = *i* ]]; then
	if [ $USER = "root" ]; then
		PS1='\h:\w# '
	else
		PS1='[\W] '
	fi
fi

alias df="df -h"
alias du="du -h"
alias l="exa -F"
alias ll="exa -lFg"
alias la="exa -lFga"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias vi="vim"
alias ytaudio="youtube-dl -x --audio-format m4a --audio-quality 0 --restrict-filenames -o '%(title)s-%(id)s.%(ext)s'"

toggle_touchpad() {
	synclient TouchpadOff=$(synclient -l | grep -c "TouchpadOff.*=.*0")
}

