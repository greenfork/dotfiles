# Environment settings
E:PAGER=less
E:EDITOR=vim
E:XDG_CONFIG_HOME=$E:HOME/.config
E:LC_CTYPE=en_US.UTF-8
home=$E:HOME
# /bin /sbin /usr/sbin are all symbolic links to /usr/bin on Void Linux
E:PATH=/usr/local/bin:/usr/local/sbin:/usr/bin
E:PATH=$home/.nimble/bin:$E:PATH
E:PATH=$home/go/bin:$E:PATH
E:PATH=$home/.rbenv/shims:$E:PATH
E:PATH=$home/.yarn/bin:$home/.config/yarn/global/node_modules/.bin:$E:PATH

# Aliases
fn l [@a]{ exa -F $@a }
fn ll [@a]{ exa -Flg $@a }
fn la [@a]{ exa -Flga $@a }
fn ytaudio [@a]{ youtube-dl -x --audio-format vorbis --audio-quality 0 --restrict-filenames -o '%(title)s-%(id)s.%(ext)s' $@a }
fn Rv [@a]{ R --vanilla $@a }
fn xbi [@a]{ doas xbps-install -S $@a }

use epm
epm:install &silent-if-installed=$true \
  github.com/zzamboni/elvish-completions \
  github.com/xiaq/edit.elv \
  github.com/zzamboni/elvish-modules

use re

# Readline
use readline-binding
edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~
# workaround for https://github.com/elves/elvish/issues/627
edit:navigation:binding["Alt-n"] = $nop~

# Left and right prompts
# edit:prompt = { tilde-abbr $pwd; put '> ' }
epm:install &silent-if-installed=$true github.com/zzamboni/elvish-themes
use github.com/zzamboni/elvish-themes/chain
edit:rprompt = (constantly 'no return')

# Completions
use github.com/xiaq/edit.elv/smart-matcher
smart-matcher:apply
use github.com/zzamboni/elvish-completions/cd
#use github.com/zzamboni/elvish-completions/ssh
#use github.com/zzamboni/elvish-completions/builtins
use github.com/zzamboni/elvish-completions/git

# Send notification if command runs more than `threshold` seconds
use github.com/zzamboni/elvish-modules/long-running-notifications
long-running-notifications:threshold = 40

# Shortcuts for inserting previous commands with !! and !$
use github.com/zzamboni/elvish-modules/bang-bang

# Shortcuts for directory traversal
use github.com/zzamboni/elvish-modules/dir
fn cd [@a]{ dir:cd $@a }
fn cdb [@a]{ dir:cdb $@a }
edit:insert:binding[Alt-b] = $dir:left-word-or-prev-dir~
edit:insert:binding[Alt-f] = $dir:right-word-or-next-dir~

# Case-insensitive search when prompting
edit:location:matcher = [@a]{ edit:location:match-dir-pattern &ignore-case $@a }
