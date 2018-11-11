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
alias e="emacsclient -c"
alias ytaudio="youtube-dl -x --audio-format vorbis --audio-quality 0 --restrict-filenames -o '%(title)s-%(id)s.%(ext)s'"
alias Rv="R --vanilla"

# special alias for haskell builds
alias cabal="env TMPDIR=/usr/local/cabal/build cabal"

toggle_touchpad() {
	synclient TouchpadOff=$(synclient -l | grep -c "TouchpadOff.*=.*0")
}

