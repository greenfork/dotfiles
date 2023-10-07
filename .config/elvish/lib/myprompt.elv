use re
use str
use github.com/muesli/elvish-libs/git

# Mercurial

fn hg {|@a| chg $@a }
var hg-log-cmd = { hg log --rev . --template json 2>/dev/null }
var hg-status-cmd = { hg status --template json 2>/dev/null }
var hg-current-bookmark-cmd = { hg bookmarks --list . --template json 2>/dev/null }

fn mercurial-summary {
  var branch            = ""
  var tags              = []
  var bookmarks         = []
  var modified-count    = 0
  var added-count       = 0
  var not-tracked-count = 0
  var removed-count     = 0
  var clean-count       = 0
  var missing-count     = 0
  var ignored-count     = 0
  var morestatus        = $nil
  var is-hg-repo        = $true

  try {
    var log = ($hg-log-cmd | from-json | put (all)[0])
    set branch = $log[branch]
    set tags = $log[tags]
    set bookmarks = $log[bookmarks]
    try {
      var cur-bo = ($hg-current-bookmark-cmd | from-json)[0]
      var i = 0;
      var len = (count $bookmarks)
      while (< $i $len) {
        if (==s $cur-bo[bookmark] $bookmarks[$i]) {
          set bookmarks[$i] = '*'$bookmarks[$i]
          break
        }
        set i = (+ $i 1)
      }
    } catch e {
      nop
    }

    var status = ($hg-status-cmd | from-json)
    each {|st|
      if (==s $st[itemtype] file) {
        if (==s $st[status] 'M') {
          set modified-count = (+ $modified-count 1)
        } elif (==s $st[status] 'A') {
          set added-count = (+ $added-count 1)
        } elif (==s $st[status] 'R') {
          set removed-count = (+ $removed-count 1)
        } elif (==s $st[status] 'C') {
          set clean-count = (+ $clean-count 1)
        } elif (==s $st[status] '!') {
          set missing-count = (+ $missing-count 1)
        } elif (==s $st[status] '?') {
          set not-tracked-count = (+ $not-tracked-count 1)
        } elif (==s $st[status] 'I') {
          set ignored-count = (+ $ignored-count 1)
        }
      } elif (==s $st[itemtype] morestatus) {
        set morestatus = $st[unfinished]
      }
    } $status
  } catch e {
    set is-hg-repo = $false
  }

  put [
    &branch=            $branch
    &tags=              $tags
    &bookmarks=         $bookmarks
    &modified-count=    $modified-count
    &added-count=       $added-count
    &not-tracked-count= $not-tracked-count
    &removed-count=     $removed-count
    &clean-count=       $clean-count
    &missing-count=     $missing-count
    &ignored-count=     $ignored-count
    &morestatus=        $morestatus
    &is-hg-repo=        $is-hg-repo
  ]
}
fn -join {|sep @xs|
  var len = (count $xs)
  var i = 0
  while (< $i $len) {
    put $xs[$i]
    if (!= $i (- $len 1)) {
      put $sep
    }
    set i = (+ $i 1)
  }
}
fn mercurial-prompt {
  var summary = (mercurial-summary)
  if $summary[is-hg-repo] {
    put ' ('(styled $summary[branch] cyan)
    if (> (count $summary[tags]) 0) {
      put '|'
      put $summary[tags] |
        each {|tag| put (styled $tag yellow) } (all) |
        -join '|' (all)
    }
    if (> (count $summary[bookmarks]) 0) {
      put '|'
      put $summary[bookmarks] |
        each {|bm| put (styled $bm green) } (all) |
        -join '|' (all)
    }
    if $summary[morestatus] {
      put '|'(styled $summary[morestatus] red)
    }
    put ')'

    if (> $summary[modified-count] 0) {
      put '*'$summary[modified-count]
    }
    if (> $summary[added-count] 0) {
      put '+'$summary[added-count]
    }
    if (> $summary[removed-count] 0) {
      put '-'$summary[removed-count]
    }
    if (> $summary[clean-count] 0) {
      put 'c'$summary[clean-count]
    }
    if (> $summary[missing-count] 0) {
      put '!'$summary[missing-count]
    }
    if (> $summary[not-tracked-count] 0) {
      put '?'$summary[not-tracked-count]
    }
    if (> $summary[ignored-count] 0) {
      put '#'$summary[ignored-count]
    }
  }
}

# Git

fn git-prompt {
  var status = (git:status &counts=$true)
  if $status[is-git-repo] {
    put ' ('
    if (==s $status[branch-name] '(detached)') {
      var short-rev = $status[branch-oid][0..7]
      put (styled detached yellow)'|'(styled $short-rev yellow)
    } else {
      put (styled $status[branch-name] green)
    }
    if (> $status[unmerged-count] 0) {
      put '|'(styled conflict red)
    }
    put ')'

    if (> $status[local-modified-count] 0) {
      put '*'$status[local-modified-count]
    }
    if (or (> $status[staged-modified-count] 0) ^
           (> $status[staged-added-count] 0)) {
      put '+'(+ $status[staged-modified-count] $status[staged-added-count])
    }
    if (> $status[staged-deleted-count] 0) {
      put '-'$status[staged-deleted-count]
    }
    if (or (> $status[copied-count] 0) ^
           (> $status[renamed-count] 0)) {
      put 'c'(+ $status[copied-count] $status[renamed-count])
    }
    if (> $status[local-deleted-count] 0) {
      put '!'$status[local-deleted-count]
    }
    if (> $status[untracked-count] 0) {
      put '?'$status[untracked-count]
    }
    if (> $status[ignored-count] 0) {
      put '#'$status[ignored-count]
    }
  }
}

# pwd

fn abbrev-segment {|s|
  if (str:has-prefix $s '.') {
    put $s[0..2]
  } else {
    put $s[0]
  }
}
fn tilde-path {
  var abbr = (tilde-abbr $pwd)
  var @segments = (re:split '/' $abbr)
  if (> (count $segments) 2) {
    var @abbr-segments = (each {|s| put (abbrev-segment $s) } $segments[1..-1])
    put (str:join '/' [$segments[0] $@abbr-segments $segments[-1]])
  } else {
    put $abbr
  }
}
