function fzf_search_history -d "Fuzzy history search"
    commandline (history | fzf --no-sort)
    commandline -f force-repaint
end
