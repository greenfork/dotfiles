use epm
epm:install &silent-if-installed=$true ^
  github.com/muesli/elvish-libs ^
  github.com/zzamboni/elvish-modules

use path

use readline-binding

# Use gpg for ssh
gpg-connect-agent updatestartuptty /bye >/dev/null

use github.com/zzamboni/elvish-modules/long-running-notifications
set long-running-notifications:threshold = 40
set long-running-notifications:never-notify = [vi vim emacs nano less more bat
  kak hx delta difft k h hdf hd gd git hg chg psql sqlite3 bash zsh elvish ksh
  bin/dev bin/front man tail rc factor haredoc]

use github.com/zzamboni/elvish-modules/dir
set edit:insert:binding[Alt-i] = $dir:history-chooser~
fn cd {|@a| dir:cd $@a}

# Mercurial
fn hg  {|@a| chg $@a }
fn hp  {|@a| hg push $@a }
fn hc  {|@a| hg commit $@a }
fn hca {|@a| hg commit --addremove $@a }
fn hdf {|@a| hg dft $@a }
fn hd  {|@a| hg delta $@a }
fn hs  {|@a| hg summary; hg status $@a }
fn hl  {|@a| hg log --rev "reverse(ancestors(.))" --graph $@a }
fn hw  {|@a| hg wip $@a }

# Fossil
fn f   {|@a| fossil $@a }
# fn fa  {|@a| fossil addremove $@a }
# fn fc  {|@a| fossil commit $@a }
# fn fdi {|@a| fossil diff $@a }

# Git
fn ga       {|@a| git add $@a }
fn gaa      {|@a| git add --all $@a }
fn gc       {|@a| git commit --verbose $@a }
fn gca      {|@a| git commit --verbose --all $@a }
fn gco      {|@a| git checkout $@a }
fn gcb      {|@a| git checkout -b $@a }
fn gf       {|@a| git fetch $@a }
fn gd       {|@a| git diff $@a }
fn gdca     {|@a| git diff --cached $@a }
fn gl       {|@a| git pull $@a }
fn gp       {|@a| git push $@a }
fn gpf      {|@a| git push --force-with-lease $@a }
fn gpgm     {|@a| git push github master $@a }
fn gpsup    {|@a| git push -u origin (git rev-parse --abbrev-ref HEAD) $@a }
fn glog     {|@a| git log --oneline --decorate --graph $@a }
fn gloga    {|@a| git log --oneline --decorate --graph --all $@a }
fn gsb      {|@a| git status -sb $@a }
fn gap      {|@a| git add --all --patch $@a }
fn gri      {|@a| git rebase --interactive --autosquash master $@a }
fn gcm      {|@a| try { git checkout master 2>/dev/null } catch e { git checkout main 2>/dev/null } }
fn gitprune { git fetch --prune; git branch -v | grep gone | cut -f3 -d' ' | xargs git branch -D }

# Rails
fn fullrdrs { bin/rails db:environment:set RAILS_ENV=development; rake db:drop db:create db:migrate db:fixtures:load }
fn rt       {|@a| env PARALLEL_WORKERS=12 spring rails test $@a }
fn rc       {|@a| spring rails console $@a }
fn rdm      {|@a| rails db:migrate $@a }
fn rgm      {|@a| rails generate migration $@a }
fn rdf      {|@a| rails db:fixtures:load $@a }

# Editors
fn k {|@a| kak $@a }
fn h {|@a| hx $@a }

# Misc
fn ip  {|@a| e:ip -color=auto $@a }
fn l   {|@a| eza -F $@a }
fn ll  {|@a| eza -lFg $@a }
fn la  {|@a| eza -lFga $@a }
fn gdb {|@a| e:gdb -q $@a }
fn ...   { cd ../.. }
fn ....  { cd ../../.. }
fn ..... { cd ../../../.. }

use myprompt
set edit:prompt-stale-threshold = 0.5
set edit:prompt = {
  myprompt:tilde-path
  myprompt:mercurial-prompt
  myprompt:git-prompt
  put '> '
}
