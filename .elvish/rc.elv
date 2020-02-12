if ?(test -f $E:HOME/.elvish/profile.elv) { -source $E:HOME/.elvish/profile.elv }

# Environment settings
E:PAGER=less
E:EDITOR=kak
E:XDG_CONFIG_HOME=$E:HOME/.config
E:LC_CTYPE=en_US.UTF-8
home=$E:HOME
if (==s $E:ELVISH_OS_PROFILE macos_work) {
  paths = [$home/go/bin $@paths]
  paths = [$home/.cargo/bin $@paths]
  paths = [/usr/local/opt/node@10/bin $@paths]
  paths = [$home/.nimble/bin $@paths]
} else {
  E:ANDROID_HOME=$home/android
  # /bin /sbin /usr/sbin are all symbolic links to /usr/bin on Void Linux
  E:PATH=/usr/local/bin:/usr/local/sbin:/usr/bin
  E:PATH=$home/.local/bin:$E:PATH
  E:PATH=$home/.nimble/bin:$E:PATH
  E:PATH=$home/go/bin:$E:PATH
  E:PATH=$home/.rbenv/shims:$E:PATH
  E:PATH=$home/.cargo/bin:$E:PATH
  E:PATH=$home/.cabal/bin:$E:PATH
  E:PATH=$home/.yarn/bin:$home/.config/yarn/global/node_modules/.bin:$E:PATH
  E:PATH=$home/flutter/bin:$E:PATH
  E:PATH=$home/android/sdk/platform-tools:$E:PATH
  E:PATH=$home/android/sdk/tools:$E:PATH
  E:PATH=$home/android/sdk/tools/bin:$E:PATH
  E:PATH=$home/.cask/bin:$E:PATH
  E:PATH=$home/.racket/7.5/bin:$E:PATH
  E:PATH=/bedrock/cross/pin/bin:$E:PATH
  E:PATH=/bedrock/bin:$E:PATH
  E:PATH=(put $E:PATH):/bedrock/cross/bin
}

use epm
epm:install &silent-if-installed=$true \
  github.com/zzamboni/elvish-completions \
  github.com/xiaq/edit.elv \
  github.com/zzamboni/elvish-modules \
  github.com/muesli/elvish-libs

use re
use github.com/muesli/elvish-libs/git

# Aliases
fn l [@a]{ exa -F $@a }
fn ll [@a]{ exa -Flg $@a }
fn la [@a]{ exa -Flga $@a }
fn ytaudio [@a]{ youtube-dl -x --audio-format vorbis --audio-quality 0 --restrict-filenames -o '%(title)s-%(id)s.%(ext)s' $@a }
fn ytaudiomp3 [@a]{ youtube-dl -x --audio-format mp3 --audio-quality 0 --restrict-filenames -o '%(title)s-%(id)s.%(ext)s' $@a }
fn Rv [@a]{ R --vanilla $@a }
fn xbi [@a]{ doas xbps-install -S $@a }
fn xbr [@a]{ doas xbps-remove $@a }
fn xbq [@a]{ xbps-query $@a }

fn gc    [@a]{ git commit -v $@a }
fn gca   [@a]{ git commit -av $@a }
fn ga    [@a]{ git add $@a }
fn gaa   [@a]{ git add --all $@a }
fn gco   [@a]{ git checkout $@a }
fn gcb   [@a]{ git checkout -b $@a }
fn gcm   [@a]{ git checkout master $@a }
fn gf    [@a]{ put "You have no gf"; git fetch $@a }
fn gd    [@a]{ git diff $@a }
fn gdca  [@a]{ git diff --cached $@a }
fn gl    [@a]{ git pull $@a }
fn gp    [@a]{ git push $@a }
fn gpsup [@a]{ git push -u origin (git:branch_name) $@a }
fn gpf   [@a]{ git push --force-with-lease $@a }
fn glog  [@a]{ git log --oneline --decorate --graph $@a }
fn gloga [@a]{ git log --oneline --decorate --graph --all $@a }
fn gst   [@a]{ git status $@a }
fn gsb   [@a]{ git status -sb $@a }

fn fullrdrs { rake db:drop db:create db:migrate db:fixtures:load }
fn proddb { rake db:drop db:create; pg_restore -Od hub2_development ../latest.dump }
fn rt [@a]{ spring rails test $@a }
fn rc [@a]{ spring rails console $@a }
fn rdm [@a]{ rails db:migrate $@a }
fn rgm [@a]{ rails generate migration $@a }

# Readline
use readline-binding
edit:insert:binding[Alt-Backspace] = $edit:kill-small-word-left~

# Left and right prompts
# edit:prompt = { tilde-abbr $pwd; put '> ' }
fn git-dirty {
  data = (git:status)
  if (> (+ (count $data[local-modified]) \
           (count $data[untracked]) \
           (count $data[local-deleted])) \
        0) {
    put '*'
  }
}
fn git-branch {
  if (git:status)[is-git-repo] {
    put '(' (styled (git:branch_name) blue) (styled (or (git-dirty) '') magenta) ')'
  }
}
edit:prompt = { put (tilde-abbr $pwd) (git-branch) '> ' }
edit:rprompt = (constantly 'no return')
edit:rprompt-persistent = $true

# Completions
use github.com/zzamboni/elvish-completions/cd
edit:completion:matcher[''] = [seed]{ edit:match-substr $seed &ignore-case=$true }

# Send notification if command runs more than `threshold` seconds
use github.com/zzamboni/elvish-modules/long-running-notifications
long-running-notifications:threshold = 40

# Shortcuts for inserting previous commands with !! and !$
use github.com/zzamboni/elvish-modules/bang-bang

use github.com/zzamboni/elvish-modules/dir
fn cd [@a]{ dir:cd $@a }
