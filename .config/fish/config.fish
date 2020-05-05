if status --is-interactive
    # Git stuff
    abbr --add --global ga    git add
    abbr --add --global gaa   git add --all
    abbr --add --global gc    git commit -v
    abbr --add --global gca   git commit -av
    abbr --add --global gco   git checkout
    abbr --add --global gcb   git checkout -b
    abbr --add --global gcm   git checkout master
    abbr --add --global gf    git fetch
    abbr --add --global gd    git diff
    abbr --add --global gdca  git diff --cached
    abbr --add --global gl    git pull
    abbr --add --global gp    git push
    abbr --add --global gpf   git push --force-with-lease
    abbr --add --global gpsup "git push -u origin (git rev-parse --abbrev-ref HEAD)"
    abbr --add --global glog  git log --oneline --decorate --graph
    abbr --add --global gloga git log --oneline --decorate --graph --all
    abbr --add --global gsb   git status -sb
    alias fco   fzf_git_checkout_branch
    alias fcoc  fzf_git_checkout_commit

    # Rails stuff
    abbr --add --global fullrdrs rake db:drop db:create db:migrate db:fixtures:load
    abbr --add --global proddb "rake db:drop db:create; pg_restore -Od hub2_development ../latest.dump"
    abbr --add --global rt spring rails test
    abbr --add --global rc spring rails console
    abbr --add --global rdm rails db:migrate
    abbr --add --global rgm rails generate migration
    abbr --add --global yic yarn install --check-files

    # Key bindings
    bind \cr fzf_search_history

    # Dev-specific settings
    rbenv init - | source
end
